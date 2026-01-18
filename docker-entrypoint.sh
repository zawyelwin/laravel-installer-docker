#!/bin/bash

# Main logic - using exec to properly pass through TTY for interactive prompts
case "$1" in
    "composer")
        shift
        if [ "$1" = "run" ] && [ "$2" = "dev" ]; then
            exec composer run-script dev
        else
            exec composer "$@"
        fi
        ;;
    "npm")
        shift
        exec npm "$@"
        ;;
    "artisan")
        shift
        exec php artisan "$@"
        ;;
    "laravel")
        shift
        exec laravel "$@"
        ;;
    "bash"|"sh")
        exec "$@"
        ;;
    *)
        # Default to laravel command if no specific command is given
        exec laravel "$@"
        ;;
esac