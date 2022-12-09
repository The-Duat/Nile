if status is-interactive
	function fish_greeting
	end

	function fish_prompt
		echo -e "\x1b[38;2;186;194;222m┌──(\x1b[38;2$(whoami)@$hostname)─[$PWD]"
		echo -e "└─\\ "
	end
end
