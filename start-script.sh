#!/usr/bin/env bash

wget https://github.com/thiagoneo/xubuntu-postinstall/archive/refs/tags/2022-05-20.tar.gz
tar -xzvf 2022-05-20.tar.gz
cd ubuntu-postinstall-2022-05-20/
chmod +x *.sh

bash script.sh
