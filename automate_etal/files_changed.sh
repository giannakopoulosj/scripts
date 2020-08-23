find / -type f -print0 | xargs -0 stat --format '%Z :%z %n' | sort -nr > /root/all_files.txt
