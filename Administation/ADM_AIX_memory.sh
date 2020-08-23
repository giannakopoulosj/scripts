#more info: https://www.ibm.com/support/knowledgecenter/en/ssw_aix_72/performance/mem_use_processes.html
svmon -Pt15 | perl -e 'while(<>){print if($.==2||$&&&!$s++);$.=0 if(/^-+$/)}'
