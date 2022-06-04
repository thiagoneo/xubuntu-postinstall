#!/usr/bin/env bash

wget https://github.com/thiagoneo/xubuntu-postinstall/archive/refs/tags/2022-06-04.tar.gz
tar -xzvf 2022-06-04.tar.gz
cd xubuntu-postinstall-2022-06-04/
chmod +x *.sh

bash script.sh
