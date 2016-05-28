#!/bin/bash

set -e

main () {
  check_cmd_reqs docker-compose docker gzip
  check_file_reqs ./db.sql.gz ./drocker
  bootstrap
}

check_cmd_reqs () {
  for req in $@; do
    type "$req" &>/dev/null || bootstrap_error $req
  done;
}

check_file_reqs () {
  for req in $@; do
    if [[ ! -f $req ]]; then bootstrap_error $req; fi
  done;
}

bootstrap () {
  build && up && import_db
}

build () {
  docker-compose build
}

up () {
  # make sure any old instances are cleaned up
  docker-compose down 2>/dev/null || true
  docker-compose up -d
}

import_db () {
  printf "Waiting for MySQL to come up. Sleeping 1 minute...\n" >&2 && sleep 60
  gzip -dc ./db.sql.gz | ./drocker drush sqlc
}

bootstrap_error () {
  printf "Bootstrapping requires that you have %b available.\n" $1 >&2
  exit 1
}

main $@
