<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start">
	<cfcontent reset="true"><cfinclude template="header.cfm">
	<cfparam name="attributes.message" default="A request exception has occurred.">
	<cfparam name="attributes.detail" default="">
	<cfoutput>
		<div class="error">#XmlFormat(attributes.message)#</div>
		<cfif StructKeyExists(request, "isAuthenticated") AND request.isAuthenticated>
			<cfif StructKeyExists(request, "firewall")>#request.firewall.stringCleaner(attributes.detail, "escape")#</cfif>
		</cfif>
	</cfoutput>
	<cfinclude template="footer.cfm">
	<cfabort>
</cfif>