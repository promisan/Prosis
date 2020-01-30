
<cfoutput>

<table width="100%">
<tr><td colspan="2" height="1" class="linedotted"></td></tr>
<tr>
	<td>
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right">
	 <cfif #URL.Page# gt "1">
	     <input type="button" name="Prior" value="<<" class="button3" onClick="javascript:reloadForm('#URL.Page-1#','#URL.View#','#URL.Lay#','#URL.global#')">
	   </cfif>
	  <cfif #URL.Page# lt "#Pages#">
	       <input type="button" name="Next" value=">>" class="button3" onClick="javascript:reloadForm('#URL.Page+1#','#URL.View#','#URL.Lay#','#URL.global#')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
<tr><td colspan="2" height="1" class="linedotted"></td></tr>							
</table>	

<cf_waitEnd>
</cfoutput>						