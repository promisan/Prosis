
<!--- schedule --->

<!---We show the current schedule for each of the workorderlines that are active for the selected workorder--->

<cfparam name="session.selectworkorderid" default="">
<cfparam name="session.selectactiondate"  default="">

<cfset url.entryMode   = 'Manual'>

<cfif session.selectworkorderid neq "" and session.selectactiondate neq "">

	<cfset url.workorderid = session.selectworkorderid>
	<cfset url.date        = session.selectactiondate>

	<cfinclude template="../Action/WorkOrderActionListing.cfm">

<cfelse>

	<cfinclude template="../Action/WorkOrderActionSelect.cfm">

</cfif>
