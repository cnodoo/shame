#!/bin/sh

# uuencode (provided by sharutils)


# data:[<MIME-type>][;charset=<encoding>][;base64],<data>


data_charset=`file -b --mime-encoding $file`
data_mimetype=`file -b --mime-type $file` # file -b -i $file | cut -d ';' -f1
data_base64=`uuencode -m $file`
data_uri="data:${data_mimetype};base64,${data_base64}"

