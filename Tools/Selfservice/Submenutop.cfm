
<cfif find ("MSIE 7","#CGI.HTTP_USER_AGENT#")>

	<cfset validateSession = "Yes">
	
<cfelse>

	<cfset validateSession = "No">

</cfif>

<cf_screentop height="100%" scroll="vertical" html="No" ValidateSession="#validateSession#">