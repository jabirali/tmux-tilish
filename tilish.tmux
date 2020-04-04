#!/usr/bin/env bash
# vim: foldmethod=marker

# Project: tmux-tilish
# Author:  Jabir Ali Ouassou <jabirali@switzerlandmail.ch>
# Licence: MIT licence
# 
# This file contains the `tmux` plugin `tilish`, which implements keybindings
# that turns `tmux` into a more typical tiling window manger for your terminal.
# The keybindings are taken nearly directly from `i3wm` and `sway`, but with
# minor adaptation to fit better with `vim` and `tmux`. See also the README.

# Define core functionality {{{
bind_switch () {
	# Bind keys to switch between workspaces.
	tmux bind -n "$1" \
		if-shell "tmux select-window -t :$2" "" "new-window -t :$2"
}

bind_move () {
	# Bind keys to move panes between workspaces.
	tmux bind -n "$1" \
		if-shell "tmux join-pane -t :$2" "" "break-pane -t :$2" \\\;\
		select-layout \\\;\
		select-layout -E
}
# }}}

# Define keybindings {{{
# Switch to workspace via Alt + #.
bind_switch 'M-1' 1
bind_switch 'M-2' 2
bind_switch 'M-3' 3
bind_switch 'M-4' 4
bind_switch 'M-5' 5
bind_switch 'M-6' 6
bind_switch 'M-7' 7
bind_switch 'M-8' 8
bind_switch 'M-9' 9

# Move pane to workspace via Alt + Shift + #.
bind_move 'M-!' 1
bind_move 'M-@' 2
bind_move 'M-#' 3
bind_move 'M-$' 4
bind_move 'M-%' 5
bind_move 'M-^' 6
bind_move 'M-&' 7
bind_move 'M-*' 8
bind_move 'M-(' 9

# The mapping of Alt + 0 and Alt + Shift + 0 depends on `base-index`.
# It can either refer to workspace number 0 or workspace number 10.
if [ "$(tmux display -p '#{base-index}')" = 0 ]
then
	bind_switch 'M-0' 0
	bind_move   'M-)' 0
else 
	bind_switch 'M-0' 10
	bind_move   'M-)' 10
fi

# Switch to pane via Alt + hjkl.
tmux bind -n 'M-h' select-pane -t '{left-of}' 
tmux bind -n 'M-j' select-pane -t '{down-of}' 
tmux bind -n 'M-k' select-pane -t '{up-of}'   
tmux bind -n 'M-l' select-pane -t '{right-of}'

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
# }}}
