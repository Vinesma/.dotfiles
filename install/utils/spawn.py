"""
Helpers for spawning processes and getting their output
"""

from subprocess import run, CalledProcessError
from time import sleep

def process(process_name, args=[]):
    """
    Run a process, this will display its output to the screen 
        process_name = string with the process to run
        args = list with the arguments to pass to the process
        return -> The process' output as a CompletedProcess instance
    Errors are reported, then ignored after 30 seconds.
    """ 
    process = [process_name] + args
    try:
        output = run(process, check=True, text=True)
    except CalledProcessError as error:
        print(f"\n[Process error (code {error.returncode})]: {error.output}")

        for i in range(3, 0, -1):
            print(f"Program will continue in {i * 10} seconds...")
            sleep(10)

    return output

def process_silent(process_name, args=[]):
    """
    Run a process, this will NOT display its output to the screen 
        process_name = string with the process to run
        args = list with the arguments to pass to the process
        return -> The process' output as a CompletedProcess instance
    Errors are reported, then ignored after 30 seconds.
    """ 
    process = [process_name] + args
    try:
        output = run(process, check=True, capture_output=True, text=True)
    except CalledProcessError as error:
        print(f"\n[Process error (code {error.returncode})]: {error.output}")

        for i in range(3, 0, -1):
            print(f"Program will continue in {i * 10} seconds...")
            sleep(10)

    return output

def process_stdout(process_name, args=[]):
    """
    Run a process, this will NOT display its output to the screen 
        process_name = string with the process to run
        args = list with the arguments to pass to the process
        return -> The output of the process as a string
    """ 
    output = process_silent(process_name, args)

    return str(output.stdout)

def sudo_process(process_name, args=[]):
    """
    Run a process with root privileges
        process_name = string with the process to run
        args = list with the arguments to pass to the process
        return -> The process' output as a CompletedProcess instance
    Errors will crash the script
    """
    process = ["sudo", process_name] + args
    output = run(process, check=True, text=True)

    return output