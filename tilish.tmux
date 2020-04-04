#!/usr/bin/env bash

# Count workspaces from 1 like i3, as assumed by the keybindings below. IMHO,
# this also makes more sense on a keyboard where the number row starts at 1.
tmux set -g base-index 1

# Switch to workspace via Alt + #.
tmux bind -n 'M-1' \
	if-shell 'tmux select-window -t :1' '' 'new-window -t :1'
tmux bind -n 'M-2' \
	if-shell 'tmux select-window -t :2' '' 'new-window -t :2'
tmux bind -n 'M-3' \
	if-shell 'tmux select-window -t :3' '' 'new-window -t :3'
tmux bind -n 'M-4' \
	if-shell 'tmux select-window -t :4' '' 'new-window -t :4'
tmux bind -n 'M-5' \
	if-shell 'tmux select-window -t :5' '' 'new-window -t :5'
tmux bind -n 'M-6' \
	if-shell 'tmux select-window -t :6' '' 'new-window -t :6'
tmux bind -n 'M-7' \
	if-shell 'tmux select-window -t :7' '' 'new-window -t :7'
tmux bind -n 'M-8' \
	if-shell 'tmux select-window -t :8' '' 'new-window -t :8'
tmux bind -n 'M-9' \
	if-shell 'tmux select-window -t :9' '' 'new-window -t :9'
tmux bind -n 'M-0' \
	if-shell 'tmux select-window -t :10' '' 'new-window -t :10'

# Move pane to workspace via Alt + Shift + #.
tmux bind -n 'M-!' \
	if-shell 'tmux join-pane -t :1' '' 'break-pane -t :1' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-@' \
	if-shell 'tmux join-pane -t :2' '' 'break-pane -t :2' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-#' \
	if-shell 'tmux join-pane -t :3' '' 'break-pane -t :3' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-$' \
	if-shell 'tmux join-pane -t :4' '' 'break-pane -t :4' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-%' \
	if-shell 'tmux join-pane -t :5' '' 'break-pane -t :5' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-^' \
	if-shell 'tmux join-pane -t :6' '' 'break-pane -t :6' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-&' \
	if-shell 'tmux join-pane -t :7' '' 'break-pane -t :7' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-*' \
	if-shell 'tmux join-pane -t :8' '' 'break-pane -t :8' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-(' \
	if-shell 'tmux join-pane -t :9' '' 'break-pane -t :9' \\\;\
	select-layout \\\;\
	select-layout -E
tmux bind -n 'M-)' \
	if-shell 'tmux join-pane -t :10' '' 'break-pane -t :10' \\\;\
	select-layout \\\;\
	select-layout -E

# Switch to pane via Alt + hjkl.
tmux bind -n 'M-h' select-pane -L
tmux bind -n 'M-j' select-pane -D
tmux bind -n 'M-k' select-pane -U
tmux bind -n 'M-l' select-pane -R

# Move pane via Alt + Shift + hjkl.
tmux bind -n 'M-H' swap-pane -s '{left-of}'
tmux bind -n 'M-J' swap-pane -s '{down-of}'
tmux bind -n 'M-K' swap-pane -s '{up-of}'
tmux bind -n 'M-L' swap-pane -s '{right-of}'

# Make :split layouts with Alt + s.
tmux bind -n 'M-s' \
	select-layout main-horizontal \\\;\
	select-layout -E
tmux bind -n 'M-S' \
	select-layout even-vertical \\\;\
	select-layout -E

# Make :vsplit layouts with Alt + v.
tmux bind -n 'M-v' \
	select-layout main-vertical \\\;\
	select-layout -E
tmux bind -n 'M-V' \
	select-layout even-horizontal \\\;\
	select-layout -E

# Make tiled layouts with Alt + t.
tmux bind -n 'M-t' \
	select-layout tiled \\\;\
	select-layout -E

# Switch to fullscreen with Alt + f.
tmux bind -n 'M-f' \
	resize-pane -Z

# Open a terminal with Alt + Enter.
tmux bind -n 'M-enter' \
	select-pane -t '{bottom-right}' \\\;\
	split-pane -h \\\;\
	select-layout \\\;\
	select-layout -E

# Close a window with Alt + Shift + q.
tmux bind -n 'M-Q' \
	kill-pane

# Close a connection with Alt + Shift + e.
tmux bind -n 'M-E' \
	confirm-before -p "Detach from #H:#S? (y/n)" detach-client

# Reload configuration with Alt + Shift + c.
tmux bind -n 'M-C' \
	source-file ~/.tmux.conf \\\;\
	display "Reloaded config"
