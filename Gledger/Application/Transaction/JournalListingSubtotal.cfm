
<cfif amt neq "0.00">
	
	<cfoutput>
	
		  <tr class="line labelmedium" style="background-color:f1f1f1;height:20px">    
		  	   <td style="width:100%" align="center"></td> 
		   
			   <cfif outst eq "1">
				   	<td align="right" style="min-width:100px;padding-right:3px">#NumberFormat(Amt,',.__')#</td>	
				    <td align="right" style="min-width:120px;padding-right:3px">#NumberFormat(AmtOut,',.__')#</td>	
			   <cfelse>	   
			   	    <td align="right" style="min-width:100px;padding-right:3px">#NumberFormat(Amt,',.__')#</td>	
			 	   		<cfif journal.glaccount neq "" and Journal.TransactionCategory neq "Memorial">
			   			<td align="right" style="min-width:100px;padding-right:3px">#NumberFormat(AmtTriD,',.__')#</td>	
						<td align="right" style="min-width:120px;padding-right:3px">#NumberFormat(AmtTriC,',.__')#</td>	
					</cfif>		    			
			   </cfif>
			   
			   <td style="min-width:50px"></td>
		   
		  </TR>
	
	</cfoutput>

</cfif>