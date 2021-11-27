""" Define values used throught the modules
"""

# pylint: disable=pointless-string-statement
import os


class Config:
    """Singleton with constants necessary for using qtile."""

    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Config, cls).__new__(cls)

        cls.home_path = os.path.expanduser("~")
        """Your user's home directory."""
        cls.scripts_path = os.path.join(cls.home_path, ".dotfiles", "scripts")
        """Path to my scripts."""
        cls.mail_path = os.path.join(cls.home_path, ".mail", "gmail", "Inbox", "new")
        """Path to my unread email files."""
        cls.newsboat_path = os.path.join(cls.scripts_path, "newsboat")
        """Path to newsboat files."""
        cls.mod_key = "mod4"
        """Mod key to use. 'mod4' is the Windows key."""
        cls.terminal = "kitty"
        """Name of default terminal emulator."""
        cls.terminal_reduced_opacity = f"{cls.terminal} -o background_opacity=0.9"
        """Default terminal emulator with reduced background transparency."""
        cls.terminal_increased_opacity = f"{cls.terminal} -o background_opacity=0.7"
        """Default terminal emulator with increased background transparency."""
        cls.browser = "firefox"
        """Default web browser."""
        cls.file_browser = "thunar"
        """Default file browser."""

        return cls._instance


class Theme:
    """Singleton with theme variables."""

    _instance = None
    _theme_path = os.path.join(Config().home_path, ".cache", "wal", "colors.json")

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Theme, cls).__new__(cls)

        try:
            # pylint: disable=import-outside-toplevel
            from pywal import theme

            theme = theme.file(cls._theme_path)
        except (ImportError, FileNotFoundError):
            theme = {}

        cls.colors_main = theme.get(
            "special",
            {
                "background": "#0d1320",
                "foreground": "#ddd1e0",
                "cursor": "#ddd1e0",
            },
        )
        cls.colors = theme.get(
            "colors",
            {
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
            },
        )
        cls.highlight = cls.colors.get("color4")
        cls.shadow = "#3F3F44"

        return cls._instance
