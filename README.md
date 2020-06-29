# elastic-unicorn-service

A proof-of-concept custom AWS service, exposed through a `botocore` client. Read
the [blog
post](https://www.seporaitis.net/posts/2020/06/29/aws-like-service-on-boto3/) to
understand more what this is.

Running `tox` does not require any AWS resources and should give an impression
of this unusual idea. Continue reading if you'd like to run an example "Elastic
Unicorn Service" like this.

## Requirements & Setup

Requirements:

* Python 3.7
* AWS Account and `awscli` configuration/credentials for `eu-west-1` region.

Note: If you cannot run in `eu-west-1` - then `git grep eu-west-1` and replace references.

Setup:

```bash
python -m venv venv
source venv/bin/activate
./deploy.sh  # follow the instructions in the output
```

`deploy.sh` is a simple script that should be run twice:

1. First time it creates the service stack.
2. Second time it updates it and prints out instructions how to update the two
   files in `models` directory.

## Running

`AWS_DATA_PATH` should point to `models` directory, for everything to work.

For example, run - `AWS_DATA_PATH=models/ python unicorn.py` and see the service
in action.
