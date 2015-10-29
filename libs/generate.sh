#! /bin/bash

function resolve {
host=$(host $1|awk '{print $4}')
echo $host
}

#echo "PASS=$entpass KEY=$entkey EPASS=$entepass"
function generate {

cat >> ./$oemname'_parameters.map' << EOF
  preprod-$oemname-ams-proxy-*:
    application: ams
    role:
      - proxy
    sysctl_vm_overcommit_memory: 0
    sysctl_vm_swappiness: 0
    ldap_nss_base_group:
      - 'ou=SystemGroups,dc=flatns,dc=net'
      - 'ou=PosixGroups,ou=IAMAcceptance,ou=SecurityContexts,dc=flatns,dc=net'
    puppet_agent_cron_enabled: false
    ams_updates_repo:
      - 'os-2014-11-21'
      - 'updates-2014-11-21'
    ams_instance: '$oemname'
    ams_base_url: 'https://preprod-$oemname-ams.services.tomtom.com'
    ams_internal_cookie_domain: '.flatns.net'
    ams_external_cookie_domain: '.tomtom.com'
    ams_saml_enabled: true
    ams_openam:
      site:
        base_url: 'http://preprod-$oemname-ams-back-vip.flatns.net:80/openam'
    ams_entitlementservice:
      base_url: 'http://entitlementservice.preprod-$oemname-ams-back-vip.flatns.net:8080'
    ams_perseus:
      node_uri: 'perseusClusterA'
    ams_nodes:
      logonservice:
        logon001:
          host: preprod-$oemname-ams-front-001.flatns.net
	  ip: $(resolve preprod-$oemname-ams-front-001.flatns.net)
          port: 8080
        logon002:
          host: preprod-$oemname-ams-front-002.flatns.net
	  ip: $(resolve preprod-$oemname-ams-front-002.flatns.net)
          port: 8080
      entitlementservice:
        entitlementservice001:
          host: preprod-$oemname-ams-front-001.flatns.net
          port: 8180
        entitlementservice002:
          host: preprod-$oemname-ams-front-002.flatns.net
          port: 8180
      perseus:
        perseus001:
          host: preprod-$oemname-ams-front-001.flatns.net
          port: 8380
        perseus002:
          host: preprod-$oemname-ams-front-002.flatns.net
          port: 8380
    ams_external_tls_termination: true
    perseus_node_url: '$prospectnodeurl'

  preprod-$oemname-ams-front-*:
    application: ams
    role:
      - logonservice
      - entitlementservice
      - perseus
    sysctl_vm_overcommit_memory: 0
    sysctl_vm_swappiness: 0
    ldap_nss_base_group:
      - 'ou=SystemGroups,dc=flatns,dc=net'
      - 'ou=PosixGroups,ou=IAMAcceptance,ou=SecurityContexts,dc=flatns,dc=net'
    puppet_agent_cron_enabled: false
    ams_updates_repo:
      - 'os-2014-11-21'
      - 'updates-2014-11-21'
    ams_base_dn: 'dc=tomtom,dc=com'
    ams_instance: '$oemname'
    ams_base_url: 'https://preprod-$oemname-ams.services.tomtom.com'
    ams_internal_cookie_domain: '.flatns.net'
    ams_saml_enabled: true
    ams_log_access_mode: '0755'
    ams_log_retention: '30'
    ams_log_partition: '14G'
    ams_opendj:
      host: 'preprod-$oemname-ams-back-vip.flatns.net'
      ldap_port: 1389
      service_user: 'service'
      service_password: '$djusrpass'
    ams_openam:
      agent_version: '$agentver'
      site:
        base_url: 'http://preprod-$oemname-ams-back-vip.flatns.net:80/openam'
      tomtom:
        alias: tomtom.preprod-$oemname-ams-back-vip.flatns.net
      saml:
        sp_entity:
          - 'AMS_SP'
        idp_entity:
          - 'OEM_IDP'
          - 'MON_IDP'
        federation_b2: true
    ams_entitlements:
      perseus:
        default:
          - '$perseusent'
    ams_regions:
      $perseusregion
    ams_truststore_password: '$trustpass'
    ams_logonservice:
      version: '$amsver'
      tomcat:
        http_port: 8080
        shutdown_port: 8005
        jmx_port: 1090
        xms: '512m'
        xmx: '512m'
        permsize: '64m'
        maxpermsize: '64m'
        newratio: 1
        gc_log: true
        extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
    ams_entitlementservice:
      version: '$amsver'
      tomcat:
        http_port: 8180
        shutdown_port: 8105
        jmx_port: 1190
        xms: '768m'
        xmx: '768m'
        permsize: '64m'
        maxpermsize: '64m'
        newratio: 1
        gc_log: true
        extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
      base_url: 'http://entitlementservice.preprod-$oemname-ams-back-vip.flatns.net:8080'
      agent:
        password: '$entpass'
        key: '$entkey'
        epassword: '$entepass'
      ldap:
        idle_timeout: 3
        pool_min: 1
        pool_max: 60
    ams_perseus:
      version: '$amsver'
      tomcat:
        http_port: 8380
        shutdown_port: 8305
        jmx_port: 1390
        xms: '768m'
        xmx: '768m'
        permsize: '64m'
        maxpermsize: '64m'
        newratio: 1
        gc_log: true
        extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
      agent:
        password: '$pspass'
        key: '$pskey'
        epassword: '$psepass'
      product:
        default: '$persprod'
      keystore_password: '$trustpass'
    ams_proxy_nodes:
      - $(resolve preprod-$oemname-ams-proxy-001.flatns.net)
      - $(resolve preprod-$oemname-ams-proxy-002.flatns.net)
    ams_nodes:
      logonservice:
        logon001:
          host: preprod-$oemname-ams-front-001.flatns.net
          ip: $(resolve preprod-$oemname-ams-front-001.flatns.net)
          port: 8080
        logon002:
          host: preprod-$oemname-ams-front-002.flatns.net
          ip: $(resolve preprod-$oemname-ams-front-002.flatns.net)
          port: 8080
      entitlementservice:
        entitlementservice001:
          host: preprod-$oemname-ams-front-001.flatns.net
          port: 8180
        entitlementservice002:
          host: preprod-$oemname-ams-front-002.flatns.net
          port: 8180
      perseus:
        perseus001:
          host: preprod-$oemname-ams-front-001.flatns.net
          port: 8380
        perseus002:
          host: preprod-$oemname-ams-front-002.flatns.net
          port: 8380
    perseus_base_url: '$prospectbaseurl'
    perseus_node_url: '$prospectnodeurl'

  preprod-$oemname-ams-back-*:
    application: ams
    role:
      - opendj
      - openam
    sysctl_vm_overcommit_memory: 0
    sysctl_vm_swappiness: 0
    ldap_nss_base_group:
      - 'ou=SystemGroups,dc=flatns,dc=net'
      - 'ou=PosixGroups,ou=IAMAcceptance,ou=SecurityContexts,dc=flatns,dc=net'
    puppet_agent_cron_enabled: false
    ams_updates_repo:
      - 'os-2014-11-21'
      - 'updates-2014-11-21'
    ams_base_dn: 'dc=tomtom,dc=com'
    ams_instance: '$oemname'
    ams_base_url: 'https://preprod-$oemname-ams.services.tomtom.com'
    ams_internal_cookie_domain: '.flatns.net'
    ams_saml_enabled: true
    ams_log_access_mode: '0755'
    ams_log_retention: '30'
    ams_opendj_partition: '7G'
    ams_opendj:
      version: '$amsver'
      host: 'preprod-$oemname-ams-back-vip.flatns.net'
      ldap_port: 1389
      jmx_port: 1689
      admin_port: 4444
      replication_port: 8989
      xms: '2048m'
      xmx: '2048m'
      permsize: '64m'
      maxpermsize: '64m'
      newratio: 3
      gc_log: true
      extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
      root_user: 'cn=Directory Manager'
      root_password: '$djdmpass'
      openam_user: 'openam'
      openam_password: '$djampass'
      service_user: 'service'
      service_password: '$djusrpass'
      iwh_user: 'iwh'
      iwh_password: '$djiwhpass'
      replication_user: 'admin'
      replication_password: '$djrplpass'
      idle_timeout: '4m'
      snmp_monitoring: true
      backends:
        - cts
      backend_caches:
        cts: 70
    ams_openam_partition: '7G'
    ams_openam:
      version: '$amsver'
      forgerock_version: '$frockver'
      tomcat:
        xms: '3078m'
        xmx: '3078m'
        permsize: '128m'
        maxpermsize: '128m'
        newratio: 3
        gc_log: true
        extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
      site:
        name: 'AMS '$oemname
        base_url: 'http://preprod-$oemname-ams-back-vip.flatns.net:80/openam'
        primary_url: 'http://preprod-$oemname-ams-back-001.flatns.net:8080/openam'
      root:
        alias: admin.preprod-$oemname-ams-back-vip.flatns.net
        key: '$amkey'
        admin_password: '$amadmpass'
        agent_password: '$amagentpass'
      tomtom:
        alias: tomtom.preprod-$oemname-ams-back-vip.flatns.net
      session:
        max_sessions: 100000
        max_time: 120
        idle_time: 60
        caching_time: 3
      certs:
        default: 'ams'
        saml: 'ams_sp'
        password: '$certspass'
      saml:
        sp_entity:
          - 'AMS_SP'
        idp_entity:
          - 'MON_IDP'
        federation_b2: true
      max_cache_size: 10000
      ldap:
        idle_timeout: 3
        pool_min: 1
        pool_max: 10
      monitoring:
        snmp_port:  8085
    ams_entitlements:
      perseus:
        default:
          - '$perseusent'
    ams_entitlementservice:
      base_url: 'http://entitlementservice.preprod-$oemname-ams-back-vip.flatns.net:8080'
      agent:
        password: '$entpass'
    ams_perseus:
      agent:
        password: '$pspass'
    ams_nodes:
      opendj:
        opendj001:
          host: preprod-$oemname-ams-back-001.flatns.net
          ldap_port: 1389
        opendj002:
          host: preprod-$oemname-ams-back-002.flatns.net
          ldap_port: 1389
      logonservice:
        logon001:
          host: preprod-$oemname-ams-front-001.flatns.net
          ip: $(resolve preprod-$oemname-ams-front-001.flatns.net)
          port: 8080
        logon002:
          host: preprod-$oemname-ams-front-002.flatns.net
          ip: $(resolve preprod-$oemname-ams-front-002.flatns.net)
          port: 8080
      entitlementservice:
        entitlementservice001:
          host: preprod-$oemname-ams-front-001.flatns.net
          port: 8180
        entitlementservice002:
          host: preprod-$oemname-ams-front-002.flatns.net
          port: 8180
      perseus:
        perseus001:
          host: preprod-$oemname-ams-front-001.flatns.net
          port: 8380
        perseus002:
          host: preprod-$oemname-ams-front-002.flatns.net
          port: 8380
# $oemname AMS END
EOF
createlog
kstore_create
}

