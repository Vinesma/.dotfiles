""" Helpers for spawning processes """

import sys
from subprocess import run, CalledProcessError
from time import sleep
from utils import message
from config.shared import Config

config = Config()


def process(process_string, silent=False, capture=False, sudo=False):
    """Run a process.

    If silent = False, displays process output to the screen,
    otherwise only this program's output is shown.

    If capture = True, return the process' stdout instead of a CompletedProcess instance.

    If sudo = True, run the process as super user
    (may require user intervention for collecting password).

    On error, stops execution for 30 seconds for evaluation, alternatively, crashes the program.
    """

    if sudo:
        process_string = f"{config.admin_command} {process_string}"

    [process_name, *args] = process_string.split()

    # Remove special {SPACE} character, which denotes a space that doesn't mean a new argument
    for index, arg in enumerate(args):
        if "{SPACE}" in arg:
            args[index] = arg.replace("{SPACE}", " ")

    try:
        output = run(
            [process_name, *args],
            check=True,
            text=True,
            capture_output=(capture or silent),
        )
    except CalledProcessError as error:
        message.error(
            f"'{process_name}' failed with code {error.returncode} :: {error.output}"
        )
        message.alert(f"ARGS: {args}")

        if config.fail_fast:
            message.alert(
                f"Halting execution because of fail_fast = {config.fail_fast}"
            )
            sys.exit(1)
        else:
            message.info("Stopping execution temporarily for your evaluation.")

            for i in range(3, 0, -1):
                message.info(f"Program will continue in {i * 10} seconds...")
                sleep(config.seconds_to_wait_on_fail)

            output = run(["echo"], check=True, text=True)

    if capture:
        return output.stdout

    return output
