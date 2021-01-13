from classes.Category import Category
from os import path, listdir
from utils import spawn, messages
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

    if "manjaro" in distro.lower():
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