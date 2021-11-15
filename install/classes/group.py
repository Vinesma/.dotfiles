""" A package group
"""

import os
import json
from classes.package import Package
from classes.file import File
from installers import pacman, pip, aur
from utils import message
from config.shared import Config

config = Config()


class Group:
    """A package group"""

    def __init__(self, name, packages=None, files=None):
        self.name = name

        if packages is None:
            self.packages = []
        else:
            self.packages = [
                Package(
                    package["display_name"],
                    package["name"],
                    package["installer"],
                    package["files"],
                    package["auto_start"],
                    package["comments"],
                    package["post_install_commands"],
                )
                for package in packages
            ]

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

    def to_dict(self):
        """Return a dictionary version of this instance"""
        return {
            "name": self.name,
            "packages": [package.to_dict() for package in self.packages],
            "files": [_file.to_dict() for _file in self.files],
        }

    def install(self, sync=False):
        """Install all the packages and configure them."""

        if sync:
            pacman.sync()

        message.heading(f"Installing '{self.name}' package group.")

        pacman_packages = " ".join(
            [package.name for package in self.packages if package.installer == "pacman"]
        )
        aur_packages = " ".join(
            [package.name for package in self.packages if package.installer == "aur"]
        )
        pip_packages = " ".join(
            [package.name for package in self.packages if package.installer == "pip"]
        )

        pacman.install(pacman_packages)
        aur.install(aur_packages)
        pip.install(pip_packages)

        for package in self.packages:
            package.configure()
            package.add_autostart()
            package.show_comments()

        for _file in self.files:
            _file.configure()

    def show_comments(self):
        """Show all comments from all files and packages in this category"""

        for package in self.packages:
            package.show_comments()

        for _file in self.files:
            _file.show_comments()

    def link_files(self):
        """Link the files associated with this group to their destinations"""

        for package in self.packages:
            package.link_files()

        for _file in self.files:
            if _file.create_link:
                _file.link()

    @staticmethod
    def load(group_name):
        """Load a group from a file"""
        group_path = os.path.join(
            os.path.expanduser(config.group_files_path), f"{group_name}.json"
        )

        with open(group_path, "r", encoding="utf-8") as _file:
            group = json.load(_file)

        return Group(group["name"], group["packages"], group["files"])

    @staticmethod
    def load_all():
        """Load all groups and return a list of them"""

        main_file_path = os.path.join(config.program_path, "data", "main.json")

        with open(main_file_path, "r", encoding="utf-8") as _file:
            groups = json.load(_file)

        return [Group.load(group) for group in groups]

    def save(self):
        """Save this group to a .json file"""

        with open(
            os.path.join(config.group_files_path, f"{self.name}.json"),
            "w",
            encoding="utf-8",
        ) as _file:
            json.dump(self.to_dict(), fp=_file, indent=4)

    @staticmethod
    def interactive_insert():
        """Create a new group object from the command line"""
        group_name = None
        group_packages = []
        group_files = []

        while True:
            message.heading("Creating a new group.")
            group_name = (
                message.question("What is the group name? (will be used as filename)")
                .lower()
                .replace(" ", "_")
            )

            if message.question(
                "Will this group have packages associated to it?", "boolean"
            ):
                while True:
                    package = Package.interactive_insert(group_name).to_dict()
                    group_packages.append(package)
                    if not message.question("Add another package?", "boolean"):
                        break

            if message.question(
                "Will this group have files associated to it?", "boolean"
            ):
                while True:
                    _file = File.interactive_insert(group_name).to_dict()
                    group_files.append(_file)
                    if not message.question("Add another file?", "boolean"):
                        break

            message.info(
                f"""Group info:
            [Name]: '{group_name}'
            [Packages]: '{[package["display_name"] for package in group_packages]}'
            [Files]: '{[_file["name"] for _file in group_files]}'
            """
            )
            if message.question("Confirm?", "boolean"):
                break

        return Group(group_name, group_packages, group_files)
