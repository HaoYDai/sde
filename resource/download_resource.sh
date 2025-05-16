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
    local urls=($("$tq_exec" '.resources[].url' "$current_dir/$toml_file" -r))

    for i in "${!files[@]}"; do
        local partial_name="${files[$i]}"
        local url="${urls[$i]}"
        local found=0

        for file in "$current_dir"/*; do
            if [[ "$(basename "$file")" == *"$partial_name"* ]]; then
                echo "File matching '$partial_name' exists: $file"
                found=1
                break
            fi
        done

        if [ $found -eq 0 ]; then
            echo "No file matching '$partial_name' found in $current_dir. Downloading from $url..."
            wget --show-progress "$url" -P "$current_dir"
            if [ $? -eq 0 ]; then
                echo "Downloaded '$partial_name' from $url."
            else
                echo "Failed to download '$partial_name' from $url."
            fi
        fi
    done
}

# 执行检查
check_files_in_list