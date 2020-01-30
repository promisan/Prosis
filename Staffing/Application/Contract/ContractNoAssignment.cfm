
<cf_screentop html="No">

<cf_listingscript>

<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">

<tr><td class="labelmedium" style="padding-left:5px;height:35px;"><b><i><cfoutput>#URL.ID2#</cfoutput></i></b>: staff members that have a contract but do not have an assignment</td></tr>

<tr><td class="linedotted"></td></tr>

<tr><td height="100%">					
	<cf_divscroll overflowx="auto">  
		<cfinclude template="ContractNoAssignmentListing.cfm">
	</cf_divscroll>
	</td>
</tr>

</table>