#!/usr/bin/env bash
set -euo pipefail

DIRS=(
  "$HOME"
  "$HOME/Documents"
  "$HOME/Documents/Projects"
)

# Pick directory (or use argument)
if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(
    fd --type d --max-depth 1 . "${DIRS[@]}" \
      | sed "s|^$HOME/||" \
      | sort -u \
      | sk
  )

  [[ -n "$selected" ]] || exit 0
  selected="$HOME/$selected"
fi

# Session name
selected_name=$(basename "$selected" | tr '.' '_')

# Create session if it doesn't exist
if ! tmux has-session -t "$selected_name" 2>/dev/null; then
  tmux new-session -d -s "$selected_name" -c "$selected" -n "shell"
  tmux new-window -t "$selected_name" -c "$selected" -n "vim" "nvim"
fi

# Switch / attach safely
if [[ -n "${TMUX:-}" ]]; then
  tmux switch-client -t "$selected_name"
else
  tmux attach -t "$selected_name"
fi
