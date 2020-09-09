
<cfif mode eq "subtotal">

	<cfif amt neq "0.00">
	
		<cfoutput>
		
			  <tr class="labelmedium" style="height:20px">    
			  	   <td colspan="10" style="width:100%" align="center">&nbsp;</td> 
			   
				   <cfif outst eq "1">
					   	<td align="right" style="min-width:100px;padding-right:3px;font-weight:bold">#NumberFormat(Amt,',.__')#</td>	
					    <td align="right" style="min-width:107px;padding-right:3px;font-weight:bold">#NumberFormat(AmtOut,',.__')#</td>	
				   <cfelse>	   
				   	    <td align="right" style="min-width:100px;padding-right:3px;font-weight:bold">#NumberFormat(Amt,',.__')#</td>	
				 	   		<cfif journal.glaccount neq "" and Journal.TransactionCategory neq "Memorial">
				   			<td align="right" style="min-width:107px;padding-right:3px;font-weight:bold">#NumberFormat(AmtTriD,',.__')#</td>	
							<td align="right" style="min-width:107px;padding-right:3px;font-weight:bold">#NumberFormat(AmtTriC,',.__')#</td>	
						</cfif>		    			
				   </cfif>
				   
				   <td style="min-width:40px"></td>
			   
			  </TR>
		
		</cfoutput>

   </cfif>

<cfelse>

	<cfif amtT neq "0.00">
	
		<cfoutput>
		
			  <tr class="labelmedium" style="height:20px">    
			  	   <td colspan="10" style="width:100%" align="center">&nbsp;</td> 
			   
				   <cfif outst eq "1">
					   	<td align="right" style="min-width:100px;padding-right:3px;font-weight:bold">#NumberFormat(AmtT,',.__')#</td>	
					    <td align="right" style="min-width:107px;padding-right:3px;font-weight:bold">#NumberFormat(AmtOutT,',.__')#</td>	
				   <cfelse>	   
				   	    <td align="right" style="min-width:100px;padding-right:3px;font-weight:bold">#NumberFormat(AmtT,',.__')#</td>	
				 	   		<cfif journal.glaccount neq "" and Journal.TransactionCategory neq "Memorial">
				   			<td align="right" style="min-width:107px;padding-right:3px;font-weight:bold">#NumberFormat(AmtTriDT,',.__')#</td>	
							<td align="right" style="min-width:107px;padding-right:3px;font-weight:bold">#NumberFormat(AmtTriCT,',.__')#</td>	
						</cfif>		    			
				   </cfif>
				   
				   <td style="min-width:40px"></td>
			   
			  </TR>
		
		</cfoutput>

   </cfif>
	
</cfif>

				
<cfset amt     = 0>
<cfset amtOut  = 0>
<cfset amtTriD = 0>
<cfset amtTriC = 0>