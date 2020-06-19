import boto3
import json


def main():
    eus = boto3.client("eus", region_name="eu-west-1")

    print("DescribeUnicorns:")
    print(json.dumps(eus.describe_unicorns(), indent=2))

    print("GetUnicorn:")
    print(json.dumps(eus.get_unicorn(UnicornId="u-00001"), indent=2))


if __name__ == "__main__":
    main()
