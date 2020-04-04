# Tmux Tilish

This is a plugin that makes `tmux` act and feel more like a tiling window
manager. Most of the keybindings are just taken [directly from `i3wm`][1].
However, I have made some adjustments to make the keybindings more similar
to `vim`: notably, using <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> 
instead of <kbd>j</kbd><kbd>k</kbd><kbd>l</kbd><kbd>;</kbd> for cardinal 
directions, and `vim`'s interpretations of what a "split" and "vsplit" is.

You can find a full list of keybindings below. I'd be happy to receive 
feedback and suggestions. For instance, if there's interest, I could add
a config option that makes the keybindings more similar to "vanilla" `i3wm`.
However, I have the impression that *most* `i3wm` users anyway remap their 
keys to be more like `vim`, so I'm not adding this unless there's interest.

[1]: https://i3wm.org/docs/refcard.html

## Why?

Okay, so who is this plugin for anyway? You may be interested in this if:

- You're using or interested in using `tmux`, but find the default keybindings
  a bit clunky. This lets you try out an alternative keybinding paradigm, 
  which uses a modifier key (<kbd>Alt</kbd>) instead of a prefix key 
  (e.g. <kbd>Ctrl</kbd> + <kbd>b</kbd>).
- You love `i3wm`, but also do a remote work over `ssh` + `tmux`. This lets 
  you use similar keybindings in both contexts.
- You also use other platforms like Gnome, Mac, or WSL. You want to take 
  your `i3wm` muscle memory with you via `tmux`.
- You're not really using `i3wm` anymore, but you did like how it handled
  terminals and workspaces. You'd like to keep working that way in terminals,
  without using `i3wm` or `sway` for your whole desktop.

Personally, I made this because I loved the `i3wm` paradigm and keybindings,
but these days I'm mostly using Gnome/Wayland at home and WSL/Windows at work.
Now, `tmux` lets me have a consistent user interface for tabs and splits across
both platforms, and this plugin lets me use the (IMHO) more efficient `i3wm` keys.

## Quickstart

The easiest way to install this plugin is via the [Tmux Plugin Manager][2].
Just add the following to `~/.tmux.conf`, then press <kbd>Ctrl</kbd> + <kbd>b</kbd>
followed by <kbd>Shift</kbd> + <kbd>i</kbd> to install it (assuming default prefix key):

	set -g @plugin 'jabirali/tmux-tilish'

It is also recommended that you add the following to the top of your `.tmux.conf`:

	set -s escape-time 0
	set -g base-index 1

This plugin should work fine without these settings. However, without the first one,
you may accidentally trigger e.g. the <kbd>Alt</kbd> + <kbd>h</kbd> binding by pressing
<kbd>Esc</kbd> + <kbd>h</kbd>, something that can happen often if you use `vim` in `tmux`. 
Note that this setting only has to be set manually if you don't use [tmux-sensible][4].
The second one makes the window numbers go from 1-10 instead of 0-9, which IMO
makes more sense on a keyboard where the number row starts at 1. This behavior
is also more similar to how `i3wm` numbers its workspaces. However, the plugin
will check this setting explicitly when mapping keys, and works fine without it.

If you use `vim-tmux-navigator`, which you should if you're using `vim` or `neovim`,
see the section at the end of this README for how to integrate it with `tilish`.

[2]: https://github.com/tmux-plugins/tpm
[4]: https://github.com/tmux-plugins/tmux-sensible

## Keybindings

Finally, here is a list of the actual keybindings. Most are [taken from `i3wm`][1].
Below, a "workspace" is what `tmux` would call a "window" and `vim` would call a "tab",
while a "pane" is what `i3wm` would call a "window" and `vim` would call a "split".
The words "split" and "vsplit" below refer to the layouts you get in `vim` when
running the commands `:split` and `:vsplit`, respectively. (Unfortunately, what
is called a "vertical" and "horizontal" split seems to vary between programs.)

