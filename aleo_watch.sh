#!/bin/bash
aleo_dbc_path="/home/test/aleo/"
host_name=`hostname`
#cpu型号7302|7542|3960X
model="7302 7542 3960X"
cputxt=`lscpu|grep "Model name"`
for i in $model
do
        if [ `echo $cputxt |grep $i |wc -l` -eq  1 ];then cpu_model=$i;fi
done

pool=$(ps -elf|grep vip|grep -v grep|xargs -d ' ' -L 1|grep 4040)
process=$(ps -elf|grep vip|grep -v grep|wc -l)



#判断是否为pool的主机名，pool没有pps，只检测process存在。
if [ "$host_name" == "Dong-amd1-10"  ]
then
        curl -s -i XPOST '61.83.29.162:8086/write?db=telegraf' --data-binary 'aleo_Dong,hostname='$host_name',cpu_model='$cpu_model' process='$process''
else
        solution=$(grep  Found "${aleo_dbc_path}/worker.log" |wc -l)
        pps=`tail -n5 $aleo_dbc_path/worker.log |grep "P/s"`
        pps_1m=$(echo $pps |cut -d " " -f 10 |sort |tail -n1)
        pps_5m=$(echo $pps |cut -d " " -f 13 |sort |tail -n1)
        pps_30m=$(echo $pps |cut -d " " -f 16 |sort |tail -n1)
        echo "aleo_Dong,hostname='$host_name',cpu_model='$cpu_model' solution='$solution',process='$process',pps_1m='$pps_1m',pps_5m='$pps_5m',pps_30m='$pps_30m'"

        curl -s -i XPOST '61.83.29.162:8086/write?db=telegraf' --data-binary 'aleo_Dong,hostname='$host_name',cpu_model='$cpu_model' solution='$solution',process='$process',pps_1m='$pps_1m',pps_5m='$pps_5m',pps_30m='$pps_30m''
fi
