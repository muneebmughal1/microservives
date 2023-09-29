#!/usr/bin/env bash

# Load environment variables
source ~/.bash_profile

# Application Server
aws cloudformation create-stack --stack-name eks-pipeline-express-node \
--template-url "https://$S3_BUCKET_NAME.s3.amazonaws.com/pipeline_stack/pipeline_cloudformation.yml" \
--parameters ParameterKey=MicroserviceName,ParameterValue="express-node" \
ParameterKey=SharedStackName,ParameterValue="$SHARED_STACK_NAME" \
ParameterKey=BuildComputeType,ParameterValue="$BUILD_COMPUTE_TYPE" \
ParameterKey=SourceCodeBucket,ParameterValue="$S3_BUCKET_NAME" \
ParameterKey=SampleMicroservices,ParameterValue="$USE_SAMPLE_MICROSERVICES" \
--capabilities CAPABILITY_IAM \
--region $AWS_REGION

# User Interface
aws cloudformation create-stack --stack-name eks-pipeline-react-app \
--template-url "https://$S3_BUCKET_NAME.s3.amazonaws.com/pipeline_stack/pipeline_cloudformation.yml" \
--parameters ParameterKey=MicroserviceName,ParameterValue="react-app" \
ParameterKey=SharedStackName,ParameterValue="$SHARED_STACK_NAME" \
ParameterKey=BuildComputeType,ParameterValue="$BUILD_COMPUTE_TYPE" \
ParameterKey=SourceCodeBucket,ParameterValue="$S3_BUCKET_NAME" \
ParameterKey=SampleMicroservices,ParameterValue="$USE_SAMPLE_MICROSERVICES" \
--capabilities CAPABILITY_IAM \
--region $AWS_REGION


echo -n "Creating the AWS CloudFormation stacks"
while 
[ "$(aws cloudformation describe-stacks --stack-name eks-pipeline-express-node --region $AWS_REGION --output json | jq -r '.Stacks[0].StackStatus')" == "CREATE_IN_PROGRESS" ] || \
[ "$(aws cloudformation describe-stacks --stack-name eks-pipeline-react-app --region $AWS_REGION --output json | jq -r '.Stacks[0].StackStatus')" == "CREATE_IN_PROGRESS" ] ; do
  echo -n '.'
  sleep 10
done

if
[ "$(aws cloudformation describe-stacks --stack-name eks-pipeline-express-node --region $AWS_REGION --output json | jq -r '.Stacks[0].StackStatus')" == "CREATE_COMPLETE" ] && \
[ "$(aws cloudformation describe-stacks --stack-name eks-pipeline-react-app --region $AWS_REGION --output json | jq -r '.Stacks[0].StackStatus')" == "CREATE_COMPLETE" ] ; then
    echo -e "\nAll four stacks created successfully!"
else
    echo -e "\nAn error occurred while creating the stacks! Don't move forward before fixing it!"
fi


