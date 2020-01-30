
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr>
	<td height="23">
	 &nbsp;Record <b>#First#</b> to <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> selected positions 
	</td>
	<td align="right">
	 <cfif URL.Page gt 1>
	     <button name="Prior" class="button3" 
		 onClick="javascript:reloadForm('#URL.Page-1#','#URL.sort#','#URL.Mandate#','#URL.Lay#','1','0','#url.header#')">
		 <img src="#SESSION.root#/Images/pageprior.gif" border="0">	
		 </button>
	 </cfif>
	 <cfif URL.Page lt Pages>
	       <button name="Next" class="button3" 
		    onClick="javascript:reloadForm('#URL.Page+1#','#URL.sort#','#URL.Mandate#','#URL.Lay#','1','0','#url.header#')">
			<img src="#SESSION.root#/Images/pagenext.gif" border="0">	
			</button>
      </cfif>
	  
	</td>	
</tr>	
												
</table>	
</cfoutput>						