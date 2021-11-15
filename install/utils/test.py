""" Test saved .json group files for errors.
"""

import sys
from utils import message
from classes.group import Group


def run():
    """Run sanity tests on package files"""
    message.info("Checking for package errors...")
    groups = Group.load_all()
    errors_found = 0

    for group in groups:
        files = group.files
        packages = group.packages

        for package in packages:
            errors_found += package.evaluate()

            for _file in package.files:
                errors_found += _file.evaluate()

        for _file in files:
            errors_found += _file.evaluate()

    if errors_found > 0:
        message.alert(
            f"{errors_found} errors found. It is highly recommended to fix them before proceeding."
        )
        if not message.question("Proceed without fixing?", "boolean"):
            sys.exit(1)
    else:
        message.info("No errors found")

    message.break_line()
