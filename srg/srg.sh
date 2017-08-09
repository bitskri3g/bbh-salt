#!/bin/bash

checklist=OS_SRG_TEMPLATE.ckl

while read line; do
  echo $line >> working
done

export hostname=$(grep "host:" -A 1 working | tail -n 1)
export ip_address=$(grep "ipv4:" -A 2 working | tail -n 1 | awk '{ print $2 }')
export mac_address=$(grep "hwaddr_interfaces:" -A 3 working | tail -n 1)
export fqdn=$(grep "id:" -A 1 working | tail -n 1)
rm working

cp $checklist $checklist.$fqdn.ckl
checklist+=.$fqdn.ckl

perl -i -0pe 's/(?<=ASSET)(.*?)<HOST_NAME><\/HOST_NAME>/$1<HOST_NAME>$ENV{hostname}<\/HOST_NAME>/s' $checklist
perl -i -0pe 's/(?<=ASSET)(.*?)<HOST_IP><\/HOST_IP>/$1<HOST_IP>$ENV{ip_address}<\/HOST_IP>/s' $checklist
perl -i -0pe 's/(?<=ASSET)(.*?)<HOST_MAC><\/HOST_MAC>/$1<HOST_MAC>$ENV{mac_address}<\/HOST_MAC>/s' $checklist
perl -i -0pe 's/(?<=ASSET)(.*?)<HOST_FQDN><\/HOST_FQDN>/$1<HOST_FQDN>$ENV{fqdn}<\/HOST_FQDN>/s' $checklist

grep '<VULN>' -A 3 $checklist |                             \
grep 'V-' |                                                 \
grep -oP '(?<=<ATTRIBUTE_DATA>).+?(?=</ATTRIBUTE_DATA>)' |  \
while read vuln
do

### The next line is the important part.  Whatever command you run should take $vuln as input and perform
### different checks based on its value.  In our case, we have a special srg folder with state files named
### $vuln.sls that will be executed.  We are currently building these state files.  The echo is just
### a proof-of-concept placeholder.  stdout is written to comments, stderr is written to details.

  salt $fqdn state.apply srg/os/$vuln 2> stderr 1> stdout
  export vuln
  export comments=$(cat stdout)
  export details=$(cat stderr)
  perl -i -0pe 's/(?<=$ENV{vuln})(.*?)<COMMENTS><\/COMMENTS>/$1<COMMENTS>$ENV{comments}<\/COMMENTS>/s' $checklist
  perl -i -0pe 's/(?<=$ENV{vuln})(.*?)<FINDING_DETAILS><\/FINDING_DETAILS>/$1<FINDING_DETAILS>$ENV{details}<\/FINDING_DETAILS>/s' $checklist
  if [ ! -z "$details" ]; then
    perl -i -0pe 's/(?<=$ENV{vuln})(.*?)<STATUS>Not_Reviewed<\/STATUS>/$1<STATUS>Open<\/STATUS>/s' $checklist
  else
    perl -i -0pe 's/(?<=$ENV{vuln})(.*?)<STATUS>Not_Reviewed<\/STATUS>/$1<STATUS>NotAFinding<\/STATUS>/s' $checklist
  fi
done
