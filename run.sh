#!/bin/bash
cd ./NFV-VMS/ 
node . &
cd ../NFV-MON/Server/ 
node . &
cd ../../NFV-BMS/ 
node . &
