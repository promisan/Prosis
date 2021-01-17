
<table width="100%" cellpadding="0">

	<tr><td><cfinclude template="Criteria.cfm"></td></tr>
	
	<cfoutput>
	<tr class="line"><td><iframe src="ListingDistributionDetail.cfm?row=#url.row#&id=#url.id#" width="100%" height="200" scrolling="no" frameborder="0">
	</cfoutput>
	
	<!---
	<tr><td height="200">
		<cfinclude template="ListingDistributionDetail.cfm">
	</td>
	</tr>
	--->

</table>
