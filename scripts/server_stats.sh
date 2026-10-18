COUNT=$1
GREEN=$'\033[1;32m'
NC=$'\033[0m'

# CPU Usage in percent
echo -e "$GREEN-----------[CPU Usage]-----------$NC"
top -bn1 | grep "Cpu"|cut -d ',' -f 4|awk '{print "Cpu Usage: " 100-$1"%" }'
echo ""

# Memory stats
# Total $2, used $3, free $4
echo "$GREEN-----------[Memory Usage]-----------$NC"
free |grep "Mem:" -w |awk '{printf "Total\t: %.1fGi\nUsed\t: %.1fGi (%.1f%%)\nFree\t: %.1fGi (%.1f%%)\n",$2/1024^2,$3/1024^2,$3/$2*100,$4/1024^2,$4/$2*100}'
echo ""

# Disk stats
echo "$GREEN-----------[Disk Usage]-----------$NC"
df -h|grep "/" -w|awk '{printf "Total\t: %s\nUsed\t: %s (%.1f%%)\nAvail\t: %s (%.1f%%)\n",$3+$4,$3,$3/($4+$3)*100,$4,$4/($3+$4)*100}'
echo ""

# Top Programs using CPU
echo "$GREEN-----------[Programs using CPU]-----------$NC"
ps aux --sort=-%cpu|head -n $COUNT| awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'
echo ""

# Top Programs using Memory
echo "$GREEN-----------[Programs using Memory]-----------$NC"
ps aux --sort=-%mem|head -n $COUNT|awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'
echo ""
