+#!/bin/bash
+
+set -x
+PORT=$(docker port functional_test 80 | cut -d ':' -f 2)
+OUTPUT=$(curl "http://localhost:${PORT}/")
+[[ "${OUTPUT}" == "Hello, World!" ]]