function createlog {
echo "" > ./CreateLog_$oemname
echo "OEM: $oemname" >>./CreateLog_$oemname
echo "OPEN DJ PASS: $djusrpass" >>./CreateLog_$oemname
echo "Entitelements pass: $entpass" >>./CreateLog_$oemname
echo "Entitelements key: $entkey" >>./CreateLog_$oemname
echo "Entitelements ePass: $entepass" >>./CreateLog_$oemname
echo "Perseus password: $pspass" >>./CreateLog_$oemname
echo "Perseus Key: $pskey" >>./CreateLog_$oemname
echo "Perseus ePass: $psepass" >>./CreateLog_$oemname
echo "OpenDJ Directory Manager Pasword: $djdmpass" >>./CreateLog_$oemname
echo "OpenDJ AMS password: $djampass" >>./CreateLog_$oemname
echo "OpenDJ IWH pass:  $djiwhpass" >>./CreateLog_$oemname
echo "OpenDJ Replicatipn pass: $djrplpass" >>./CreateLog_$oemname
echo "Certs password: $certspass" >>./CreateLog_$oemname
echo "OpenAm admin password: $amadmpass" >>./CreateLog_$oemname
echo "OpenAm agent password: $amagentpass" >>./CreateLog_$oemname
echo "OpenAm KEY: $amkey" >>./CreateLog_$oemname
echo "Perseus Node Url: $prospectnodeurl" >>./CreateLog_$oemname
echo "Perseus Base Url: $prospectbaseurl" >>./CreateLog_$oemname
echo "Perseus Entitelemets: $perseusent" >>./CreateLog_$oemname
echo "Perseus Region: $perseusregion" >>./CreateLog_$oemname
echo "Perseus Product: $persprod" >>./CreateLog_$oemname
echo "Trust sotre password: $trustpass" >>./CreateLog_$oemname
}

