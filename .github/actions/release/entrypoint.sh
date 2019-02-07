#!/bin/sh

set -eux

cat $GITHUB_EVENT_PATH | jq .
