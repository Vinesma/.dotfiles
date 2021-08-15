"""
Wrappers for pacman
"""
from utils import messages, spawn

def sync(args=None):
    """
    Sync repos and install packages
    """
    if args is None:
        args = []

    if len(args) > 0:
        spawn.sudo_process("pacman", ["--noconfirm", "-Syu"] + args)
    else:
        spawn.sudo_process("pacman", ["--noconfirm", "-Syu"])

def install(args=None):
    """
    Install packages, no sync
    """
    if args is None:
        args = []

    if len(args) > 0:
        spawn.sudo_process("pacman", ["--noconfirm", "--needed", "-S"] + args)
    else:
        raise Exception("No packages to install for Pacman, please pass a list of packages.")