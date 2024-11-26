#!/usr/bin/env bash

discord_ver_file=new_discord.deb

# Download the latest version of Discord for Linux (Debian package format)
wget --output-document=$discord_ver_file --verbose "https://discord.com/api/download?platform=linux&format=deb"
echo "New discord version downloaded"

sudo nala install --assume-yes --verbose ./$discord_ver_file
echo "New discord version has been installed successfully."

rm --force --verbose ./$discord_ver_file
echo "Downloaded file deleted"

# Prompt the user to open Discord, defaulting to "yes" if no input is provided within 10 seconds
read -t 10 -p "Open Discord now? (Y/n): " open_discord 
open_discord=${open_discord:-y}

# Check if the user wants to open Discord; open it in the background if they do
if [[ "$open_discord" =~ ^[Yy]$ ]]; then
    nohup discord &> /dev/null &
    echo "Discord has been opened."
else
    echo "Discord installation complete. Not opening Discord."
fi
