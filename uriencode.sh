#!/bin/sh


if [ $# -gt 0 ]
then
  echo "$*" | xxd -plain | tr -d '\n' | sed -e 's/\(..\)/%\1/g' -e 's/\%0a$//g'
  # echo "$*" | perl -MURI::Escape -lne 'print uri_escape($_)'
else
  cat -- | xxd -plain | tr -d '\n' | sed -e 's/\(..\)/%\1/g' -e 's/\%0a$//g'
  # cat -- |perl -MURI::Escape -lne 'print uri_escape($_)'
fi
