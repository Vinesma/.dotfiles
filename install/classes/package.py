""" Package class
"""

import os
import re
from utils import message, spawn, log
from config.shared import Config
from classes.file import File

config = Config()


class Package:
    """One package and its associated files"""

    def __init__(
        self,
        display_name,
        name,
        installer,
        files=None,
        auto_start=None,
        comments=None,
        post_install_commands=None,
    ):
        self.display_name = display_name
        self.name = name
        self.installer = installer

        if files is None:
            self.files = []
        else:
            self.files = [
                File(
                    _file["name"],
                    _file["path_destination"],
                    _file["path_source"],
                    _file["text"],
                    _file["create_link"],
                    _file["sudo"],
                    _file["comments"],
                )
                for _file in files
            ]

        if comments is None:
            self.comments = []
        else:
            self.comments = comments

        if auto_start is None:
            self.auto_start = []
        else:
            self.auto_start = auto_start

        if post_install_commands is None:
            self.post_install_commands = []
        else:
            self.post_install_commands = post_install_commands

    def to_dict(self):
        """Return a dictionary version of this instance"""
        return {
            "display_name": self.display_name,
            "name": self.name,
            "installer": self.installer,
            "auto_start": self.auto_start,
            "post_install_commands": self.post_install_commands,
            "comments": self.comments,
            "files": [_file.to_dict() for _file in self.files],
        }

    def configure(self):
        """Run commands to configure the package
        Afterwards, move configuration files in place.
        """

        if len(self.post_install_commands) > 0:
            message.normal(f"Running commands to configure {self.display_name}")

        for command in self.post_install_commands:
            spawn.process(os.path.expandvars(command))

        for _file in self.files:
            _file.configure()

    def add_autostart(self):
        """Append lines to auto_start file"""

        if len(self.auto_start) > 0:
            auto_start_file = config.auto_start_path

            with open(auto_start_file, "a", encoding="utf-8") as _file:
                for line in self.auto_start:
                    message.normal(
                        f"Appending the line '{line}' to the file at '{auto_start_file}'"
                    )
                    _file.write(f"\n{line}")

    def show_comments(self):
        """Show useful comments to the user,
        such as how to configure a program further or what to do next.
        """

        for index, comment in enumerate(self.comments):
            if index == 0:
                message.heading(f"[{self.display_name}]")
            message.info(comment)

        if len(self.comments) > 0:
            log.write(f"PACKAGE ({self.name})\n" + "\n".join(self.comments))

        for _file in self.files:
            _file.show_comments()

    def link_files(self):
        """Link the files associated with this package to their destinations"""
        for _file in self.files:
            if _file.create_link:
                _file.link()

    def evaluate(self):
        """Run sanity tests on this package instance"""
        errors_found = 0

        # Valid name
        if re.search(r" +", self.name) is not None:
            message.alert(
                f"PACKAGE [{self.display_name}]: install name: '{self.name}' could be invalid."
            )
            errors_found += 1

        if not (
            isinstance(self.comments, list)
            and isinstance(self.auto_start, list)
            and isinstance(self.files, list)
            and isinstance(self.post_install_commands, list)
        ):
            message.alert(
                f"PACKAGE [{self.display_name}]: Type mismatch, some attributes are not 'list'"
            )
            errors_found += 1

        for command in self.post_install_commands:
            if "~" in command:
                message.alert(
                    "The '~' special variable won't be expanded in commands. Please use '$HOME' instead."
                )

        return errors_found

    @staticmethod
    def interactive_insert(group_name=None):
        """Create a new package object from the command line"""
        package_display_name = ""
        package_name = ""
        package_installer = config.default_installer
        package_files = []
        package_auto_start = []
        package_comments = []
        package_post_install_commands = []

        while True:
            message.heading("Creating a new package.")
            if group_name is not None:
                message.info(f"Current group: {group_name}")

            package_display_name = message.question(
                "What is the display name of the package?"
            )
            package_name = message.question(
                "What is the exact name of the package? (Will be used for installing, needs to be exact)"
            )
            package_installer = message.choose(["default", "pacman", "aur", "pip"])
            if package_installer == "default":
                package_installer = config.default_installer

            if message.question("Will this package be autostarted?", "boolean"):
                while True:
                    command = message.question(
                        "New command for autostart (will appear on a newline):"
                    )
                    package_auto_start.append(command)
                    if not message.question(
                        "Add another autostart command?", "boolean"
                    ):
                        break

            if message.question(
                "Will this package have post install commands?", "boolean"
            ):
                while True:
                    command = message.question(
                        "New command for post install (${vars} supported):"
                    )
                    package_post_install_commands.append(command)
                    if not message.question("Add another command?", "boolean"):
                        break

            if message.question("Will this package have files associated?", "boolean"):
                while True:
                    _file = File.interactive_insert(group_name, package_name).to_dict()
                    package_files.append(_file)
                    if not message.question("Add another file?", "boolean"):
                        break

            if message.question(
                "Will the package have comments to aid the user?", "boolean"
            ):
                while True:
                    comment = message.question("New comment:")
                    package_comments.append(comment)
                    if not message.question("Add another comment?", "boolean"):
                        break

            package = Package(
                package_display_name,
                package_name,
                package_installer,
                package_files,
                package_auto_start,
                package_comments,
                package_post_install_commands,
            )

            package.evaluate()

            message.info(
                f"""Package info:
            [Display Name]: '{package.display_name}'
            [Install Name]: '{package.name}'
            [Installer]: '{package.installer}'
            [Autostart]: '{package.auto_start}'
            [Post Install Commands]: '{package.post_install_commands}'
            [Files]: '{[_file.name for _file in package.files]}'
            [Comments]: {package.comments}"""
            )
            if message.question("Confirm?", "boolean"):
                break

        return package
