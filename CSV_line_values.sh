INPUT=data.cvs
OLDIFS=$IFS
IFS=,

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read F1 F2 F3 F4 F5
do
  echo "First_VAR : $F1"
  echo "Second_VAR : $F2"
  echo "Third_VAR : $F3"
  echo "Fourth_VAR : $F4"
  echo "Fifth_VAR : $F5"
done < $INPUT
IFS=$OLDIFS
