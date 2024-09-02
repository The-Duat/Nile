local function SplitString(str, splitChar)
	local resultSplit = {}
	if splitChar == nil then
		splitChar = " "
	end
	if str and splitChar then
		for part in string.gmatch(str, "([^"..splitChar.."]+)") do
			table.insert(resultSplit, part)
		end
	end
	return resultSplit
end

local function TrimWhite(str)
    local trimmedString = ""
	local i = 1
	while i <= #str do
		local currentChar = string.sub(str, i, i)
		if currentChar ~= " " then
			trimmedString = trimmedString .. currentChar
		end
		i = i + 1
	end
	return trimmedString
end

local pipe  = Posix.unistd.pipe
local fork  = Posix.unistd.fork
local execp = Posix.unistd.execp
local dup2  = Posix.unistd.dup2
local close = Posix.unistd.close
local wait  = Posix.sys.wait.wait
local kill  = Posix.signal.kill
SIGKILL = 9

local read_fd, write_fd = pipe()
local read_fd2, write_fd2 = pipe()

Posix.setenv("LANG", "en_US.UTF-8")

local Wrapper = {}
Wrapper.Install = {}
Wrapper.Remove = {}

local function create_pipe_and_fork(program, arguments)
    local read_fd, write_fd = pipe()
    local read_fd2, write_fd2 = pipe()

    local pid = fork()

    if pid == 0 then
        -- Child process
        dup2(read_fd2, Posix.unistd.STDIN_FILENO)
        dup2(write_fd, Posix.unistd.STDOUT_FILENO)
        dup2(write_fd, Posix.unistd.STDERR_FILENO)

        close(read_fd)
        close(write_fd2)
        close(write_fd)
        close(read_fd2)

        execp(program, arguments)
    else
        -- Parent process
        close(write_fd)
        close(read_fd2)
        return pid, read_fd, write_fd2
    end
end

local pid, read_fd, write_fd2

local buffer = ""
local capturing = true


local function send_input(input)
    Posix.unistd.write(write_fd2, input)
end

local function switch_to_direct_output()
    capturing = false
    close(read_fd)
    -- print("Switched to direct output from child process.")
end

local function switch_back_to_capturing()
    capturing = true
    pid, read_fd, write_fd2 = create_pipe_and_fork()
    -- print("Switched back to capturing output from child process.")
end


Wrapper.Install.pacman = function(packageTable)
    local arguments = {"-S"}
    for _,item in ipairs(packageTable) do
        table.insert(arguments, item)
    end
    pid, read_fd, write_fd2 = create_pipe_and_fork("/bin/pacman", arguments)
    buffer = ""
    capturing = true
    local function read_output_line_by_line()
        while capturing do
            local chunk = Posix.unistd.read(read_fd, 1024)
            if not chunk or #chunk == 0 then
                break
            end
            buffer = buffer .. chunk
            local PackagesToBeInstalled = {}
            local CurrentlyCountingPackages = false
            for line in buffer:gmatch("[^\r\n]+") do

                if line == "error: failed to init transaction (unable to lock database)" then
                    switch_to_direct_output()
                    Fault("Another package management operation is currently running.")
                    Say("If you are 100% sure no other operation is running, remove the following file:")
                    Say2("/var/lib/pacman/db.lck")
                    Exit()

                elseif string.sub(line, 1, 17) == "Enter a selection" or string.sub(line, 1, 14) == "Enter a number" then
                    send_input("\n")

                elseif string.sub(line, 1, 25) == "error: target not found: " then
                    switch_to_direct_output()
                    Fault("The package \"" .. string.sub(line, 26, #line) .. "\" does not exist.")
                    Exit()

                elseif string.sub(line, 1, 8) == "Packages" then
                    local split = SplitString(line, " ")
                    for i = 3, #split, 1 do
                        table.insert(PackagesToBeInstalled, TrimWhite(split[i]))
                    end
                    CurrentlyCountingPackages = true

                elseif string.sub(line, 1, 11) == "Net Upgrade" then
                    CurrentlyCountingPackages = false
                    switch_to_direct_output()
                    Say("Packages:")
                    for _,package in ipairs(PackagesToBeInstalled) do
                        Say2(package)
                    end
                    Say("Required disk space: " .. SplitString(line, " ")[4] .. " " .. SplitString(line, " ")[5])
                    Say("Install listed packages? (y/n)")
                    if string.lower(Read()) == "y" then
                        send_input("y\n")
                        switch_back_to_capturing()
                    else
                        Fault("Package installation aborted.")
                        kill(pid, SIGKILL)
                        os.remove("/var/lib/pacman/db.lck")
                        Exit()
                    end
                else
                    if CurrentlyCountingPackages == true and #line > 2 and string.sub(line, 1, 15) ~= "Total Installed" then
                        local split = SplitString(line, " ")
                        for _,part in ipairs(split) do
                            table.insert(PackagesToBeInstalled, TrimWhite(part))
                        end
                    end
                end
            end
            buffer = ""
        end
    end
    read_output_line_by_line()
    wait(pid)
    close(write_fd2)
end




return Wrapper

--[=[
                    if string.sub(line, 1, 25) == "error: target not found: " then
                        capturing = false
                        close(read_fd)
                        Fault("The package \"" .. string.sub(line, 26, #line) .. "\" does not exist.")
                    end
]=]--