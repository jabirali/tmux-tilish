#!/bin/sh
# vim: foldmethod=marker

# Project: tmux-tilish
# Author:  Jabir Ali Ouassou <jabir.ali.ouassou@hvl.no>
# Licence: MIT licence
#
# This file contains the `tmux` plugin `tilish`, which implements keybindings
# that turns `tmux` into a more typical tiling window manger for your terminal.
# The keybindings are taken nearly directly from `i3wm` and `sway`, but with
# minor adaptation to fit better with `vim` and `tmux`. See also the README.

# shellcheck disable=SC2016
# shellcheck disable=SC2086
# shellcheck disable=SC2250

# Check input parameters {{{
	# Whether we need to use legacy workarounds (required before Tmux 2.7).
	legacy="$(tmux -V | grep -E 'tmux (1\.|2\.[0-6])')"

	# Read user options.
	for opt in default dmenu easymode navigate navigator prefix shiftnum
	do
		export "$opt"="$(tmux show-option -gv @tilish-"$opt" 2>/dev/null)"
	done

	# Default to US keyboard layout, unless something is configured.
	if [ -z "$shiftnum" ]
	then
		shiftnum='!@#$%^&*()'
	fi

	# Determine "arrow types".
	if [ "${easymode:-}" = "on" ]
	then
		# Simplified arrows.
		h='left';   j='down';   k='up';   l='right';
		H='S-left'; J='S-down'; K='S-up'; L='S-right';
	else
		# Vim-style arrows.
		h='h'; j='j'; k='k'; l='l';
		H='H'; J='J'; K='K'; L='L';
	fi

	# Determine modifier vs. prefix key.
	if [ -z "${prefix:-}" ]
	then
		bind='bind -n'
		mod='M-'
	else
		bind='bind -rT tilish'
		mod=''
	fi
# }}}

# Define core functionality {{{
bind_switch () {
	# Bind keys to switch between workspaces.
	tmux $bind "$1" \
		if-shell "tmux select-window -t :$2" "" "new-window -t :$2"
}

bind_move () {
	# Bind keys to move panes between workspaces.
	if [ -z "$legacy" ]
	then
		tmux $bind "$1" \
			if-shell "tmux join-pane -t :$2" \
				"" \
				"new-window -dt :$2; join-pane -t :$2; select-pane -t top-left; kill-pane" \\\;\
			select-layout \\\;\
			select-layout -E
	else
		tmux $bind "$1" \
			if-shell "tmux new-window -dt :$2" \
				"join-pane -t :$2; select-pane -t top-left; kill-pane" \
				"send escape; join-pane -t :$2" \\\;\
			select-layout
	fi
}

bind_layout () {
	# Bind keys to switch or refresh layouts.
	if [ "$2" = "zoom" ]
	then
		# Invoke the zoom feature.
		tmux $bind "$1" \
			resize-pane -Z
	else
		# Actually switch layout.
		if [ -z "$legacy" ]
		then
			tmux $bind "$1" \
				select-layout "$2" \\\;\
				select-layout -E
		else
			tmux $bind "$1" \
				run-shell "tmux select-layout \"$2\"" \\\;\
				send escape
		fi
	fi
}

char_at () {
	# Finding the character at a given position in
	# a string in a way compatible with POSIX sh.
	echo $1 | cut -c $2
}
# }}}

# Define keybindings {{{
# Define a prefix key.
if [ -n "$prefix" ]
then
	tmux bind -n "$prefix" switch-client -T tilish
fi

# Switch to workspace via Alt + #.
bind_switch "${mod}1" 1
bind_switch "${mod}2" 2
bind_switch "${mod}3" 3
bind_switch "${mod}4" 4
bind_switch "${mod}5" 5
bind_switch "${mod}6" 6
bind_switch "${mod}7" 7
bind_switch "${mod}8" 8
bind_switch "${mod}9" 9

# Move pane to workspace via Alt + Shift + #.
bind_move "${mod}$(char_at $shiftnum 1)" 1
bind_move "${mod}$(char_at $shiftnum 2)" 2
bind_move "${mod}$(char_at $shiftnum 3)" 3
bind_move "${mod}$(char_at $shiftnum 4)" 4
bind_move "${mod}$(char_at $shiftnum 5)" 5
bind_move "${mod}$(char_at $shiftnum 6)" 6
bind_move "${mod}$(char_at $shiftnum 7)" 7
bind_move "${mod}$(char_at $shiftnum 8)" 8
bind_move "${mod}$(char_at $shiftnum 9)" 9

# The mapping of Alt + 0 and Alt + Shift + 0 depends on `base-index`.
# It can either refer to workspace number 0 or workspace number 10.
if [ "$(tmux show-option -gv base-index)" = "1" ]
then
	bind_switch "${mod}0" 10
	bind_move   "${mod}$(char_at "$shiftnum" 10)" 10
else
	bind_switch "${mod}0" 0
	bind_move   "${mod}$(char_at "$shiftnum" 10)" 0
fi

# Switch layout with Alt + <mnemonic key>. The mnemonics are `s` and `S` for
# layouts Vim would generate with `:split`, and `v` and `V` for `:vsplit`.
# The remaining mappings based on `z` and `t` should be quite obvious.
bind_layout "${mod}s" 'main-horizontal'
bind_layout "${mod}S" 'even-vertical'
bind_layout "${mod}v" 'main-vertical'
bind_layout "${mod}V" 'even-horizontal'
bind_layout "${mod}t" 'tiled'
bind_layout "${mod}z" 'zoom'

# Refresh the current layout (e.g. after deleting a pane).
if [ -z "$legacy" ]
then
	tmux $bind "${mod}r" select-layout -E
