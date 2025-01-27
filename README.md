# Tmux Tilish

This is a plugin that makes [`tmux`][6] behave more like a typical
[dynamic window manager][7]. It is heavily inspired by [`i3wm`][8], and 
most keybindings are taken [directly from there][1]. However, I have made 
some adjustments to make these keybindings more consistent with `vim`: 
using <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> instead of
<kbd>j</kbd><kbd>k</kbd><kbd>l</kbd><kbd>;</kbd> for directions, and 
using `vim`'s definitions of "split" and "vsplit". There is also an 
"easy mode" available for non-`vim` users, which uses arrow keys 
instead of <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd>.

The plugin has been verified to work on `tmux` v1.9, v2.6, v2.7, v2.9, and v3.0. 
Some features are only available on newer versions of `tmux` (currently v2.7+), 
but I hope to provide at least basic support for most `tmux` versions in active use.
If you encounter any problems, please file an issue and I'll try to look into it.

[1]: https://i3wm.org/docs/refcard.html
[6]: https://github.com/tmux/tmux/wiki/Getting-Started
[7]: https://en.wikipedia.org/wiki/Dynamic_window_manager
[8]: https://i3wm.org/docs/

## Why?

Okay, so who is this plugin for anyway? You may be interested in this if:

- You're using or interested in using `tmux`, but find the default keybindings
  a bit clunky. This lets you try out an alternative keybinding paradigm, 
  which uses a modifier key (<kbd>Alt</kbd>) instead of a prefix key 
  (<kbd>Ctrl</kbd> + <kbd>b</kbd>). The plugin also makes it easier to do
  automatic tiling via `tmux` layouts, as opposed to splitting panes manually.
- You use `i3wm`, but also do remote work over `ssh` + `tmux`. This lets 
  you use similar keybindings in both contexts.
- You also use other platforms like Gnome, Mac, or WSL. You want to take 
  your `i3wm` muscle memory with you via `tmux`.
- You're not really using `i3wm` anymore, but you did like how it handled
  terminals and workspaces. You'd like to keep working that way in terminals,
  without using `i3wm` or `sway` for your whole desktop.
- You use a window manager that is similar to `i3wm`, e.g. [`dwm`][9],
  and want to have that workflow in `tmux` too.

[9]: https://dwm.suckless.org/tutorial/

## Quickstart

The easiest way to install this plugin is via the [Tmux Plugin Manager][2].
Just add the following to `~/.tmux.conf`, then press <kbd>Ctrl</kbd> + <kbd>b</kbd>
followed by <kbd>Shift</kbd> + <kbd>i</kbd> to install it (assuming default prefix key):

	set -g @plugin 'jabirali/tmux-tilish'

For `tmux` v2.7+, you can customize which layout is used as default for new workspaces.
To do so, add this to your `tmux.conf`:

	set -g @tilish-default 'main-vertical'

Just replace `main-vertical` with one of the layouts from the `tmux` `man` page:

| Description       | Name              |
| ----------------- | ----------------- |
| split then vsplit | `main-horizontal` |
| only split        | `even-vertical`   |
| vsplit then split | `main-vertical`   |
| only vsplit       | `even-horizontal` |
| fully tiled       | `tiled`           |

The words "split" and "vsplit" refer to the layouts you get in `vim` when
running `:split` and `:vsplit`, respectively. (Unfortunately, what is called 
a "vertical" and "horizontal" split varies between programs.)
If you do not set this option, `tilish` will not autoselect any layout; you
can still choose layouts manually using the keybindings listed below.

By default, Tilish will enforce the selected layout by automatically reapplying
it every time a new pane is created or destroyed. If you want to disable this
feature, you can add one of these commands to your `tmux.conf`:

    set -g @tilish-enforce 'size'
    set -g @tilish-enforce 'none'

The former enforces that panes should have equal sizes, but does not move the
panes around to enforce the layout. The latter disables the feature completely.

