
<cfoutput>
	 
	   <tr class="labelmedium2 fixrow line" style="border-top:1px solid silver;background-color:c0c0c0">
	       <td align="center" width="100%"></td>
		   <td align="center" style="min-width:60px"><cf_tl id="Total"></td>
		  	 
			<cfloop query="Resource">
			       <td style="min-width:50px;border:1px solid silver;border-bottom:0px;border-top:0px;" align="center">
				   <cfif Resource.PostGradeBudget eq "Subtotal">
				        #Left(Resource.Code,8)#				   		
				         <cfset subT = subT & "-#Resource.CurrentRow#-">
				   <cfelse>
				   #Left(Resource.PostGradeBudget,6)#				  
				   </cfif>
				   </td>
			</cfloop>	
				    		
	   </tr>	
	
 </cfoutput>
