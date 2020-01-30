
<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
	<td class="labelit" style="padding-left:4px">
	<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to"> <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="selected records">
	</td>
	<td align="right">
	 <cfif URL.Page gt "1">
	     <button name="Prior" id="Prior" class="button3" onClick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#','#URL.Page-1#',sort.value,view.value,'0')">
		 <img src="#SESSION.root#/images/pageprior.gif" border="0">		 
		 </button>
		</cfif> 
		 <cfif URL.Page lt "#Pages#">
	    <button name="Prior" id="Prior" class="button3" onClick="listreload('#URL.ID#','#URL.ID1#','#URL.ID2#','#URL.Page+1#',sort.value,view.value,'0')">
		 <img src="#SESSION.root#/images/pagenext.gif" border="0">		 
		 </button>
		 </cfif>
	</td>	
</tr>										
</table>	

</cfoutput>						