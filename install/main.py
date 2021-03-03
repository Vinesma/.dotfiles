"""
Installs and configures an entire linux system from scratch.
"""

from subprocess import run
from os import path
from utils import messages, spawn, install_util, menu
from installers import pacman
from classes.Category import Category
import json

options = [
    "Full install",
    "Individual install",
    "Create/Edit install files",
    "Link files",
    "Show instructions/comments"
]

def main():
    choice = menu.show(options, header="Welcome to the best installer. Pick your poison:")

    if choice == 0:
        # Full install
        messages.header("Collecting system information...")
        isManjaro = install_util.check_distro()
        install_laptop = messages.question_bool("Are you installing on a laptop?")
        install_printer = messages.question_bool("Install printer support?")

        # Initial sync to make sure all packages are up to date.
        messages.header("Syncing repositories and updating system packages.")
        pacman.sync()

        messages.header("All good, go grab a coffee, we gon' be here a while.")

        messages.arrow("Initial configuration...")
        install_util.init_category("initial").install_group()
        install_util.init_category("essential").install_group()

        messages.header("Setting keymap")
        spawn.process("localectl", ["--no-convert", "set-x11-keymap", "br"])

        if install_laptop:
            messages.header("Installing laptop packages.")
            install_util.init_many_install(["touchpad", "backlight", "bluetooth", "power_saving"])
        else:
            # Non laptop packages
            messages.header("Installing desktop packages.")
            install_util.init_category("numpad").install_group()

        # Main software
        install_util.init_many_install([
            "apps", "eyecandy", "applets", "input_methods", "email"
        ])

        if isManjaro:
            messages.header("Installing Manjaro specific packages.")
            install_util.init_category("manjaro").install_group()

            if install_printer:
                messages.header("Installing Manjaro printer.")
                install_util.init_category("printer").install_group()
    elif choice == 1:
        # Individual install
        packages = install_util.list_packages()
        package_index = 0

        while package_index is not None:
            package_index = menu.show(packages, header="Choose a group of packages to install.")

            if package_index is not None:
                install_util.init_category(packages[package_index]).install_group()
    elif choice == 2:
        # Create/Edit install files
        install_files_choice = menu.show([
            "Create install file",
            "Edit install file"
        ], header="What to do?")
        if install_files_choice == 0:
            install_util.create_install_file()
        elif install_files_choice == 1:
            #@TODO
            pass

    elif choice == 3:
        # Link files
        packages = install_util.list_packages()
        package_index = 0

        while package_index is not None:
            package_index = menu.show(packages, header="Choose a group of packages to link files from.")

            if package_index is not None:
                install_util.init_category(packages[package_index]).link_files()
    elif choice == 4:
        # Show instructions/comments
        packages = install_util.list_packages()
        package_index = 0

        while package_index is not None:
            package_index = menu.show(packages, header="Choose a group of packages to show instructions/comments.")

            if package_index is not None:
                install_util.init_category(packages[package_index]).show_all_comments()

    else:
        messages.info("Exiting...")

main()
