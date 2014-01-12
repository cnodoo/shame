#!/bin/sh

if [ $# -gt 0 ]
then
  echo "$*" | perl -MURI::Escape -lne 'print uri_unescape($_)'
else
  cat -- | perl -MURI::Escape -lne 'print uri_unescape($_)'
fi

