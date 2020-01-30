
<cfoutput>

<cfset nav = "#SESSION.root#/tools/selectlookup/Funding/FundingResult.cfm?close=#url.close#&box=#box#&link=#url.link#&des1=#des1#">

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td colspan="2" class="linedotted"></td></tr>
<tr>
	<td class="labelit">
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	</td>
	<td align="right">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page-1#','searchresultfunding#box#','','','POST','searchselectfunding')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page+1#','searchresultfunding#box#','','','POST','searchselectfunding')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
<tr><td colspan="2" class="linedotted"></td></tr>					
</table>	

</cfoutput>						