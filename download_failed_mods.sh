#!/usr/bin/env bash

print_info() { echo -e "\e[36m$1\e[0m"; }

print_success() { echo -e "\e[32m$1\e[0m"; }

print_error() { echo -e "\e[31mError: $1\e[0m"; }

cleanup() {
    if [[ -f "$current_file" ]]; then
        print_info "Cleaning up: Deleting partially downloaded file '$current_file'."
        rm -f "$current_file"
    fi
}

# Set trap to handle interruptions and clean up the downloaded file
trap cleanup SIGINT SIGTERM

if [[ $# -ne 2 ]]; then
    print_error "Usage: $0 <path_to_log_file> <path_to_download_directory>"
    exit 1
fi

log_file="$1"
download_dir="$2"

if [[ ! -f "$log_file" ]]; then
    print_error "Log file '$log_file' does not exist."
    exit 1
fi

if [[ ! -d "$download_dir" ]]; then
    print_error "Download directory '$download_dir' does not exist. Please provide a valid directory."
    exit 1
fi

# Extract URLs and download them
print_info "Starting download process..."
grep -oP 'failed to download file: \Khttps?://\S+' "$log_file" | while read -r url; do
    print_info "Downloading: $url"

    current_file="$download_dir/$(basename "$url")"
    if wget -P "$download_dir" "$url"; then
        print_success "Successfully downloaded: $url"
    else
        if [[ $? -ne 130 ]]; then
            print_error "Failed to download: $url"
        fi
    fi
done

print_success "Download process completed."

