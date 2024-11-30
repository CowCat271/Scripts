#!/usr/bin/env bash

print_error() { echo -e "\e[31mError: $1\e[0m"; }

print_success() { echo -e "\e[32m$1\e[0m"; }

print_info() { echo -e "\e[36m$1\e[0m"; }

print_prompt() { echo -e "\e[33m$1\e[0m"; }

# Set package manager variable here
package_manager="nala"

# Check if nala is installed, otherwise fall back to apt
if ! command -v "$package_manager" &>/dev/null; then
    if ! command -v apt &>/dev/null; then
        print_error "Neither nala nor apt is installed. Please install one of them or modify the script to another package manager."
        exit 1
    else
        print_info "Nala not found. Falling back to apt."
        package_manager="apt"
    fi
fi

download_url="https://discord.com/api/download?platform=linux&format=deb"
download_dir="$HOME/Downloads/Packages/Debs/Discord/"
deb_file="$download_dir/new_discord.deb"

cleanup() {
    if [[ -f "$deb_file" ]]; then
        print_info "Cleaning up: Deleting partially downloaded file."
        rm -f "$deb_file"
    fi
}

# Set trap to handle interruptions and clean up the downloaded file
trap cleanup SIGINT SIGTERM

mkdir -p "$download_dir" || { print_error "Failed to create download directory."; exit 1; }

print_info "Downloading the latest version of Discord..."
if wget -O "$deb_file" "$download_url"; then
    print_success "Download completed: $deb_file"
else
    # If not user interruption
    if [[ $? -ne 130 ]]; then
        print_error "Failed to download Discord from $download_url"
    fi
    exit 1
fi

print_info "Installing Discord..."
if sudo "$package_manager" install -y "$deb_file"; then
    print_success "Discord successfully installed."
else
    print_error "Installation failed."
    exit 1
fi

print_prompt "Do you want to open Discord now? (default is 'yes' after 30 seconds)"
read -t 30 -p "(Y/n): " user_input
user_input=${user_input:-yes}

if [[ "$user_input" =~ ^(yes|y|Y)$ ]]; then
    print_info "Opening Discord..."
    nohup discord >/dev/null 2>&1 &
    print_success "Discord is running in the background."
else
    print_info "You chose not to open Discord."
fi
