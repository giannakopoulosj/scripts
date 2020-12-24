import sys
import os
from subprocess import call

comp_file = sys.argv[1]
comp_file_ext = comp_file.split('.');
error_msg = "Can't Handle the extension"
path_msg = "Can't Handle the extraction Path"

try:
    extract_path = sys.argv[2]
except IndexError:
    if "tar" and "gz" in comp_file_ext:
        call(["tar", "-zxvf", comp_file])
    elif "tar" and "bz2" in comp_file_ext:
        call(["tar", "-xjvf", comp_file])
    elif comp_file_ext[-1] == "tar":
        call(["tar", "-xvf", comp_file])
    else:
        print error_msg
else:
    if os.path.exists(sys.argv[2]):        
        if "tar" and "gz" in comp_file_ext:
            call(["tar", "-zxvf", comp_file, extract_path])
        elif "tar" and "bz2" in comp_file_ext:
            call(["tar", "-xjvf", comp_file, extract_path])
        elif comp_file_ext[-1] == "tar":
            call(["tar", "-xvf", comp_file, extract_path])
        else:
            print error_msg
    else:
        print path_msg
