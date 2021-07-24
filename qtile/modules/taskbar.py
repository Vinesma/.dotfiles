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
from subprocess import run

from libqtile import widget, bar
from modules import theme, constants

config = constants.config()
pallete = theme.create_pallete()
font_size=12
font_size_med=font_size+1

# PYWAL COLORS
colors_main = pallete["colors_main"]
colors = pallete["colors"]
highlight = pallete["highlight"]
shadow = pallete["shadow"]

def check_mail():
    mail_count = len(listdir(config.get("mail_path")))

    if mail_count > 0:
        return f" {mail_count}"
    else:
        return ""

def check_rss():
    upper_limit = 500
    lower_limit = 50
    file_path = path.join(config.get("newsboat_path"), "unread_count.tmp")
    
    try:
        with open(file_path, "r") as _file:
            unread_count = int(_file.readline().rstrip())

        if unread_count > upper_limit:
            return f" {unread_count}+"
        elif unread_count < lower_limit:
            return ""
        else:
            return f" {unread_count}"
    except OSError:
        return ""

def create_widgets():
    """
    Creates widgets to show on a bar
    """
    widgets = [
        widget.GroupBox(
            highlight_method="block",
            urgent_alert_method="block",
            highlight_color=[colors_main.get("background"), "282828"],
            this_current_screen_border=colors.get("color3"),
            this_screen_border=colors.get("color3"),
            urgent_border="FF4847",
            urgent_text="FFFFFF",
            fontshadow=shadow,
            disable_drag=True,
            rounded=False,
            ),
        widget.Spacer(
            length=4
            ),
        widget.TaskList(
            foreground='FFFFFF',
            max_title_width=200,
            highlight_method="block",
            urgent_border="FF4847",
            border=highlight,
            fontshadow=shadow,
            ),
        widget.Spacer(
            length=bar.STRETCH
            ),
        widget.Mpd2(
            foreground=highlight,
            status_format='{play_status} {title}',
            idle_message='',
            idle_format='',
            no_connection='',
            fontsize=font_size_med,
            play_states={'pause': '', 'play': '', 'stop': ''}
        ),
        widget.GenPollText(
            func=check_mail,
            update_interval=10,
            max_chars=10,
            fontsize=font_size_med,
            fontshadow=shadow,
            background=colors.get("color3"),
        ),
        widget.GenPollText(
            func=check_rss,
            update_interval=6,
            max_chars=10,
            foreground='FFFFFF',
            fontsize=font_size_med,
            fontshadow=shadow,
            background=colors.get("color1"),
        ),
        widget.Clock(
            format=r"%d/%m - %I:%M %p",
            foreground='FFFFFF',
            fontshadow=shadow,
            ),
        widget.Systray(),
    ]
    return widgets

def create_bar(useBar=False):
    """
    Initialize a bar
    """
    if useBar:
        return bar.Bar(widgets=create_widgets(), size=25, background=colors_main.get("background"), opacity=0.9)
    else:
        return None

def generate_defaults():
    """
    Return default values of widgets and bar
    """
    return {
        "font": "Source Code Pro Bold",
        "fontsize": font_size,
        "padding": 6,
        "foreground": colors_main["foreground"],
    }
