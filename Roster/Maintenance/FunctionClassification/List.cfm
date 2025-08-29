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
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_FunctionClassification
	WHERE ParentCode = '#URL.ParentCode#'	
	ORDER By ListingOrder
</cfquery>

<cfquery name="Last" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Max(ListingOrder)+1 as Last
    FROM  Ref_FunctionClassification
	WHERE ParentCode = '#URL.ParentCode#'	
</cfquery>

<cfif Last.last eq "">

  <cfset lst = "1">
  
<cfelse>

  <cfset lst = last.last>
    
</cfif>

<cfparam name="URL.code" default="">
	
<table width="100%" cellspacing="0" cellpadding="0">
				
		<cfif list.recordcount eq "0">
		  <cfset url.code = "new">
		</cfif>  
			
	    <tr class="labelheader line">
		   <td>&nbsp;Code</td>
		   <td width="60%">Description</td>
		   <td width="50">Order</td>			  
		   <td width="30" align="center">Active</td>
		   <td colspan="2" align="right">
	       <cfoutput>
			 <cfif URL.code neq "new">
			     <A href="javascript:ColdFusion.navigate('List.cfm?ParentCode=#URL.ParentCode#&Code=new','#url.parentcode#_list')">
				 <font color="0080FF">[add]</font></a>
			 </cfif>
			 </cfoutput>&nbsp;
		   </td>		  
	    </tr>					
				
		<cfoutput>
		
		<cfloop query="List">
					
			<cfset nm  = Description>
			<cfset de  = Code>
			<cfset ls  = ListingOrder>
			<cfset op  = Operational>
																								
			<cfif url.code eq de>		
				
				<tr>
					<td colspan="6">
					
					<cfform action="ListSubmit.cfm?ParentCode=#URL.ParentCode#&code=#url.code#" 
	    			method="POST" 
					name="element">
					
						<table width="100%" align="center">
							<tr>
							   <td>&nbsp;#de#</td>
							   <td>
							   
							   	   <cfinput type="Text" 
									   	value="#nm#" 
										name="Description" 
										message="You must enter a description" 
										required="Yes" 
										size="60" 
										maxlength="60" 
										class="regular">
							  
					           </td>
							   <td height="22">
							   
								   	<cfinput type="Text"
									       name="ListingOrder"
									       value="#ls#"
										   class="regular"
									       validate="integer"
									       required="Yes"
										   message="Please enter an order value" 
									       visible="Yes"
									       enabled="Yes"
									       typeahead="No"
									       size="1"
									       maxlength="2"
										   style="text-align:center">
								   			   
							   </td>
							 
							   <td align="center">
							      <input type="checkbox" name="Operational" value="1" <cfif "1" eq op>checked</cfif>>
							   </td>
							   <td colspan="2" align="right">
								   <input type="submit" 
								        value="Save" 
										class="button10s" 
										style="width:50">&nbsp;
							   </td>
						    </tr>
						</table>
						
					  </cfform>
												
					</td>
				</tr>
															
			<cfelse>								
						
				<tr class="cellcontent linedotted navigation_row">
				   <td>&nbsp;#de#</td>
				   <td height="20">#nm#</td>
				   <td>#ls#</td>
				  
				   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
				   <td align="right"> <cf_img icon="edit" onclick="ColdFusion.navigate('List.cfm?ParentCode=#URL.ParentCode#&code=#de#','#url.parentcode#_list')"></td>
			   			   
				   <cfquery name="Check" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT TOP 1 *
					    FROM  FunctionTitle
						WHERE FunctionClassification = '#de#'							
				   </cfquery>
				   
				   <td align="center" width="20">
				     <cfif check.recordcount eq "0">
					 	<cf_img icon="delete" onclick="ColdFusion.navigate('ListPurge.cfm?parentcode=#url.parentcode#&code=#de#','#url.parentcode#_list')">
					 </cfif>	   
				    </td>
					
				 </tr>					 
						
			</cfif>
						
		</cfloop>
		</cfoutput>
													
		<cfif URL.code eq "new">
			
			<tr>
				<td colspan="7">
							
					<cfform action="ListSubmit.cfm?ParentCode=#URL.ParentCode#&code=new" 
				    method="POST" 
					name="element">
					<table width="100%" align="center">
					
					  <tr>
						<td height="28">&nbsp;
						
							    <cfinput type="Text" 
							         value="" 
									 name="Code" 
									 message="You must enter a code" 
									 required="Yes" 
									 size="2" 
									 maxlength="20" 
									 class="regular">
				        </td>
									   
						    <td>
							   	<cfinput type="Text" 
							         name="Description" 
									 message="You must enter a name" 
									 required="Yes" 
									 size="60" 
									 maxlength="80" 
									 class="regular">
							</td>								 
							<td>
							     <cfinput type="Text" 
							     	 name="ListingOrder" 
									 message="You must enter an order" 
									 required="Yes" 
									 size="1" 
									 style="text-align:center"
									 value="#lst#"
									 validate="integer"
									 class="regular"
									 maxlength="2">
							</td>
							
									
						<td align="center">
							<input type="checkbox" name="Operational" value="1" checked>
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
					  </tr>
					
					</table>
					</cfform>
				</td>
			</tr>
											
		</cfif>								
</table>	
