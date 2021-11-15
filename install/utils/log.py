""" Handle logging to file
"""

import time
from config.shared import Config

config = Config()


def write(text):
    """Write text to the logfile"""
    localtime = time.localtime()
    hour = localtime.tm_hour
    minute = localtime.tm_min
    second = localtime.tm_sec

    if config.install_log:
        with open(
            config.log_path,
            "a",
            encoding="utf-8",
        ) as logfile:
            logfile.write(f"\nLOG [{hour}:{minute}:{second}]: {text}")
