#!/bin/bash

ZSHRC_CONF_PART="IyBCRUdJTl9QQVJUX0RPTlRfTU9ECiMgQWRkIGZ6ZiBrZXkgYmluZGluZ3MgdG8gbWFrZSB0aGlu
Z3MgYW1hemluZwpzb3VyY2UgL3Vzci9zaGFyZS9memYvc2hlbGwva2V5LWJpbmRpbmdzLnpzaAoK
ZXhwb3J0IE5WTV9ESVI9IiRIT01FLy5udm0iClsgLXMgIiROVk1fRElSL252bS5zaCIgXSAmJiBc
LiAiJE5WTV9ESVIvbnZtLnNoIiAgIyBUaGlzIGxvYWRzIG52bQpbIC1zICIkTlZNX0RJUi9iYXNo
X2NvbXBsZXRpb24iIF0gJiYgXC4gIiROVk1fRElSL2Jhc2hfY29tcGxldGlvbiIgICMgVGhpcyBs
b2FkcyBudm0gYmFzaF9jb21wbGV0aW9uCgphbGlhcyB2aW09J252aW0nCmV4cG9ydCBFRElUT1I9
bnZpbQojIEVORF9QQVJUX0RPTlRfTU9ECgo="

# Setup nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash

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

    BEGIN=0
    END=0

    # If begin part and end part doesn't exist, then add it to the file
    ! grep -E '^# BEGIN_PART_DONT_MOD' $ZSHRC > /dev/null && ! grep -E '^# END_PART_DONT_MOD' $ZSHRC > /dev/null && {
        BEGIN=1
        END=1
    }

    [[ $BEGIN == 1 && $END == 1 ]] && { 
        echo "Added config part to $ZSHRC"
        echo "$ZSHRC_CONF_PART" | base64 -d >> $ZSHRC
    } || {
        echo "Config part already exists"
    }
fi


