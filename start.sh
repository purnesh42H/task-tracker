#!/bin/bash

export PORT=5101

cd ~/www/tracker
./bin/tracker stop || true
./bin/tracker start

