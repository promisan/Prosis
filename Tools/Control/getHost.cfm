
<cfparam name="Attributes.Host"  default="#cgi.http_host#">

<cfset cnt = 1>
<cfloop index="itm" list="#Attributes.Host#" delimiters=".">
	<cfif cnt eq "1">
		<cfset caller.host = itm>
		<cfif itm neq "www" and itm neq "admin" and not isNumeric(itm)>
			<cfset cnt = 2>
			<!--- this will stop the loop --->
		</cfif>		
	</cfif>
</cfloop>