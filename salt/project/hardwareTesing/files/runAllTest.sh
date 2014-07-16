#!/bin/bash

resultDir="result/`date "+%Y-%m-%d_%H:%m:%S"`"
mkdir -p $resultDir

./fio.sh > $resultDir/fio.log 2>&1
./iperf.sh > $resultDir/iperf.log 2>&1
./mbw.sh > $resultDir/mbw.log 2>&1
./sysbench.sh > $resultDir/sysbench.log 2>&1