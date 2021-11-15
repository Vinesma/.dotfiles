""" Wrappers for pip
"""

from utils import spawn, log


def install(args):
    """Install packages"""

    if len(args) > 0:
        spawn.process(f"pip install {args}")
        log.write(f"(PIP) Installed: {args}")
