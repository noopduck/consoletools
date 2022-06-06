#!/bin/bash

# Setup nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Setup shell temporarily in order to prepare nvm/npm config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ "$SHELL" =~ "zsh" ]]; then
	echo "Found zsh shell running"
	for i in $(find ~/.* -type f -name ".zshrc" -print0 2>/dev/null|xargs -0 echo); do 
	        if [[ -f $i ]]; then
	                ZSHRC=$i
	        fi
	done 
	if ! grep NVM_DIR $ZSHRC; then
		echo "Added NVM_DIR to zsh"
	        cat /tmp/consoletools/nvm/zshrcpart.txt >> "$ZSHRC"
	else    
	        echo "NVM FOR ZSH ALREADY OK..."
	fi
fi


