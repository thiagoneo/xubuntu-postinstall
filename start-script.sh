#!/usr/bin/env bash

wget https://github.com/thiagoneo/ubuntu-postinstall/archive/refs/tags/2022-05-10-3.tar.gz
tar -xzvf 2022-05-10-3.tar.gz
cd ubuntu-postinstall-2022-05-10-3/
chmod +x *.sh

bash script.sh
