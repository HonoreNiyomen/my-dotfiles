#!/bin/bash
path=$(tmux display-message -p '#{pane_current_path}')
home=$HOME

if [[ $path == $home* ]]; then
    # Replace home with ~
    relative_path="~${path#$home}"
    # If path is deeper than 3 levels from ~, show ... + last 2 components
    if [[ $(echo "$relative_path" | tr '/' '\n' | wc -l) -gt 4 ]]; then
        echo "$relative_path" | awk -F/ '{print "~..." $(NF-1) "/" $NF}'
    else
        echo "$relative_path"
    fi
else
    # For paths outside home, show ... + last 2 components if deeper than 3 levels
    if [[ $(echo "$path" | tr '/' '\n' | wc -l) -gt 4 ]]; then
        echo "$path" | awk -F/ '{print "..." $(NF-1) "/" $NF}'
    else
        echo "$path"
    fi
fi
