""" Test spawning commands
"""
from subprocess import CompletedProcess
from utils import spawn
from config.shared import Config

COMMAND = "echo -n   argument1  argument2"
COMMAND_FAIL = "false"
config = Config()


def test_success():
    """Normal execution with normal command"""
    result = spawn.process(COMMAND)

    assert isinstance(result, CompletedProcess)
    assert result.args == COMMAND.split()


def test_capture():
    """Test output capture"""
    result = spawn.process(COMMAND, capture=True)

    assert result == " ".join(COMMAND.split()[2:])


def test_failure():
    """Test a failure"""
    config.seconds_to_wait_on_fail = 0
    result = spawn.process(COMMAND_FAIL)

    assert result.args == ["echo"]
