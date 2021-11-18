""" Helpers for displaying information to the user."""

import sys
from config.shared import Config

config = Config()

_PADDING = "  "
_BIG_ARROW = "==>"
_SHORT_ARROW = "->"
_INFO = "[i]"
_QUESTION = "[?]"
_ALERT = "[!!!]"


def break_line():
    """Jump one line."""
    print("\n")


def error(message):
    """Show an error message."""
    break_line()
    print(f"{_PADDING}{_ALERT} ERROR: {message} {_ALERT}")


def heading(message):
    """Show a heading message."""
    print(f"{_PADDING}{_BIG_ARROW} {message}")
    break_line()


def normal(message):
    """Show a simple message."""
    print(f"{_PADDING}{_SHORT_ARROW} {message}")


def info(message):
    """Show an informational message."""
    print(f"{_PADDING}{_INFO}: {message}")


def alert(message):
    """Show an alert message."""
    print(f"{_PADDING}{_ALERT}: {message}")


def numbered(message, number):
    """Show a numbered message."""
    print(f"{_PADDING}[{number}]: {message}")


def question(message, response_type="string"):
    """Prints a question that the user must answer

    Response parameter controls what kind of question will be asked
    and the return type of the function.
    """
    if response_type == "boolean":
        print(f"{_QUESTION}: {message} (Y/n)")
    else:
        print(f"{_QUESTION}: {message}")

    user_response = sys.stdin.readline().rstrip()

    if response_type == "integer":
        return int(user_response)

    if response_type == "boolean":
        if user_response.lower() != "n":
            return True

        return False

    if config.fail_fast and response_type != "string":
        raise NotImplementedError(
            f"Question type '{response_type}' has not been implemented or does not exist."
        )

    return user_response  # Fallback to string return type


def choose(choices, allow_exit=False):
    """Receive a list of strings, number them and let the user choose between them.

    Returns the chosen string.
    Unless 'allow_exit' is True, won't let the user quit without confirmation.
    If 'allow_exit' is True return 'EXIT' if the user selects anything outside the range of choices.
    """

    while True:
        for index, choice in enumerate(choices, start=1):
            numbered(choice, index)
        if allow_exit:
            numbered("EXIT", len(choices) + 1)

        try:
            selected_index = question("Which do you choose?", response_type="integer")
        except ValueError:
            alert("Value must be the integer representing the choice.")
        else:
            if selected_index - 1 in range(len(choices)):
                return choices[selected_index - 1]
            elif allow_exit:
                return "EXIT"
            else:
                alert("Your choice is invalid, try again.")
