#!/bin/sh

grep '11:00:00 PM' 0310_Dealer_schedule | awk -F" " '{print $1, $2, $5, $6}'



#0310 11PM Dealer

