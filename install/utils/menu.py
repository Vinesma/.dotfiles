"""
Display a menu with choices for the user
"""
from utils import messages

def show(options, header=None):
    """
    Display menu on screen and question the user
    Optionally, a header can be shown
    Returns the index of the choice [0 index], or None if the user decided to exit.
    """
    if header is not None: messages.header(header)
    if options[-1] != "Exit": options.append("Exit")

    for index, option in enumerate(options, start=1):
        messages.option(option, index)
    
    response = messages.question_int("Your choice?")
    if response == len(options):
        return None
    else:
        messages.arrow(f"Choice: {options[response - 1]}")
        return response - 1