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
<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Listing</title>

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

</head>

<cfoutput>

<cfparam name="URL.ID1" default="Locate">

<table width="99%" height="100%" cellspacing="0" cellpadding="0">
    <cfif url.id1 eq "Locate">
	<tr><td height="10">
		<cfinclude template="MandateViewLocate.cfm">
	</td></tr>
	<tr><td height="98%">
		<iframe name="detail" id="detail" width="100%" height="100%" frameborder="0"></iframe>
	</td></tr>
	<cfelse>
	<tr><td height="100%">
	    <iframe name="detail" id="detail" width="100%" height="100%" frameborder="0"></iframe>		
		</td>
	</tr>	
	</cfif>
</table>
	
</cfoutput>

</html>