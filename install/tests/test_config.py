""" Test config
"""
import pytest
from config.shared import Config


@pytest.fixture
def configs():
    """Returns two config instances"""
    config_1 = Config()
    config_2 = Config()

    yield [config_1, config_2]

    # pylint: disable=protected-access
    config_1._instance = None
    config_2._instance = None


def test_config(configs):  # pylint: disable=redefined-outer-name
    """Test if config returns same instance"""
    config_1, config_2 = configs

    assert config_1 == config_2
