
<cfoutput>

<table width="100%">
	<tr class="line labelmedium">
		<td style="height:25px;padding:2px;padding-left:4px">
		<cf_tl id="Record"> #First# to <cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif> of #Counted# records</b>
		</td>
		<td align="right" style="padding-right:5px">
		
		 <cfif URL.Page gt "1">
		      <input type="button" name="Prior" value="<<" class="button3" 
			 onClick="javascript:listing('#url.tab#','#url.box#','show','#url.mode#','#url.filter#','#url.level#','','#url.total#','#url.process#','#URL.page-1#',view.value)">
		 </cfif>
		 <cfif URL.Page lt "#Pages#">
		       <input type="button" name="Next" value=">>" class="button3" 
			   onClick="javascript:listing('#url.tab#','#url.box#','show','#url.mode#','#url.filter#','#url.level#','','#url.total#','#url.process#','#URL.page+1#',view.value)">
	      </cfif>
		 
		</td>	
	</tr>							
</table>	

</cfoutput>						