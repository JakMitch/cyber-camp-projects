#!/bin/sh

grep '08:00:00 PM' 0310_Dealer_schedule | awk -F" " '{print $1, $2, $5, $6}'



#0310 8PM Dealer
