
<cfoutput>

<cfset nav = "#SESSION.root#/workorder/application/workorder/serviceagreement/ServiceLine.cfm?tabno=#url.tabno#&workorderid=#URL.workorderid#&search=#url.search#&id2=">

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td colspan="2"></td></tr>
<tr>
	<td class="labelit">	
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 	 
	</td>
	
	<td align="right" class="padding-right:4px">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button10g" onClick="ColdFusion.navigate('#nav#&page=#url.page-1#','contentbox#url.tabno#')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button10g" onClick="ColdFusion.navigate('#nav#&page=#url.page+1#','contentbox#url.tabno#')">
	   </cfif>
	  
	</td>	
</tr>						
				
</table>	

</cfoutput>						