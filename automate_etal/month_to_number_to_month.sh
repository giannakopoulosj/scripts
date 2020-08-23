number_to_month() {
local month_tmp=$1
  case "$month_tmp" in
    01|1) month_tmp="Jan" ;;
    01|1) month_tmp="Jan" ;;
    02|2) month_tmp="Feb" ;;
    03|3) month_tmp="Mar" ;;
    04|4) month_tmp="Apr" ;;
    05|5) month_tmp="May" ;; 
    06|6) month_tmp="Jun" ;;
    07|7) month_tmp="Jul" ;;
    08|8) month_tmp="Aug" ;;
    09|9) month_tmp="Sep" ;;
      10) month_tmp="Oct" ;;
      11) month_tmp="Nov" ;;
      12) month_tmp="Dec" ;;
  esac
echo $month_tmp
}

month_to_number() {
local month_tmp=$1
  case "$month_tmp" in
    "Jan") month_tmp="01" ;;
    "Feb") month_tmp="02" ;;
    "Mar") month_tmp="03" ;;
    "Apr") month_tmp="04" ;;
    "May") month_tmp="05" ;;
    "Jun") month_tmp="06" ;;
    "Jul") month_tmp="07" ;;
    "Aug") month_tmp="08" ;;
    "Sep") month_tmp="09" ;;
    "Oct") month_tmp="10" ;;
    "Nov") month_tmp="11" ;;
    "Dec") month_tmp="12" ;;
  esac
echo $month_tmp
}


monthnumber() {
    month=$1
    months="JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
    tmp=${months%%$month*}
    month=${#tmp}
    monthnumber=$((month/3+1))
    printf "%02d\n" $monthnumber
}
