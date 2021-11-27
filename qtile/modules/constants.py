""" Define values used throught the modules
"""

import os


class Config:
    """Singleton with constants necessary for using qtile"""

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
