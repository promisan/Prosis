
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td>
	 &nbsp;Record <b>#First#</b> to <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> selected Classes
	</td>
	<td align="right">
	 <cfif #URL.Page# gt "1">
	     <input type="button" name="Prior" id="Prior" value="<<" class="button7" onClick="javascript:reloadForm('#URL.Page-1#','#URL.View#','#URL.Lay#','#URL.sort#')">
	   </cfif>
	  <cfif #URL.Page# lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button7" onClick="javascript:reloadForm('#URL.Page+1#','#URL.View#','#URL.Lay#','#URL.sort#')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
</table>	
</cfoutput>						