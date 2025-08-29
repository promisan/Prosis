<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name		="getEDIConfig"
         datasource	="AppsSystem" 
         username  	="#SESSION.login#" 
         password  	="#SESSION.dbpw#">
         SELECT 	*
		 FROM 		Parameter
</cfquery>

<cfset vEDIDirectory = getEDIConfig.EDIDirectory>
<cfset vCertificatesDirectory = vEDIDirectory & "Certificates">

<cfif not directoryExists(vCertificatesDirectory)>
	<cfdirectory action="create" directory="#vCertificatesDirectory#">
</cfif>

<cfset signature = sign("#vCertificatesDirectory#\private-key2.0.pem", url.request)>
<cfcontent type="text/plain">
<cfoutput>#signature#</cfoutput>
<cfscript>

public any function sign(required string keyPath, required string message, string algorithm = "SHA1withRSA", string encoding = "base64") {
	createObject("java", "java.security.Security")
		.addProvider(createObject("java", "org.bouncycastle.jce.provider.BouncyCastleProvider").init());
	privateKey = createPrivateKey(fileRead(keyPath));
	var signer = createObject("java", "java.security.Signature").getInstance(javaCast( "string", algorithm ));
	signer.initSign(privateKey);
	signer.update(charsetDecode(message, "utf-8"));
	var signedBytes = signer.sign();
	return encoding == "binary" ? signedBytes : binaryEncode(signedBytes, encoding);
}

private any function createPrivateKey(required string contents) {
	var pkcs8 = createObject("java", "java.security.spec.PKCS8EncodedKeySpec").init(
		binaryDecode(stripKeyDelimiters(contents), "base64")
	);
	return createObject("java", "java.security.KeyFactory")
		.getInstance(javaCast( "string", "RSA" )).generatePrivate(pkcs8);
}

private string function stripKeyDelimiters(required string keyText) {
	return trim(reReplace(keyText, "-----(BEGIN|END)[^\r\n]+", "", "all" ));
}
</cfscript>