from pathlib import Path
from utils import messages
from shutil import copy2

class File:

    def __init__(self, name, residence, source=None):
        self.name = name
        self.residence = Path(residence).expanduser()
        self.full_path = residence/name

        if source is not None:
            self.source = Path(source).expanduser()
        else:
            self.source = None

    def create(self):
        """ Create an empty file at its residence
        """
        self.full_path.write_text("")
        messages.arrow(f"Created {self.name} at {self.full_path}")

    def copy(self):
        """ Copy a file from source to its residence
        """
        if self.source is not None:
            copy2(self.source, self.residence)
        else:
            messages.error(f"{self.name} has no source from which to copy from.")

    def link(self):
        """ Create a link from source to its residence
        """
        if self.source is not None:
            self.source.symlink_to(self.full_path)
        else:
            messages.error(f"{self.name} has no source from which to copy from.")