<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>

<!---
 <cfif Counted neq "0">
 --->
	
	<table width="100%" height="100%">	
		<tr>					
			<td class="fixlength" style="width:100%">	
							
				 <table>
				 <tr class="labelmedium" style="height:30px;font-size:17px"> 			
				 				 
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
					
					 <td class="fixlength" style="padding-top:1px"><cf_tl id="Record"></td>
					 <td class="fixlength" style="padding-top:1px"><cfif countedrows eq "0">0<cfelse>#first#</cfif></b></td>
					 <td class="fixlength" style="padding-top:1px"><cf_tl id="to"></td>
					 <td class="fixlength" style="padding-top:1px" name="#attributes.box#_rowshown"><cfif Last gt CountedRows>#CountedRows#<cfelse>#Last#</cfif></td>
					 <td class="fixlength" style="padding-top:1px"><cf_tl id="of"></td>
					 <td class="fixlength" style="padding-top:1px">#CountedRows#</td>
					 
				 
				 <cfelse>
				 				 
					 <td class="fixlength" style="padding-top:1px"><cf_tl id="Group"></td>
					 <td class="fixlength" style="padding-top:1px">#currrow#</td>
					 <td class="fixlength" style="padding-top:1px"><cf_tl id="generated from"></td>
					 <td class="fixlength" style="padding-top:1px" name="#attributes.box#_rowshown">#session.listingdata[box]['recordsinit']#</td>	
					 <td class="fixlength" style="padding-top:1px"><cf_tl id="records"></td>			
								
				 </cfif>	
				 
				 <td style="padding-top:1px;padding-left:10px;"><cfif attributes.isFiltered eq "Yes"><a href="javascript:listingshow('locate#attributes.box#')"><font color="FF8040">[<cf_tl id="result is filtered">]</a></font></cfif></td>
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