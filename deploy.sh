#!/bin/bash

echo "> Looking for stack"

stack=$(aws cloudformation list-stacks --query "StackSummaries[?StackName == 'ElasticUnicornService']|[?(StackStatus == 'UPDATE_COMPLETE' || StackStatus == 'CREATE_COMPLETE')]")

command="update-stack"
if [ "$stack" == '[]' ];  then
    command="create-stack"
fi

echo "> Deploying ElasticUnicornService"

aws cloudformation \
    $command \
    --stack-name ElasticUnicornService \
    --template-body "$(cat ./cloudformation/ElasticUnicornService.yml)" \
    --capabilities CAPABILITY_IAM || true

if [ "$stack" == "[]" ]; then
    echo "> Deployment started, sleeping for 3minutes."
    sleep 3m
    echo "> Done. Run this command again, to continue the setup."
    exit 0
fi

echo "> Ignore if the error says: No updates to be performed."

api_id=$(aws cloudformation describe-stacks --stack-name ElasticUnicornService --query "Stacks[0].Outputs[?OutputKey == 'RestApi'] | [0].OutputValue")
api_id=$(eval printf $api_id)

api_hostname=$(aws cloudformation describe-stacks --stack-name ElasticUnicornService --query "Stacks[0].Outputs[?OutputKey == 'Hostname'] | [0].OutputValue")
api_hostname=$(eval printf $api_hostname)


current_hostname=$(grep -Hn -m 1 '"hostname": "https:' models/endpoints.json)
current_api_id=$(grep -Hn -m 1 '"endpointPrefix": "' models/eus/2019-10-20/service-2.json)

echo "> ElasticUnicornService ID: $api_id"
echo "> ElasticUnicornService Hostname: $api_hostname"

echo
echo

echo "IMPORTANT: You should change the line below to \"hostname\": \"https://$api_hostname\""
echo
echo "> $current_hostname"
echo
echo "and the line below to \"endpointPrefix\": \"$api_id.execute-api\""
echo
echo "> $current_api_id"
echo
echo "when that is done - run: AWS_DATA_PATH=models/ python unicorn.py"
