
<cfoutput>

<table width="100%">
	
	<tr class="labelmedium" style="height:20px">
		<td style="padding-left:14px">
		 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
		</td>
		<td align="right" style="padding-right:14px">	
		
			<table>
				<tr>
				<td style="min-width:20px">
				 <cfif URL.Page gt "1">	 
				     <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="reloadForm('#url.page-1#','#URL.IDStatus#')">
				 </cfif>
				</td>
				<td style="min-width:20px">
				 <cfif URL.Page lt Pages>
				     <input type="button" name="Next"  id="Next" value=">>"  class="button3" onClick="reloadForm('#url.page+1#','#URL.IDStatus#')">
				 </cfif>		   		  
				</td>
				</tr>
			</table>
		
		</td>	
	</tr>		
								
</table>	

</cfoutput>						