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
  docker-compose up -d
}

import_db () {
  gzip -dc ./db.sql.gz | ./drocker drush sqlc
}

bootstrap_error () {
  printf "Bootstrapping requires that you have %b available.\n" $1
  exit 1
}

main $@
