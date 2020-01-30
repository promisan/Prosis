
<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td colspan="2" class="line"></td></tr>
<tr bgcolor="f1f1f1" class="line labelmedium">
	<td style="padding-left:5px">
	 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right" style="padding-right:5px">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" value="<<" class="button3" onClick="reloadForm('#url.page-1#',sort.value,layout.value,searchid.value)">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" value=">>" class="button3" onClick="reloadForm('#url.page+1#',sort.value,layout.value,searchid.value)">
	   </cfif>
	   
	</td>	
</tr>										
</table>	

</cfoutput>						