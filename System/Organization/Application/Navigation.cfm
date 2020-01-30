
<cfoutput>

<table width="100%">
<tr>
	<td>
	 &nbsp;Record <b>#First#</b> to <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> selected records 
	</td>
	<td align="right">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" id="Prior" value="<<" class="button3" onClick="ColdFusion.navigate('OrganizationListingList.cfm?page=#url.page-1#&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4=#url.id4#','tree')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" onClick="ColdFusion.navigate('OrganizationListingList.cfm?page=#url.page+1#&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4=#url.id4#','tree')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>						
							
</table>	
</cfoutput>						