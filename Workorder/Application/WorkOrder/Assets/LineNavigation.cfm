
<cfif counted gt "0">
	
	<cfoutput>
		
		<cfset nav = "#SESSION.root#/workorder/application/workorder/assets/Line.cfm?workorderid=#URL.workorderid#&workorderline=#URL.workorderline#&search=#url.search#&id2=">
		
		<table width="100%" cellspacing="0" cellpadding="0">
			
			<tr><td colspan="2"></td></tr>
			
			<tr>
			
				<td class="labelit">	
				 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
			    </td>
				
				<td align="right" style="padding-right:4px">
			
				  <cfif URL.Page gt "1">	 
				       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page-1#','contentbox1')">
				  </cfif>
				  
				  <cfif URL.Page lt "#Pages#">
				       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page+1#','contentbox1')">
				  </cfif>
				  
				</td>	
			</tr>						
						
		</table>	
	
	</cfoutput>		

</cfif>				