io.write("\nThis installation script assumes you are using Void Linux. If you are not using Void Linux, your system may break!!!\n\n")
io.write("To continue, type \"I am using Void Linux\" and hit enter\n\n")
io.write("> ")

ans = io.read()

if ans == "I am using Void Linux" then
	io.write("\n\nYou will need to reboot after this script finishes, accept? Y/N \n\n")
	io.write("> ")
	ynans = io.read()
	if ynans == "Y" then
		os.execute("sudo sh ../assets/bed* --hijack")
	end
end
