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

config = constants.Config()

MOD = config.mod_key
TERMINAL = config.terminal
terminal_reduced_opacity = config.terminal_reduced_opacity
terminal_increased_opacity = config.terminal_increased_opacity
FILE_BROWSER = config.file_browser
BROWSER = config.browser
scripts_path = config.scripts_path


def create():
    """
    Initialize keybinds for qtile
    """
    keys = [
        # Switch between windows in current stack pane
        Key([MOD], "Down", lazy.layout.down()),
        Key([MOD], "Up", lazy.layout.up()),
        Key([MOD], "Left", lazy.layout.left()),
        Key([MOD], "Right", lazy.layout.right()),
        Key(["mod1"], "Tab", lazy.layout.next()),
        # Move windows up or down in current stack
        Key([MOD, "shift"], "Down", lazy.layout.shuffle_down()),
        Key([MOD, "shift"], "Up", lazy.layout.shuffle_up()),
        Key([MOD, "shift"], "Left", lazy.layout.shuffle_left()),
        Key([MOD, "shift"], "Right", lazy.layout.shuffle_right()),
        # Grow windows in current stack
        Key([MOD, "control"], "Down", lazy.layout.grow_down()),
        Key([MOD, "control"], "Up", lazy.layout.grow_up()),
        Key([MOD, "control"], "Left", lazy.layout.grow_left()),
        Key([MOD, "control"], "Right", lazy.layout.grow_right()),
        # Swap panes of split stack
        Key([MOD, "shift"], "space", lazy.layout.rotate()),
        # Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key([MOD, "shift"], "Return", lazy.layout.toggle_split()),
        Key([MOD], "Return", lazy.spawn(TERMINAL)),
        # Toggle between different layouts as defined below
        Key([MOD], "Tab", lazy.next_layout()),
        Key([MOD], "w", lazy.window.kill()),
        Key([MOD, "control"], "r", lazy.restart()),
        Key([MOD, "control"], "q", lazy.shutdown()),
        # Toggle between floating window on/off
        Key([MOD], "t", lazy.window.toggle_floating()),
        # Custom commands
        # emulate win ctrl+alt+del (spawn task manager)
        Key(
            ["mod1", "control"],
            "Delete",
            lazy.spawn(f"{terminal_reduced_opacity} htop"),
        ),
        # rofi
        Key([MOD], "r", lazy.spawn("rofi -show run")),
        Key([MOD], "e", lazy.spawn("rofi -show window")),
        # spawn apps
        Key([MOD, "mod1"], "e", lazy.spawn(FILE_BROWSER)),
        Key([MOD, "mod1"], "b", lazy.spawn(BROWSER)),
        Key(
            [MOD, "mod1"],
            "n",
            lazy.spawn(
                f'{terminal_reduced_opacity} -T "newsboat" {scripts_path}/newsboat/open-newsboat.sh'
            ),
        ),
        Key(
            [MOD, "mod1"],
            "m",
            lazy.spawn(f'{terminal_increased_opacity} -T "MPD" ncmpcpp -q'),
        ),
        Key(
            [MOD, "shift"],
            "m",
            lazy.spawn(path.join(scripts_path, "ncmpcpp-cover", "kitty-ncmpcpp.sh")),
        ),
        Key([MOD, "mod1"], "l", lazy.spawn(f"{terminal_reduced_opacity} neomutt")),
        Key([MOD, "mod1"], "i", lazy.spawn(path.join(scripts_path, "wifi-finder.sh"))),
        Key(
            [MOD, "control"],
            "m",
            lazy.spawn(path.join(scripts_path, "mpd", "music-browser.sh")),
        ),
        Key([MOD, "mod1"], "s", lazy.spawn(path.join(scripts_path, "rosearch.sh"))),
        Key([MOD, "mod1"], "v", lazy.spawn(path.join(scripts_path, "roconfig.sh"))),
        # take screenshot, either fullscreen or a selection
        Key([MOD], "Print", lazy.spawn(path.join(scripts_path, "take-screenshot.sh"))),
        Key(
            [MOD, "mod1"],
            "Print",
            lazy.spawn(path.join(scripts_path, "take-screenshot.sh select")),
        ),
        # wallpaper setter
        Key(
            [MOD, "mod1"],
            "w",
            lazy.spawn(path.join(scripts_path, "bg-setter", "choose-bg.sh")),
        ),
        # mpc/mpv contextual remote control
        Key(
            [], "Pause", lazy.spawn(path.join(scripts_path, "media-control.sh toggle"))
        ),
        Key([MOD], "p", lazy.spawn(path.join(scripts_path, "media-control.sh toggle"))),
        Key([MOD, "mod1"], "Pause", lazy.spawn("mpc seek 0%")),
        Key(
            [MOD],
            "Page_Up",
            lazy.spawn(path.join(scripts_path, "media-control.sh +10")),
        ),
        Key(
            [MOD],
            "Page_Down",
            lazy.spawn(path.join(scripts_path, "media-control.sh -10")),
        ),
        Key(
            [MOD],
            "equal",
            lazy.spawn(path.join(scripts_path, "media-control.sh +10")),
        ),
        Key(
            [MOD],
            "minus",
            lazy.spawn(path.join(scripts_path, "media-control.sh -10")),
        ),
        Key(
            [MOD, "mod1"],
            "Page_Up",
            lazy.spawn(path.join(scripts_path, "media-control.sh +20")),
        ),
        Key(
            [MOD, "mod1"],
            "Page_Down",
            lazy.spawn(path.join(scripts_path, "media-control.sh -20")),
        ),
        Key(
            [MOD],
            "Home",
            lazy.spawn(path.join(scripts_path, "media-control.sh seek +10")),
        ),
        Key(
            [MOD],
            "End",
            lazy.spawn(path.join(scripts_path, "media-control.sh seek -10")),
        ),
        Key([MOD], "Insert", lazy.spawn("mpc stop")),
        Key([MOD], "period", lazy.spawn("mpc next")),
        Key([MOD], "comma", lazy.spawn("mpc prev")),
        Key(
            [MOD],
            "F9",
            lazy.spawn(path.join(scripts_path, "mpd", "queue-music.sh clear-music")),
        ),
        Key(
            [MOD],
            "F10",
            lazy.spawn(path.join(scripts_path, "mpd", "queue-music.sh Calm")),
        ),
        Key(
            [MOD],
            "F11",
            lazy.spawn(path.join(scripts_path, "mpd", "queue-music.sh Fast")),
        ),
        Key(
            [MOD],
            "F12",
            lazy.spawn(path.join(scripts_path, "mpd", "queue-music.sh Epic")),
        ),
        # mpv (video player)
        Key(
            [MOD, "mod1"],
            "p",
            lazy.spawn(path.join(scripts_path, "mpv", "clipboard-mpv.sh")),
        ),
        # youtube-dl mass downloading
        Key(
            [MOD, "mod1"],
            "y",
            lazy.spawn(
                path.join(scripts_path, "youtube-dl-queuer", "youtube-dl-queuer.sh")
            ),
        ),
        Key(
            [MOD, "control"],
            "y",
            lazy.spawn(path.join(scripts_path, "youtube-dl-queuer", "hot-queue.sh")),
        ),
        # dunst
        Key(["control"], "space", lazy.spawn("dunstctl close")),
        Key(["control", "shift"], "space", lazy.spawn("dunstctl close-all")),
        Key([MOD], "h", lazy.spawn("dunstctl history-pop")),
        # lock screen
        Key([MOD, "control"], "F12", lazy.spawn("light-locker-command -l")),
    ]

    # Create keybinds for switching groups
    for group in groups.create():
        keys.extend(
            [
                # mod1 + letter of group = switch to group
                Key([MOD], group.name, lazy.group[group.name].toscreen()),
                # mod1 + shift + letter of group = send to group
                Key(
                    [MOD, "shift"],
                    group.name,
                    lazy.window.togroup(group.name, switch_group=False),
                ),
                # mod1 + control + letter of group = send to group & switch screens
                Key(
                    [MOD, "control"],
                    group.name,
                    lazy.window.togroup(group.name, switch_group=True),
                ),
            ]
        )

    return keys
