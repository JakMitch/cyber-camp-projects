#!/bin/bash
# Author: Jacob Mitchell

nameFind=$2

grep "$nameFind" $1_Dealer_schedule | awk -F" " '{print $1,$2,$5,$6}'


#Use argument 1 to specify date
#Use argument 2 to specify time
#surround time with "

