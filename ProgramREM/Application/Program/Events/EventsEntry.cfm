
<cfparam name="url.portal" default="0">
<cfparam name="url.mode"   default="edit">

<cfif url.portal eq "0">
	
	<cfajaximport tags="cfform">
	
	<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes">
		
		<cfset url.attach = "0">
		<table width="99%" align="center" border="0" frame="hsides" bordercolor="silver">
		<tr><td><cfinclude template="../Header/ViewHeader.cfm"></tr>
		
		<tr><td id="eventdetail">
		<cfif url.mode eq "edit">
			<cfinclude template="EventsEntryDetail.cfm">
		<cfelse>
			<cfinclude template="EventsEntryDetail.cfm">
		</cfif>
		</td>
		</tr>   
		
		</table>
	
	<cf_screenbottom html="No">

<cfelse>

	<table width="99%" align="center" border="0" frame="hsides" bordercolor="silver">				
		<tr><td id="eventdetail"><cfinclude template="EventsEntryDetail.cfm"></td></tr>   		
	</table>

</cfif>
