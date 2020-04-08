
<cfoutput>

<TR style="vertical-align:top">
    	
	<td class="line" colspan="2" align="center">
						 
	 <table width="97%" class="formpadding" align="center">
	 
	   <tr class="labelmedium">
	       <td align="center" width="100%"><cf_space spaces="36"></td>
		   <td style="border:1px solid silver;border-bottom:0px;border-top:0px;" align="center">
		   <cf_space spaces="24" class="labelmedium" align="center" label="Total">	
		  
		   </td>
		  	 
			<cfloop query="Resource">
			       <td style="border:1px solid silver;border-bottom:0px;border-top:0px;" align="center" class="labelmedium">
				   <cfif Resource.PostGradeBudget eq "Subtotal">
				   		<cf_space spaces="20"  class="labelmedium" align="center" label="#Left(Resource.Code,8)#">
				         <cfset subT = subT & "-#Resource.CurrentRow#-">
				   <cfelse>
				   <cf_space spaces="16" class="labelmedium" align="center" label="#Left(Resource.PostGradeBudget,6)#">
				   </cfif>
				   </td>
			</cfloop>
			
			<td><cf_space spaces="5"></td>
	    		
	   </tr>	
	
	 </table>	
	 
	</td>
	
</TR>

 </cfoutput>
