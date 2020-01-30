
<!--- set the screen based on the selected activity --->

<cfset id         = url.id>
<cfset activityid = url.activityid>

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<cfparam name="last.recordcount" default="1">

<cfinclude template="HourEntryFormSlots.cfm">	