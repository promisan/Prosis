<cfparam name="URL.Msg" default = "">

<table width="90%" align="center"><tr><td style="padding-top:60px">

<cf_message message="#URL.Msg#" return="no"	report="1">

</td></tr></table>

<cfif isDefined("Session.status")>
	<cfscript>
		StructDelete(Session,"Status");
	</cfscript>
</cfif>