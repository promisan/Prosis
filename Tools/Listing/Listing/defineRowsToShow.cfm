
<cfparam name="url.action" default="all">

<cfif url.action eq "all">

	<cfset CLIENT.PageRecordsOld = CLIENT.PageRecords>
	<cfset CLIENT.PageRecords = url.maxRows>

<cfelse>

	<cfset CLIENT.PageRecords = CLIENT.PageRecordsOld>
	<cfif CLIENT.PageRecords gt url.maxrows>
		<cfset CLIENT.PageRecords = 35>
	</cfif>

</cfif>