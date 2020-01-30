

<cfparam name="url.minutes" default="0">

<cfset hour = int(url.minutes/60)>
<cfset mins = url.minutes - (hour*60)>

<cfoutput>

#hour#:#mins#<cfif mins lt 10>0</cfif>

<input type="hidden" name="OvertimeHours" id="OvertimeHours" value="#hour#">
<input type="hidden" name="OvertimeMinut" id="OvertimeMinut" value="#mins#">

</cfoutput>