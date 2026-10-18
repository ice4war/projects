RED='\033[0;31m'
BOLD_RED='\033[1;31m'
NC='\033[0m'
if [ "$#" -lt 2 ]; then
echo -e "${BOLD_RED}-------------------------------------${NC}"
    echo -e "${RED}[+] Usage : $0 <OUTDIR> log dirs...$NC"
echo -e "${BOLD_RED}-------------------------------------${NC}"
    exit 1;
fi
TIME=$(date +"%Y%m%d_%H%M%S")
LOGFILE="logs_$TIME.tar.gz"
OUTDIR=$1
LOGDIRS=${@:2}
tar -czf "$OUTDIR/$LOGFILE" $LOGDIRS
