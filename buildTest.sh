#!/bin/bash

docker build -f Dockerfile.dev -t test --build-arg PHP_MAJOR=$1 --build-arg PHP_MINOR=$2 --build-arg RUNMODE=$3 .
