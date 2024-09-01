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


Wrapper.Install.pacman = function(packageTable)
    local pid = fork()
    if pid == 0 then
        dup2(read_fd2, Posix.unistd.STDIN_FILENO)
        dup2(write_fd, Posix.unistd.STDOUT_FILENO)
        dup2(write_fd, Posix.unistd.STDERR_FILENO)
        close(read_fd)
        close(write_fd2)
        close(write_fd)
        close(read_fd2)
        local argTable = {"-S"}
        for _,p in ipairs(packageTable) do
            table.insert(argTable, p)
        end
        execp("/bin/pacman", argTable)
    else
        close(write_fd)
        close(read_fd2)
        local buffer = ""
        local capturing = true
    
        local function read_output_line_by_line()
            while capturing do
                local chunk = Posix.unistd.read(read_fd, 1024)
                if not chunk or #chunk == 0 then
                    break
                end
                buffer = buffer .. chunk
                for line in buffer:gmatch("[^\r\n]+") do

                    if string.sub(line, 1, 25) == "error: target not found: " then
                        capturing = false
                        close(read_fd)
                        Fault("The package \"" .. string.sub(line, 26, #line) .. "\" does not exist.")
                    end

                end
                buffer = ""
            end
        end
    
        -- Posix.unistd.write(write_fd2, input)
    
        -- Posix.unistd.sleep(1) -- Give some time for the output to be generated
        read_output_line_by_line()
    
        -- Wait for the child process to exit
        wait(pid)
        
        close(read_fd)
        close(write_fd2)
    end
end




return Wrapper