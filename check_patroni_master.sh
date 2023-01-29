#!/bin/bash

readonly hosts=( your_array_with_hosts )
#hosts should be of the following types - http://localhost:8008/cluster
#for more information read the official Patroni API documentation - https://patroni.readthedocs.io/en/latest/rest_api.html

qty=0
master=( )

for ix in ${!hosts[*]}
do
    res=$(curl -s "${hosts[$ix]}" | jq '.members.role')
    if [[ "$res" == "leader" ]]
    then
        qty=$(( "$qty" + 1 ))
        master[$ix]+="${hosts[$ix]}"
    fi
done

if [[ "$qty" -gt 1 ]]
then 
    echo "WARNING: more than one master! Actual master quantity - $qty"
elif [[ "$qty" == 0 ]]
then
    echo "WARNING: master not found!"
fi

for ix in ${!master[*]}
do 
    echo "${master[$ix]}"
done
