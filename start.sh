#!/bin/bash

<<<<<<< HEAD
export PORT=5102
=======
export PORT=5101
>>>>>>> 576c873e772e22e2410f23051b9f1d4ae5a5e291

cd ~/www/tracker
./bin/tracker stop || true
./bin/tracker start

