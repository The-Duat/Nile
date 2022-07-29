while true do
	io.write("\n[--(mzsh)--] ")
	io.write("\n[-->> ")
	cmd = io.read()
	os.execute(cmd)
end
