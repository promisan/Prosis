
<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">
<tr> 
   	<td class="labelheader">
	 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right" class="labelheader" style="padding-right:5px">
	
	<cfif url.mode neq "DrillBox">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('Vacancy/Listing.cfm?mode=#url.mode#&fileno=#url.fileno#&item=#url.item#&series=#url.series#&select=#url.select#&page=#url.page-1#','listing')">
	 </cfif>
	 <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" value=">>" class="button3" onClick="ColdFusion.navigate('Vacancy/Listing.cfm?mode=#url.mode#&fileno=#url.fileno#&item=#url.item#&series=#url.series#&select=#url.select#&page=#url.page+1#','listing')">
	 </cfif>
		   
	</cfif>
	   
	</td>	
</tr>						
							
</table>	

</cfoutput>			
		  			