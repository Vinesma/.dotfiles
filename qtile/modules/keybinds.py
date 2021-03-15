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

"""
User defined keybinds for qtile
"""

from os import path
from libqtile.config import Key
from libqtile.lazy import lazy
from modules import groups, constants

config = constants.config()

mod = config["mod"]
terminal = config["terminal"]
terminal_reduced_opacity = config["terminal_reduced_opacity"]
terminal_increased_opacity = config["terminal_increased_opacity"]
file_browser = config["file_browser"]
browser = config["browser"]
scripts_path = config["scripts_path"]

def create_keybinds():
    """
    Initialize keybinds for qtile
    """
    keys = [
        # Switch between windows in current stack pane
        Key([mod], "Down", lazy.layout.down()),
        Key([mod], "Up", lazy.layout.up()),
        Key([mod], "Left", lazy.layout.left()),
        Key([mod], "Right", lazy.layout.right()),
        Key(["mod1"], "Tab", lazy.layout.next()),

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

        # Toggle between floating window on/off
        Key([mod], "t", lazy.window.toggle_floating()),

        # Custom commands
        # emulate win ctrl+alt+del (spawn task manager)
        Key(["mod1", "control"], "Delete", lazy.spawn(f"{terminal_reduced_opacity} htop")),
        # rofi
        Key([mod], "r", lazy.spawn("rofi -show run")),
        Key([mod], "e", lazy.spawn("rofi -show window")),
        # spawn apps
        Key([mod, "mod1"], "e", lazy.spawn(file_browser)),
        Key([mod, "mod1"], "b", lazy.spawn(browser)),
        Key([mod, "mod1"], "n", lazy.spawn(f"{terminal_reduced_opacity} -T \"newsboat\" {scripts_path}/newsboat/open-newsboat.sh")),
        Key([mod, "mod1"], "m", lazy.spawn(f"{terminal_increased_opacity} -T \"MPD\" ncmpcpp -q")),
        Key([mod, "shift"], "m", lazy.spawn(path.join(scripts_path, "ncmpcpp-cover", "kitty-ncmpcpp.sh"))),
        Key([mod, "mod1"], "l", lazy.spawn(f"{terminal_reduced_opacity} neomutt")),
        Key([mod, "mod1"], "i", lazy.spawn(path.join(scripts_path, "wifi-finder.sh"))),
        Key([mod, "control"], "m", lazy.spawn(path.join(scripts_path, "song-browser.sh"))),
        Key([mod, "mod1"], "s", lazy.spawn(path.join(scripts_path, "rosearch.sh"))),
        Key([mod, "mod1"], "v", lazy.spawn(path.join(scripts_path, "roconfig.sh"))),
        # take screenshot, either fullscreen or a selection
        Key([mod], "Print", lazy.spawn(path.join(scripts_path, "take-screenshot.sh"))),
        Key([mod, "mod1"], "Print", lazy.spawn(path.join(scripts_path, "take-screenshot.sh select"))),
        # wallpaper setter
        Key([mod, "mod1"], "w", lazy.spawn(path.join(scripts_path, "bg-setter", "choose-bg.sh"))),
        # mpc (mpd controller)
        Key([], "Pause", lazy.spawn("mpc toggle")),
        Key([mod, "mod1"], "Pause", lazy.spawn("mpc seek 0%")),
        Key([mod], "Page_Up",
            lazy.spawn(path.join(scripts_path, "query-vol.sh +10")),
        ),
        Key([mod], "Page_Down",
            lazy.spawn(path.join(scripts_path, "query-vol.sh -10")),
        ),
        Key([mod, "mod1"], "Page_Up",
            lazy.spawn(path.join(scripts_path, "query-vol.sh +20")),
        ),
        Key([mod, "mod1"], "Page_Down",
            lazy.spawn(path.join(scripts_path, "query-vol.sh -20")),
        ),
        Key([mod], "Home", lazy.spawn("mpc seek +10")),
        Key([mod], "End", lazy.spawn("mpc seek -10")),
        Key([mod], "Insert", lazy.spawn("mpc stop")),
        Key([mod], "period", lazy.spawn("mpc next")),
        Key([mod], "comma", lazy.spawn("mpc prev")),
        Key([mod], "F9",
            lazy.spawn(path.join(scripts_path, "queue-clear.sh")),
        ),
        Key([mod], "F10",
            lazy.spawn(path.join(scripts_path, "queue-songs.sh Calm")),
        ),
        Key([mod], "F11",
            lazy.spawn(path.join(scripts_path, "queue-songs.sh Fast")),
        ),
        Key([mod], "F12",
            lazy.spawn(path.join(scripts_path, "queue-songs.sh Epic")),
        ),
        # mpv (video player)
        Key([mod, "mod1"], "p", lazy.spawn(path.join(scripts_path, "clipboard-mpv.sh"))),
        # youtube-dl mass downloading
        Key([mod, "mod1"], "y", lazy.spawn(path.join(scripts_path, "youtube-dl-queuer", "youtube-dl-queuer.sh"))),
        Key([mod, "control"], "y", lazy.spawn(path.join(scripts_path, "youtube-dl-queuer", "hot-queue.sh"))),
    ]

    # Create keybinds for switching groups
    for group in groups.create_groups():
        keys.extend([
            # mod1 + letter of group = switch to group
            Key([mod], group.name, lazy.group[group.name].toscreen()),

            # mod1 + shift + letter of group = send to group
            Key([mod, "shift"], group.name, lazy.window.togroup(group.name, switch_group=False)),
            # mod1 + control + letter of group = send to group & switch screens
            Key([mod, "control"], group.name, lazy.window.togroup(group.name, switch_group=True)),
    ])

    return keys
