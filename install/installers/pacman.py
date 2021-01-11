"""
Wrappers for pacman
"""
from utils import messages, spawn

def sync(args=[]):
    """
    Sync repos and install packages
    """
    if len(args) > 0:
        # spawn.sudo_process("pacman", ["--noconfirm", "-Syu"] + packages)
        messages.info(args)
    else:
        # spawn.sudo_process("pacman", ["--noconfirm", "-Syu"])
        pass

def install(args=[]):
    """
    Install packages, no sync
    """
    if len(args) > 0:
        # spawn.sudo_process("pacman", ["--noconfirm", "--needed", "-S", packages])
        messages.info(args)
    else:
        messages.error("No packages to install, please pass a list of packages.")