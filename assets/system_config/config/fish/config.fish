if status is-interactive
	function fish_greeting
	end

	function fish_prompt
		echo -e "\x1b[38;2;186;194;222m┌──(\x1b[38;2;137;180;250m$(whoami)@$hostname\x1b[38;2;186;194;222m)─[\x1b[38;2;245;194;231m$PWD\x1b[38;2;186;194;222m]"
		echo -e "└─\\ "
	end
end
