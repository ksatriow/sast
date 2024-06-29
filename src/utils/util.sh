#!/bin/bash

log_message() {
    local message="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $message"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        cp "$file" "${file}.bak"
        log_message "Backup of '$file' created as '${file}.bak'"
    else
        log_message "File '$file' not found, no backup created"
    fi
}

file_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        return 0
    else
        return 1
    fi
}

dir_exists() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        return 0
    else
        return 1
    fi
}

create_dir_if_not_exists() {
    local dir="$1"
    if ! dir_exists "$dir"; then
        mkdir -p "$dir"
        log_message "Directory '$dir' created"
    else
        log_message "Directory '$dir' already exists"
    fi
}

find_and_replace() {
    local find="$1"
    local replace="$2"
    local file="$3"
    if file_exists "$file"; then
        sed -i "s/$find/$replace/g" "$file"
        log_message "Replaced '$find' with '$replace' in '$file'"
    else
        log_message "File '$file' not found, cannot replace text"
    fi
}

download_file() {
    local url="$1"
    local output="$2"
    if command_exists "curl"; then
        curl -o "$output" "$url"
        log_message "File downloaded from '$url' to '$output'"
    elif command_exists "wget"; then
        wget -O "$output" "$url"
        log_message "File downloaded from '$url' to '$output'"
    else
        log_message "Neither curl nor wget is installed"
    fi
}

disk_usage() {
    local dir="$1"
    if dir_exists "$dir"; then
        du -sh "$dir"
    else
        log_message "Directory '$dir' not found"
    fi
}

list_files() {
    local dir="$1"
    if dir_exists "$dir"; then
        ls -l "$dir"
    else
        log_message "Directory '$dir' not found"
    fi
}

archive_dir() {
    local dir="$1"
    local output="${2:-${dir}.tar.gz}"
    if dir_exists "$dir"; then
        tar -czf "$output" "$dir"
        log_message "Directory '$dir' archived as '$output'"
    else
        log_message "Directory '$dir' not found, cannot archive"
    fi
}

extract_archive() {
    local archive="$1"
    local output_dir="${2:-.}"
    if file_exists "$archive"; then
        tar -xzf "$archive" -C "$output_dir"
        log_message "Archive '$archive' extracted to '$output_dir'"
    else
        log_message "Archive '$archive' not found, cannot extract"
    fi
}

send_email() {
    local to="$1"
    local subject="$2"
    local body="$3"
    if command_exists "mailx"; then
        echo "$body" | mailx -s "$subject" "$to"
        log_message "Email sent to '$to' with subject '$subject'"
    else
        log_message "mailx command is not installed"
    fi
}
