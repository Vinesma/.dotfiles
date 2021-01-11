""" Installs and configures an entire linux system from scratch.
"""

from subprocess import run
from pathlib import Path
from utils import messages, spawn
from installers import pacman

def main():
    # FOLDERS
    MAIN_FOLDER = Path("~/.dotfiles/install").expanduser()
    PACKAGE_LIST = MAIN_FOLDER/"packlists"

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
    pacman.sync()

    messages.header("All good, go grab a coffee, we gon' be here a while.")
    messages.arrow("Initializing install...")

if "root" in spawn.process_stdout("whoami"):
    main()
else:
    messages.error("This installer needs root access to properly configure the system. Please run as sudo.")