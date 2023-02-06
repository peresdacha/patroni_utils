#!/bin/bash 

INPUT_ARR_HOSTS=($1) #example ./check_patroni_master "localhost;localhost;localhost"

ARR_HOSTS=($(echo $INPUT_ARR_HOSTS | tr ";" "\n"))

function check_exist { 
    res=$(curl -s "http://${1}:8008/cluster" | jq -r '.members[] | select(.role=="leader") | .name') 

    if [ -z "$res" ]
    then
        continue
    else 
        echo ${res}
        exit 0
    fi
} 

for ix in ${!ARR_HOSTS[*]}
do
   check_exist ${ARR_HOSTS[$ix]} 
done

if [ -z "$res" ] 
then 
    echo "WARNING: master not found!" 
    exit 1
fi 
