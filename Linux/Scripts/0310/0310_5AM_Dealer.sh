#!/bin/sh

grep '05:00:00 AM' 0310_Dealer_schedule | awk -F" " '{print $1, $2, $5, $6}'

#0310 5AM 

