echo "[random_rw]
rw=randrw
size=1024M
numjobs=32
directory=/data/disktest" > stress.fio
mkdir -p /data/disktest

while true
do
        killall -0 fio || /usr/local/bin/fio stress.fio > null &
        killall -0 mbw || /usr/local/bin/mbw 4096 > null & 
        killall -0 sysbench || sysbench --test=cpu --cpu-max-prime=5000000 --max-requests=10000000 --num-threads=32 run > null &
        echo burnning in.......; sleep 1
done