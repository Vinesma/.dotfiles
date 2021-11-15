""" Manage an entire system's installation
"""

import os
import json
from config.shared import Config
from classes.group import Group
from utils import message, test, log

config = Config()


def main():
    """Start here."""

    if config.dev_mode:
        print("DEV MODE: ON")
        test.run()

    while True:
        message.heading("Welcome! Pick your poison:")

        choice = message.choose(
            [
                "Full install",
                "Select group",
                "Create links",
                "Create new package group",
                "Populate main.json with all group .json files",
            ],
            allow_exit=True,
        )

        if choice == "Full install":
            log.write("--LOG START--", refresh=True)
            groups = Group.load_all()

            for index, group in enumerate(groups, start=1):
                if index == 1:
                    group.install(sync=True)
                else:
                    group.install()

            log.write("--LOG END--")
        elif choice == "Select group":
            groups = Group.load_all()

            group_choice = message.choose(
                [group.name for group in groups], allow_exit=True
            )

            if group_choice != "EXIT":
                Group.load(group_choice).install()
            else:
                os.system("clear")
        elif choice == "Create links":
            groups = Group.load_all()

            group_choice = message.choose(
                [group.name for group in groups], allow_exit=True
            )

            if group_choice != "EXIT":
                Group.load(group_choice).link_files()
            else:
                os.system("clear")
        elif choice == "Create new package group":
            Group.interactive_insert().save()
            message.info(
                "Don't forget to add this group to the 'main.json' file. This decides the order in which it is installed."
            )
        elif choice == "Populate main.json with all group .json files":
            group_names = [
                group.replace(".json", "")
                for group in os.listdir(config.group_files_path)
                if group.endswith(".json") and group != "initial.json"
            ]

            group_names.insert(0, "initial")

            with open(
                os.path.join(config.program_path, "data", "main.json"),
                "w",
                encoding="utf-8",
            ) as _file:
                json.dump(group_names, fp=_file, indent=4)
            os.system("clear")
            message.info("Populated main.json with all groups found.")
        else:
            message.normal("See ya!")
            break


main()
