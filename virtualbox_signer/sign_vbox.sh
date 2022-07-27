#!/bin/bash

# Just supply the filename without the priv/der file extenstions
# The scrip will sort the rest

FILE=$1

echo $FILE

for modfile in $(dirname $(modinfo -n vboxdrv))/*.ko; do
  echo "Signing $modfile"
  /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 \
	  			/etc/pki/akmods/private/$FILE.priv \
                                /etc/pki/akmods/certs/$FILE.der "$modfile"
done

