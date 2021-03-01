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
        Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
        Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
        Key([mod], "Left", lazy.layout.left(), desc="Move focus left"),
        Key([mod], "Right", lazy.layout.right(), desc="Move focus right"),
        Key(["mod1"], "Tab", lazy.layout.next(), desc="Move window focus to next window"),

        # Move windows up or down in current stack
        Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
        Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
        Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
        Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),

        # Grow windows in current stack
        Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window downwards"),
        Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window upwards"),
        Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
        Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),

        # Swap panes of split stack
        Key([mod, "shift"], "space", lazy.layout.rotate(), desc="Swap windows in a split stack"),

        # Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
        Key([mod], "Return", lazy.spawn(terminal), desc="Spawn terminal"),

        # Toggle between different layouts as defined below
        Key([mod], "Tab", lazy.next_layout(), desc="Switch to next layout"),
        Key([mod], "w", lazy.window.kill(), desc="Kill focused window's process"),

        Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
        Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

        # Toggle between floating window on/off
        Key([mod], "t", lazy.window.toggle_floating()),

        # Custom commands
        # emulate win ctrl+alt+del (spawn task manager)
        Key(["mod1", "control"], "Delete", lazy.spawn(f"{terminal_reduced_opacity} htop"), desc="Task manager wannabe"),
        # rofi
        Key([mod], "r", lazy.spawn("rofi -show run"), desc="Spawn rofi in run mode"),
        Key([mod], "e", lazy.spawn("rofi -show window"), desc="Spawn rofi in window mode"),
        # spawn apps
        Key([mod, "mod1"], "e", lazy.spawn(file_browser), desc="Spawn file browser"),
        Key([mod, "mod1"], "b", lazy.spawn(browser), desc="Spawn web browser"),
        Key([mod, "mod1"], "n", lazy.spawn(f"{terminal_reduced_opacity} -T \"newsboat\" {scripts_path}/newsboat/open-newsboat.sh"), desc="Spawn rss reader"),
        Key([mod, "mod1"], "m", lazy.spawn(f"{terminal_increased_opacity} -T \"MPD\" ncmpcpp -q"), desc="Spawn music player"),
        Key([mod, "shift"], "m", lazy.spawn(path.join(scripts_path, "ncmpcpp-cover", "kitty-ncmpcpp.sh"), desc="Spawn music player + album covers")),
        Key([mod, "mod1"], "l", lazy.spawn(f"{terminal_reduced_opacity} neomutt"), desc="Spawn email client"),
        Key([mod, "mod1"], "i", lazy.spawn(path.join(scripts_path, "wifi-finder.sh")), desc="Spawn wifi finder script"),
        Key([mod, "control"], "m", lazy.spawn(path.join(scripts_path, "song-browser.sh")), desc="Spawn song browser script"),
        # take screenshot, either fullscreen or a selection
        Key([mod], "Print", lazy.spawn(path.join(scripts_path, "take-screenshot.sh")), desc="Take a fullscreen screenshot"),
        Key([mod, "mod1"], "Print", lazy.spawn(path.join(scripts_path, "take-screenshot.sh select")), desc="Take a screenshot of a selection"),
        # wallpaper setter
        Key([mod, "mod1"], "w", lazy.spawn(path.join(scripts_path, "bg-setter", "choose-bg.sh")), desc="Spawn wallpaper setter script"),
        # mpc (mpd controller)
        Key([], "Pause", lazy.spawn("mpc toggle"), desc="Toggle music play/pause"),
        Key([mod, "mod1"], "Pause", lazy.spawn("mpc seek 0%"), desc="Restart music"),
        Key([mod], "Page_Up",
            lazy.spawn(path.join(scripts_path, "query-vol.sh +10"), desc="Increase music volume"),
        ),
        Key([mod], "Page_Down",
            lazy.spawn(path.join(scripts_path, "query-vol.sh -10"), desc="Decrease music volume"),
        ),
        Key([mod, "mod1"], "Page_Up",
            lazy.spawn(path.join(scripts_path, "query-vol.sh +20"), desc="Greatly increase music volume"),
        ),
        Key([mod, "mod1"], "Page_Down",
            lazy.spawn(path.join(scripts_path, "query-vol.sh -20"), desc="Greatly decrease music volume"),
        ),
        Key([mod], "Home", lazy.spawn("mpc seek +10"), desc="Seek forwards in music"),
        Key([mod], "End", lazy.spawn("mpc seek -10"), desc="Seek backwards in music"),
        Key([mod], "Insert", lazy.spawn("mpc stop"), desc="Stop music"),
        Key([mod], "period", lazy.spawn("mpc next"), desc="Skip to next track"),
        Key([mod], "comma", lazy.spawn("mpc prev"), desc="Skip to previous track"),
        Key([mod], "F9",
            lazy.spawn(path.join(scripts_path, "queue-clear.sh"), desc="Clear music queue"),
        ),
        Key([mod], "F10",
            lazy.spawn(path.join(scripts_path, "queue-songs.sh Calm"), desc="Queue all calm tracks"),
        ),
        Key([mod], "F11",
            lazy.spawn(path.join(scripts_path, "queue-songs.sh Fast"), desc="Queue all fast tracks"),
        ),
        Key([mod], "F12",
            lazy.spawn(path.join(scripts_path, "queue-songs.sh Epic"), desc="Queue all epic tracks"),
        ),
        # mpv (video player)
        Key([mod, "mod1"], "p", lazy.spawn(path.join(scripts_path, "clipboard-mpv.sh")), desc="Spawn mpv controller script for watching and resuming videos"),
        # youtube-dl mass downloading
        Key([mod, "mod1"], "y", lazy.spawn(path.join(scripts_path, "youtube-dl-queuer", "youtube-dl-queuer.sh")), desc="Spawn youtube-dl helper script for downloading a queue of videos"),
        Key([mod, "control"], "y", lazy.spawn(path.join(scripts_path, "youtube-dl-queuer", "hot-queue.sh")), desc="Quickly queue a video from the clipboard"),
    ]

    # Create keybinds for switching groups
    for group in groups.create_groups():
        keys.extend([
            # mod1 + letter of group = switch to group
            Key([mod], group.name, lazy.group[group.name].toscreen(), desc="Switch to this group"),

            # mod1 + shift + letter of group = send to group
            Key([mod, "shift"], group.name, lazy.window.togroup(group.name, switch_group=False), desc="Send window to this group"),
            # mod1 + control + letter of group = send to group & switch screens
            Key([mod, "control"], group.name, lazy.window.togroup(group.name, switch_group=True), desc="Send window to this group and also switch to it"),
    ])

    return keys
