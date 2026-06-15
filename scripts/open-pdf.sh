#!/usr/bin/env bash
set -euo pipefail

DIRS=(
  "/mnt/media/Books"
)

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(
    fd --type f \
      --extension djvu \
      --extension epub \
      --extension pdf \
      . "${DIRS[@]}" \
    | sort -u \
    | fzf)

  [[ -n "$selected" ]] || exit 0
fi

# Normalize path if needed
selected="$(realpath "$selected")"

# Launch in tmux or fallback
if [[ -n "${TMUX:-}" ]]; then
  tmux new-window -n "reader" "zathura $(printf '%q' "$selected")"
else
  exec zathura "$selected" &
fi