else
	tmux $bind "${mod}r" run-shell 'tmux select-layout'\\\; send escape
fi

# Switch pane via Alt + o. (Mirrors Tmux `Ctrl-b o` and Emacs `Ctrl-x o`.)
tmux $bind "${mod}o" select-pane -t :.+1

# Switch to pane via Alt + hjkl.
tmux $bind "${mod}${h}" select-pane -L
tmux $bind "${mod}${j}" select-pane -D
tmux $bind "${mod}${k}" select-pane -U
tmux $bind "${mod}${l}" select-pane -R

# Move a pane via Alt + Shift + hjkl.
if [ -z "$legacy" ]
then
	tmux $bind "${mod}${H}" swap-pane -s '{left-of}'
	tmux $bind "${mod}${J}" swap-pane -s '{down-of}'
	tmux $bind "${mod}${K}" swap-pane -s '{up-of}'
	tmux $bind "${mod}${L}" swap-pane -s '{right-of}'
else
	tmux $bind "${mod}${H}" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -L; tmux swap-pane -t $old'
	tmux $bind "${mod}${J}" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -D; tmux swap-pane -t $old'
	tmux $bind "${mod}${K}" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -U; tmux swap-pane -t $old'
	tmux $bind "${mod}${L}" run-shell 'old=`tmux display -p "#{pane_index}"`; tmux select-pane -R; tmux swap-pane -t $old'
fi

# Open a terminal with Alt + Enter.
if [ -z "$legacy" ]
then
	tmux $bind "${mod}enter" \
		run-shell 'cwd="`tmux display -p \"#{pane_current_path}\"`"; tmux select-pane -t "bottom-right"; tmux split-pane -c "$cwd"'
else
	tmux $bind "${mod}enter" \
		select-pane -t 'bottom-right' \\\;\
		split-window \\\;\
		run-shell 'tmux select-layout' \\\;\
		send escape
fi

# Name a window with Alt + n.
tmux $bind "${mod}n" \
	command-prompt -p 'Workspace name:' 'rename-window "%%"'

# Close a window with Alt + Shift + q.
if [ -z "$legacy" ]
then
	tmux $bind "${mod}Q" \
		if-shell \
			'[ "$(tmux display-message -p "#{window_panes}")" -gt 1 ]' \
			'kill-pane; select-layout; select-layout -E' \
			'kill-pane'
else
	tmux $bind "${mod}Q" \
		kill-pane
fi

# Close a connection with Alt + Shift + e.
tmux $bind "${mod}E" \
	confirm-before -p "Detach from #H:#S? (y/n)" detach-client

# Reload configuration with Alt + Shift + c.
tmux $bind "${mod}C" \
	source-file ~/.tmux.conf \\\;\
	display "Reloaded config"
# }}}

# Define hooks {{{
if [ -z "$legacy" ]
then
	# Autorefresh layout after deleting a pane.
	tmux set-hook -g after-split-window "select-layout; select-layout -E"
	tmux set-hook -g pane-exited "select-layout; select-layout -E"

	# Autoselect layout after creating new window.
	if [ -n "${default:-}" ]
	then
		tmux set-hook -g window-linked "select-layout \"$default\"; select-layout -E"
		tmux select-layout "$default"
		tmux select-layout -E
	fi
fi
# }}}

# Integrate with Vim for transparent navigation {{{
if [ "${navigate:-}" = "on" ]
then
	# If `@tilish-navigate` is nonzero, integrate Alt + hjkl with `tmux-navigate`.
	tmux set -g '@navigate-left'  "-n M-$h"
	tmux set -g '@navigate-down'  "-n M-$j"
	tmux set -g '@navigate-up'    "-n M-$k"
	tmux set -g '@navigate-right' "-n M-$l"
elif [ "${navigator:-}" = "on" ]
then
	# If `@tilish-navigator` is nonzero, integrate Alt + hjkl with `vim-tmux-navigator`.
	# This assumes that your Vim/Neovim is setup to use Alt + hjkl bindings as well.
	is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

	tmux $bind "${mod}${h}" if-shell "$is_vim" 'send M-h' 'select-pane -L'
	tmux $bind "${mod}${j}" if-shell "$is_vim" 'send M-j' 'select-pane -D'
	tmux $bind "${mod}${k}" if-shell "$is_vim" 'send M-k' 'select-pane -U'
	tmux $bind "${mod}${l}" if-shell "$is_vim" 'send M-l' 'select-pane -R'

	if [ -z "$prefix" ]
	then
		tmux bind -T copy-mode-vi "M-$h" select-pane -L
		tmux bind -T copy-mode-vi "M-$j" select-pane -D
		tmux bind -T copy-mode-vi "M-$k" select-pane -U
		tmux bind -T copy-mode-vi "M-$l" select-pane -R
	fi
fi
# }}}

# Integrate with `fzf` to approximate `dmenu` {{{
if [ -z "$legacy" ] && [ "${dmenu:-}" = "on" ]
then
	if [ -n "$(command -v fzf)" ]
	then
		# The environment variables of your `default-shell` are used when running `fzf`.
		# This solution is about an order of magnitude faster than invoking `compgen`.
		# Based on: https://medium.com/njiuko/using-fzf-instead-of-dmenu-2780d184753f
		tmux $bind "${mod}d" \
			select-pane -t '{bottom-right}' \\\;\
			split-pane 'sh -c "exec \$(echo \"\$PATH\" | tr \":\" \"\n\" | xargs -I{} -- find {} -maxdepth 1 -mindepth 1 -executable 2>/dev/null | sort -u | fzf)"'
	else
		tmux $bind "${mod}d" \
			display 'To enable this function, install `fzf` and restart `tmux`.'
	fi
fi
# }}}
