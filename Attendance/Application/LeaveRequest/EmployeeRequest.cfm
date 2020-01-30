
<cfparam name="url.scope" default="Backoffice">
<cfparam name="url.src" default="Manual">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
	 <cfset url.src = "Selfservice">
	 <cfset url.webapp = "portal">
</cfif>

<cf_screentop html="no" scroll="VerticalShow" jQuery="yes">
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td>
	<cfset client.stafftoggle = "close">
    <cfset openmode = "close">
	<cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">
</td>

</tr>
<cfset ctr = "1">
<tr>		
	<td colspan="14" id="contentdependent" style="padding-bottom:10px">		
		<cfinclude template="Request1.cfm">		
	</td>
</tr>
</table>	



