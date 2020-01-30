<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cfoutput>
<table width="100%">
<tr>
	<td>
	 &nbsp;<cf_tl id="Record"> <b>#First#</b> <cf_tl id="to"> <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> <cf_tl id="of"> <b>#Counted#</b> <cf_tl id="purchase orders">
	</td>
	<td align="right">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" id="Prior" value="<<" class="button7" onClick="javascript:reloadForm('#URL.Page-1#','#URL.sort#','#URL.view#')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button7" onClick="javascript:reloadForm('#URL.Page+1#','#URL.sort#','#URL.view#')">
	   </cfif>
	   &nbsp;
	</td>	
</tr>		
<tr><td colspan="2" class="line" height="1"></td></tr>				
</table>	
</cfoutput>						