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
User defined bar for qtile
"""

from os import path, listdir
from subprocess import run, CalledProcessError

from libqtile import widget, bar, qtile
from modules import theme, constants

config = constants.Config()
pallete = theme.create_pallete()
FONT_SIZE = 15
FONT_SIZE_MED = FONT_SIZE + 1
FONT_SIZE_BIG = FONT_SIZE_MED + 2
PADDING = FONT_SIZE - 3

# PYWAL COLORS
colors_main = pallete["colors_main"]
colors = pallete["colors"]
highlight = pallete["highlight"]
SHADOW = pallete["shadow"]

# DISABLED BECAUSE MY EMAIL SCRIPT STOPPED WORKING, RIP
# def check_mail():
#     """Lists files in user's inbox to determine if there are unread emails."""
#     mail_count = len(listdir(config.get("mail_path")))

#     if mail_count > 0:
#         return f" {mail_count}"

#     return ""


def check_rss():
    """Reads my newsboat's output file to show in the bar."""
    upper_limit = 500
    lower_limit = 50
    file_path = path.join(config.newsboat_path, "unread_count.tmp")

    try:
        with open(file_path, "r", encoding="utf-8") as _file:
            unread_count = int(_file.readline().rstrip())

        if unread_count > upper_limit:
            return f"索 {upper_limit}+"

        if unread_count < lower_limit:
            return ""

        return f"索 {unread_count}"
    except OSError:
        return ""


def check_wifi():
    """Checks connection by asking NetworkManager."""
    cmd = "nmcli -t -f STATE general"
    # pylint: disable=subprocess-run-check
    output = run(list(cmd.split()), text=True, capture_output=True)

    if output.stdout.strip() == "connected":
        return "直"

    return "睊"


def check_bluetooth():
    """Checks if bluetooth is powered on."""
    cmd = "bluetoothctl show"
    try:
        output = run(list(cmd.split()), text=True, capture_output=True, check=True)
    except (CalledProcessError, FileNotFoundError):
        return ""

    if "Powered: yes" in output.stdout:
        return ""

    return ""


# Common widgets
group_box = widget.GroupBox(
    fontshadow=SHADOW,
    highlight_method="block",
    this_current_screen_border=highlight,
    this_screen_border=highlight,
    urgent_alert_method="block",
    urgent_border="FF4847",
    urgent_text="FFFFFF",
    disable_drag=True,
    rounded=False,
    use_mouse_wheel=False,
)
window_count = widget.WindowCount(font_size=FONT_SIZE_MED, fmt="({})")
window_tabs = widget.WindowTabs(
    foreground="FFFFFF",
    fontshadow=SHADOW,
    font_size=FONT_SIZE_MED,
    max_chars=200,
    separator=" ⏽ ",
)
clock = widget.Clock(
    format=r"%d/%m %I:%M %p",
    foreground=colors.get("color1"),
    fontshadow=SHADOW,
    padding=PADDING,
)
# pylint: disable=unnecessary-lambda
spacer = lambda length: widget.Spacer(length)

main_screen_widgets = [
    group_box,
    spacer(4),
    window_count,
    window_tabs,
    spacer(bar.STRETCH),
    widget.Mpd2(
        foreground=colors.get("color3"),
        status_format='<span size="large">{play_status}</span> {title}',
        idle_message="",
        idle_format="",
        no_connection="",
        fontsize=FONT_SIZE_MED,
        play_states={"pause": "", "play": "", "stop": ""},
        padding=PADDING,
    ),
    widget.GenPollText(
        func=check_rss,
        update_interval=8,
        fontsize=FONT_SIZE_MED,
        fontshadow=SHADOW,
        foreground=colors.get("color3"),
        padding=PADDING,
    ),
    widget.GenPollText(
        func=check_bluetooth,
        update_interval=10,
        max_chars=3,
        fontsize=FONT_SIZE,
        fontshadow=SHADOW,
        foreground=colors.get("color3"),
        padding=PADDING,
    ),
    widget.GenPollText(
        func=check_wifi,
        update_interval=5,
        max_chars=3,
        fontsize=FONT_SIZE_BIG,
        fontshadow=SHADOW,
        foreground=colors.get("color3"),
        padding=PADDING,
    ),
    clock,
    widget.Systray(),
]
minimal_widgets = [
    group_box,
    spacer(4),
    window_count,
    window_tabs,
    spacer(bar.STRETCH),
    clock,
]

has_battery = len(listdir(path.join("/", "sys", "class", "power_supply"))) > 0
if has_battery:
    main_screen_widgets.insert(
        -3,
        widget.Battery(
            format='<span size="small">{char}</span>{percent:2.0%}',
            full_char=" ",
            charge_char=" ",
            discharge_char=" ",
            empty_char=" ",
            unknown_char=" ",
            low_foreground="FF4847",
            hide_threshold=0.98,
            fontsize=FONT_SIZE_MED,
            fontshadow=SHADOW,
            foreground=colors.get("color3"),
            padding=PADDING,
        ),
    )


def create_bar(minimal=False):
    """
    Initialize a bar
    """

    return bar.Bar(
        widgets=main_screen_widgets if not minimal else minimal_widgets,
        size=30,
        background=colors_main.get("background"),
        opacity=0.9,
    )


def generate_defaults():
    """
    Return default values of widgets and bar
    """
    return {
        "font": "Source Code Pro Bold",
        "fontsize": FONT_SIZE,
        "padding": 6,
        "foreground": colors_main["foreground"],
    }
