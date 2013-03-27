#!/bin/sh

TABLE=mangle

remove_chain()
{
	echo "removing chain..."
	{
		sudo /sbin/iptables -d www.renren.com -t ${TABLE} -D PREROUTING -j NF_QUEUE_CHAIN
		sudo /sbin/iptables -d www.renren.com -t ${TABLE} -D OUTPUT -j NF_QUEUE_CHAIN
		sudo /sbin/iptables -t ${TABLE} -F NF_QUEUE_CHAIN
		sudo /sbin/iptables -t ${TABLE} -X NF_QUEUE_CHAIN
	}
	echo "done"
}

create_chain()
{
	echo  "adding chain..."
	{
		sudo /sbin/iptables -t ${TABLE} -N NF_QUEUE_CHAIN
		sudo /sbin/iptables -d www.renren.com -t ${TABLE} -A NF_QUEUE_CHAIN -m mark --mark 0 -j NFQUEUE --queue-num 0
		sudo /sbin/iptables -d www.renren.com -t ${TABLE} -A NF_QUEUE_CHAIN -j MARK --set-mark 0
		sudo /sbin/iptables -d www.renren.com -t ${TABLE} -I OUTPUT -j NF_QUEUE_CHAIN
		sudo /sbin/iptables -d www.renren.com -t ${TABLE} -I PREROUTING -j NF_QUEUE_CHAIN
	}
	echo "done"
}

on_iqh(){
    remove_chain
    exit 1
}

trap on_iqh INT QUIT HUP
remove_chain
create_chain
sudo ./nf_queue_test
remove_chain