After performing the steps above, you should read the [list of keybindings](#keybindings).
For further configuration options:

- If you use `nvim` or `vim`, consider [integrating it with `tilish`](#integration-with-vim).
- If you do not use `vim` or `kak`, consider activating [easy mode](#easy-mode).
- If you use `kak` or `emacs`, consider activating [prefix mode](#prefix-mode).
- If you use `tmux` within `i3wm` or `sway`, see [this section](#usage-inside-i3wm).
- If you like `fzf`, check out the [project launcher](#project-launcher) and [application launcher](#application-launcher).
- If it doesn't work, check your [terminal settings](#terminal-compatibility).

It is also recommended that you add the following to the top of your `tmux.conf`:

	set -s escape-time 0
	set -g base-index 1

The first line prevents e.g. <kbd>Esc</kbd> + <kbd>h</kbd> from triggering the
<kbd>Alt</kbd> + <kbd>h</kbd> keybinding, preventing common misbehavior when
using `vim` in `tmux`. This option is automatically set by [tmux-sensible][4], if 
you use that. The second line makes workspace numbers go from 1-10 instead of 0-9,
which makes more sense on a keyboard where the number row starts at 1. However,
`tilish` explicitly checks this setting when mapping keys, and works fine without it.

[2]: https://github.com/tmux-plugins/tpm
[4]: https://github.com/tmux-plugins/tmux-sensible

## Keybindings

Finally, here is a list of the actual keybindings. Most are [taken from `i3wm`][1].
Below, a "workspace" is what `tmux` would call a "window" and `vim` would call a "tab",
while a "pane" is what `i3wm` would call a "window" and `vim` would call a "split".

| Keybinding | Description |
| ---------- | ----------- |
| <kbd>Alt</kbd> + <kbd>0</kbd>-<kbd>9</kbd> | Switch to workspace number 0-9 |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>0</kbd>-<kbd>9</kbd> | Move pane to workspace 0-9 |
| <kbd>Alt</kbd> + <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> | Move focus left/down/up/right |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> | Move pane left/down/up/right |
| <kbd>Alt</kbd> + <kbd>o</kbd> | Move focus cyclically |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>o</kbd> | Move pane cyclically |
| <kbd>Alt</kbd> + <kbd>Enter</kbd> | Create a new pane at "the end" of the current layout |
| <kbd>Alt</kbd> + <kbd>s</kbd> | Switch to layout: split then vsplit |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>s</kbd> | Switch to layout: only split |
| <kbd>Alt</kbd> + <kbd>v</kbd> | Switch to layout: vsplit then split |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>v</kbd> | Switch to layout: only vsplit |
| <kbd>Alt</kbd> + <kbd>t</kbd> | Switch to layout: fully tiled |
| <kbd>Alt</kbd> + <kbd>z</kbd> | Switch to layout: zoom (fullscreen) |
| <kbd>Alt</kbd> + <kbd>r</kbd> | Refresh current layout |
| <kbd>Alt</kbd> + <kbd>n</kbd> | Name current workspace |
| <kbd>Alt</kbd> + <kbd>d</kbd> | Application launcher (if enabled) |
| <kbd>Alt</kbd> + <kbd>p</kbd> | Project launcher (if enabled) |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>q</kbd> | Quit (close) pane |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>e</kbd> | Exit (detach) `tmux` |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>c</kbd> | Reload config |

The <kbd>Alt</kbd> + <kbd>0</kbd> and <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>0</kbd> 
bindings are "smart": depending on `base-index`, they either act on workspace 0 or 10.
Moreover, if you press <kbd>Alt</kbd> + <kbd>3</kbd> to switch to workspace 3 and then
press it again, you will be sent back to the previous workspace you were using.

The  <kbd>Alt</kbd> + <kbd>0</kbd>-<kbd>9</kbd> will create a new workspace if
one does not exist. This option can be turned off by the configuration
`@tilish-createauto` as follows:

    set -g @tilish-createauto 'off'

When set to off, this setting will silently ignore when a non-existing
workspace is selected. This prevents accidental creation of workspaces. Note
that this configuration does not change the move pane to workspace command
<kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>0</kbd>-<kbd>9</kbd>, which will
create a new workspace.

These keybindings can be changed by using a configuration setting `@tilish-remap`,
which is somewhat similar to `vim`'s `nnoremap` command. The way it works is
that you specify which keys you want to remap in the following format. For instance,
say that you want to remap the `vim`-style `hjkl` movements to the arrow-like `ijkl`
movements; use <kbd>Alt</kbd> + <kbd>p</kbd> instead of <kbd>Alt</kbd> + <kbd>Enter</kbd>
to create new panes; replace <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>Q</kbd>
with <kbd>Alt</kbd> + <kbd>q</kbd> as the keybinding to close a pane; and use
<kbd>Alt</kbd> + <kbd>space</kbd> to run the application launcher.
This can be accomplished as follows:[^remap]

    set -g @tilish-remap 'h=j; j=k; k=i; l=l; Q=q; enter=p; d=space'

[^remap]: If you want to remap something to a key that's already in use,
          remember to also remap the key you're replacing. Otherwise, it
	  is not guaranteed that the key remapping will work.

The keybindings that move panes between workspaces assume a US keyboard layout.
However, you can configure `tilish` for international keyboards by providing a string
`@tilish-shiftnum` prepared by pressing <kbd>Shift</kbd> + 
<kbd>1</kbd><kbd>2</kbd><kbd>3</kbd><kbd>4</kbd><kbd>5</kbd><kbd>6</kbd><kbd>7</kbd><kbd>8</kbd><kbd>9</kbd><kbd>0</kbd>. 
For instance, for a UK keyboard, you would configure it as follows:

	set -g @tilish-shiftnum '!"£$%^&*()'

Your terminal must support sending keycodes like `M-£` for the above to work.
For instance, a UK keyboard layout works fine on `urxvt`, but does not work 
by default on `kitty` or `alacritty`, which may require additional configuration.

## Easy mode

To make the plugin more accessible for people who do not use `vim` as well,
there is also an "easy mode" available, which uses arrow keys instead of 
the `vim`-style <kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> keys.
This mode can be activated by putting this in your `tmux.conf`:

	set -g @tilish-easymode 'on'

The revised keybindings for the pane focus and movement then become:

| Keybinding | Description |
| ---------- | ----------- |
| <kbd>Alt</kbd> + <kbd>&#8592;</kbd><kbd>&#8595;</kbd><kbd>&#8593;</kbd><kbd>&#8594;</kbd> | Move focus left/down/up/right |
| <kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>&#8592;</kbd><kbd>&#8595;</kbd><kbd>&#8593;</kbd><kbd>&#8594;</kbd> | Move pane left/down/up/right |

## Prefix mode
Note that this feature is currently only available in `tmux` v2.4+.
The "prefix mode" uses a prefix key instead of <kbd>Alt</kbd>, and 
may be particularly interesting for users of editors like `kak` and 
`emacs` that use <kbd>Alt</kbd> key a lot. To activate this mode, you
define a prefix keybinding in your `tmux.conf`. For instance, to use
<kbd>Alt</kbd> + <kbd>Space</kbd> as your `tilish` prefix, add:

	set -g @tilish-prefix 'M-space'

Actions that would usually be done by <kbd>Alt</kbd> + <kbd>key</kbd>
are now accomplished by pressing the prefix and then <kbd>key</kbd>. 
For example, opening a split is usually <kbd>Alt</kbd> + <kbd>Enter</kbd>,
but with the above prefix this becomes <kbd>Alt</kbd> + <kbd>Space</kbd> 
then <kbd>Enter</kbd>. Note that the `tilish` prefix is different from
the `tmux` prefix, and should generally be bound to a different key.
For the prefix key, you can choose basically any keybinding that `tmux`
supports, e.g. `F12` or `C-s` or anything else you may prefer.

All these keybindings are `repeat`'able, so you do not have to press the
prefix key again if you type multiple commands fast enough. Thus, pressing
<kbd>Alt</kbd> + <kbd>Space</kbd> followed by <kbd>h</kbd><kbd>j</kbd> would 
move to the left and then down, without requiring another prefix activation.
The `tmux` option `repeat-time` can be used to customize this timeout.
Personally, I find the default 500ms timeout somewhat short, and would
recommend that you increase this to at least a second if you use `tilish`:

	set -g repeat-time 1000

## Project launcher

Many editors and IDEs provide some notion of "projects" that can be easily
opened using fuzzy-searching. For instance, in Sublime Text you can use the
keybinding <kbd>Cmd</kbd> + <kbd>Ctrl</kbd> + <kbd>p</kbd> to quickly open
recent projects, and <kbd>Ctrl</kbd> + <kbd>r</kbd> does the same in VSCode.

If you tell Tilish where you store your projects, it can integrate with `fzf`
to provide a project launcher. The keybinding <kbd>Alt</kbd> + <kbd>p</kbd>
will then pop up an `fzf` window that lets you select a directory from your
project directory, and will then open a new `tmux` workspace in that folder
which is automatically named to match the folder name.

To enable this feature, place e.g. the following snippet in your `tmux.conf` if
you store all your code projects in `~/Code`:

    set -g @tilish-project "$HOME/Code"

## Application launcher

In `i3wm`, the keybinding <kbd>Alt</kbd>+<kbd>d</kbd> is by default mapped to
the application launcher `dmenu`, which can be practical to quickly open apps.
If you have [`fzf`][5] available on your system, `tilish` can offer a similar 
application launcher using the same keyboard shortcut. To enable this 
functionality, add the following to your `tmux.conf`:

	set -g @tilish-dmenu 'on'

Pressing <kbd>Alt</kbd>+<kbd>d</kbd> will then show a pop-up `tmux` window that
lets you fuzzy-search through all executables in your system `$PATH`. Selecting
an executable runs the command in a new window. This can be quite convenient
as a way to quickly launch interactive processes like `htop` and `ipython`.

[5]: https://github.com/junegunn/fzf

## Terminal compatibility

Not all terminals support all keybindings. The plugin has been verified
to work well with: `iTerm2` and `Terminal.app` on macOS; `alacritty`, `kitty`,
`terminator`, `gnome-terminal`, and `urxvt` on Linux; `wsltty` and `alacritty`
on Windows.  Some of these terminals bind <kbd>Alt</kbd>+<kbd>Enter</kbd> to
fullscreen, so you have to disable that for the `tilish` "new pane" binding to
work.  Moreover, `gnome-terminal` steals the "switch workspace" keybindings
<kbd>Alt</kbd>+<kbd>0</kbd>-<kbd>9</kbd> *if* you open multiple tabs. If you
use macOS, you likely want to configure the `Option` key to send either `Esc+`
(`iTerm2`) or `Meta` (`Terminal.app`) under the keyboard settings of the app.

It is also worth noting that `iTerm2` allows you to swap the `Cmd` and `Option`
keys in the terminal app. I recommend giving this a try if you're on macOS,
since the `Cmd` is more ergonomic than the `Option` key for extended use.

If you use `xterm`, almost none of the <kbd>Alt</kbd> keys work by default.
That can be fixed by adding this to `~/.Xresources`:

	XTerm*eightBitControl: false
	XTerm*eightBitInput: false
	XTerm.omitTranslation: fullscreen
	XTerm*fullscreen: never

The same issue affects Alacritty on macOS; see
[this issue](https://github.com/alacritty/alacritty/issues/93#issuecomment-353489475)
for a proposed solution.

## Usage inside i3wm

If you use `tilish` inside `i3wm` or `sway`, keybindings like 
<kbd>Alt</kbd>+<kbd>Enter</kbd> may spawn a new terminal in your window manager
instead of a new terminal pane inside `tmux`. The window manager always takes
priority — so if both `i3wm` and `tilish` define the same keybinding,
`i3wm` will intercept the keybinding before `tmux` sees it.

The best way to solve this is perhaps to change your window manager  modifier key
to <kbd>Super</kbd>, also known as the "Windows key". As described 
[in the `i3wm` user guide](https://i3wm.org/docs/userguide.html#_using_i3), this can
be done by changing `$mod` to `Mod4` in your `i3wm` config. That way, pressing e.g.
<kbd>Alt</kbd>+<kbd>Enter</kbd> opens a new terminal pane inside `tmux`, while
<kbd>Super</kbd>+<kbd>Enter</kbd> opens a new terminal in `i3wm`. 

Alternatively, `tilish` also supports a [Prefix mode](#prefix-mode). This is in my opinion
less ergonomic than the default `tilish` keybindings. However, it does not require the use
of <kbd>Alt</kbd>, and is therefore compatible with the default `i3wm` keybindings.

## Integration with vim/neovim

There are multiple great plugins [tmux-navigate][10], [vim-tmux-navigator][3],
[smart-splits.nvim][11], which all allow seamless navigation between `vim`
splits and `tmux` splits. [tmux-navigate][10] has an advantage that it also
works over `ssh` connections, and that it plays better with zooming
(<kbd>Alt</kbd>+<kbd>z</kbd>). If you use these plugins, you can tell `tilish`
to make it setup the keybindings for you as described below. (If you don't,
`tilish` will use fallback keybindings that don't integrate with `vim`.)

### Navigate

It is perhaps easiest to setup `tmux-navigate`. Just load `navigate` *after* `tilish`
in your `tmux.conf`, and set the option `@tilish-navigate` to `on` to integrate them.
Thus a full working minimal example of a `tpm`-based `tmux.conf` would be:

	# List of plugins.
	set -g @plugin 'tmux-plugins/tpm'
	set -g @plugin 'tmux-plugins/tmux-sensible'
	set -g @plugin 'jabirali/tmux-tilish'
	set -g @plugin 'sunaku/tmux-navigate'
	
	# Plugin options.
	set -g @tilish-navigate 'on'
	
	# Install `tpm` if needed.
	if "test ! -d ~/.tmux/plugins/tpm" \
	   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"
	
	# Activate the plugins.
	run -b "~/.tmux/plugins/tpm/tpm"


No further setup is required; `tilish` sets up the keybindings, and `navigate`
handles seamless navigation of `vim`/`nvim` splits. However, if you also want
this seamless navigation over `ssh` connections, you should install
the accompanying `vim` plugin; see [their website for more information][10].

### Navigator

To install `vim-tmux-navigator`, you should first install the plugin for `vim` 
or `nvim`, as described on [their website][3]. Then place this in your
`~/.config/nvim/init.vim` (`nvim`) or `~/.vimrc` (`vim`):

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

### Smart-splits (neovim)

Integration with [smart-splits][11] is achieved through setting the
`@tilish-smartsplits` option to `on`. This automatically configures the
keybindings so that <kbd>M</kbd>-<kbd>hjkl</kbd> permit navigating around panes.

Prior to that, it requires installing the `smart-splits.nvim` plugin and
configuring the following keybindings in e.g. `~/.config/nvim/init.vim`:

```lua
  -- moving between splits
  vim.keymap.set("n", "<A-h>", require("smart-splits").move_cursor_left)
  vim.keymap.set("n", "<A-k>", require("smart-splits").move_cursor_up)
  vim.keymap.set("n", "<A-j>", require("smart-splits").move_cursor_down)
  vim.keymap.set("n", "<A-l>", require("smart-splits").move_cursor_right)
  vim.keymap.set("n", "<A-\\>", require("smart-splits").move_cursor_previous)
  -- resizing splits
  vim.keymap.set("n", "<C-h>", require("smart-splits").resize_left)
  vim.keymap.set("n", "<C-j>", require("smart-splits").resize_down)
  vim.keymap.set("n", "<C-k>", require("smart-splits").resize_up)
  vim.keymap.set("n", "<C-l>", require("smart-splits").resize_right)
  -- swapping buffers between windows
  vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
  vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
  vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
  vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
```

[3]:  https://github.com/christoomey/vim-tmux-navigator
[10]: https://github.com/sunaku/tmux-navigate
[11]: https://github.com/mrjones2014/smart-splits.nvim

# Related projects

- [3mux](https://github.com/aaronjanse/3mux)
- [tmux-normalmode](https://github.com/jabirali/tmux-normalmode/)
- [tmux-navigate](https://github.com/sunaku/tmux-navigate)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [vim-i3wm-tmux-navigator](https://github.com/fogine/vim-i3wm-tmux-navigator)
- [smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)
