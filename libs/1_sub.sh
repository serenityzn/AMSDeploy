#! /bin/bash
function sub1 {
clear
1_menu

while true; do
 read n
 case $n in
	1)
		sub3
	 ;;
	2)
		sub4
	 ;;
	3)
		sub2
	 ;;
	0)
		exit
	 ;;
	*)
		echo ${message[0]}
	 ;;
 esac   
done
}
