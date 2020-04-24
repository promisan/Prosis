
<cf_tl id="Receipt and Inspection" var="1">

<cfparam name="url.id" default="RI">

<cf_screentop height="100%"   
	label         = "#lt_text# #url.id#" 
	title         = "#url.id#"
	banner        = "gray" 
	scroll        = "No"
	bannerforce   = "Yes" 
	layout        = "webapp" 
	line          = "no" 
	html          = "Yes" 
	menuAccess    = "Context"
	systemmodule  = "Procurement"
	FunctionClass = "Window"
	FunctionName  = "Receipt Document">
	
	<table width="100%" height="100%"><tr><td>
	
	<cfoutput>
	<iframe src="ReceiptEditContent.cfm?#cgi.query_string#&header=0" width="100%" height="100%" frameborder="0"></iframe> 
	</cfoutput>
	
	</td></tr>
	</table>

<cf_screenbottom layout="webapp">
 