"""
Wrappers for aur helper
"""
from utils import messages, spawn

aur_helper="yay"

def sync(args=[]):
    """
    Sync repos and install packages
    """
    if len(args) > 0:
        spawn.process(aur_helper, ["--noconfirm", "-Sua"] + args)
    else:
        spawn.process(aur_helper, ["--noconfirm", "-Sua"])

def install(args=[]):
    """
    Install packages, no sync
    """
    if len(args) > 0:
        spawn.process(aur_helper, ["--noconfirm", "-S"] + args)
