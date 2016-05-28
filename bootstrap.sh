#!/bin/bash

set -e

main () {
  check_reqs docker-compose docker gzip ./db.sql.gz ./drocker
  bootstrap
}

check_reqs () {
  for req in $@; do
    type "$req" &>/dev/null || bootstrap_error $req
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
  ./drocker drush sql-import <(gzip -dc ./db.sql.gz)
}

bootstrap_error () {
  printf "Bootstrapping requires that you have %b available.\n" $1
  exit 1
}

main $@
