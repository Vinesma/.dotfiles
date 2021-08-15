from classes.Category import Category
from classes.File import File
from classes.Package import Package
from os import path, listdir
from utils import spawn, messages, menu
import json

# Folders
MAIN_FOLDER = path.expanduser("~/.dotfiles/install")
PACKAGE_LISTS = path.join(MAIN_FOLDER, "packages")

def init_category(filename):
    """
    Initialize a category from a file
        filename = File from 'packages' (no .json extension needed)
    """
    category_path = path.join(PACKAGE_LISTS, f"{filename}.json")
    with open(category_path, "r") as readFile:
        category = json.load(readFile)

    initializedObject = Category(
        category_name=category["category_name"],
        packages=category["packages"],
        files=category["files"]
    )

    return initializedObject

def init_many_install(filenames):
    """
    Initialize many categories and install them
    """
    for filename in filenames:
        init_category(filename).install_group()

def check_distro():
    """
    Check if the distro is Manjaro Linux
    """
    distro = spawn.process_stdout("uname", ["-r"])

    if "MANJARO" in distro:
        messages.arrow("Manjaro Linux detected. Specific packages will be installed.")
        return True

    messages.arrow("It appears you are not using Manjaro Linux, some distro specific packages will be skipped.")
    return False

def list_packages():
    """
    List the names of package groups in the PACKAGE_LISTS dir
    """
    packages = listdir(PACKAGE_LISTS)
    packagesList = []
    for package in packages:
        package = package.replace(".json", "")
        packagesList.append(package)
    
    return packagesList

def create_string_list(message, alt_message=""):
    string_list = []
    addAnother = True

    # 1st run
    text = messages.question_str(message)
    if text == "":
        addAnother = False
    else:
        string_list.append(text)
    
    if alt_message != "": message = alt_message

    # Subsequent runs
    while addAnother:
        text = messages.question_str(message)

        if text == "":
            addAnother = False
        else:
            string_list.append(text)
    
    return string_list

def create_install_file():
    """
    Helper for creating .json package files quickly
    """
    filename = messages.question_str("What should the file be called? (No extension)")
    filename_abs = path.join(PACKAGE_LISTS, f"{filename}.json")

    if path.isfile(filename_abs):
        messages.error("File already exists! choose another filename.")
    else:
        category_name = messages.question_str("What should the category be called? (No effect on install)")
        hasPackages = messages.question_bool("Does this category install any packages?")
        hasFiles = messages.question_bool("Does this category copy/move/link any files?")
        packages = []
        files = []
        count = 1

        if hasPackages:
            addAnotherPackage = True

            while addAnotherPackage:
                messages.header(f"Package: {count}")

                package_name = messages.question_str("What is the name of the package? (No effect on install)")
                install_name = messages.question_str("What is the name of the package in the repositories?")
                installer = messages.question_str("What is the installer used by this package? (pacman, aur, pip, ...)")
                run_commands = create_string_list(
                    "Type a command that should be ran after the package has been installed (Empty for none/cancel)",
                    "Type another command (Empty for none/cancel)"
                )
                autostart = messages.question_str("What command is used to autostart this package? (Empty for none)")
                comments = create_string_list(
                    "Type a comment that should be shown to the user after install (Empty for none/cancel)",
                    "Type another comment (Empty for none/cancel)"
                )
                if autostart == "": autostart = None

                packages.append(
                    {
                        "name": package_name,
                        "install_name": install_name,
                        "installer": installer,
                        "run_commands": run_commands,
                        "autostart": autostart,
                        "comments": comments
                    }
                )

                addAnotherPackage = messages.question_bool("Add another package after this one?")
                count += 1
            count = 1
            
        if hasFiles:
            addAnotherFile = True

            while addAnotherFile:
                messages.header(f"File: {count}")

                file_name = messages.question_str("What is the exact filename?")
                residence = messages.question_str("Where will it reside in the system?")
                source = messages.question_str("Where will it be sourced from? (Empty for Null)")
                text = ""

                if source == "": 
                    source = None
                    text = messages.question_str("Type the contents with which the file will start with")

                create_link = messages.question_bool("Create a link between source and residence?")
                sudo = messages.question_bool("Use sudo?")
                comments = create_string_list(
                    "Type a comment that should be shown to the user afterwards (Empty for none/cancel)",
                    "Type another comment (Empty for none/cancel)"
                )
                
                files.append(
                    {
                        "name": file_name,
                        "residence": residence,
                        "source": source,
                        "text": text,
                        "create_link": create_link,
                        "sudo": sudo,
                        "comments": comments
                    }
                )

                addAnotherFile = messages.question_bool("Add another file after this one?")
                count += 1

        category = {
            "category_name": category_name,
            "packages": packages,
            "files": files
        }

        with open(filename_abs, "w") as package_file:
            json.dump(category, package_file, indent=4)

        messages.info(f"Created {filename}.json in {PACKAGE_LISTS}")