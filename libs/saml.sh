function sp_conf {
export
cat >> ./templates/saml/'acceptance_'$oemname'_AMS_SP.conf' << EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<EntityDescriptor entityID="AMS_SP" xmlns="urn:oasis:names:tc:SAML:2.0:metadata">
    <SPSSODescriptor AuthnRequestsSigned="false" WantAssertionsSigned="false" protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
        <KeyDescriptor use="signing">
            <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
                <ds:X509Data>
                    <ds:X509Certificate>
$sp_cert
                    </ds:X509Certificate>
                </ds:X509Data>
            </ds:KeyInfo>
        </KeyDescriptor>
        <KeyDescriptor use="encryption">
            <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
                <ds:X509Data>
                    <ds:X509Certificate>
$sp_cert
                    </ds:X509Certificate>
                </ds:X509Data>
            </ds:KeyInfo>
            <EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#aes128-cbc">
                <xenc:KeySize xmlns:xenc="http://www.w3.org/2001/04/xmlenc#">128</xenc:KeySize>
            </EncryptionMethod>
        </KeyDescriptor>
        <NameIDFormat>urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified</NameIDFormat>
        <NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat>
        <AssertionConsumerService index="0" isDefault="true" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact" Location="<%= @ams_base_url %>/ams/cl/authentication/saml2"/>
        <AssertionConsumerService index="1" Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="<%= @ams_base_url %>/ams/cl/authentication/saml2"/>
        <AssertionConsumerService index="2" Binding="urn:oasis:names:tc:SAML:2.0:bindings:PAOS" Location="<%= @ams_base_url %>/ams/cl/authentication/saml2"/>
    </SPSSODescriptor>
</EntityDescriptor>
EOF
}

function sp_ext {
cat >> ./templates/saml/'acceptance_'$oemname'_AMS_SP_ext.conf' << EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<EntityConfig entityID="AMS_SP" hosted="true" xmlns="urn:sun:fm:SAML:2.0:entityconfig">
    <SPSSOConfig metaAlias="/$cname/AMS">
        <Attribute name="description">
            <Value/>
        </Attribute>
        <Attribute name="signingCertAlias">
            <Value>ams_sp</Value>
        </Attribute>
        <Attribute name="encryptionCertAlias">
            <Value>ams_sp</Value>
        </Attribute>
        <Attribute name="basicAuthOn">
            <Value>false</Value>
        </Attribute>
        <Attribute name="basicAuthUser">
            <Value/>
        </Attribute>
        <Attribute name="basicAuthPassword">
            <Value/>
        </Attribute>
        <Attribute name="autofedEnabled">
            <Value>false</Value>
        </Attribute>
        <Attribute name="autofedAttribute">
            <Value/>
        </Attribute>
        <Attribute name="transientUser">
            <Value/>
        </Attribute>
        <Attribute name="spAdapter">
            <Value/>
        </Attribute>
        <Attribute name="spAdapterEnv">
            <Value/>
        </Attribute>
        <Attribute name="spAccountMapper">
<% if @saml_b2 -%>
            <Value>com.sun.identity.saml2.plugins.AmsDefaultSPAccountMapper</Value>
<% else -%>
            <Value>com.sun.identity.saml2.plugins.DefaultSPAccountMapper</Value>
<% end -%>
        </Attribute>
        <Attribute name="useNameIDAsSPUserID">
            <Value>true</Value>
        </Attribute>
        <Attribute name="spAttributeMapper">
<% if @saml_b2 -%>
            <Value>com.sun.identity.saml2.plugins.AmsSPAttributeMapper</Value>
<% else -%>
            <Value>com.sun.identity.saml2.plugins.DefaultSPAttributeMapper</Value>
<% end -%>
        </Attribute>
        <Attribute name="spAuthncontextMapper">
            <Value>com.sun.identity.saml2.plugins.DefaultSPAuthnContextMapper</Value>
        </Attribute>
        <Attribute name="spAuthncontextClassrefMapping">
            <Value>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport|0|default</Value>
        </Attribute>
        <Attribute name="spAuthncontextComparisonType">
            <Value>exact</Value>
        </Attribute>
        <Attribute name="attributeMap">
            <Value>NameID=subjectId</Value>
<% if @saml_b2 -%>
            <Value>tt.ams.mngmt.ident.1.Entitlements=entitlements</Value>
<% end -%>
        </Attribute>
        <Attribute name="saml2AuthModuleName">
            <Value/>
        </Attribute>
        <Attribute name="localAuthURL">
            <Value/>
        </Attribute>
        <Attribute name="intermediateUrl">
            <Value/>
        </Attribute>
        <Attribute name="defaultRelayState">
            <Value/>
        </Attribute>
        <Attribute name="appLogoutUrl">
            <Value/>
        </Attribute>
        <Attribute name="assertionTimeSkew">
            <Value>300</Value>
        </Attribute>
<% if @saml_b2 -%>
        <Attribute name="spDoNotWriteFederationInfo">
            <Value>true</Value>
        </Attribute>
<% end -%>
        <Attribute name="wantAttributeEncrypted">
            <Value>false</Value>
        </Attribute>
        <Attribute name="wantAssertionEncrypted">
            <Value>false</Value>
        </Attribute>
        <Attribute name="wantNameIDEncrypted">
            <Value>false</Value>
        </Attribute>
        <Attribute name="wantPOSTResponseSigned">
            <Value>false</Value>
        </Attribute>
        <Attribute name="wantArtifactResponseSigned">
            <Value>false</Value>
        </Attribute>
        <Attribute name="wantLogoutRequestSigned">
            <Value>false</Value>
        </Attribute>
        <Attribute name="wantLogoutResponseSigned">
            <Value>false</Value>
        </Attribute>
        <Attribute name="wantMNIRequestSigned">
            <Value>false</Value>
        </Attribute>
        <Attribute name="wantMNIResponseSigned">
            <Value>false</Value>
        </Attribute>
        <Attribute name="responseArtifactMessageEncoding">
            <Value>URI</Value>
        </Attribute>
        <Attribute name="cotlist">
            <Value><%= @ams_cot_name %></Value>
        </Attribute>
        <Attribute name="saeAppSecretList"/>
        <Attribute name="saeSPUrl">
            <Value></Value>
        </Attribute>
        <Attribute name="saeSPLogoutUrl"/>
        <Attribute name="ECPRequestIDPListFinderImpl">
            <Value>com.sun.identity.saml2.plugins.ECPIDPFinder</Value>
        </Attribute>
        <Attribute name="ECPRequestIDPList">
            <Value/>
        </Attribute>
        <Attribute name="ECPRequestIDPListGetComplete">
            <Value/>
        </Attribute>
        <Attribute name="enableIDPProxy">
            <Value>false</Value>
        </Attribute>
        <Attribute name="idpProxyList">
            <Value/>
        </Attribute>
        <Attribute name="idpProxyCount">
            <Value>0</Value>
        </Attribute>
        <Attribute name="useIntroductionForIDPProxy">
            <Value>false</Value>
        </Attribute>
        <Attribute name="spSessionSyncEnabled">
            <Value>false</Value>
        </Attribute>
        <Attribute name="relayStateUrlList"/>
    </SPSSOConfig>
</EntityConfig>
EOF
}
