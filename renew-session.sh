#!/usr/local/bin/bash
profile=$1
read -r account arn userid <<< $(aws --profile saml-hcs-fca-integration-Admin sts get-caller-identity  --query "[Account,Arn]" --output text |sed 's|sts|iam|; s|assumed-||; s|/\([^/]*\)$| \1|')
while true
do
  new_credential=$(aws --profile $profile sts assume-role --role-arn $arn --role-session-name $userid --duration-seconds 3600 --query "Credentials.{aws_access_key_id:AccessKeyId,aws_secret_access_key:SecretAccessKey,aws_session_token:SessionToken}" --output json | grep aws_ |sed 's/^ *"//; s/": "/ = /; s/",*$//')
  sed -i.bak "/\[$profile\]/,+5d"  ~/.aws/credentials
  echo "[$profile]" >> ~/.aws/credentials
  echo "output = json" >> ~/.aws/credentials
  echo "region = us-east-1" >> ~/.aws/credentials
  echo "$new_credential" >> ~/.aws/credentials
  sleep $(( 60 * 45 ))
done
