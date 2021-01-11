from os import path, symlink
from utils import messages
from shutil import copy2

class File:

    def __init__(self, name, residence, source=None, text="", create_link=False, comments=[]):
        self.name = name
        self.residence = path.expanduser(residence)
        self.text = text
        self.create_link = create_link
        self.full_path = path.expanduser(path.join(residence, name))
        self.comments = comments

        if source is not None:
            self.source = path.join(path.expanduser(source), name)
        else:
            self.source = None

    def create(self):
        """ 
        Create a file at its residence
        """
        # with open(self.full_path, "w") as writeFile:
            # writeFile.write(self.text)
        messages.arrow(f"Created: '{self.name}' at '{self.full_path}'")

    def copy(self):
        """ 
        Copy a file from source to its residence
        """
        if self.source is not None:
            messages.arrow(f"Copied: '{self.source}' ==> '{self.residence}'")
            # copy2(self.source, self.residence)
        else:
            messages.error(f"{self.name} has no source from which to copy from.")

    def link(self):
        """ 
        Create a link from source to its residence
        """
        if self.source is not None:
            messages.arrow(f"Linked: '{self.source}' --> '{self.full_path}'")
            # symlink(self.source, self.full_path)
        else:
            messages.error(f"{self.name} has no source from which to copy from.")
    
    def show_comments(self):
        """
        Show useful comments to the user, such as how to configure a program further or what to do next.
        """
        for comment in self.comments:
            messages.info(comment)