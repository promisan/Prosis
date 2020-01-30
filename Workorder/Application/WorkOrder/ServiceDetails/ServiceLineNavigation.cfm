
<cfoutput>

<cfset nav = "#SESSION.root#/workorder/application/workorder/servicedetails/ServiceLine.cfm?tabno=#url.tabno#&workorderid=#URL.workorderid#&search=#url.search#&id2=">

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td colspan="2"></td></tr>
<tr>
	<td>
	 <font face="Verdana" size="1">
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to2"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records"> 
	 </font>
	</td>
	<td align="right">

	 <cfif URL.Page gt "1">	 
	       <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page-1#','contentbox#url.tabno#')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('#nav#&page=#url.page+1#','contentbox#url.tabno#')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
<tr><td colspan="2" bgcolor="silver"></td></tr>							

</table>	

</cfoutput>						