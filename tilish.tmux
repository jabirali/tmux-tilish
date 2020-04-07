#!/bin/sh
# vim: foldmethod=marker

# Project: tmux-tilish
# Author:  Jabir Ali Ouassou <jabirali@switzerlandmail.ch>
# Licence: MIT licence
# 
# This file contains the `tmux` plugin `tilish`, which implements keybindings
# that turns `tmux` into a more typical tiling window manger for your terminal.
# The keybindings are taken nearly directly from `i3wm` and `sway`, but with
# minor adaptation to fit better with `vim` and `tmux`. See also the README.

# Check input parameters {{{
	# Get version and options.
	options="$(tmux show-options -g | sed -ne 's/^@tilish-\([[:alpha:]]*\)\s\s*.\(\S*\).\s*$/\1=\2/p')"
	version="$(tmux -V | sed 's/\S* \([0-9]\)\..*/\1/')"
	
	# Set option variables.
	for n in $options
	do 
		export $n
	done
	
	# Determine "arrow types".
	if [ -n "$easymode" ]
	then
		# Simplified arrows.
		h='left';   j='down';   k='up';   l='right';
		H='S-left'; J='S-down'; K='S-up'; L='S-right';
	else
		# Vim-style arrows.
		h='h'; j='j'; k='k'; l='l';
		H='H'; J='J'; K='K'; L='L';
	fi
# }}}

# Define core functionality {{{
bind_switch () {
	# Bind keys to switch between workspaces.
	tmux bind -n "$1" \
		if-shell "tmux select-window -t :$2" "" "new-window -t :$2"
}

bind_move () {
	# Bind keys to move panes between workspaces.
	if [ "$version" -ge 2 ]
	then
		tmux bind -n "$1" \
			if-shell "tmux join-pane -t :$2" \
				"" \
				"new-window -dt :$2; join-pane -t :$2; select-pane -t top-left; kill-pane" \\\;\
			select-layout \\\;\
			select-layout -E
	else
		tmux bind -n "$1" \
			if-shell "tmux new-window -dt :$2" \
				"join-pane -t :$2; select-pane -t top-left; kill-pane" \
				"send escape; join-pane -t :$2" \\\;\
			select-layout
	fi
}

