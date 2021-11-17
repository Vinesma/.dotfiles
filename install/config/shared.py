""" Shared configuration """

import os

# pylint: disable=pointless-string-statement
class Config:
    """Singleton with global configuration."""

    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(Config, cls).__new__(cls)

        cls.dev_mode = True
        """
        Determines if the program should run sanity checks on startup.
        Some of these checks don't make sense if the user is in a fresh install.
        Thus, this option should be 'True' only if the user intends to create new packages.
        Tests after creating packages interactively will still be run.
        """
        cls.verbose = False
        """
        How verbose the program should be. True = very / False = not very (default).
        """
        cls.fail_fast = False
        """
        Halt the program as soon as any error happens,
        if this is not set the program will try to chug along as much as possible (default).
        """
        cls.default_installer = "pacman"
        """
        The default package installer
        """
        cls.aur_helper = "yay"
        """
        What AUR helper to use, currently will break if helper doesn't use yay's args.
        """
        cls.auto_start_path = os.path.expandvars("$HOME/.autostart")
        """
        Where to put commands the WM will run on startup.
        """
        cls.seconds_to_wait_on_fail = 10
        """
        Default timeout when an error occurs so that the user is made aware of it.
        Will happen 3 times, so whatever number is chosen should be treated as x * 3.
        For example: x = 10 -> 10 * 3 = 30 -> 30 seconds will elapse.
        """
        cls.admin_command = "sudo"
        """
        Command to run for privilege escalation.
        """
        cls.program_path = os.path.expandvars("$HOME/.dotfiles/install")
        """
        Where to find this program's main.py file
        """
        cls.group_files_path = os.path.join(cls.program_path, "data", "groups")
        """
        Path for all the group '.json' files
        """
        cls.install_log = True
        """
        Log errors, comments and other install specific info into a logfile.
        """
        cls.log_path = os.path.join(cls.program_path, "data", "install.log")
        """
        Path to the logfile
        """

        return cls._instance
