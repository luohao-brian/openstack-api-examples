#! /bin/bash

source configs.cfg

echo "loading auth info..."
sh get_token.sh

source configs.cfg

echo "create a volume start..."

sh 
