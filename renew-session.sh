#!/usr/local/bin/bash
profile=$1
account=$2
role=$3
#new_credential=$(aws --profile saml-hcs-sandbox-Admin sts assume-role --role-arn arn:aws:iam::630527842429:role/Admin --role-session-name terraform-tiger --query "Credentials.{aws_access_key_id:AccessKeyId,aws_secret_access_key:SecretAccessKey,aws_session_token:SessionToken}" --output json | grep aws_ |sed 's/^ *"//; s/": "/ = /; s/",*$//')
while true
do
	new_credential=$(aws --profile $profile sts assume-role --role-arn arn:aws:iam::$account:role/$role --role-session-name renewed-$(date "+%Y-%m-%dT%H.%M.%S") --query "Credentials.{aws_access_key_id:AccessKeyId,aws_secret_access_key:SecretAccessKey,aws_session_token:SessionToken}" --output json | grep aws_ |sed 's/^ *"//; s/": "/ = /; s/",*$//')
  sed -i.bak '/\[saml-hcs-sandbox-Admin\]/,+5d'  ~/.aws/credentials
  echo '[saml-hcs-sandbox-Admin]' >> ~/.aws/credentials
  echo 'output = json' >> ~/.aws/credentials
  echo 'region = us-east-1' >> ~/.aws/credentials
  echo "$new_credential" >> ~/.aws/credentials
  sleep $(( 60 * 45 ))
done
