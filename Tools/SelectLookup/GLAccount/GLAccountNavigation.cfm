
<cfoutput>

<table width="100%">
<tr>
	<td>
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('#SESSION.root#/tools/selectlookup/GLAccount/GLAccountResult.cfm?page=#url.page-1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','accountresult','','','POST','selectaccount')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('#SESSION.root#/tools/selectlookup/GLAccount/GLAccountResult.cfm?page=#url.page+1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','accountresult','','','POST','selectaccount')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
							
</table>	

</cfoutput>						