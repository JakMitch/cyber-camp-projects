#!/bin/sh

grep '08:00:00 AM' 0315_Dealer_schedule | awk -F" " '{print $1, $2, $5, $6}'


#0315 8AM Dealer


