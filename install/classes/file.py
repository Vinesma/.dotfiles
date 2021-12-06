""" File class
"""

import os
import sys
import shutil
from time import sleep
from utils import message, spawn, log
from config.shared import Config

config = Config()


class File:
    """A single file"""

    def __init__(
        self,
        name,
        path_destination,
        path_source=None,
        text="",
        create_link=False,
        sudo=False,
        comments=None,
    ):
        self.name = name
        self.path_destination = os.path.expanduser(path_destination)
        self.text = text
        self.create_link = create_link
        self.sudo = sudo

        if path_source is None:
            self.path_source = None
        else:
            self.path_source = path_source

        if comments is None:
            self.comments = []
        else:
            self.comments = comments

    def to_dict(self):
        """Return a dictionary version of this instance"""
        return {
            "name": self.name,
            "path_destination": self.path_destination,
            "path_source": self.path_source,
            "text": self.text,
            "create_link": self.create_link,
            "sudo": self.sudo,
            "comments": self.comments,
        }

    def mkdir(self):
        """Create inexistent directories"""

        if not os.path.isdir(os.path.expandvars(self.path_destination)):
            message.normal(f"Created directory: '{self.path_destination}'")
            os.makedirs(os.path.expandvars(self.path_destination))

    def touch(self):
        """Create this file at its destination. Write text to it."""
        full_destination_path = os.path.join(
            os.path.expandvars(self.path_destination), self.name
        )

        try:
            with open(full_destination_path, "w", encoding="utf-8") as _file:
                _file.write(self.text)
            message.info(f"Created file: '{self.name}' at '{self.path_destination}'")
        except OSError:
            message.error(
                f"There was a problem creating the file '{self.name}' at '{self.path_destination}'"
            )

            if config.fail_fast:
                sys.exit(1)

            message.info("Stopping execution temporarily for your evaluation.")

            for i in range(3, 0, -1):
                message.info(f"Program will continue in {i * 10} seconds...")
                sleep(config.seconds_to_wait_on_fail)

    def copy(self):
        """Copy this file from source to destination"""

        if self.path_source is not None:
            full_source_path = os.path.join(
                os.path.expandvars(self.path_source), self.name
            )

            if self.sudo:
                spawn.process(
                    f'cp -v -- "{full_source_path}" "{self.path_destination}"',
                    sudo=True,
                )
            else:
                message.info(
                    f"Copied: '{full_source_path}' --> '{self.path_destination}'"
                )
                shutil.copy(full_source_path, self.path_destination)
        else:
            message.error(f"'{self.name}' has no source from which to copy from.")

    def link(self):
        """Link this file from source to destination"""

        if self.path_source is not None:
            full_source_path = os.path.join(
                os.path.expandvars(self.path_source), self.name
            )
            full_destination_path = os.path.join(
                os.path.expandvars(self.path_destination), self.name
            )

            try:
                if self.sudo:
                    spawn.process(
                        f'ln -sfv "{full_source_path}" "{full_destination_path}"',
                        sudo=True,
                    )
                else:
                    os.symlink(full_source_path, full_destination_path)
            except FileExistsError:
                message.error(
                    "Can't symlink, file already exists at destination. Attempting fix."
                )
                os.remove(full_destination_path)
                message.info(f"Removed: '{full_destination_path}'")
                os.symlink(full_source_path, full_destination_path)
            finally:
                message.info(
                    f"Symlink created: '{full_source_path}' <--> '{full_destination_path}'"
                )
        else:
            message.error(
                f"'{self.name}' has no source from which to create a link from."
            )

    def show_comments(self):
        """Show useful comments to the user,
        such as how to configure a program further or what to do next.
        """

        for index, comment in enumerate(self.comments):
            if index == 0:
                message.heading(f"[{self.name}]")
            message.info(comment)

        if len(self.comments) > 0:
            log.write(f"FILE ({self.name})\n" + "\n".join(self.comments))

    def configure(self):
        """Configure the file (move, link or create it)"""

        self.mkdir()

        if self.create_link:
            self.link()
        elif self.path_source is not None:
            self.copy()
        else:
            self.touch()

        self.show_comments()

    def evaluate(self):
        """Run sanity tests on this file instance"""
        errors_found = 0

        # Test if destination exists and is a directory
        if not os.path.isdir(os.path.expandvars(self.path_destination)):
            message.alert(
                f"FILE [{self.name}]: '{self.path_destination}' destination path is not a known directory."
            )
            errors_found += 1

        # Test if sudo is really needed if the file's
        # destination is in a directory owned by the current user
        if os.getenv("HOME") in os.path.expandvars(self.path_destination) and self.sudo:
            message.alert(
                f"FILE [{self.name}]: Sudo use may be unnecessary as {self.path_destination} is in your home path."
            )
            errors_found += 1

        # Test if source is a directory
        if self.path_source is not None:
            if not os.path.isdir(os.path.expandvars(self.path_source)):
                message.alert(
                    f"FILE [{self.name}]: '{self.path_source}' source path is not a known directory."
                )
                errors_found += 1

            if not os.path.isfile(
                os.path.join(os.path.expandvars(self.path_source), self.name)
            ):
                message.alert(
                    f"FILE [{self.name}] at PATH: [{self.path_source}] does not exist."
                )
                errors_found += 1

        # Check expected types
        if not isinstance(self.comments, list):
            message.alert(
                f"FILE [{self.name}]: Type mismatch, comments attribute is of type '{type(self.comments)}' instead of 'list'"
            )
            errors_found += 1

        return errors_found

    @staticmethod
    def interactive_insert(group_name=None, package_name=None):
        """Create a new file object from the command line"""
        file_name = ""
        file_destination = ""
        file_source = None
        file_create_link = False
        file_sudo = False
        file_comments = []

        def ask_file_source():
            return message.question("What is the full source file path?")

        def ask_sudo():
            return message.question("Is sudo needed for this operation?", "boolean")

        while True:
            file_source = None
            file_create_link = False
            file_sudo = False

            message.heading("Creating a new file. (${vars} is supported, '~' is not)")
            if group_name is not None:
                message.info(f"Current group: {group_name}")
            if package_name is not None:
                message.info(f"Current package: {package_name}")

            file_destination = message.question(
                "Where will this file be (created/linked/copied) to? (no basename)"
            )

            if message.question(
                "Will this file be linked to [destination]?", "boolean"
            ):
                file_create_link = True
                file_source = ask_file_source()
                file_sudo = ask_sudo()
            elif message.question(
                "Will this file be copied to [destination]?", "boolean"
            ):
                file_source = ask_file_source()
                file_sudo = ask_sudo()

            if file_source is not None:
                [_, file_name] = os.path.split(os.path.expandvars(file_source))
            else:
                file_name = message.question("What will be the file's name?")

            if message.question(
                "Will the file have comments to aid the user?", "boolean"
            ):
                while True:
                    comment = message.question("New comment:")
                    file_comments.append(comment)
                    if not message.question("Add another comment?", "boolean"):
                        break

            new_file = File(
                file_name,
                file_destination,
                os.path.split(file_source)[0] if file_source is not None else None,
                "",
                file_create_link,
                file_sudo,
                file_comments,
            )

            new_file.evaluate()

            message.info(
                f"""File info:
            [Name]: '{new_file.name}'
            [Destination]: '{new_file.path_destination}'
            [Source]: '{new_file.path_source}'
            [Link?]: '{'Yes' if new_file.create_link else 'No'}'
            [Need superuser?]: '{'Yes' if new_file.sudo else 'No'}'
            [Comments]: {new_file.comments}"""
            )
            if message.question("Confirm?", "boolean"):
                break

        return new_file
