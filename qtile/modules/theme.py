""" Get color information from pywal
    if pywal can't be imported, return default values
"""

from os import path
from modules import constants

config = constants.Config()


def create_pallete():
    """
    Return usable colors
    """
    try:
        # pylint: disable=import-outside-toplevel
        from pywal import theme

        theme = theme.file(path.join(config.home_path, ".cache", "wal", "colors.json"))
    except (ImportError, FileNotFoundError):
        # FALLBACKS
        colors_main = {
            "background": "#0d1320",
            "foreground": "#ddd1e0",
            "cursor": "#ddd1e0",
        }
        colors = {
            "color0": "#0d1320",
            "color1": "#3283db",
            "color2": "#3f72dd",
            "color3": "#3abddc",
            "color4": "#5d5de2",
            "color5": "#b557e1",
            "color6": "#9082e8",
            "color7": "#ddd1e0",
            "color8": "#9a929c",
            "color9": "#3283db",
            "color10": "#3f72dd",
            "color11": "#3abddc",
            "color12": "#5d5de2",
            "color13": "#b557e1",
            "color14": "#9082e8",
            "color15": "#ddd1e0",
        }
    else:
        # PYWAL COLORS
        colors_main = theme.get("special")
        colors = theme.get("colors")
        highlight = colors.get("color4")
    finally:
        highlight = colors.get("color4")
        shadow = "#3F3F44"

    return {
        "colors_main": colors_main,
        "colors": colors,
        "highlight": highlight,
        "shadow": shadow,
    }
