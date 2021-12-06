""" Wrappers for installing AUR packages
"""

from utils import spawn, log
from config.shared import Config

config = Config()


def sync(args=""):
    """Sync repos and install packages"""

    spawn.process(f"{config.aur_helper} --noconfirm -Sua {args}")
    log.write("Synced AUR packages")


def install(args):
    """Install packages, no sync"""

    if len(args) > 0:
        spawn.process(f"{config.aur_helper} --noconfirm -S {args}")
        log.write(f"(AUR) Installed: {args}")
