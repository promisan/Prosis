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

<html>
<head>
	<title><cfoutput>Mail</cfoutput></title>
</head>
<body onLoad="window.focus()"></body>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObject
WHERE      ObjectId = '#URL.Objectid#'
</cfquery>

<!---

<cfdocument 
          format="PDF"
          pagetype="letter"
		  orientation="portrait"
          unit="cm"
          encryption="none"
		  margintop="0.4"
          marginbottom="0.4"
          marginright="0.4"
          marginleft="0.4"
          fontembed="Yes"
          scale="90"
          backgroundvisible="Yes">
		  
		  --->
		  		  
		  <!---
		  <cfdocumentitem type="header">
		  --->
		  <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		  <tr><td align="center"><cfoutput>#Object.ObjectReference#</cfoutput></td></tr>
		  <tr><td height="1" bgcolor="0080C0"></td></tr>
		  </table>	
		  
		  <!---	  		  
		  </cfdocumentitem>
		  --->

		  <cfset pdf = 1>
		  <cfinclude template="NoteBody.cfm">
		  
<!---		  

</cfdocument>

--->


<script>
window.print()
</script>

