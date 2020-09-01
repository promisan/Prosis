
<cfoutput>

<!---
 <cfif Counted neq "0">
 --->
	
	<table width="100%" height="100%">	
		<tr>					
			<td>	
							
				 <table>
				 <tr class="labelmedium" style="font-size:17px;font-weight:390"> 			
				
					<td style="padding-left:2px;padding-right:1px">
					
					<cfif pages gte "2">					
						<select name="selpage" id="selpage" style="border:0px;border-right:1px solid silver"
				        size="1" class="regularxl" 
				        onChange="document.getElementById('page').value=this.value;applyfilter('','','content')">
						  <cfloop index="Item" from="1" to="#pages#" step="1">
				             <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
				          </cfloop>	 
						</SELECT>					
					</cfif>
					
				 </td>
				 
				 <td style="padding-top:3px;padding-left:4px"><cf_tl id="Record"></td>
				 <td style="padding-top:3px;padding-left:2px;"><cfif counted eq "0">0<cfelse>#first#</cfif></b></td>
				 <td style="padding-top:3px;padding-left:2px;"><cf_tl id="to"></td>
				 <td style="padding-top:3px;padding-left:2px;"><cfif Last gt Counted>#Counted#<cfelse>#Last#</cfif></b></td>
				 <td style="padding-top:3px;padding-left:2px;"><cf_tl id="of"></td>
				 <td style="padding-top:3px;padding-left:2px;">#Counted#&nbsp;&nbsp;&nbsp;<cfif attributes.isFiltered eq "Yes"><u><a href="javascript:listingshow('locate#attributes.box#')"><font face="Calibri" size="2" color="FF8040">[<cf_tl id="total is filtered">]</a></i></font></cfif></td>
			
				</tr>
				</table>
						
			</td>
						
			<td align="right" style="padding-right:8px">
			
				 <img src="#SESSION.root#/Images/refresh3.gif" 
				    alt="refresh" border="0" id="listingrefresh" name="listingrefresh"
					height="12" width="12" style="cursor:pointer" align="absmiddle"
				    onclick="applyfilter('1','','content')">
				
			</td>
				
			 <cfif URL.Page gt "1">
			 
			 	<td align="right" style="padding-right:4px">
			 
			     <input type="button" 
				    name="prior" id="prior"
					value="<<" 
					class="button3" 
					onClick="document.getElementById('page').value=#URL.Page-1#;applyfilter('','','content')">
					
				</td>	
					
			 </cfif>
			
			 <cfif URL.Page lt "#Pages#">
			 
			 	<td align="right" style="padding-right:4px">
			  
			       <input type="button" 
				     name="next" id="next" 
					 value=">>" 
					 class="button3" 
					 onClick="document.getElementById('page').value=#URL.Page+1#;applyfilter('','','content')">
					 
				 </td>	 
					 
			 </cfif>			
			
		</tr>										
	</table>	

<!---	
 </cfif>	
 --->


</cfoutput>						