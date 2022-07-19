#!/bin/bash

for modfile in $(dirname $(modinfo -n vboxdrv))/*.ko; do
  echo "Signing $modfile"
  /usr/src/kernels/$(uname -r)/scripts/sign-file sha256 \
	  			/etc/pki/akmods/private/fedora-2566945805.priv \
                                /etc/pki/akmods/certs/fedora-2566945805.der "$modfile"
done

#/etc/pki/akmods/private/fedora-2566945805.priv \
#/etc/pki/akmods/certs/fedora-2566945805.der
