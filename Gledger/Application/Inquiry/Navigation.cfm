
<cfoutput>

<table width="100%" height="20">
<tr>
	<td class="labelmedium" style="padding-left:4px">
	 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to"> <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="transactions">
	</td>
	<td align="right" style="padding-right:5px">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" value="<<" class="button3" onClick="javascript:reloadForm('#URL.Id2#','#URL.id#','#URL.Page-1#')">
	   </cfif>
	  <cfif URL.Page lt Pages>
	       <input type="button" name="Next" value=">>" class="button3" onClick="javascript:reloadForm('#URL.id2#','#URL.id#','#URL.Page+1#')">
	   </cfif>
	   
	</td>	
</tr>						
</table>	
</cfoutput>						