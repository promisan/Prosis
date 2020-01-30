
<cfoutput>

	<table width="97%" border="0" cellspacing="2" cellpadding="2" align="center" rules="rows" bordercolor="silver" >
	
		<tr><td class="labelit"><b>Claim Submission Fund Account Period Mapping Table</td>
		    <td align="right"><input type="button" class="button10g" name="Add" value="Add" onClick="recordadd()"></td>
		</tr>
		
		<tr><td colspan="2" id="fundbox">
	
		<cfset url.addHeader = 0>
		<cfinclude template="../FundValidation/RecordListing.cfm">
		
		</td></tr>
		
	</table>
	
</cfoutput>	
	
	
	