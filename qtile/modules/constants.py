from os import path 

def config():
    """
    Returns constants necessary for using qtile
    """
    homepath = path.expanduser("~")
    scripts_path = path.join(homepath, ".dotfiles", "scripts")
    mod = "mod4"
    terminal = "kitty",
    terminal_reduced_opacity = "kitty -o background_opacity=0.9"
    terminal_increased_opacity = "kitty -o background_opacity=0.7"
    browser = "firefox"
    file_browser = "thunar"

    return {
        "homepath": homepath,
        "scripts_path": scripts_path,
        "mod": mod,
        "terminal": terminal,
        "terminal_reduced_opacity": terminal_reduced_opacity,
        "terminal_increased_opacity": terminal_increased_opacity,
        "browser": browser,
        "file_browser": file_browser
    }