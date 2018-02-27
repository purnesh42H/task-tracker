#!/bin/bash

export PORT=5102

cd ~/www/tracker
./bin/tracker stop || true
./bin/tracker start

