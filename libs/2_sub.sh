#! /bin/bash
function sub2 {
clear
2_menu

while true; do
 read n
 case $n in
	1)
		oemch
		2_menu
	 ;;
	2)
		pndch
		2_menu
	 ;;
	3)
		pbsch
		2_menu
	 ;;
	4)
		pentch
		2_menu
	 ;;
	5)
		prgch
		2_menu
	 ;;
	6)
		ppdch
		2_menu
	 ;;
	7)
		tpch
		2_menu
	 ;;
	8)
		avch
		2_menu
	 ;;
	9)
		agvch
		2_menu
	 ;;
	10)
		frvch
		2_menu
	 ;;
	11)
		generate
		2_menu
	 ;;
	0)
		1_menu
		break
	 ;;
	*)
		echo ${message[0]}
	 ;;
 esac   
done
}
