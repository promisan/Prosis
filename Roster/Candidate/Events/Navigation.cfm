
<cfoutput>

<table width="100%">
<tr class="labelmedium">
	<td>
	 &nbsp;Document <b>#First#</b> to <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> selected records 
	</td>
	<td align="right">
	 <cfif #URL.Page# gt "1">
	     <input type="button" name="Prior" value="<<" class="button7" onClick="javascript:reloadForm('#URL.Page-1#')">
	   </cfif>
	  <cfif #URL.Page# lt "#Pages#">
	       <input type="button" name="Next" value=">>" class="button7" onClick="javascript:reloadForm('#URL.Page+1#')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
							
</table>	
</cfoutput>						