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

local pipe = Posix.unistd.pipe
local fork = Posix.unistd.fork
local execp = Posix.unistd.execp
local dup2 = Posix.unistd.dup2
local close = Posix.unistd.close
local wait = Posix.sys.wait.wait

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
            for line in buffer:gmatch("[^\r\n]+") do
                if string.sub(line, 1, 25) == "error: target not found: " then
                    switch_to_direct_output()
                    Fault("The package \"" .. string.sub(line, 26, #line) .. "\" does not exist.")
                    Exit()
                end
                local isPackageReal = false
                if string.sub(line, 1, 22) == "resolving dependencies" then
                    isPackageReal = true
                end
                if string.sub(line, 1, 8) == "Packages" and isPackageReal == true then
                    local split = SplitString(line, " ")
                    switch_to_direct_output()
                    Say("Packages: ")
                    for i = 1, #split, 1 do
                        if i >= 3 then
                            Say2(TrimWhite(split[i]))
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