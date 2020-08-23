#!/bin/bash

export MAILTO="xxxxx"
export msg_from='xxxxxx';
export SUBJECT="xxxxxxx"
export BODY="/xxx.html"
export ATTACH="xxx.tar.gz"
(
echo "From: $msg_from"
echo "To: $MAILTO"
echo "Subject: $SUBJECT"
echo "MIME-Version: 1.0"
echo 'Content-Type: multipart/mixed; boundary="-q1w2e3r4t5"'
echo
echo '---q1w2e3r4t5'
echo "Content-Type: text/html"
echo "Content-Disposition: inline"
cat $BODY
echo '---q1w2e3r4t5'
echo 'Content-Type: application; name="'$(basename $ATTACH)'"'
echo "Content-Transfer-Encoding: base64"
echo 'Content-Disposition: attachment; filename="'$(basename $ATTACH)'"'
uuencode -m $ATTACH $(basename $ATTACH)
echo '---q1w2e3r4t5--'
) | /usr/sbin/sendmail $MAILTO
