from classes.File import File 
from classes.Package import Package
from utils import messages
from installers import pacman

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
                comments=file["comments"]
            )
            filelist.append(newFile)

        self.files = filelist

    def install_packages(self):
        """
        Install all the packages and configure them by running the set commands
        """
        package_names = []
        for package in self.packages:
            package_names.append(package.install_name)

        pacman.install(package_names)

        for package in self.packages:
            package.configure()
            package.create_autostart()
            package.show_comments()

    def configure_files(self):
        """
        Copy, create and link config files
        """
        for file in self.files:
            if file.source is not None:
                file.copy()
            else:
                file.create()
            
            if file.create_link:
                file.link()
        
        file.show_comments()
                
    def install_group(self):
        """
        Install and configure the entire category
        """
        messages.header(f"Installing {self.category_name} group.")
        self.install_packages()
        self.configure_files()