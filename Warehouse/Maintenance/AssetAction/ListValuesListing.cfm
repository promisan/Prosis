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
<cfquery name="List" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_AssetActionList
	WHERE Code = '#URL.Code#'	
	ORDER BY ListOrder
</cfquery>

<cfquery name="Last" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(ListOrder)+1 as Last
    FROM  Ref_AssetActionList
	WHERE Code = '#URL.Code#'	
</cfquery>


<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfparam name="URL.ID2" default="">
	
<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0" >
				
		<cfif list.recordcount eq "0">
			<cfset url.id2 = "new">		
		</cfif>	
		    <TR height="20">
			   <td class="labelit" width="5%">&nbsp;<cf_tl id="Code"></td>
			   <td class="labelit" width="70%"><cf_tl id="Description"></td>
			   <td class="labelit" width="50" align="center"><cf_tl id="Order"></td>
			   <td class="labelit" width="50"><cf_tl id="Default"></td>
			   <td class="labelit"  width="30" align="center"><cf_tl id="Active"></td>
			   <td class="labelit"  width="5%" colspan="2" align="right">
		       <cfoutput>
				 <cfif URL.ID2 neq "new">
				     <A href="javascript:ColdFusion.navigate('ListValuesListing.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&ID2=new','contentbox2')">
					 <font color="0080FF">[<cf_tl id="add">]</font></a>
				 </cfif>
				 </cfoutput>&nbsp;
			   </td>		  
		    </TR>
			<tr><td height="1" colspan="7" class="line"></td></tr>	
					
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm = ListCode>
			<cfset de = ListValue>
			<cfset ls = ListOrder>
			<cfset op = Operational>
			<cfset def = ListDefault>
																					
			<cfif URL.ID2 eq nm>		
				
				<tr>
					<td colspan="7">
						<cfform action="ListValuesSubmit.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&id2=#url.id2#" 
				    		method="POST" 
							name="element">
							
							<input type="hidden" name="ListCode" id="ListCode" value="<cfoutput>#nm#</cfoutput>">
							
						<table width="100%" align="center">
													
							<TR>
							   <td class="labelit"  width="5%">#nm#</td>
							   <td class="labelit"  width="60%">
							   	   <cfinput type="Text" 
								   	value="#de#" 
									name="ListValue" 
									message="You must enter a description" 
									required="Yes" 
									size="60" 
									maxlength="60" 
									class="regular">
							  
					           </td>
							   <td height="22" width="50" align="center">
							   	<cfinput type="Text"
								       name="ListOrder"
								       value="#ls#"
								       validate="integer"
								       required="Yes"
									   message="Please enter an order value" 
								       visible="Yes"
								       enabled="Yes"
								       typeahead="No"
									   class="regular"
								       size="1"
								       maxlength="2"
									   style="text-align:center">
							   			   
							     </td>
								 
								 <td width="50">
							      <input type="checkbox" name="ListDefault" id="ListDefault" value="1" <cfif "1" eq def>checked</cfif>>
								</td>
							  
							   <td width="30" align="center">
							      <input type="checkbox" name="Operational" id="Operational" value="1" <cfif "1" eq op>checked</cfif>>
								</td>
							   <td colspan="2" align="right">
							   <input type="submit" 
							        value="Save" 
									class="button10s" 
									style="width:50">&nbsp;</td>
						    </TR>
						</table>
						</cfform>
					</td>
				</tr>	
				
															
			<cfelse>
								
						
				<TR onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF">
				   <td class="labelit"  height="20" width="5%">&nbsp;#nm#</td>
				   <td class="labelit" >#de#</td>
				   <td class="labelit"  align="center">#ls#</td>
				   <td class="labelit" ><cfif def eq "1"><b>Yes</b></cfif></td>				 
				   <td class="labelit"  align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				   <td class="labelit"  align="right" style="padding-top:2px;">
				   		<cf_img icon="edit" onclick="ColdFusion.navigate('ListValuesListing.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&ID2=#nm#','contentbox2');">
				   </td>
			   			   
				   <cfquery name="Check" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT *
					    FROM  AssetItemAction
						WHERE ActionCategory = '#URL.Code#'	
						AND   ActionCategoryList = '#ListCode#'
				   </cfquery>
				   
				   <td class="labelit"  align="center" style="padding-top:2px;">
				     <cfif check.recordcount eq "0">
					 		<cf_img icon="delete" onclick="ColdFusion.navigate('ListValuesPurge.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&ID2=#nm#','contentbox2');">
					 </cfif>	   
					  
				    </td>
					
				 </TR>	
				 
				 <cfif currentrow neq recordcount>
				 <tr><td height="1" colspan="7" class="line"></td></tr>
				 </cfif>
						
			</cfif>
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.ID2 eq "new">		
			
			<tr>
				<td colspan="7">
					<cfform action="ListValuesSubmit.cfm?idmenu=#url.idmenu#&Code=#URL.Code#&id2=new" 
						method="POST" 				
						name="element">
					<table width="100%" align="center">
						<TR>
							<td  height="28" width="5%">
							
								    <cfinput type="Text" 
								         value="" 
										 name="ListCode" 
										 message="You must enter a code" 
										 required="Yes" 
										 size="2" 
										 maxlength="20" 
										 class="regular">
					        </td>
										   
							    <td width="60%">
								   	<cfinput type="Text" 
								         name="ListValue" 
										 message="You must enter a name" 
										 required="Yes" 
										 size="60" 
										 maxlength="80" 
										 class="regular">
								</td>								 
								<td width="50" align="center">
								   <cfinput type="Text" 
								      name="ListOrder" 
									  message="You must enter an order" 
									  required="Yes" 
									  size="1" 
									  class="regular"
									  style="text-align:center"
									  value="#lst#"
									  validate="integer"
									  maxlength="2">
								</td>
								
							<td width="50">
							     <input type="checkbox" name="ListDefault" id="ListDefault" value="1">
							</td>	
							
							<td width="30" align="center">
								<input type="checkbox" name="Operational" id="Operational" value="1" checked>
							</td>
												   
							<td colspan="2" align="right">
							<cfoutput>
							<input type="submit" 
								value="Add" 
								class="button10s" 
								style="width:50">
							&nbsp;
							</cfoutput>
							</td>			    
							</TR>	
							
							
						
					</table>
					</cfform>
				</td>
			</tr>
											
		</cfif>								
</table>		
						

