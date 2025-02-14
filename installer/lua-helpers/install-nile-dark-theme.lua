local NileRiver = dofile("/NileRiver/core/NileRiver.lua")

local frontend_IO = {}

frontend_IO.inp = function() -- Get user input.
	io.write("\x1b[38;2;137;180;250m> \x1b[38;2;180;190;254m")
	local text = io.read()
	io.write("\x1b[38;2;255;255;255m")
	return text
end
frontend_IO.outp = function(text) -- Write raw output.
	io.write(text)
end
frontend_IO.foutp = function(text) -- Print stylized output.
	print("\x1b[38;2;137;180;250m| \x1b[38;2;180;190;254m" .. text .. "\x1b[38;2;255;255;255m")
end
frontend_IO.afoutp = function(text) -- Print secondary stylized output.
	print("    \x1b[38;2;245;194;231m> \x1b[38;2;203;166;247m" .. text .. "\x1b[38;2;255;255;255m")
end
frontend_IO.err = function(text) -- Print error output.
	print("\x1b[38;2;243;139;168m!![Error]> \x1b[38;2;203;160;247m" .. text .. "\x1b[38;2;255;255;255m")
end

NileRiver.InitializeIO(frontend_IO)

NileRiver.Main.Software("fetch", {"The-Duat/Nile-Dark-Theme"}, false, true)
