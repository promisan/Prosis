
<cfoutput>

<table width="100%">

	<tr class="line">
		<td class="labelit" style="padding-left:10px">
		 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
		</td>
		<td align="right" style="padding-right:4px">
	
		 <cfif URL.Page gt "1">	 
		       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/Unit/OrganizationResult.cfm?height=#url.height#&page=#url.page-1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','resultunit#box#','','','POST','selectorg')">
		   </cfif>
		  <cfif URL.Page lt "#Pages#">
		       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/Unit/OrganizationResult.cfm?height=#url.height#&page=#url.page+1#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','resultunit#box#','','','POST','selectorg')">
		   </cfif>	 
		</td>	
	</tr>	
		
							
</table>	

</cfoutput>						