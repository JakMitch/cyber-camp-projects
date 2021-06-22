#!/bin/bash
# Author: Jacob Mitchell

nameFind=$2

head -1 $1_Dealer_schedule

grep "$nameFind" $1_Dealer_schedule | awk -F" " '{print $1, $2, $3, $4, $5, $6, $7, $8}'



#Use argument 1 to specify date
#Use argument 2 to specify time 
#Surround time with "
