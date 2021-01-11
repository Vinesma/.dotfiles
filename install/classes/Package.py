from installers import pacman
from utils import spawn, messages
from os import path

class Package:

    def __init__(self, name, install_name, installer, run_commands=[], autostart=None, comments=[]):
        self.name = name
        self.install_name = install_name
        self.installer = installer
        self.run_commands = run_commands
        self.autostart = autostart
        self.comments = comments
    
    def configure(self):
        """
        Run the set commands to configure the package
        """
        if len(self.run_commands) > 0:
            messages.arrow(f"Running commands to configure {self.name}")

        for command in self.run_commands:
            process = command.split(" ")
            process_name = process[0]

            if len(process) > 1:
                process_args = process[1:]
            else:
                process_args = []

            # spawn.process(process_name, process_args)
    
    def create_autostart(self):
        """
        Add a line to .autostart so that the program starts up automatically
        """
        if self.autostart is not None:
            AUTOSTART = path.expanduser("~/.autostart")
            messages.arrow(f"Appending '{self.autostart}' to the autostart file at {AUTOSTART}")
            # with open(AUTOSTART, "a") as appendFile:
                # appendFile.write(self.autostart)

    def show_comments(self):
        """
        Show useful comments to the user, such as how to configure a program further or what to do next.
        """
        for comment in self.comments:
            messages.info(comment)