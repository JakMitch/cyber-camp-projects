#!/bin/sh

grep '05:00:00 AM' 0312_Dealer_schedule | awk -F" " '{print $1, $2, $5, $6}'



#0312 5AM Dealer



