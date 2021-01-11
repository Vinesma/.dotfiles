from installers import pacman

class Package:

    def __init__(self, name, install_name, installer, run_commands=[]):
        self.name = name
        self.install_name = install_name
        self.installer = installer
        self.run_commands = run_commands
    
    def install(self):
        """ Install this package
        """
        if self.installer == "pacman":
            pacman.install_package(self.install_name, self.name)