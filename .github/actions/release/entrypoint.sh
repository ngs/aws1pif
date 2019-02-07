#!/bin/sh

set -eux

UPLOAD_URL=$(cat $GITHUB_EVENT_PATH | jq -r .upload_url)
UPLOAD_URL=${UPLOAD_URL/{?name,label}/}
RELEASE_NAME=$(cat $GITHUB_EVENT_PATH | jq -r .name)
PROJECT_NAME=$(basename $GITHUB_REPOSITORY)
NAME="${PROJECT_NAME}_${RELEASE_NAME}_${GOOS}_${GOARCH}"

tar cvfz tmp.tgz $PROJECT_NAME
CKECKSUM=$(md5sum tmp.tgz | cut -d ' ' -f 1)

curl \
  -X POST \
  --data-binary @tmp.tgz \
  -H 'Content-Type: application/gzip' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=${$NAME}.tar.gz"

curl \
  -X POST \
  --data $CHECKSUM \
  -H 'Content-Type: text/plain' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=${$NAME}_checksum.txt"
