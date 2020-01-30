
<cfparam name="url.mode" default="progress">

<cfif url.mode eq "activity">

	<cfinclude template="Listing/ActivityView.cfm">

<cfelse>

	<cfinclude template="Progress/ActivityView.cfm">

</cfif>