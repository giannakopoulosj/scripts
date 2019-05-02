awk 'BEGIN{print "Header"; FIELDWIDTHS ="3 4 3"}{print $1"|"$2"|"$3"|"};END{print "Footer"}'



#cat file8
#1234567890
#2345678901
#3456789012
#987654321


#awk 'BEGIN{print "Header"; FIELDWIDTHS ="3 4 3"}{print $1"|"$2"|"$3"|"};END{print "Footer"}' file8
#Header
#123|4567|890|
#234|5678|901|
#345|6789|012|
#098|7654|321|
#Footer