bind_layout () {
	# Bind keys to switch or refresh layouts.
	if [ "$2" = "fullscreen" ]
	then
		# Invoke the zoom feature.
		tmux bind -n "$1" \
			resize-pane -Z
	else
		# Actually switch layout.
		if [ "$version" -ge 2 ]
		then
			tmux bind -n "$1" \
				select-layout "$2" \\\;\
				select-layout -E
		else
			tmux bind -n "$1" \
				run-shell "tmux select-layout \"$2\"" \\\;\
				send escape
		fi
	fi
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
if [ "$(tmux show-options -g base-index)" = "base-index 1" ]
then
	bind_switch 'M-0' 10
	bind_move   'M-)' 10
else 
	bind_switch 'M-0' 0
	bind_move   'M-)' 0
fi

# Switch layout with Alt + <mnemonic key>. The mnemonics are `s` and `S` for 
# layouts Vim would generate with `:split`, and `v` and `V` for `:vsplit`.
# The remaining mappings based on `f` and `t` should be quite obvious.
bind_layout 'M-s' 'main-horizontal'
bind_layout 'M-S' 'even-vertical'
bind_layout 'M-v' 'main-vertical'
bind_layout 'M-V' 'even-horizontal'
bind_layout 'M-f' 'fullscreen'
bind_layout 'M-t' 'tiled'

# Refresh the current layout (e.g. after deleting a pane).
if [ "$version" -ge 2 ]
then
	tmux bind -n 'M-r' select-layout -E
else
	tmux bind -n 'M-r' run-shell 'tmux select-layout'\\\; send escape
fi

# Switch to pane via Alt + hjkl.
tmux bind -n "M-$h" select-pane -L
tmux bind -n "M-$j" select-pane -D
tmux bind -n "M-$k" select-pane -U
tmux bind -n "M-$l" select-pane -R

# Move a pane via Alt + Shift + hjkl.
if [ "$version" -ge 2 ]
then
	tmux bind -n "M-$H" swap-pane -s '{left-of}'
	tmux bind -n "M-$J" swap-pane -s '{down-of}'
	tmux bind -n "M-$K" swap-pane -s '{up-of}'
	tmux bind -n "M-$L" swap-pane -s '{right-of}'
else
	tmux bind -n "M-$H" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -L; tmux swap-pane -t $old'
	tmux bind -n "M-$J" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -D; tmux swap-pane -t $old'
	tmux bind -n "M-$K" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -U; tmux swap-pane -t $old'
	tmux bind -n "M-$L" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -R; tmux swap-pane -t $old'
fi

# Open a terminal with Alt + Enter.
if [ "$version" -ge 2 ]
then
	tmux bind -n 'M-enter' \
		run-shell 'cwd="`tmux display -p \"#{pane_current_path}\"`"; tmux select-pane -t "bottom-right"; tmux split-pane -c "$cwd"'
else
	tmux bind -n 'M-enter' \
		select-pane -t 'bottom-right' \\\;\
		split-window \\\;\
		run-shell 'tmux select-layout' \\\;\
		send escape
fi

# Close a window with Alt + Shift + q.
if [ "$version" -ge 2 ]
then
	tmux bind -n 'M-Q' \
		kill-pane \\\;\
		select-layout \\\;\
		select-layout -E
else
	tmux bind -n 'M-Q' \
		kill-pane
fi

# Close a connection with Alt + Shift + e.
tmux bind -n 'M-E' \
	confirm-before -p "Detach from #H:#S? (y/n)" detach-client

# Reload configuration with Alt + Shift + c.
tmux bind -n 'M-C' \
	source-file ~/.tmux.conf \\\;\
	display "Reloaded config"
# }}}

# Define hooks {{{
if [ "$version" -ge 2 ]
then
	# Autorefresh layout after deleting a pane.
	tmux set-hook after-split-window "select-layout; select-layout -E"
	tmux set-hook pane-exited "select-layout; select-layout -E"
	
	# Autoselect layout after creating new window.
	if [ -n "$default" ]
	then
		tmux set-hook window-linked "select-layout $default; select-layout -E"
		tmux select-layout $default
		tmux select-layout -E
	fi
fi
# }}}

# Integrate with `vim-tmux-navigator` {{{
if [ -n "$navigator" ]
then
	# If `@tilish-navigator` is nonzero, we override the Alt + hjkl bindings.
	# This assumes that your Vim/Neovim is setup to use Alt + hjkl as well.
	is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
	
	tmux bind -n "M-$h" if-shell "$is_vim" 'send M-h' 'select-pane -L'
	tmux bind -n "M-$j" if-shell "$is_vim" 'send M-j' 'select-pane -D'
	tmux bind -n "M-$k" if-shell "$is_vim" 'send M-k' 'select-pane -U'
	tmux bind -n "M-$l" if-shell "$is_vim" 'send M-l' 'select-pane -R'
	
	tmux bind -T copy-mode-vi "M-$h" select-pane -L
	tmux bind -T copy-mode-vi "M-$j" select-pane -D
	tmux bind -T copy-mode-vi "M-$k" select-pane -U
	tmux bind -T copy-mode-vi "M-$l" select-pane -R
fi
# }}}

# Integrate with `fzf` to approximate `dmenu` {{{
if [ "$version" -ge 2 -a -n "$dmenu" ]
then
	if [ -n "$(which fzf)" ]
	then
		# The environment variables of your `default-shell` are used when running `fzf`.
		# This solution is about an order of magnitude faster than invoking `compgen`.
		# Based on: https://medium.com/njiuko/using-fzf-instead-of-dmenu-2780d184753f
		tmux bind -n 'M-d' \
			select-pane -t '{bottom-right}' \\\;\
			split-pane 'sh -c "exec \$(echo \"\$PATH\" | tr \":\" \"\n\" | xargs -I{} -- find {} -maxdepth 1 -mindepth 1 -executable 2>/dev/null | sort -u | fzf)"'
	else
		tmux bind -n 'M-d' \
			display 'To enable this function, install `fzf` and restart `tmux`.'
	fi
fi
# }}}
