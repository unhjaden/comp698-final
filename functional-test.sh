#!/bin/bash

PORT=$(docker port functional_test 80 | cut -d ':' -f 2)
OUTPUT=$(curl "http://localhost:${PORT}/home")
[[ "${OUTPUT}" == "Hello, World!" ]]

if [[ $OUTPUT = *"COMP698 Final Project with Bootstrap"* ]]; then
  exit 0
fi

echo 'did not find expected text'
exit 1