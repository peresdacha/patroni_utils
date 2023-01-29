#!/bin/bash

readonly hosts=( your_array_with_hosts )

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