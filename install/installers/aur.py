"""
Wrappers for aur helper
"""
from utils import messages, spawn

aur_helper="yay"

def sync(args=None):
    """
    Sync repos and install packages
    """
    if args is None:
        args = []

    if len(args) > 0:
        spawn.process(aur_helper, ["--noconfirm", "-Sua"] + args)
    else:
        spawn.process(aur_helper, ["--noconfirm", "-Sua"])

def install(args=None):
    """
    Install packages, no sync
    """
    if args is None:
        args = []

    if len(args) > 0:
        spawn.process(aur_helper, ["--noconfirm", "-S"] + args)