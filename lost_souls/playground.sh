#!/bin/bash
output='"errors":[]'
noData='"data":[]'
errorsPresent='"errors":[]'
if [[ $output == *"$noData"* ]]
then
  echo "NO_DATA"
  echo "$output"
elif [[ $output == *"$errorsPresent"* ]]
then
  echo "SUCCESS"
  echo "$output"
else
  echo "ERRORS"
  echo "$output"
fi
