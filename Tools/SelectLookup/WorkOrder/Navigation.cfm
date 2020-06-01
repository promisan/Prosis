
<cfoutput>

<table width="100%">
<tr>
	<td class="labelit">
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Workorder/Result.cfm?page=#url.page-1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#&filter3=#filter3#&filter3value=#filter3value#','resultworkorder#url.box#','','','POST','selectservice')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Workorder/Result.cfm?page=#url.page+1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#&filter3=#filter3#&filter3value=#filter3value#','resultworkorder#url.box#','','','POST','selectservice')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>	
<tr><td height="1" class="linedotted" colspan="2"></td></tr>					
							
</table>	

</cfoutput>						