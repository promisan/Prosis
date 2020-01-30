
<cfif counted gt "0">

<cfoutput>

<table width="100%">
<tr class="linedotted">
	<td class="labelit" style="padding-left:4px">
	<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right" style="padding-right:10px">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('#SESSION.root#/tools/selectlookup/Asset/ItemResult.cfm?height=#url.height#&page=#url.page-1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#&filter3=#filter3#&filter3value=#filter3value#&filter4=#filter4#&filter4value=#filter4value#','result#url.box#','','','POST','select_#url.box#')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('#SESSION.root#/tools/selectlookup/Asset/ItemResult.cfm?height=#url.height#&page=#url.page+1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#&filter3=#filter3#&filter3value=#filter3value#&filter4=#filter4#&filter4value=#filter4value#','result#url.box#','','','POST','select_#url.box#')">
	   </cfif>	   
	</td>	
</tr>		

							
</table>	

</cfoutput>		

</cfif>				