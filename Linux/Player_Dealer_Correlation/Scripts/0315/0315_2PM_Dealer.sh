#!/bin/sh


grep '02:00:00 PM' 0315_Dealer_schedule | awk -F" " '{print $1, $2, $5, $6}'


#0315 2PM Dealer