function generate_a1 {

cat >> ./$oemname'_parameters.map' << EOF
  test-$oemname-ams-001:
    application: ams
    role:
      - proxy
      - opendj
      - openam
      - logonservice
      - entitlementservice
      - perseus
    sysctl_vm_overcommit_memory: 0
    sysctl_vm_swappiness: 0
    ldap_nss_base_group:
      - 'ou=SystemGroups,dc=flatns,dc=net'
      - 'ou=PosixGroups,ou=IAMDevelopment,ou=SecurityContexts,dc=flatns,dc=net'
    puppet_agent_cron_enabled: false
    ams_updates_repo:
      - 'os-2014-11-21'
      - 'updates-2014-11-21'
    ams_base_dn: 'dc=tomtom,dc=com'
    ams_instance: '$oemname'
    ams_base_url: 'https://$oemname-ams.test.tomtom.com'
    ams_internal_cookie_domain: '.flatns.net'
    ams_external_cookie_domain: '.tomtom.com'
    ams_tls_enabled: true
    ams_external_tls_termination: true
    ams_log_access_mode: '0755'
    ams_log_retention: '30'
    ams_log_partition: '7G'
    ams_opendj_partition: '7G'
    ams_opendj:
      version: '$amsver'
      host: 'test-$oemname-ams-001.flatns.net'
      ldap_port: 1389
      jmx_port: 1689
      admin_port: 4444
      replication_port: 8989
      xms: '512m'
      xmx: '512m'
      permsize: '96m'
      maxpermsize: '96m'
      gc_log: true
      extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
      root_user: 'cn=Directory Manager'
      root_password: '$djdmpass'
      openam_user: 'openam'
      openam_password: '$djampass'
      service_user: 'service'
      service_password: '$djusrpass'
      iwh_user: 'iwh'
      iwh_password: '$djiwhpass'
      idle_timeout: '4m'
      snmp_monitoring: true
      backends:
        - 'cts'
        - 'amusers'
    ams_openam_partition: '7G'
    ams_openam:
      version: '$amsver'
      agent_version: '$agentver'
      forgerock_version: '$frockver'
      tomcat:
        xms: '1024m'
        xmx: '1024m'
        permsize: '256m'
        maxpermsize: '256m'
        gc_log: true
        extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
      site:
        name: 'AMS $oemname'
        base_url: 'http://test-$oemname-ams-lb.flatns.net:8080/openam'
        primary_url: 'http://test-$oemname-ams-001.flatns.net:8080/openam'
      root:
        alias: admin.test-$oemname-ams-lb.flatns.net
        key: '$amkey'
        admin_password: '$amadmpass'
        agent_password: '$amagentpass'
      tomtom:
        alias: tomtom.test-$oemname-ams-lb.flatns.net
      mgtservice:
        alias: management.test-$oemname-ams-lb.flatns.net
      session:
        max_sessions: 10000
        max_time: 120
        idle_time: 60
        caching_time: 3
      certs:
        default: 'ams'
        password: '$certspass'
      max_cache_size: 10000
      ldap:
        idle_timeout: 3
        pool_min: 1
        pool_max: 10
      monitoring:
        snmp_port: 8085
    ams_entitlements:
      perseus:
        default:
          - '$perseusent'
    ams_regions:
      $perseusregion
    ams_truststore_password: '$trustpass'
    ams_logonservice:
      version: '$amsver'
      tomcat:
        http_port: 8180
        shutdown_port: 8105
        jmx_port: 1190
        xms: '512m'
        xmx: '512m'
        permsize: '64m'
        maxpermsize: '64m'
        gc_log: true
        extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
    ams_entitlementservice:
      version: '$amsver'
      tomcat:
        http_port: 8280
        shutdown_port: 8205
        jmx_port: 1290
        xms: '512m'
        xmx: '512m'
        permsize: '64m'
        maxpermsize: '64m'
        gc_log: true
        extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps'
      base_url: 'http://entitlementservice.test-$oemname-ams-lb.flatns.net:8280'
      agent:
        password: '$entpass'
        key: '$entkey'
        epassword: '$entepass'
      ldap:
        idle_timeout: 3
        pool_min: 1
        pool_max: 10
    ams_perseus:
      version: '$amsver'
      tomcat:
        http_port: 8480
        shutdown_port: 8405
        jmx_port: 1490
        xms: '512m'
        xmx: '512m'
        permsize: '64m'
        maxpermsize: '64m'
        gc_log: true
        extra: '-XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=2 -XX:+ExplicitGCInvokesConcurrent -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSWaitDuration=60000 -XX:+CMSScavengeBeforeRemark -XX:+CMSClassUnloadingEnabled -XX:+TraceClassLoading -XX:+TraceClassUnloading -XX:+PrintTenuringDistribution -XX:+PrintGCDateStamps -Djavax.net.debug=ssl'
      agent:
        password: '$pspass'
        key: '$pskey'
        epassword: '$psepass'
      product:
        default: '$persprod'
      keystore_password: '$trustpass'
      node_uri: 'perseusClusterA'
    ams_proxy_nodes:
      - $(resolve test-$oemname-ams-001.flatns.net)
    ams_nodes:
      opendj:
        opendj001:
          host: test-$oemname-ams-001.flatns.net
          ldap_port: 1389
      logonservice:
        logon001:
          host: test-$oemname-ams-001.flatns.net
          ip $(resolve test-$oemname-ams-001.flatns.net)
          port: 8180
      entitlementservice:
        entitlementservice001:
          host: test-$oemname-ams-001.flatns.net
          port: 8280
      managementservice:
        managementservice001:
          host: test-$oemname-ams-001.flatns.net
          port: 8380
      perseus:
        perseus001:
          host: test-$oemname-ams-001.flatns.net
          port: 8480
    ams_host_private_key: |
      -----BEGIN PRIVATE KEY-----
      MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCxWw+/y45tEroN
      VhRWLXUjuId8jf1b6Q3agJg+MxORT6MZhlbgTgvOOalMJzDDPxy6fhH3Fgaqux4d
      oLFlA7o3jVnQFacW1lQJgUZZnHTV+hZn2JkgREL16WPf+FtCCwUPrwOtyTOqfJEL
      lAQve/y3JFIvgH7SnRDXmRYJb55AHtiP7izEjmBRU2fZ+shPc5NjXR+NwIo8tHna
      S2FzUCk10UonqqEsv+qjs1QItiWHRmdViyrIylpNA072qfdZNzu3aTGko7gLPVqB
      MzUJp3uow8uMINcTd2tzVh54woFNmOuh9Mf0KqQakHp46dY9y+kHFBo8KbyHKyAu
      6MrRCkmHAgMBAAECggEAW2QMQo33L5eFzhd8VUgJY8XT80gLtY/rdpvrV6nkPG3o
      IuAJ5n3xMWyfI8HSK9payHLseQGdn97aTvQeVWpNTBEHpeVye58oINm/0a+AuT6s
      ywhfJ7RlOOjycVg+VlLtYb6Sy7uxZvnXmDrGyV0/xXPu8dFqCMetBRw6sdQVnP4s
      GQwn3/umGWqJT1E3bF5fKjDtPnB24C4j7rX1rG8Y0GCICp4JCbA/MRb9WEEhzEUD
      mXLu3e8Iv2R8oxlaVzRg67ViHcGRk2lRjGlr6JEa27zwwBlhqcSkVxCBV8SVB4zp
      QYwNUmxH8UrAnbkECwF8p6SsVaq3hbfyp1CnkJTZuQKBgQDjB8oeheK6YODDT0Z2
      YENfuyoo2UK0vLFDBoOtirnNawDwc/zujVk3iQ667FeiqfpM5UsSL1mh2jNwSyRH
      OPpfbquxgR6nHHrMN9ki6hI6k21YrogkVyd6KdozhBE/AcdER8yJKns8q+NgOoqD
      IYLCZ3jS7gYJYbbQ5klNbCxnuwKBgQDH/JcPPJ6rePWsV92itRXmrkFTTDWRJlAQ
      aRvKPNSw3T84GqaoeXlTY/mcGH3wfXlYMWte3w9h0r+luooJLVLhe9KdDLKIAb4F
      4rhYvjwLR0OhWUdFRcJO6HZ6wVfH2Q0WB/epvLALrIruMpCVlV1TN+c8KMw0X/Ty
      itA13OhqpQKBgQDAZVKJSWcaEY2Ilr8dBHk0QJX65huctSf3qCahRCYvihXSsEjS
      FOFdqf3ctPuTcz8WOV7EO3JXMmZTLKrC3Ot5Qn2oQMcsUXtTY6TU7M6j61pIRChF
      u8JNyfgLnklLPwOSvtH8EA8+HGDlpNbLR/PbMfr3rhVZkABwyiemwBxljwKBgQCM
      aLaydvA8Ge/68bHls9hNnti0oBQX9dtOuk1Nn4oBJ0VkoamTLb5WIyI0SynY+G+C
      0Se+c0P8fZgaxq51pQHE2EfWBf0u6nI89aJShDXqAT3lgaY9Z6318taEd0ynPqgm
      aK+k15qOh7T/ajcDHtxoOh66qTY+K4Tx6S4oMxJnFQKBgQCSF0rZfbR4JKYzHP8E
      PFPjZXGg+47zPMVd4Cn+SfKrdyUX9mVcybyA9ymvQyCFfVlemrckdpB+bd0Vh7/J
      Dldmz/R8kx/zihUx695duigu5noW0SxMJqDoqxp864+Uudj+kocE5BgxS4Kkqtr9
      nNSuSbcRSOgodM4T6VL6++Xwfw==
      -----END PRIVATE KEY-----
    ams_single_machine: true
    ams_openam_lb_cookie: '2999589292.36895.0000'
    ams_openam_is_primary: true
    perseus_base_url: 'https://tts-china.tomtom.com'
    perseus_node_url: 'https://tts-china.tomtom.com:8443'
EOF
}
