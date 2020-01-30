
<cfoutput>

<cfset nav = "#SESSION.root#/tools/selectlookup/Employee/EmployeeResult.cfm?height=#url.height#&close=#url.close#&box=#box#&link=#url.link#&des1=#des1#&filter1=#url.filter1#&filter1value=#url.filter1value#&filter2=#url.filter2#&filter2value=#url.filter2value#&filter3=#url.filter3#&filter3value=#url.filter3value#">

<table width="100%" cellspacing="0" cellpadding="0">
<tr class="line">
	<td class="labelit">
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right" style="padding-right:10px">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page-1#','searchresult#url.box#','','','POST','select_#url.box#')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page+1#','searchresult#url.box#','','','POST','select_#url.box#')">
	   </cfif>
	   
	</td>	
</tr>										
</table>	

</cfoutput>						