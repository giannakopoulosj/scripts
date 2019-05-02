awk -F, '   BEGIN{OFS=FS}   NR==FNR {a[$1]; next}   $4 in a {$7 = "24:00:00"}   1 ' input_list.txt modify.csv
