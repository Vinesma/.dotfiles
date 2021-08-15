from installers import pacman
from utils import spawn, messages
from os import path, getenv
import re

class Package:

    def __init__(self, name, install_name, installer, run_commands=None, autostart=None, comments=None):

        if comments is None:
            comments = []
        if run_commands is None:
            run_commands = []

        self.name = name
        self.install_name = install_name
        self.installer = installer
        self.autostart = autostart
        self.comments = comments

        commandList = []
        for command in run_commands:
            # Search for environment variables such as $USER or $HOME
            substitute_vars = re.findall(r"\$([A-Z1-9_]+)", command)

            if len(substitute_vars) > 0:

                for substitute in substitute_vars:
                    # Retrieve the environment variable if possible
                    environment_var = getenv(substitute)

                    if environment_var is not None:
                        command = command.replace(f"${substitute}", environment_var)
                    else:
                        messages.error(f"Could not find environment variable: {substitute}")

            commandList.append(command)

        self.run_commands = commandList
    
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

            spawn.process(process_name, process_args)
    
    def create_autostart(self):
        """
        Add a line to .autostart so that the program starts up automatically
        """
        if self.autostart is not None:
            AUTOSTART = path.expanduser("~/.autostart")
            messages.arrow(f"Appending '{self.autostart}' to the autostart file at {AUTOSTART}")
            with open(AUTOSTART, "a") as appendFile:
                appendFile.write(f"\n{self.autostart}")

    def show_comments(self):
        """
        Show useful comments to the user, such as how to configure a program further or what to do next.
        """
        for index, comment in enumerate(self.comments):
            if index == 0:
                messages.arrow(f"[{self.name}]")
            messages.info(comment)
    
    def has_comments(self):
        """
        Check if a package has written comments about it
        """
        if len(self.comments) > 0: 
            return True

        return False