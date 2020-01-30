
<cfoutput>

<cfset nav = "#SESSION.root#/tools/selectlookup/Template/TemplateResult.cfm?close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&des2=#des2#">

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td colspan="2" bgcolor="silver"></td></tr>
<tr bgcolor="f1f1f1">
	<td>
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page-1#','searchresult','','','POST','searchselect')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page+1#','searchresult','','','POST','searchselect')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
<tr><td colspan="2" bgcolor="silver"></td></tr>							
</table>	

</cfoutput>						