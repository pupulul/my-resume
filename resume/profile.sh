#!/bin/bash
# 程序运行顺序如下：
# 1.杀死旧进程。输出提示语句。加入延时。
# 2.通过pm2启动bin/www。加入延时。
# 3.开始无限循环。
# 4.设置阀值，通过ps aux查找进程中项目PID（2列）和CPU（3列），通过pm2 show查看项目状态，输出提示语句。
# 5.判断是否存在项目pid，如果不存在则中断循环并重新启动项目，输出提示语句。并通过项目状态判断项目是否被人为关闭，如果人为关闭，则不重启。
# 6.通过expr命令来比较两个小数，如果结果是1，则真，其他则假。
# 7.通过expr命令的结果来判断条件是否符合，如果符合，则重启项目，如不符合，则输出提示语句。

pm2 kill;
echo "关闭旧进程。";
sleep 2;

pm2 start bin/www;
sleep 2;

while true
do

        key=0.5
        pid=$(ps aux|grep www|grep -v 'grep'|grep 'bin'|awk '{print $2}');
        cpu=$(ps aux|grep www|grep -v 'grep'|grep 'bin'|awk '{print $3}');
        status=$(pm2 show www|grep 'status'|awk '{print $4}');
        echo "项目PID是： $pid "
        echo "目前CPU占用率是： $cpu"
        echo "目前程序状态是： $status"

        if [ ! $pid ]
                then
                        if [ $status == "stopped" ] 
                                then 
                                        echo "项目已被主动关闭。"
                                        break;
                                        
                                else
                                        echo "没有项目PID，重新启动项目。" ;
                                        pm2 start bin/www;
                                        continue;
                                        sleep 2;
                        fi
        fi

        val=$(expr $cpu \> $key);

        if [ $val -eq 1 ]
        	then
                        echo "系统过载，2秒后重新启动系统。"
                        sleep 2;
        		pm2 reload bin/www;
                        sleep 2;
        	else
        		echo "目前系统安全，10秒后重新检测。";
                        sleep 10;
        fi		
done;

