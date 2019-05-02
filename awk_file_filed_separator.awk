awk 'BEGIN{print "Header"; FIELDWIDTHS ="3 4 3"}{print $1"|"$2"|"$3"|"};END{print "Footer"}'
