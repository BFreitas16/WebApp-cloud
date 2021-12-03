#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# get the DB files
sudo wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1PaXFNGemi21eLQFq8HhgFKDZ2fe2KAR1' -O /data/db-data.zip 
sudo unzip /data/db-data.zip -d /data/db/
