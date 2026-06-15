#!/usr/bin/env bash
set -euo pipefail

cd "$(tmux display-message -p -F "#{pane_current_path}")"

url=$(git remote get-url origin 2>/dev/null || true)

if [[ "$url" == *github.com* ]]; then
    if [[ "$url" == git@* ]]; then
        url="${url#git@}"
        url="${url/:/\/}"
        url="https://$url"
    fi
    xdg-open "$url"
else
    echo "This repository is not hosted on GitHub"
fi
