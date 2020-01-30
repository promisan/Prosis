

<!--- position listing --->

<table width="100%" height="100%" cellspacing="1" cellpadding="1">

<cfoutput>
	<tr><td height="10"></td></tr>	
	<tr><td style="height:20" class="labellarge">Positions in units assigned for this workorder with a valid workschedule per #dateformat(now(),client.dateformatshow)#</td></tr>
	<tr><td class="line"></td></tr>
</cfoutput>	
	
	<tr><td></td></tr>	
	<tr><td height="100%" id="listingbox">
		<cfinclude template="PositionListingContent.cfm">
	</td></tr>
	
</table>	