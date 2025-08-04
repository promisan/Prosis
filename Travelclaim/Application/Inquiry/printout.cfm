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
<!---
<cfhttp url="http://www.w3.org/TR/REC-html32" method="get" resolveURL="true">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<cfdocument format="PDF" encryption="40-bit"
   ownerpassword="us3rpa$$w0rd" userpassword="us3rpa$$w0rd"
   permissions="AllowCopy" >
--->
<html><head>

<title>Print JJ</title>

<cfdocument 
			format="pdf" 
			margintop = "0.25"   
			marginbottom = "0.25"   
			marginleft = "0.25"   
			marginright = "0.25"
			scale=95 orientation="landscape">
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="1">
<title>Print JJ</title>
<cfoutput>
<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">

</cfoutput>

<cfoutput >
<cfinclude template="claimviewdetails.cfm">
</cfoutput>

</cfdocument>
</head></html>
