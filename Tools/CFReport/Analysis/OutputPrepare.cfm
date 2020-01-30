<cfparam name="URL.debug" default="0">

<cfif url.debug eq 0>

	<cf_screentop height="100%" scroll="No" jquery="yes" html="No" blockevent="rightclick">
	
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
	<cfajaximport tags="cfchart">
	
	<!---	
	<cf_divscroll overflowx="scroll" id="_divPivotContainer">
	--->
		
		<cfdiv bind="url:#SESSION.root#/Tools/CFReport/Analysis/OutputPrepareContent.cfm?#cgi.query_string#">
	
	<!---	
	</cf_divscroll>
	--->
	
	
	<!--- load the script --->
	<cfinclude template="../../../Component/Analysis/CrossTabHolder.cfm">
	
	<!---  <cfinclude template="OutputPrepareContent.cfm"> --->
	
<cfelse>
	
	<cfinclude template="../../../Tools/CFReport/Analysis/OutputPrepareContent.cfm">

</cfif>