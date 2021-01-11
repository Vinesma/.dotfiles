"""
Installs and configures an entire linux system from scratch.
"""

from subprocess import run
from os import path
from utils import messages, spawn
from installers import pacman
from classes.Category import Category
import json

def main():
    # FOLDERS
    MAIN_FOLDER = path.expanduser("~/.dotfiles/install")
    PACKAGE_LISTS = path.join(MAIN_FOLDER, "packages")

    messages.header("Collecting system information...")
    distro = spawn.process_stdout("uname", ["-r"])

    if "manjaro" in distro.lower():
        messages.arrow("Manjaro Linux detected. Specific packages will be installed.")
        distro = "MANJARO"
    else:
        messages.arrow("It appears you are not using Manjaro Linux, some distro specific packages will be skipped.")
        distro = "OTHER"

    install_laptop = messages.question_bool("Are you installing on a laptop?")
    install_printer = messages.question_bool("Install printer support?")

    # Initial sync to make sure all packages are up to date.
    messages.header("Syncing repositories and updating system packages.")
    pacman.sync()

    messages.header("All good, go grab a coffee, we gon' be here a while.")
    messages.arrow("Initializing install...")

    # Initial configuration
    category_path = path.join(PACKAGE_LISTS, "initial.json")
    with open(category_path, "r") as readFile:
        category = json.load(readFile)

    categoryConfiguration = Category(
        category_name=category["category_name"],
        packages=category["packages"],
        files=category["files"]
    )
    categoryConfiguration.install_group()

    category_path = path.join(PACKAGE_LISTS, "essential.json")
    with open(category_path, "r") as readFile:
        category = json.load(readFile)

    categoryConfiguration = Category(
        category_name=category["category_name"],
        packages=category["packages"],
        files=category["files"]
    )
    categoryConfiguration.install_group()

main()