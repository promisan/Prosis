<cfsavecontent variable="content" >
	<cfinclude template="OrgTreePrintBody.cfm">
</cfsavecontent>


<cftry>
	<cfdirectory action="CREATE" 
	             directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#">
	<cfcatch></cfcatch>
</cftry>
	
<cftry>
	<cffile action="WRITE" file="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#URL.Mission#.htm" output="#content#">
	<cfcatch></cfcatch>
</cftry>

<cfhtmltopdf
	overwrite="yes"
	unit="in" 
	pagetype="A4"
	orientation="landscape"
	destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#URL.Mission#.pdf" 
	source="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#URL.Mission#.htm">
</cfhtmltopdf>

<cfoutput>
	<script>
		window.location = '#SESSION.root#/CFRStage/User/#SESSION.acc#/#URL.Mission#.pdf'
	</script>
</cfoutput>