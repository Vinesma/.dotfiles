""" Define values used throught the modules
"""

from os import path


def config():
    """
    Returns constants necessary for using qtile
    """
    home_path = path.expanduser("~")
    scripts_path = path.join(home_path, ".dotfiles", "scripts")
    mail_path = path.join(home_path, ".mail", "gmail", "Inbox", "new")
    newsboat_path = path.join(scripts_path, "newsboat")
    mod = "mod4"
    terminal = "kitty"
    terminal_reduced_opacity = f"{terminal} -o background_opacity=0.9"
    terminal_increased_opacity = f"{terminal} -o background_opacity=0.7"
    browser = "firefox"
    file_browser = "thunar"

    return {
        "home_path": home_path,
        "scripts_path": scripts_path,
        "mail_path": mail_path,
        "newsboat_path": newsboat_path,
        "mod": mod,
        "terminal": terminal,
        "terminal_reduced_opacity": terminal_reduced_opacity,
        "terminal_increased_opacity": terminal_increased_opacity,
        "browser": browser,
        "file_browser": file_browser,
    }
