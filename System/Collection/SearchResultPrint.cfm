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