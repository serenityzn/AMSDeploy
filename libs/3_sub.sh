#! /bin/bash
function sub3 {
clear
3_menu

while true; do
 read n
 case $n in
	1)
		oemch
		3_menu
	 ;;
	2)
		pndch
		3_menu
	 ;;
	3)
		pbsch
		3_menu
	 ;;
	4)
		pentch
		3_menu
	 ;;
	5)
		prgch
		3_menu
	 ;;
	6)
		ppdch
		3_menu
	 ;;
	7)
		tpch
		3_menu
	 ;;
	8)
		avch
		3_menu
	 ;;
	9)
		agvch
		3_menu
	 ;;
	10)
		frvch
		3_menu
	 ;;
	11)
		generate_a1
		3_menu
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
