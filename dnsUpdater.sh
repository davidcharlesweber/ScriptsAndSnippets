#!/bin/bash
myip="$(curl ipv4.icanhazip.com)"
dnsip="$(dig @8.8.8.8 +short $1)"
echo Current IP: $myip
echo DNS IP: $dnsip

if [ "$myip" == "$dnsip" ]
then
    echo "IPs match, nothing to do"
else
    echo IPs differ, need to update DNS

    aws route53 change-resource-record-sets --hosted-zone-id=Z2JYZ59QGNWVEF --change-batch='{
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "cloud.weberprep.com",
                    "Type": "A",
                    "TTL": 300,
                    "ResourceRecords": [
                        {
                        "Value": "'"$myip"'"
                        }
                    ]
                }
            }
        ]
    }'
fi
