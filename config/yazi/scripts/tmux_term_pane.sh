#!/usr/bin/env sh

if tmux list-panes | grep ^2: ; then
  SECOND_PANE_APP=$(tmux list-panes -F "#{pane_current_command}" | tail -n 1)

  if [ $SECOND_PANE_APP == "fish" ] || [ $SECOND_PANE_APP == "tmux" ]
  then
    CURRENT_DIR=$(tmux display-message -p -F "#{pane_current_path}" -t1)

    tmux send-keys -t 2 "cd \"$CURRENT_DIR\"" C-m
    tmux select-pane -t 2
  else
    tmux select-pane -t 2
  fi
else
  tmux split-window -l 15
fi
