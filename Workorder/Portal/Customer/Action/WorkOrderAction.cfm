
<cfparam name="session.selectworkorderid" default="">
<cfparam name="session.selectactiondate"  default="">

<cfset url.entryMode   = 'Batch'>

<cfif session.selectworkorderid neq "" and session.selectactiondate neq "">

	<cfset url.workorderid = session.selectworkorderid>
	<cfset url.date        = session.selectactiondate>

	<cfinclude template="WorkOrderActionListing.cfm">

<cfelse>

	<cfinclude template="WorkOrderActionSelect.cfm">

</cfif>

