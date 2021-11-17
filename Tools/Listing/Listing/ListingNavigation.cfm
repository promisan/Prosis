
<cfoutput>

<!---
 <cfif Counted neq "0">
 --->
	
	<table width="100%" height="100%">	
		<tr>					
			<td>	
							
				 <table>
				 <tr class="labelmedium" style="height:30px;font-size:17px;font-weight:390"> 			
				 				 
				 <cfif navmode neq "manual">

					 <cfif navmode eq "paging">				
				 
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
					
					 </cfif>					
					
					 <td style="padding-top:1px;padding-left:4px"><cf_tl id="Record"></td>
					 <td style="padding-top:1px;padding-left:2px;"><cfif countedrows eq "0">0<cfelse>#first#</cfif></b></td>
					 <td style="padding-top:1px;padding-left:2px;"><cf_tl id="to"></td>
					 <td style="padding-top:1px;padding-left:2px;" name="#attributes.box#_rowshown"><cfif Last gt CountedRows>#CountedRows#<cfelse>#Last#</cfif></td>
					 <td style="padding-top:1px;padding-left:2px;"><cf_tl id="of"></td>
					 <td style="padding-top:1px;padding-left:2px;">#CountedRows#</td>
					 
				 
				 <cfelse>
				 				 
					 <td style="padding-top:1px;padding-left:4px"><cf_tl id="Group"></td>
					 <td style="padding-top:1px;padding-left:2px;">#currrow#</td>
					 <td style="padding-top:1px;padding-left:2px;"><cf_tl id="generated from"></td>
					 <td style="padding-top:1px;padding-left:2px;" name="#attributes.box#_rowshown">#session.listingdata[box]['recordsinit']#</td>	
					  <td style="padding-top:1px;padding-left:2px;"><cf_tl id="records"></td>			
								
				 </cfif>	
				 
				 <td style="padding-top:1px;padding-left:10px;"><cfif attributes.isFiltered eq "Yes"><a href="javascript:listingshow('locate#attributes.box#')"><font color="FF8040">[<cf_tl id="result is filtered">]</a></i></font></cfif></td>
				 <td style="padding-top:1px;padding-left:2px;" id="#attributes.box#_performance"></td>		
				 
				</tr>
				</table>
						
			</td>
						
			<td align="right" style="padding-right:8px">
			
				 <img src="#SESSION.root#/Images/refresh3.gif" 
				    alt="refresh" border="0" id="listingrefresh" name="listingrefresh"
					height="15" width="15" style="cursor:pointer" align="absmiddle" onclick="applyfilter('1','','content')">
				
			</td>
			
			 <cfif navmode eq "paging">
				
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
				 
			 </cfif>	 		
			
		</tr>										
	</table>	

<!---	
 </cfif>	
 --->

</cfoutput>						