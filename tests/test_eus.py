import boto3
import pytest
from botocore.stub import Stubber

eus = boto3.client("eus")


@pytest.fixture(autouse=True)
def eus_stub():
    with Stubber(eus) as stubber:
        yield stubber
        stubber.assert_no_pending_responses()


def test_get_unicorn(eus_stub):
    expected = {
        "Unicorn": {"UnicornId": "u-abcdef0123", "UnicornName": "Prongs"},
    }

    eus_stub.add_response(
        "get_unicorn", expected, {"UnicornId": "u-abcdef0123"},
    )

    actual = eus.get_unicorn(UnicornId="u-abcdef0123")

    assert actual == expected


def test_describe_unicorns(eus_stub):
    expected = {
        "Unicorns": [{"UnicornId": "u-abcdef0123", "UnicornName": "Prongs"}],
    }

    eus_stub.add_response(
        "describe_unicorns", expected, {},
    )

    actual = eus.describe_unicorns()

    assert actual == expected
