gawk -F, '$1 ~ /^[[:digit:]]+$/'  #first collum is digit
gawk -F, '$1 !~ /^[[:digit:]]+$/' #fist column is not digit
