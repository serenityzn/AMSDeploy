function kstore_create {
echo -e ${message[13]}
echo -e ${message[11]}
keytool -genkeypair -alias ams -keyalg rsa -keysize 2048 -validity 3650 -keystore ./templates/keystore/'acceptance_'$oemname'_keystore.jks' -storepass $certspass -keypass $certspass
echo -e ${message[14]}
keytool -genkeypair -alias ams_sp -keyalg rsa -keysize 2048 -validity 3650 -keystore ./templates/keystore/'acceptance_'$oemname'_keystore.jks' -storepass $certspass -keypass $certspass
sp_conf
sp_ext
echo -e ${message[12]}
read some
}

function export {
keytool -export -keystore ./templates/keystore/acceptance_ferrari_keystore.jks -alias ams_sp -rfc -file ./templates/keystore/test.csr -storepass $certspass
tr -d $'\r' < ./templates/keystore/test.csr > ./templates/keystore/res.csr
sed '/-----BEGIN CERTIFICATE-----/d' ./templates/keystore/res.csr > ./templates/keystore/test.csr 
sed '/-----END CERTIFICATE-----/d' ./templates/keystore/test.csr > ./templates/keystore/res.csr 
sp_cert=`cat ./templates/keystore/res.csr`
rm ./templates/keystore/test.csr
rm ./templates/keystore/res.csr
}
