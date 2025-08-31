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
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ClaimTypeClass
	WHERE ClaimType = '#URL.ClaimType#'	
	ORDER By Created Asc
</cfquery>

<cfquery name="WFList" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT * FROM Ref_EntityClass
	WHERE  EntityCode 
	IN (
		SELECT EntityCode FROM
		Ref_Entity
	    WHERE EntityCode like 'Clm#URL.ClaimType#'	)  

</cfquery>
  
<cfparam name="URL.code" default="">
	
<table width="100%" class="navigation_table">
				
		<cfif list.recordcount eq "0">
		  <cfset url.code = "new">
		</cfif>  
			
			<tr><td style="height:6px"></td></tr>
		    <tr height="18" class="line labelmedium2">
			   <td>&nbsp;<cf_tl id="Code"></td>
			   <td width="60%"><cf_tl id="Description"></td>
			   <td> <cf_tl id="WorkFlow Class"></td>
			   <td colspan="2" align="right">
		       <cfoutput>
				 <cfif URL.code neq "new">
				     <A href="javascript:ptoken.navigate('List.cfm?ClaimType=#URL.ClaimType#&Code=new','#url.claimtype#_list')">
					 [<cf_tl id="add">]</a>
				 </cfif>
				 </cfoutput>&nbsp;
			   </td>		  
		    </tr>					
				
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset co  = Code>
			<cfset nm  = Description>
																								
			<cfif url.code eq co>		
			
			<tr>
			
				<td colspan="5">
			
				<cfform style="height:20px" action="ListSubmit.cfm?ClaimType=#URL.ClaimType#&code=#url.code#" method="POST"	name="element">
							
					<table align="center" width="100%">
															
					<tr>
					   <td>#co#</td>
					   <td>
					   
					   	  <cf_tl id="Description" var = "1">
						  <cfset vDescription = lt_text>
						  
						  <cf_tl id="You must enter a description" var = "1" class="Message">
						  <cfset vMessage = lt_text>
						  
					   	  <cfinput type="Text" 
							   	value="#nm#" 
								name="#vDescription#" 
								message="#vMessage#" 
								required="Yes" 
								size="60" 
								maxlength="60" 
								class="regularxl">
					  
			           </td>
					   <td>
					   		
							<cfselect name="entityclass" class="regularxl">
								<cfloop query="WFList">
									<cfoutput>
									<option value="#entityclass#" <cfif List.entityclass eq WFList.entityclass>selected</cfif>>#entityclass#</option>
									</cfoutput>
								</cfloop>
							</cfselect>
							
					   </td>
					   <td colspan="2" align="right">
	   				   	  <cf_tl id="Save" var = "1">
						  <cfset vSave = lt_text>
						   <input type="submit" 
						        value="#vSave#" 
								class="button10g" 
								style="width:50px" class="regularxl">
					   </td>
				    </tr>	
					
					</table>
				
				</cfform>
							
				</td>
			</tr>
																					
			<cfelse>								
						
				<tr class="line navigation_row labelmedium2">
				   <td>&nbsp;#co#</td>
				   <td height="20">#nm#</td>
				   <td>#entityclass#</td>
				   <td align="right">
					   <cf_img icon="open" onclick="ptoken.navigate('List.cfm?ClaimType=#URL.ClaimType#&code=#co#','#url.claimtype#_list')">
				   </td>
			   			   
				   <cfquery name="Check" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 *
					    FROM   Claim
						WHERE  ClaimTypeClass = '#co#'							
				   </cfquery>
				   
				   <td align="center" width="20">
				     <cfif check.recordcount eq "0">
						   <cf_img icon="delete" onclick="ptoken.navigate('ListPurge.cfm?claimtype=#url.claimtype#&code=#co#','#url.claimtype#_list')">
					 </cfif>	   
					  
				    </td>
					
				 </tr>	
						
			</cfif>
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.code eq "new">
		
			<tr class="navigation_row">
				<td colspan="5">
			
				<cfform action="ListSubmit.cfm?ClaimType=#URL.ClaimType#&code=new" method="POST" name="element">
				
					<table width="100%" align="center">
								
						<tr>
						<td height="28">
								<cfoutput>
							   	<cf_tl id="You must enter a code" var = "1">
								<cfset vMessage = lt_text>
						
							    <cfinput type="Text" 
							         value="" 
									 name="Code" 
									 message="#vMessage#" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regularxl">
									 
								</cfoutput>	 
				        </td>
									   
						    <td>
								<cfoutput>
							   	<cf_tl id="You must enter a name" var = "1">
								<cfset vMessage = lt_text>
							   	<cfinput type="Text" 
							         name="Description" 
									 message="#vMessage#" 
									 required="Yes" 
									 size="60" 
									 maxlength="80" 
									 class="regularxl">
								</cfoutput>	 
							</td>								 
						<td>
							<cfselect name="entityclass" class="regularxl">
								<cfloop query="WFList">
									<cfoutput>
									<option value="#entityclass#">#entityclass#</option>
									</cfoutput>
								</cfloop>
							</cfselect>
						</td>
						<td colspan="2" align="right">
						
							<input type="submit" 
								value="Add" 
								class="button10g" 
								style="width:50px" class="regularxl">						
						
						</td>			    
						</tr>	
					</table>
					
				</cfform>
				
				</td>
			</tr>
											
		</cfif>								
</table>	

<cfset AjaxOnLoad("doHighlight")>