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
<cfinvoke component="Service.Presentation.Presentation"
       method="highlight"
    returnvariable="stylescroll"/>
		
<cfparam name="url.id2" default="">	

<cfparam name="form.operational" default="0">	
	
<cfquery name="Listing" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Scale
	ORDER BY Created DESC
</cfquery>

<table width="93%" border="0" align="center" class="formpadding navigation_table"> 	
			
    <TR class="labelmedium line" height="18">
	   <td width="20"></td>
	   <td width="70">Code</td>
	   <td width="50%">Description</td>
	   <td width="50">Active</td>
	   <td width="20%">Officer</td>
	   <td width="80" align="right">Created</td>		
	   <td wisth="30"></td>			  	  
    </TR>	
	
	<cfif URL.ID2 eq "new">
	
		<tr>
			<td colspan="7">
			
				<cfform method="POST" name="mytopic" onsubmit="return false">
				<table width="100%" align="center">
				
						<TR bgcolor="f4f4f4" class="labelit line">
						
						<td width="1%"></td>
						<td height="25" width="10%">&nbsp;
						
							    <cfinput type="Text" 
							         value="" 
									 name="Code" 
									 message="You must enter a code" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularxl">
				        </td>	
											   
						<td width="40%">
						
							   	<cfinput type="Text" 
							         name="Description" 
									 message="You must enter a name" 
									 required="Yes" 
									 size="50" 						 
									 maxlength="60" 
									 class="regularxl">
						</td>
						<td width="50">
						
						      <input type="Checkbox" class="radiol" 
						       name="Operational" id="Operational"
						       value="1" checked>
						</td>
														   
						<td colspan="2" align="center" width="30%">
						<cfoutput>
							<input type="submit" 
								value="Save" 
								onclick="save('new')"
								class="button10g">
						</cfoutput>
						
						</td>			    
						</TR>	
						
				</table>
				</cfform>
			</td>
		</tr>
												
	</cfif>						
		
	<cfoutput>
	
	<cfloop query="Listing">
																							
		<cfif URL.ID2 eq code>
		
			<tr>
				<td colspan="7">
				
					<cfform name="mytopic" onsubmit="return false">
					
						<table width="100%" align="center">
								
							<input type="hidden" name="Code" id="Code" value="#Code#">
																
							<TR class="labelmedium2 line">
							
							   <td width="20"></td>
							   
							   <td width="10%">#Code#</td>
							   
							   <td>
							   	   <cfinput type = "Text" 
								   	value        = "#description#" 
									name         = "Description" 
									message      = "You must enter a description" 
									required     = "Yes" 
									size         = "50" 
									maxlength    = "60" 
									style        = "border:0px; border-left:1px solid silver;border-right:1px solid silver"
									class        = "regularxxl">			  
					           </td>
							   <td width="40%">							 
							     <input type="Checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif operational eq "1">checked</cfif>>									   
							   </td>
									
							   <td colspan="3" align="right">
							   
							   <input type="submit" value="Save" onclick="save('#code#')" class="button10g">
				
								</td>
						    </TR>	
										
						</table>
						
					</cfform>
				</td>
			</tr>		
		
																	
		<cfelse>
										
			<TR class="labelmedium navigation_row line">			
			  			   
			   <td align="center" style="padding-top:2px">			   
				  <cf_img icon="edit" navigation="Yes" onclick="ptoken.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&ID2=#code#','listing');">
			  </td>
			   
			   <td height="17" style="padding-left:4px">#code#</td>
			   <td>#description#</td>
			  
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td colspan="1">#OfficerFirstName# #OfficerLastName#</td>
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
			   
			     <cfquery name="Check" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 *
					    FROM  Item
						WHERE DepreciationScale = '#Code#'						
				   </cfquery>
				   
				 <td align="center" style="padding-top:6px">
				  <cfif check.recordcount eq "0">
				  	  <cf_img icon="delete" onclick="if (confirm('Remove this schedule ?')) { ptoken.navigate('RecordListingPurge.cfm?idmenu=#url.idmenu#&Code=#code#','listing'); }">
				  </cfif>	   
					  
				</td>   
			   		   
		   </tr>	
			 
		   <tr><td></td><td></td><td colspan="3">
		   
		   	<cfdiv id="#code#_list">
			
			   <cfset url.code = code>
			   <cfinclude template="List.cfm">			
			   
			  </cfdiv>  
			
			</td></tr>
				 	 			 
			 					
		</cfif>
					
	</cfloop>
	</cfoutput>													
				
</table>						

