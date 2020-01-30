
<cfoutput>

<table width="100%">
<tr>
	<td>
	 &nbsp;<cf_tl id="Record" <b>#First#</b> <cf_tl id="to"> <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records">
	</td>
	<td align="right">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="javascript:reloadForm('#URL.Page-1#')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="javascript:reloadForm('#URL.Page+1#')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
							
</table>	
</cfoutput>						