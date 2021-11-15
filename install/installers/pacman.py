""" Wrappers for pacman
"""

from utils import spawn, log


def sync(args=""):
    """Sync repos and install packages"""

    spawn.process(f"pacman --noconfirm -Syu {args}", sudo=True)
    log.write("Synced all repos with pacman.sync()")


def install(args):
    """Install packages, no sync"""

    if len(args) > 0:
        spawn.process(f"pacman --noconfirm --needed -S {args}")
        log.write("(PACMAN) Installed: ", *args)
