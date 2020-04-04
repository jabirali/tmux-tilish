# Tmux Tilish

This is a plugin that makes `tmux` act and feel more like a tiling window
manager. Most of the keybindings are just taken [directly from `i3wm`][1].
However, I have made some adjustments to make the keybindings more similar
to `vim`: notably, using `hjkl` instead of `jkl;` for cardinal directions,
and using `vim`'s interpretations of "vertical" and "horizontal" splits.

You can find a full list of keybindings below. I'd be happy to receive 
feedback and suggestions on this plugin. For instance, if there's interest,
I'd be happy to add a config option that makes the keybindings more similar
to "vanilla" `i3wm`. However, I'm under the impression that the majority of
`i3wm` users anyway remap their keys to be more similar to `vim`, so I'm
not planning to implement it unless I get a signal that there's interest.

[1]: https://i3wm.org/docs/refcard.html

## Why?

Okay, so who is this plugin for anyway? You may be interested in this if:

- You're using or interested in using `tmux`, but find the default keybindings
  a bit clunky. This lets you try out an alternative keybinding paradigm, 
  which uses a modifier key (`Alt`) instead of a prefix key (e.g. `Ctrl-b`).
- You love `i3wm`, but also do a fair bit of remote work over `ssh` + `tmux`.
  This lets you use similar keybindings in your remote terminal as locally.
- You also use other platforms like Gnome, Mac, or Windows Subsystem for Linux.
  You want to take your `i3wm` muscle memory with you to all these platforms.
- You're not really using `i3wm` anymore, but you did like how it handled
  terminals and workspace. You'd like to keep working that way in terminals.

Personally, I made this because I loved the `i3wm` paradigm and keybindings,
but these days I'm mostly using Gnome/Wayland at home and WSL/Windows. Then,
`tmux` lets me have a consistent user interface for tabs and splits across
all platforms, while this lets me use the (IMHO) more efficient `i3wm` keys.

## Quickstart

The easiest way to install this plugin is via the [Tmux Plugin Manager][2].
Just add the following to `~/.tmux.conf`, then press `C-b I` to install:

	set -g @plugin 'jabirali/tmux-tilish'

It is also recommended that you add the following to the top of your `.tmux.conf`:

	set -s escape-time 0
	set -g base-index 1

This plugin should work fine without these settings. However, without the first one,
you may accidentally trigger e.g. the `Alt` + `h` binding by pressing `Esc` + `h`,
something that can happen often if you use `vim` in `tmux`. The second one makes
the window numbers go from 1-10 instead of 0-9, which in my opinion makes much 
more sense on a keyboard where the number row starts at 1. However, the plugin
will check this setting explicitly when mapping keys, and should work without it.

[2]: https://github.com/tmux-plugins/tpm
