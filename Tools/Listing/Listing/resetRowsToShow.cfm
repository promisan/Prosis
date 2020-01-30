<cfset CLIENT.PageRecords = CLIENT.PageRecordsOld>
<cfif CLIENT.PageRecords gt url.maxrows>
	<cfset CLIENT.PageRecords = 35>
</cfif>