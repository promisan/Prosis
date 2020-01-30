

<!--- show contracts that end before the assignment end date --->
<!--- missing contract are not included --->
<cf_screentop html="No">

<cf_listingscript>

<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">

<tr> <td class="labellarge" style="padding-left:8px;font-size:29px;height:40px;"><b><cfoutput>#URL.ID2#</cfoutput></b>: assignments expiring before the end of the next month.</td> </td> </tr>

<tr><td height="100%" style="padding:8px">					
	<cf_divscroll overflowx="auto">  
		<cfinclude template="ContractExpirationListing.cfm">
	</cf_divscroll>
	</td>
</tr>

</table>

