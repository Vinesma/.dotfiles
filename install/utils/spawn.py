""" Helpers for spawning processes and getting their output
"""

from subprocess import run

def process(process_name, args=[]):
    """ Run a process, this will display its output to the screen 
            process_name = string with the process to run
            args = list with the arguments to pass to the process
        return -> The process' output as a CompletedProcess instance
    """ 
    process = [process_name] + args
    output = run(process, check=True, text=True)

    return output

def process_silent(process_name, args=[]):
    """ Run a process, this will NOT display its output to the screen 
            process_name = string with the process to run
            args = list with the arguments to pass to the process
        return -> The process' output as a CompletedProcess instance
    """ 
    process = [process_name] + args
    output = run(process, check=True, capture_output=True, text=True)

    return output

def process_stdout(process_name, args=[]):
    """ Run a process, this will NOT display its output to the screen 
            process_name = string with the process to run
            args = list with the arguments to pass to the process
        return -> The output of the process as a string
    """ 
    output = process_silent(process_name, args)

    return str(output.stdout)