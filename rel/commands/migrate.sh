#!/bin/sh

release_ctl eval --mfa "Akedia.ReleaseTasks.migrate/1" --argv -- "$@"
