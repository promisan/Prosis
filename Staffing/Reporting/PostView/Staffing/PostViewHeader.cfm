
<cfoutput>

<TR class="labelmedium fixrow" style="height:30px">     
        	   
	<td style="background-color:white;" bgcolor="white"></td>		
	<td style="background-color:white" bgcolor="white"></td>   
						   
	   <cfloop query="Resource">			

			  <cfoutput>
			  
				 <cfif PostGradeBudget eq "total" or PostGradeBudget eq "subtotal">
				    <cfset cl = "##e4e4e4">
				 <cfelse>	
				    <cfset cl = "##ffffff">
				 </cfif> 
				 			  
					   <cfif Resource.PostGradeBudget eq "Subtotal" or Resource.PostGradeBudget eq "Total">				       
					   <td align="center" bgcolor="#cl#"style="background-color:#cl#;min-width:#cellspace#px;font-size:14px;border:1px solid gray;!important">	
					       #Left(Resource.Code,5)#
					       <cfset subT = subT & "-#Resource.CurrentRow#-">
						   
					   </td>	   
					   <cfelse>				   	 
					   <td align="center" bgcolor="#cl#" style="background-color:#cl#;min-width:#cellspace#px;font-size:14px;border:1px solid gray!important">	
					   	 #Left(Resource.PostGradeBudget,5)#
					   </td>	 
					   </cfif>					   
				   
			  </cfoutput>			  
			  
		</cfloop>		
		  
</TR>
</cfoutput>
