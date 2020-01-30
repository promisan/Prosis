
<cfoutput>

<cf_PageCountN count= "#counted#">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr class="line">
	<td style="height:35px" class="labelmedium">
	 <cf_tl id="Record"> <b>#First#</b> <cf_tl id="to"> <b><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b> of <b>#Counted#</b> <cf_tl id="selected requisition lines">
	</td>
	<td width="100" align="right">
	 <!--- drop down to select only a number of record per page using a tag in tools --->	
	    
		   <cfif pages lte "1">
		   
		   		<input type="hidden" name="page" id="page" value="1">
				
		   <cfelse>
		   
			    <cfif url.id eq "WHS">
							   
		           <select name="page" id="page" size="1" class="regularxl"
		           onChange="itmonorder('s')">
				   <cfloop index="Item" from="1" to="#pages#" step="1">
		              <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>#vPage# #Item# #vOf# #pages#</option></cfoutput>
		           </cfloop>	 
		           </SELECT>
			   
			    <cfelse>
				
				   <select name="page" id="page" size="1"class="regularxl"
		           onChange="reloadForm(this.value,view.value,lay.value,sort.value,'#URL.filter#','#URL.fileNo#')">
				   <cfloop index="Item" from="1" to="#pages#" step="1">
		              <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>#vPage# #Item# #vOf# #pages#</option></cfoutput>
		           </cfloop>	 
		           </SELECT>		
				   
				</cfif>    	
		   
		   </cfif> 					
	
	</td>
	<td width="100" align="right">
	 <cfif URL.Page gt "1">
	     <input type="button" name="Prior" id="Prior" value="<<" style="width:40px;height:25" class="button10s" onClick="reloadForm('#URL.Page-1#','#URL.View#','#URL.Lay#','#URL.sort#','#URL.Filter#','#URL.fileNo#')">
	   </cfif>
	  <cfif URL.Page lt "#Pages#">
	     <input type="button" name="Next" id="Next" value=">>"  style="width:40px;height:25" class="button10s" onClick="reloadForm('#URL.Page+1#','#URL.View#','#URL.Lay#','#URL.sort#','#URL.Filter#','#URL.fileNo#')">
	   </cfif>	  
	</td>		
</tr>		
		
</table>	

</cfoutput>						