#!/bin/bash

OLD_FILE="$2"
NEW_FILE="$1"

if [ "$LAZYGIT_DIFF_TOOL" = "difftastic" ]; then
	difft --color=always "$OLD_FILE" "$NEW_FILE"
else
	git diff --no-ext-diff --no-index --color=always "$OLD_FILE" "$NEW_FILE" | delta --dark --paging=never
fi
