
<cfoutput>

<table width="100%" height="20">
<tr>
	<td class="labelit" style="padding-left:4px">
	Record <b>#First#</b> to <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> titles
	</td>
	<td align="right" style="padding-right:4px">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" value="<<" class="button3" onClick="reloadForm('#URL.Page-1#','#url.view#','#url.mode#')">
	   </cfif>
	  <cfif URL.Page lt Pages>
	       <input type="button" name="Next" value=">>" class="button3" onClick="reloadForm('#URL.Page+1#','#url.view#','#url.mode#')">
	   </cfif>
	  
	</td>	
</tr>						
</table>	
</cfoutput>						