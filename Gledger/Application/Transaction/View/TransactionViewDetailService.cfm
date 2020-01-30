<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
						
	<tr class="cellcontent linedotted">

		 <td></td>
		 <td>Class</td>
		 <td>Reference</td>
		 <td>IndexNo</td>
		 <td colspan="2">Name</td>
		 <td>Charge</td>
		 <td>Curr</td>
		 <td align="right">Amount</td>
	 
	</tr>
			
	<cfset amt = 0>
	
	<cfoutput query="ChargeDetails">	
	    				
		<cfset amt = amt + TransactionAmount>
		
		<tr class="cellcontent linedotted navigation_row">
		
			<td>#currentrow#.</td>
			<td>#UnitClass#</td>	
			<td>#Reference#</td>					
			<td>#IndexNo#</td>
			<td>#LastName#</td>
			<td>#FirstName#</td>
			<td>#Charged#</td>
			<td>#Currency#</td>					
			<td align="right" style="padding-right:3px">#numberformat(TransactionAmount,",__.__")#</td>
						
		</tr>	
					
	</cfoutput>	
	
	<cfif abs(amt-documentAmount) gt 1>
	
		<tr>
		   <td colspan="9" align="center" class="labelmedium"><font color="FF0000">Details are not in sync !</td>
	    </tr>
	
	</cfif>	

</table>