| Keybinding | Description |
| ---------- | ----------- |
| <kbd>Alt</kbd> + <kbd>0</kbd>-<kbd>9</kbd> | Switch to workspace number 0-9 |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>0</kbd>-<kbd>9</kbd> | Move pane to workspace 0-9 |
| <kbd>Alt</kbd> + <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> | Move focus left/down/up/right |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> | Move pane left/down/up/right |
| <kbd>Alt</kbd> + <kbd>Enter</kbd> | Create a new pane at "the end" of the current layout |
| <kbd>Alt</kbd> + <kbd>s</kbd> | Switch to layout: split then vsplit |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>s</kbd> | Switch to layout: only split |
| <kbd>Alt</kbd> + <kbd>v</kbd> | Switch to layout: vsplit then split |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>v</kbd> | Switch to layout: only vsplit |
| <kbd>Alt</kbd> + <kbd>t</kbd> | Switch to layout: fully tiled |
| <kbd>Alt</kbd> + <kbd>f</kbd> | Switch to layout: fullscreen (zoom) |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>q</kbd> | Quit (close) pane |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>e</kbd> | Exit (detach) `tmux` |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>c</kbd> | Reload config |

The <kbd>Alt</kbd> + <kbd>0</kbd> and <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>0</kbd> 
bindings are "smart": depending on `base-index`, they either act on workspace 0 or 10.

The keybindings that move panes between workspaces assume a US keyboard layout.
As far as I know, `tmux` has no way of knowing what your keyboard layout is,
especially if you're working over `ssh`. However, if you know of a way to make 
this more portable without manually adding all keyboard layouts, let me know.

It is worth noting that not all terminals support all keybindings. I've tested
that the above works out-of-the-box on `alacritty`, `kitty`, `urxvt`, and 
`gnome-terminal` on Linux. On `wsltty` (Windows), it works if you disable the 
terminal keyboard shortcut <kbd>Alt</kbd>+<kbd>Enter</kbd> in the settings.
Note that in `gnome-terminal`, it only works if you don't open any GUI tabs;
if so, then the terminal steals the <kbd>Alt</kbd>+<kbd>0</kbd>-<kbd>9</kbd>
keybindings for the GUI tabs. Note that almost none of the <kbd>Alt</kbd> 
keys seem to work by default on an old-fashioned `xterm`. 

## Integration with vim-tmux-navigator

There is a great `vim` plugin called [vim-tmux-navigator][3], which allows seamless 
navigation between `vim` splits and `tmux` splits. If you're using that plugin,
you can tell `tilish` about it to make it setup the keybindings for you. (If you
don't tell `tilish`, it uses fallback keybindings that only work in `tmux`.)

The process is quite simple. First install the plugin for `vim` or `neovim`, as
described on the [vim-tmux-navigator website][3]. Then place this in your
`~/.config/nvim/init.vim` (`neovim`) or `~/.vimrc` (`vim`):

	noremap <silent> <m-h> :TmuxNavigateLeft<cr>
	noremap <silent> <m-j> :TmuxNavigateDown<cr>
	noremap <silent> <m-k> :TmuxNavigateUp<cr>
	noremap <silent> <m-l> :TmuxNavigateRight<cr>

You then just have to tell `tilish` that you want the integration:

	set -g @tilish-navigator 'on'

A minimal working  example of a `~/.tmux.conf` with `tpm` would then be:

	# List of plugins.
	set -g @plugin 'tmux-plugins/tpm'
	set -g @plugin 'tmux-plugins/tmux-sensible'
	set -g @plugin 'jabirali/tmux-tilish'
	
	# Plugin options.
	set -g @tilish-navigator 'on'
	
	# Install `tpm` if needed.
	if "test ! -d ~/.tmux/plugins/tpm" \
	   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"
	
	# Activate the plugins.
	run -b "~/.tmux/plugins/tpm/tpm"

[3]: https://github.com/christoomey/vim-tmux-navigator

