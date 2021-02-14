from os import path, symlink, makedirs, remove
from utils import messages, spawn
from shutil import copy

class File:

    def __init__(self, name, residence, source=None, text="", create_link=False, sudo=False, comments=[]):
        self.name = name
        self.residence = path.expanduser(residence)
        self.text = text
        self.create_link = create_link
        self.sudo = sudo
        self.full_path = path.expanduser(path.join(residence, name))
        self.comments = comments

        if source is not None:
            self.source = path.join(path.expanduser(source), name)
        else:
            self.source = None

    def makedir(self):
        """
        Create inexistent directories
        """
        if not path.isdir(self.residence):
            messages.arrow(f"Created dir: '{self.residence}'")
            makedirs(self.residence)

    def create(self):
        """
        Create a file at its residence
        """
        with open(self.full_path, "w") as writeFile:
            writeFile.write(self.text)
        messages.arrow(f"Created: '{self.name}' at '{self.full_path}'")

    def copy(self):
        """
        Copy a file from source to its residence
        """
        if self.source is not None:
            if self.sudo:
                messages.arrow(f"Copied [sudo]: '{self.source}' ==> '{self.residence}'")
                spawn.process("cp", ["-v", "--", f"\"{self.source}\"", f"\"{self.residence}\""])
            else:
                messages.arrow(f"Copied: '{self.source}' ==> '{self.residence}'")
                copy(self.source, self.residence)
        else:
            messages.error(f"{self.name} has no source from which to copy from.")

    def link(self):
        """
        Create a link from source to its residence
        """
        if self.source is not None:
            try:
                symlink(self.source, self.full_path)
            except FileExistsError:
                messages.error("File exists, attempting to remove it, then link it.")
                remove(self.full_path)
                messages.arrow(f"Removed {self.full_path}.")
                symlink(self.source, self.full_path)
            finally:
                messages.arrow(f"Linked: '{self.source}' --> '{self.full_path}'")
        else:
            messages.error(f"{self.name} has no source from which to copy from.")

    def link_ask(self):
        """
        Create a link from source to its residence, but ask the user beforehand
        """
        if self.source is not None:
            question = f"Do you want to link these files:\nFrom: {self.source}\nTo: {self.full_path}\n"

            if messages.question_bool(question):
                try:
                    symlink(self.source, self.full_path)
                except FileExistsError:
                    messages.error("File exists, attempting to remove it, then link it.")
                    remove(self.full_path)
                    messages.arrow(f"Removed {self.full_path}.")
                    symlink(self.source, self.full_path)
                finally:
                    messages.arrow(f"Linked: '{self.source}' --> '{self.full_path}'")

    def show_comments(self):
        """
        Show useful comments to the user, such as how to configure a program further or what to do next.
        """
        for comment in self.comments:
            messages.info(comment)

    def configure(self):
        """
        Decides what to do with the file according to the conditions
        """
        self.makedir()

        if self.create_link:
            self.link()
        elif self.source is not None:
            self.copy()
        else:
            self.create()

        self.show_comments()
