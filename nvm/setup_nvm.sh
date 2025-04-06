#!/bin/bash

ZSHRC_CONF_PART="IyBCRUdJTl9QQVJUX0RPTlRfTU9ECiMgQWRkIGZ6ZiBrZXkgYmluZGluZ3MgdG8gbWFrZSB0aGlu↲
Z3MgYW1hemluZwpzb3VyY2UgL3Vzci9zaGFyZS9kb2MvZnpmL2V4YW1wbGVzL2tleS1iaW5kaW5n↲
cy56c2gKCmV4cG9ydCBOVk1fRElSPSIkSE9NRS8ubnZtIgpbIC1zICIkTlZNX0RJUi9udm0uc2gi↲
IF0gJiYgXC4gIiROVk1fRElSL252bS5zaCIgICMgVGhpcyBsb2FkcyBudm0KWyAtcyAiJE5WTV9E↲
SVIvYmFzaF9jb21wbGV0aW9uIiBdICYmIFwuICIkTlZNX0RJUi9iYXNoX2NvbXBsZXRpb24iICAj↲
IFRoaXMgbG9hZHMgbnZtIGJhc2hfY29tcGxldGlvbgoKYWxpYXMgdmltPSdudmltJwpleHBvcnQg↲
RURJVE9SPW52aW0KIyBFTkRfUEFSVF9ET05UX01PRAoK"

# Setup nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

# Setup shell temporarily in order to prepare nvm/npm config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if [[ "$SHELL" =~ "zsh" ]]; then
	echo "Found zsh shell running"
	for i in $(find ~/.* -type f -name ".zshrc" -print0 2>/dev/null | xargs -0 echo); do
		if [[ -f $i ]]; then
			ZSHRC=$i
		fi
	done

	BEGIN=0
	END=0

	# If begin part and end part doesn't exist, then add it to the file
	! grep -E '^# BEGIN_PART_DONT_MOD' $ZSHRC >/dev/null && ! grep -E '^# END_PART_DONT_MOD' $ZSHRC >/dev/null && {
		BEGIN=1
		END=1
	}

	[[ $BEGIN == 1 && $END == 1 ]] && {
		echo "Added config part to $ZSHRC"
		echo "$ZSHRC_CONF_PART" | base64 -d >>$ZSHRC
	} || {
		echo "Config part already exists"
	}
fi
