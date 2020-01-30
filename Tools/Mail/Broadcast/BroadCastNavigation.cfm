
<cfoutput>

<table width="100%">

<tr class="line">
	<td height="18" class="labelit" style="padding-left:5px;font-weight:200">
	  Record <b>#First#</b> to <b><cfif #Last# gt #Counted#>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted# records</b>  
	</td>
	
	<td align="right" bgcolor="ffffff" class="labelit" style="padding-right:4px">	
	
	<cfset connector = "&">
	<cfif FindNoCase("?",link) eq 0>
		<cfset connector = "?">
	</cfif>		
	
	 <cfif URL.Page gt "1">
	      <input type="button" name="Prior" id="Prior" value="<<" class="button3" 
		 onClick="ColdFusion.navigate('#link##connector#page=#URL.page-1#','contentbox2')">
	 </cfif>
	 
	 <cfif URL.Page lt "#Pages#">
	       <input type="button" name="Next" id="Next" value=">>" class="button3" 
		   onClick="ColdFusion.navigate('#link##connector#page=#URL.page+1#','contentbox2')">
      </cfif>
	 
	</td>	
</tr>	

</table>	
</cfoutput>						