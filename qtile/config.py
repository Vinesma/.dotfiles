# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook

from typing import List  # noqa: F401

## PYWAL
from pywal import theme
from os import getenv, path
homepath = getenv("HOME", getenv("USERPROFILE"))
## MODKEY
mod = "mod4"
## APPS
terminal = "kitty"

## HOOKS
# WIP

keys = [
    # Switch between windows in current stack pane
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),

    # Move windows up or down in current stack
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),

    # Grow windows in current stack
    Key([mod, "control"], "Down", lazy.layout.grow_down()),
    Key([mod, "control"], "Up", lazy.layout.grow_up()),
    Key([mod, "control"], "Left", lazy.layout.grow_left()),
    Key([mod, "control"], "Right", lazy.layout.grow_right()),

    # Switch window focus to other pane(s) of stack
    Key(["mod1"], "Tab", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn(terminal)),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),

    # Custom commands
    # spawn apps
    Key([mod, "mod1"], "e", lazy.spawn("thunar")),
    Key([mod, "mod1"], "b", lazy.spawn("firefox")),
    Key([mod, "mod1"], "n", lazy.spawn("kitty newsboat")),
    # cmus-remote
    Key([], "Pause", lazy.spawn("cmus-remote -u")),
    Key([mod], "Page_Up", lazy.spawn("cmus-remote -v +10%")),
    Key([mod], "Page_Down", lazy.spawn("cmus-remote -v -10%")),
    Key([mod], "period", lazy.spawn("cmus-remote -n")),
    Key([mod], "comma", lazy.spawn("cmus-remote -r")),
]

groups = [
    Group("a", spawn="firefox", label="1"),
    Group("s", layout="max", label="2"),
    Group("d", layout="max", label="3"),
    Group("f", spawn="kitty cmus", layout="max", label="4"),
]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

theme = theme.file(path.join(homepath, ".cache", "wal", "colors.json"))
colors_main = theme.get("special")
colors = theme.get("colors")
shadow ='#3F3F44'
highlight = colors.get("color4")

layouts = [
	layout.Columns(
        border_focus=highlight,
        border_normal=colors_main["background"],
        margin=4,
    ),
	layout.Max(),
    	# layout.Stack(num_stacks=2),
    	# layout.Bsp(border_focus='#00909E', border_normal='#21243D', margin=4),
    	# layout.Matrix(),
    	# layout.MonadTall(),
    	# layout.MonadWide(),
    	# layout.RatioTile(),
    	# layout.Tile(),
    	# layout.TreeTab(),
    	# layout.VerticalTile(),
    	# layout.Zoomy(),
]
widget_defaults = dict(
    font='Source Code Pro Bold',
    fontsize=12,
    padding=4,
    foreground=colors_main["foreground"],
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(
                    scale=0.8,
                ),
                widget.GroupBox(
                    this_current_screen_border=highlight,
                    urgent_border=colors_main["background"],
                    highlight_method='block',
                    rounded=False,
                    fontshadow=shadow,
                ),
                widget.Spacer(
                    length=2,
                ),
                widget.Prompt(),
                widget.WindowName(),
                widget.Cmus(
                    play_color=highlight,
                    max_chars=45,
                ),
                #widget.Spacer(
                #    length=10,
                #),
                #widget.Battery(),
                widget.Spacer(
                    length=10,
                ),
                widget.Clock(
                    format='%d/%m/%y %a %I:%M %p',
                ),
                widget.Systray(),
            ],
            23,
            background=colors_main["background"],
            opacity=0.9,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'lxappearance'},
    {'wmclass': 'anki'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
