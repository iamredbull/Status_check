# /bin/bash
while true;
do
sleep 5
cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, \([0-9,\.]*\)%* id.*/\1/" | awk '{print 100 - $1}'|sed 's/,.*$//') #for transformation from float to int join -> |sed 's/,.*$//'
cpu_temp=$(sensors | grep 'Core 0'|awk '{print $3}'|sed 's/^+//'|sed 's/..°C$//')
ram_total=$(free -m | awk '{print $2}'| awk '(NR == 2)'| sed 's/[[:alpha:]]//g')
ram_used=$(free -m | awk '{print $3}'| awk '(NR == 2)'| sed 's/[[:alpha:]]//g')
who_user=$(who |grep tty |cut -d ' ' -f1) 
smartcheck=$(smartctl -H /dev/sda |grep 'SMART overall-health self-assessment test result:'| sed 's/^SMART overall-health self-assessment test result: //')
disk_type=$(smartctl -a /dev/sda | grep 'Rotation Rate:'| sed 's/^Rotation Rate:    //')
ipadd=$(ip a s | grep eth0 | awk '(NR==2){print $2}'| sed 's/...$//')
iptun=$(ip a s | grep tun0 | awk '(NR==2){print $2}'| sed 's/...$//')
ipzaya=$(ip a s | grep zaya | awk '(NR==2){print $2}'| sed 's/...$//')
snnettop=$(dmidecode -t system | grep Serial | cut -d ' ' -f3)
json=\{\"cpu_load\":\"$cpu_load\",\"cpu_temperature\":\"$cpu_temp\",\"ram_total\":\"$ram_total\",\"ram_used\":\"$ram_used\",\"user\":\"$who_user\",\"smartcheck\":\"$smartcheck\",\"disk_type\":\"$disk_type\",\"ip_address\":\"$ipadd\",\"ip_tun\":\"$iptun\",\"ip_zaya\":\"$ipzaya\",\"sn_nettop\":\"$snnettop\"\}
curl --header "Content-Type: application/json" \
  --request POST \
  --data "$json" \
  http://IP_ADRESS &>/dev/null

done
