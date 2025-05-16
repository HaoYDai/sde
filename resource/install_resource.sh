#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
tq_exec=$script_dir/bin/tq

check_file() {
    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        echo "File $file_path does not exist."
        return 1
    fi
    return 0
}

install_file() {
    local file_path="$1"
    local file_type="$2"
    local target_dir=/usr/local
    echo "Installing from file: $file_path"

    case "$file_type" in
        tar.gz)
            tar -xzvf "$file_path" -C "$target_dir" --strip-components=1
            ;;
        tar.xz)
            tar -xJvf "$file_path" -C "$target_dir" --strip-components=1
            ;;
        tar.bz2)
            tar -xjvf "$file_path" -C "$target_dir" --strip-components=1
            ;;
        tar)
            tar -xvf "$file_path" -C "$target_dir" --strip-components=1
            ;;
        *)
            echo "Unsupported file type: $file_type"
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        echo "Successfully installed from $file_path."
    else
        echo "Failed to install from $file_path."
        return 1
    fi
}

check_files_in_list() {
    local toml_file="resources.toml"
    local current_dir=$script_dir

    if [ ! -f "$tq_exec" ]; then
        echo "tq executable not found at $tq_exec. Please check the path."
        exit 1
    fi

    if [ ! -f "$current_dir/$toml_file" ]; then
        echo "TOML file not found at $current_dir/$toml_file. Please check the path."
        exit 1
    fi

    # 使用 tq 解析文件名和下载地址
    local files=($("$tq_exec" '.resources[].name' "$current_dir/$toml_file" -r))
    local types=($("$tq_exec" '.resources[].type' "$current_dir/$toml_file" -r))

    for i in "${!files[@]}"; do
        local partial_name="${files[$i]}"
        local type="${types[$i]}"
        local found=0

        for file in "$current_dir"/*; do
            if [[ "$(basename "$file")" == *"$partial_name"* ]]; then
                echo "File matching '$partial_name' exists: $file"
                install_file "$file" "$type"
            fi
        done
    done
}

check_files_in_list

rm -rf /opt/resource
