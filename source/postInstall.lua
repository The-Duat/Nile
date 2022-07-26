io.write("/n/nRun post installation to finish installing mizOS? Y/N")

ans = io.read()

if ans == "Y" then
	os.execute("brl fetch arch && brl fetch debian")
end
