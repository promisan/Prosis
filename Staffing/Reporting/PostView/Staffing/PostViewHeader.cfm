
<cfoutput>
<TR class="labelmedium" style="height:20px">          	   
		<td bgcolor="white" style="width:100%;padding-right:4px;min-width:384px"></td>		
						   
		   <cfloop query="Resource">			
			  <cfoutput>
			  
				 <cfif PostGradeBudget eq "total" or PostGradeBudget eq "subtotal">
				    <cfset cl = "##e4e4e4">
				 <cfelse>	
				    <cfset cl = "##ffffff">
				 </cfif> 
				 			  
					   <cfif Resource.PostGradeBudget eq "Subtotal" or Resource.PostGradeBudget eq "Total">				       
					   <td align="center" bgcolor="#cl#"style="padding:1px;background-color:#cl#80;min-width:#cellspace#px;font-size:12px;border:1px solid gray">	
					       #Left(Resource.Code,5)#
					       <cfset subT = subT & "-#Resource.CurrentRow#-">
					   </td>	   
					   <cfelse>				   	 
					   <td align="center" bgcolor="#cl#" style="padding:1px;background-color:#cl#80;min-width:#cellspace#px;font-size:12px;border:1px solid gray">	
					   	 #Left(Resource.PostGradeBudget,5)#
					   </td>	 
					   </cfif>					   
				   
			  </cfoutput>			  
			</cfloop>		
		  
</TR>
</cfoutput>
