#!/bin/bash
echo “Running pre-commit hook”
swiftlint
if [ $? -ne 0 ]; then
 echo “Tests must pass before commit!”
 exit 1
fi
