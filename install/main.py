"""
Installs and configures an entire linux system from scratch.
"""

from subprocess import run
from os import path
from utils import messages, spawn, install_util
from installers import pacman
from classes.Category import Category
import json

def main():
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
        install_util.init_category("touchpad").install_group()
        install_util.init_category("backlight").install_group()
        install_util.init_category("bluetooth").install_group()
    else:
        # Non laptop packages
        messages.header("Installing desktop packages.")
        install_util.init_category("numpad").install_group()

    # Main software
    install_util.init_category("apps").install_group()
    install_util.init_category("eyecandy").install_group()
    install_util.init_category("applets").install_group()
    install_util.init_category("input_methods").install_group()
    install_util.init_category("email").install_group()

    if isManjaro:
        messages.header("Installing Manjaro specific packages.")
        install_util.init_category("manjaro").install_group()

        if install_printer:
            messages.header("Installing Manjaro printer.")
            install_util.init_category("printer").install_group()

main()