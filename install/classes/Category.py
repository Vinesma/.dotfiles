from classes.File import File 
from classes.Package import Package
from utils import messages
from installers import pacman, aur, pip

class Category:

    def __init__(self, category_name, packages=[], files=[]):
        self.category_name = category_name

        packlist = []
        filelist = []

        for package in packages:
            newPackage = Package(
                name=package["name"],
                install_name=package["install_name"],
                installer=package["installer"],
                run_commands=package["run_commands"],
                autostart=package["autostart"],
                comments=package["comments"]
            )
            packlist.append(newPackage)

        self.packages = packlist
        
        for file in files:
            newFile = File(
                name=file["name"],
                residence=file["residence"],
                source=file["source"],
                text=file["text"],
                create_link=file["create_link"],
                sudo=file["sudo"],
                comments=file["comments"]
            )
            filelist.append(newFile)

        self.files = filelist

    def install_packages(self):
        """
        Install all the packages and configure them by running the set commands
        """
        packages_pacman = []
        packages_aur = []
        packages_pip = []
        for package in self.packages:
            if package.installer == "pacman":
                packages_pacman.append(package.install_name)
            elif package.installer == "aur":
                packages_aur.append(package.install_name)
            elif package.installer == "pip":
                packages_pip.append(package.install_name)
            elif package.installer == "custom":
                pass
            else:
                packages_pacman.append(package.install_name)

        pacman.install(packages_pacman)
        aur.install(packages_aur)
        pip.install(packages_pip)

        for package in self.packages:
            package.configure()
            package.create_autostart()
            package.show_comments()

    def configure_files(self):
        """
        Copy, create, link and make directories to hold config files
        """
        for file in self.files:
            file.configure()
    
    def link_files(self):
        """
        Loop through files and link them if the user wishes to
        """
        for file in self.files:
            if file.create_link:
                file.link_ask()
                
    def install_group(self):
        """
        Install and configure the entire category
        """
        messages.header(f"Installing {self.category_name} group.")
        self.install_packages()
        self.configure_files()
    
    def install_group_ask(self):
        """
        Install and configure the entire category, but ask if the user wishes to install it first
        """
        doInstall = messages.question_bool(f"Do you wish to install the {self.category_name} group?")

        if doInstall:
            self.install_group()
        else:
            messages.arrow(f"Skipped: {self.category_name}.")
    
    def show_all_comments(self):
        """
        Show all comments from all packages and files in this category
        """
        for package in self.packages:
            if package.has_comments():
                package.show_comments()

                messages.question_str("Done?")
        
        for file in self.files:
            if file.has_comments():
                file.show_comments()

                messages.question_str("Done?")