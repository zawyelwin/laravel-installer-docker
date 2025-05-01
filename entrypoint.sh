#!/bin/sh

# If no arguments are passed, use "laravel new"
if [ "$#" -eq 0 ]; then
  exec laravel new
else
  exec "$@"
fi
