#!/bin/bash

bundle check || bundle install --jobs 20 --retry 5

if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

bin/rails s -p $PORT -b 0.0.0.0
