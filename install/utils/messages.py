""" Helpers for displaying messages to the user
"""

from sys import stdin

def header(message):
    """ Prints a big arrow with no spacing
            args = A message string to display after the arrow
    """
    print(f"==> {message}")

def arrow(message):
    """ Prints a small arrow with 2 spacings to the left
            args = A message string to display after the arrow
    """
    print(f"  -> {message}")

def info(message):
    """ Prints an info message with 2 spacings to the left
            args = A message string to display
    """
    print(f"  [i]: {message}")

def error(message):
    """ Prints an error message with 2 spacings to the left
            args = A message string to display
    """
    print(f"  [Error]: {message}")

def question_str(message):
    """ Prints a question that the user must answer
            args = A question string to display
        return -> A string typed by the user
    """
    print(message)
    response = stdin.readline().rstrip()

    return response

def question_bool(message):
    """ Prints a question that the user must answer
        args = A question string to display
        return -> A boolean value corresponding to yes or no
    """
    print(f"{message} (y/n)")
    response = stdin.readline().rstrip()

    if response.lower() == 'y':
        return True

    return False