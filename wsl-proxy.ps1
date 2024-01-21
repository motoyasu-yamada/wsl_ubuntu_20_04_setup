# Usage: .\wsl-proxy.ps1 80 3000 3001 9200 5601
# Description: Forward ports from WSL2 to Windows
if (-not $args) {
  $ports = @(22 80, 3000, 3001, 3306, 9200, 5601) # SSH, Nginx, Rails, NextJs, MySQL, ElasticSearch, Kibana
} else {
  $ports = $args
}

$wsl2Ipv4 = bash -c "ip route | grep 'eth0 proto' | cut -d ' ' -f9"

foreach ($port in $ports) {
  $hostIpv4 = "0.0.0.0"
  netsh interface portproxy delete v4tov4 listenaddress=$hostIpv4 listenport=$port
  netsh interface portproxy add v4tov4 listenaddress=$hostIpv4 listenport=$port connectaddress=$wsl2Ipv4 connectport=$port
  netsh interface portproxy show v4tov4
}
