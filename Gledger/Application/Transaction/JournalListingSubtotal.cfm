
<cfif mode eq "subtotal">

	<cfif amt neq "0.00">
	
		<cfoutput>
		
			  <tr class="line labelmedium" style="background-color:f1f1f1;height:20px">    
			  	   <td colspan="10" style="width:100%" align="center">&nbsp;</td> 
			   
				   <cfif outst eq "1">
					   	<td align="right" style="min-width:100px;padding-right:3px">#NumberFormat(Amt,',.__')#</td>	
					    <td align="right" style="min-width:107px;padding-right:3px">#NumberFormat(AmtOut,',.__')#</td>	
				   <cfelse>	   
				   	    <td align="right" style="min-width:100px;padding-right:3px">#NumberFormat(Amt,',.__')#</td>	
				 	   		<cfif journal.glaccount neq "" and Journal.TransactionCategory neq "Memorial">
				   			<td align="right" style="min-width:107px;padding-right:3px">#NumberFormat(AmtTriD,',.__')#</td>	
							<td align="right" style="min-width:107px;padding-right:3px">#NumberFormat(AmtTriC,',.__')#</td>	
						</cfif>		    			
				   </cfif>
				   
				   <td style="min-width:50px"></td>
			   
			  </TR>
		
		</cfoutput>

   </cfif>

<cfelse>

	<cfif amtT neq "0.00">
	
		<cfoutput>
		
			  <tr class="line labelmedium" style="background-color:f1f1f1;height:20px">    
			  	   <td colspan="10" style="width:100%" align="center">&nbsp;</td> 
			   
				   <cfif outst eq "1">
					   	<td align="right" style="min-width:100px;padding-right:3px">#NumberFormat(AmtT,',.__')#</td>	
					    <td align="right" style="min-width:107px;padding-right:3px">#NumberFormat(AmtOutT,',.__')#</td>	
				   <cfelse>	   
				   	    <td align="right" style="min-width:100px;padding-right:3px">#NumberFormat(AmtT,',.__')#</td>	
				 	   		<cfif journal.glaccount neq "" and Journal.TransactionCategory neq "Memorial">
				   			<td align="right" style="min-width:107px;padding-right:3px">#NumberFormat(AmtTriDT,',.__')#</td>	
							<td align="right" style="min-width:107px;padding-right:3px">#NumberFormat(AmtTriCT,',.__')#</td>	
						</cfif>		    			
				   </cfif>
				   
				   <td style="min-width:50px"></td>
			   
			  </TR>
		
		</cfoutput>

   </cfif>
	
</cfif>

				
<cfset amt     = 0>
<cfset amtOut  = 0>
<cfset amtTriD = 0>
<cfset amtTriC = 0>