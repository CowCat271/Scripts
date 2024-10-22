#!/bin/bash

discord_ver_dir="/home/cowcat271/Downloads/Discord_versions"
discord_ver_file=new_discord.deb

# mkdir --parents --verbose $discord_ver_dir
# rm --force --verbose $discord_ver_dir/$discord_ver_file
wget --output-document=$discord_ver_file --verbose "https://discord.com/api/download?platform=linux&format=deb"
echo "New discord version downloaded"

sudo nala install --assume-yes --verbose ./$discord_ver_file
echo "New discord version has been installed successfully."

rm --force --verbose ./$discord_ver_file
echo "Downloaded file deleted"
