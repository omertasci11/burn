#!/bin/bash

cd "$1"
pwd=$(pwd)

echo -e "\nScaning Files..."

findFile=$(sudo find $pwd -type f -exec md5sum "{}" + > /root/hash.$2)
echo $findFile


