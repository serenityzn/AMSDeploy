oemname='vw'
djusrpass=`pwgen 16 -1`
entpass=`pwgen 16 -1`
entkey=`pwgen 32 -1`
entepass=`java -jar passtool.jar --encrypt $entpass --secret $entkey`
pspass=`pwgen 16 -1`
pskey=`pwgen 32 -1`
psepass=`java -jar passtool.jar --encrypt $entpass --secret $entkey`
djdmpass=`pwgen 16 -1`
djampass=`pwgen 16 -1`
djiwhpass=`pwgen 16 -1`
djrplpass=`pwgen 16 -1`
certspass=`pwgen 16 -1`
amadmpass=`pwgen 16 -1`
amagentpass=`pwgen 16 -1`
amkey=`pwgen 32 -1`
prospectnodeurl='https://example.com:8443'
prospectbaseurl='https://example.com'
perseusent='TT.TEC:Europe'
perseusregion="Europe: 'AD,AT,BE,CH,CZ,DE,DK,ES,FI,FR,GB,GI,GR,HU,IE,IT,LI,LU,MC,MT,NL,NO,PL,PT,RU,SE,SK,SM,TR,VA,US,CA,MX,BR'"
persprod='VW_EU'
trustpass='password'
amsver='1.36.0-1'
agentver='3.5.0-2'
frockver='11.0.3-1'
