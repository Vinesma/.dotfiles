"""
Wrappers for pip
"""
from utils import messages, spawn

def install(args=[]):
    """
    Install packages 
    """
    if len(args) > 0:
        spawn.sudo_process("pip", ["install"] + args)