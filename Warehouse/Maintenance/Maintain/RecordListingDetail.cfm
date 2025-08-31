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
    FROM  Ref_MaintainClass
	ORDER BY Created DESC
</cfquery>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
		 				
    <TR height="18"  class="cellcontent">
	   <td width="20"></td>
	   <td width="10%">Code</td>
	   <td width="50%">Description</td>
	   <td width="10">Oper.</td>
	   <td width="20%">Officer</td>
	   <td align="right">Created</td>		
	   <td width="30"></td>			  	  
    </TR>	
	
	<tr><td height="1" colspan="7" class="line"></td></tr>
			
	<cfif URL.ID2 eq "new">
	
		<tr>
			<td colspan="7">
				<cfform method="POST" name="mytopic" onsubmit="return false">
					<table width="100%" align="center">
						<TR>
		
						<td width="10"></td>
						<td height="25" width="10%">&nbsp;
						
							    <cfinput type="Text" 
							         value="" 
									 name="Code" 
									 message="You must enter a code" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularH">
				        </td>	
											   
						<td width="50%">
						
							   	<cfinput type="Text" 
							         name="Description" 
									 message="You must enter a name" 
									 required="Yes" 
									 size="50" 						 
									 maxlength="60" 
									 class="regularxl">
						</td>
						<td width="10">
						
						      <input type="Checkbox"
						       name="Operational" id="Operational" class="radiol"
						       value="1" checked>
						</td>
														   
						<td colspan="2" align="right">
						<cfoutput>
							<input type="submit" 
								value="Save" 
								onclick="save('new')"
								class="button10g">
						</cfoutput>
						
						</td>			    
						</TR>	
						
						<tr><td colspan="7" class="line"></td></tr>	
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
							 <input type="hidden" name="Code" id="Code" value="<cfoutput>#Code#</cfoutput>">
																				
							<TR>
							
							   <td width="10"></td>
							   <td height="30" width="10%">#Code#</td>
							   <td width="50%">
							   	   <cfinput type = "Text" 
								   	value        = "#description#" 
									name         = "Description" 
									message      = "You must enter a description" 
									required     = "Yes" 
									size         = "50" 
									maxlength    = "60" 
									class        = "regularxl">			  
					           </td>
							   <td width="10">
							 
								     <input type="Checkbox"
								       name="Operational" id="Operational" class="radiol"
								       value="1"
									   <cfif operational eq "1">checked</cfif>>
									   
							   </td>
									
							   <td colspan="2" align="right">
							   
							   <input type="submit" 
							        value="Save" 
									onclick="save('#code#')"
									class="button10g">
				
								</td>
						    </TR>	
											
							<tr><td height="1" colspan="7" class="line"></td></tr>
						</table>
					</cfform>
				</td>
			</tr>
																	
		<cfelse>
										
			<TR class="navigation_row cellcontent line">
						  			   
			   <td align="center" style="padding-top:3px">
			     <cf_img icon="edit" navigation="Yes" onclick="ColdFusion.navigate('RecordListingDetail.cfm?ID2=#code#&idmenu=#url.idmenu#','listing');">
			  </td>
			   
			   <td height="17">&nbsp;
			   <A href="javascript:ColdFusion.navigate('RecordListingDetail.cfm?ID2=#code#&idmenu=#url.idmenu#','listing')">
			   #code#</a></td>
			   <td>
			   <A href="javascript:ColdFusion.navigate('RecordListingDetail.cfm?ID2=#code#&idmenu=#url.idmenu#','listing')">
			   #description#
			   </a>
			   </td>
			  
			   <td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td colspan="1">#OfficerFirstName# #OfficerLastName#</td>
			   <td align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
			   
			     <cfquery name="Check" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 *
					    FROM  AssetItemMaintain
						WHERE MaintainClass = '#Code#'						
				   </cfquery>
				   
				 <td align="center" width="20" style="padding-top:3px">
				  <cfif check.recordcount eq "0">
				  	  <cf_img icon="delete" onclick="if (confirm('Remove this maintenance ?')) { ColdFusion.navigate('RecordListingPurge.cfm?Code=#code#&idmenu=#url.idmenu#','listing'); }">
				  </cfif>	   
					  
				</td>   
			   		   
		   </tr>	
			
		   <!---	 
		   <tr><td></td><td></td><td colspan="4">
		   
		   	   <cfdiv id="#code#_list">
			
			   <cfset url.code = code>
			   <cfinclude template="List.cfm">			
			   
			   </cfdiv>
			
			</td></tr>
		    --->	
				 
		 			 					
		</cfif>
					
	</cfloop>
	</cfoutput>													
				
</table>						

