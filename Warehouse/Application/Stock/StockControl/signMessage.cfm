<!--
    Copyright © 2025 Promisan

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
<cffunction name="getSignature" returntype="string" access="public">
           <cfargument name="pemFILE" type="string" required="true">
           <cfargument name="request" type="string" required="true">
           
           
           <!---- Converting parameter onto a JAVA CLASS --->
           <cfset var vKey = JavaCast("string", arguments.pemFILE)>
           <cfset var vMsg = JavaCast("string",arguments.request).getBytes("UTF-8")>

			<!---- Calling the methods for RSA of standard JAVA ---> 
           <cfset var okey = createObject("java", "java.security.PrivateKey")>
           <cfset var okeySpec = createObject("java","java.security.spec.PKCS8EncodedKeySpec")>
           <cfset var okeyFactory = createObject("java","java.security.KeyFactory")>
           <cfset var ob64dec = createObject("java", "sun.misc.BASE64Decoder")>
           <cfset var osig = createObject("java", "java.security.Signature")>


			<!---- I need to have byte stream ---> 
           <cfset var obyteClass = createObject("java", "java.lang.Class")>
           <cfset var obyteArray = createObject("java","java.lang.reflect.Array")>
           
           <cfset obyteClass = obyteClass.forName(JavaCast("string","java.lang.Byte"))>
           <cfset keyBytes = obyteArray.newInstance(obyteClass, JavaCast("int","1024"))>
           <cfset keyBytes = ob64dec.decodeBuffer(vKey)>

			<!---- getting finally the private key --->
           <cfset osig = osig.getInstance("SHA1withRSA", "SunJSSE")>
           <cfset osig.initSign(okeyFactory.getInstance("RSA").generatePrivate(okeySpec.init(keyBytes)))>
           
           <!---- Now, we sign the message --->
           <cfset osig.update(vMsg)>
           <cfset osignBytes = osig.sign()>
     
           <cfreturn ToBase64(osignBytes)>
</cffunction>


<cfscript>  
pem_file = FileRead("d:\Certificates\private-key.pem");
result   = getSignature(pem_file,URL.request);
</cfscript> 
<cfoutput>#result#</cfoutput>
