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
<cfdocument
format = "pdf"
orientation  = "landscape"
marginBottom = "0.2"
marginLeft   = "0.2"
marginRight  = "0.2"
marginTop    = "0.2"
mimeType     = "image/jpeg"
scale        = "90">


<cf_screentop html="No" title="Search Result - friendly print version">	
<body>
<cffile action="READ" file="#CLIENT.OutputFile#" variable="vContent">

<cfoutput>

	<cfquery name="Logo" 
	datasource="AppsInit" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT LogoPath, LogoFileName 
		FROM   Parameter
		WHERE  ApplicationServer = '#client.servername#'
	</cfquery>

	<cfif Logo.recordcount gt 0 and Logo.LogoPath neq "" and Logo.LogoFileName neq "">
		
            <cfset path = Logo.LogoPath>
            <cfset npath = replacenocase(path,SESSION.rootpath,"","ALL")>
            <cfset npath = replacenocase(npath,"\","/","ALL")>
            <cfset npath = SESSION.root & "/" & npath>
               
			<cfoutput>
			<table width="100%">
				<tr>
				  <td align="center">
					<img src="#npath##Logo.LogoFileName#">
				  </td>
				</tr>
			</table>
			</cfoutput>
		
	</cfif>
	
	#vContent#
	 <cfdocumentitem type="footer">
	 	<p align="center">
	        <font size="8">Page #cfdocument.currentpagenumber#</font>
		</p>
    </cfdocumentitem>    
</cfoutput>

<script>
	window.print
</script>

</body>
</html>

</cfdocument>