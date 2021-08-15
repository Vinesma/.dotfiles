"""
Wrappers for pip
"""
from utils import messages, spawn

def install(args=None):
    """
    Install packages 
    """
    if args is None:
        args = []

    if len(args) > 0:
        spawn.sudo_process("pip", ["install"] + args)