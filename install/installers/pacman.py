"""
Wrappers for pacman
"""
from utils import messages, spawn

def sync(args=[]):
    """
    Sync repos and install packages
    """
    if len(args) > 0:
        spawn.sudo_process("pacman", ["--noconfirm", "-Syu"] + args)
    else:
        spawn.sudo_process("pacman", ["--noconfirm", "-Syu"])

def install(args=[]):
    """
    Install packages, no sync
    """
    if len(args) > 0:
        spawn.sudo_process("pacman", ["--noconfirm", "--needed", "-S"] + args)
    else:
        messages.error("No packages to install, please pass a list of packages.")