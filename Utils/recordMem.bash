while true; do
ps -C <ProgramName> -o pid=,%mem=,vsz= >> /tmp/mem.log
gnuplot generateMemPlot.plt
sleep 1
done &