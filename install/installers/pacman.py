from utils import messages, spawn

def sync():
    messages.header("Syncing repositories and updating system packages.")
    spawn.process("pacman", ["--noconfirm", "-Syu"])

def install_package(install_name, name):
    messages.arrow(f"Installing {name}")
    spawn.process("pacman", ["--noconfirm", "-S", install_name])
