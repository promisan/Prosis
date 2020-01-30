<cfif client.browser eq "">
	<cfif find("MSIE","#CGI.HTTP_USER_AGENT#")>
	    <cfset client.browser = "Explorer">
	<cfelseif find("Firefox","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Firefox">	
	<cfelseif find("Chrome","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Chrome">	 	 
	<cfelseif find("Opera","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Opera">	
	<cfelseif find("Safari","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Safari">	 
	<cfelse>	
		<cfset client.browser = "undefined"> 
	</cfif>
</cfif>
