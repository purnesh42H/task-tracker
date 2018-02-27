#!/bin/bash

<<<<<<< HEAD
export PORT=5102
=======
export PORT=5101
>>>>>>> 576c873e772e22e2410f23051b9f1d4ae5a5e291
export MIX_ENV=prod
export GIT_PATH=/home/tracker/src/tracker

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/tracker ]; then
        echo mv ~/www/tracker ~/old/$NOW
        mv ~/www/tracker ~/old/$NOW
fi

mkdir -p ~/www/tracker
REL_TAR=~/src/tracker/_build/prod/rel/tracker/releases/0.0.1/tracker.tar.gz
(cd ~/www/tracker && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/tracker/src/tracker/start.sh
CRONTAB

#. start.sh

