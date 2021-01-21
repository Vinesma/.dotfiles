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

from os import path
from libqtile import widget, bar
from modules import theme

pallete = theme.create_pallete()

# PYWAL COLORS
colors_main = pallete["colors_main"]
colors = pallete["colors"]
highlight = pallete["highlight"]
shadow = pallete["shadow"]

def create_widgets():
    """
    Creates widgets to show on a bar
    """
    widgets = [
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
        widget.Spacer(
            length=8,
        ),
        widget.Clock(
            format='%d/%m/%y %a %I:%M %p',
        ),
        widget.Systray(),
    ]
    if path.isdir("/sys/class/power_supply/BAT1/"):
        widgets.insert(-3, widget.Battery(
            format="{char}{percent:2.0%}",
            update_interval=30,
            charge_char="🔹",
            discharge_char="🔸",
            full_char="🔹",
            unknown_char="🔹",
            empty_char="⚠️ ",
            ))
        widgets.insert(-4, widget.Spacer(length=8))

def create_bar(useBar=False):
    """
    Initialize a bar
    """
    if useBar:
        return bar.Bar(widgets=create_widgets(), size=23, background=colors_main["background"], opacity=0.9)
    else:
        return None

def generate_defaults():
    """
    Return default values of widgets and bar
    """
    return {
        "font": "Source Code Pro Bold",
        "fontsize": 12,
        "padding": 4,
        "foreground": colors_main["foreground"],
    }