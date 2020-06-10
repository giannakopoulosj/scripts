$ips = GC C:\Users\myname\Desktop\dns\ip_list.txt

Foreach ($ip in $ips)        {
$name = nslookup -l 1.5.1.2 $ip 2> $null | select-string -pattern "Name:"
                if ( ! $name ) { $name = "" }
                $name = $name.ToString()
                if ($name.StartsWith("Name:")) {
                $name = (($name -Split ":")[1]).Trim()
                }
                else {
                $name = "NOT FOUND"
                }
Echo "$ip `t $name" >> C:\Users\myname\Desktop\dns\ip_output.txt
}

$ips = GC C:\Users\myname\Desktop\dns\adress_list.txt
Foreach ($ip in $ips)        {
$name = nslookup -l 1.5.1.2 $ip 2> $null | select-string -pattern "Address:"
                if ( ! $name ) { $name = "" }
                $name = $name.ToString()
                if ($name.StartsWith("Address:")) {
                $name = (($name -Split ":")[1]).Trim()
                }
                else {
                $name = "NOT FOUND"
                }
Echo "$ip `t $name" >> C:\Users\myname\Desktop\dns\adress_output.txt
}
