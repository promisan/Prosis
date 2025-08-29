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

<cfparam name="whs" default="">
						      				 
	<table width="99%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="center">
	
		    <tr class="xhide"><td colspan="4" id="process"></td></tr>							
					
			<TR>
			<TD height="25px" style="padding-left:6px" class="labelmedium"><cf_tl id="Facility">:</TD>
									
			<cfquery name="WarehouseSelect" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   * 
				FROM     Warehouse
				WHERE    Mission = '#URL.Mission#'		
				
				<cfif whs eq "all">	
				AND      Distribution = 1 
				<cfelseif whs neq "">
				AND      Warehouse IN (#preservesinglequotes(whs)#)		
				<cfelse>
				AND      1 = 0						  
				</cfif>		
				
				ORDER BY WarehouseDefault DESC
			</cfquery>
			
			<cfparam name="URL.Warehouse" default="#warehouseselect.warehouse#">
			
			<td>
																		
			<table cellspacing="0" cellpadding="0">
			
			<tr>
			
			<cfif warehouseselect.recordcount eq "1">
			
				<td class="labelmedium">
				#warehouseselect.WarehouseName#
				<input type="hidden" id="warehouse" name="warehouse" value="#warehouseselect.warehouse#">
				</td>
			
			<cfelse>
			
			    <cfif whs eq "all">
				
					<cfif warehouseselect.recordcount gte "4">
					
					   <td>
					   <select name="warehouse" id="warehouse" class="regularxl" 
					      onchange="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Request/Create/RequestEntryDetail.cfm?mode=#url.mode#&mission=#url.mission#&warehouse='+this.value,'main')">
					   <cfloop query="warehouseselect">
					   <option value="#warehouse#" <cfif url.warehouse eq warehouse>selected</cfif>>#WarehouseName#</option>
					   </cfloop>
					   </select>
					   </td>
					
					<cfelse>
					
						<input type="hidden" id="warehouse" value="#url.warehouse#">
				
						<cfloop query="warehouseselect">
						
						<td style="cursor:pointer" class="labelmedium"
						    onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Request/Create/RequestEntryDetail.cfm?mode=#url.mode#&mission=#url.mission#&warehouse=#warehouse#','main')">
						    <input type="radio" name="warehouse" value="#warehouse#" <cfif url.warehouse eq warehouse>checked</cfif>>
						</td>
						<td class="labelmedium" style="padding-left:4px;cursor:pointer;padding-right:14">#WarehouseName#</td>			
						   
						</cfloop>
					
					</cfif>
				
				<cfelse>				
								
					<cfparam name="url.webapp" default="">
					
					<input type="hidden" id="warehouse" value="#url.warehouse#">
						
					<cfloop query="warehouseselect">
					
						<cfif warehouse neq url.warehouse>
						
						<td style="cursor:pointer" class="labelmedium"
						    onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/CheckOut/CartCheckoutContent.cfm?webapp=#url.webapp#&mission=#url.mission#&warehouse=#warehouse#','main')">						
						    <input type="radio" style="height:16px;width:16px" id="warehouse" name="warehouse" value="#warehouse#"></td>
						<td class="labelmedium" style="height:30;padding-left:4px;cursor:pointer;padding-right:14" onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/CheckOut/CartCheckoutContent.cfm?webapp=#url.webapp#&mission=#url.mission#&warehouse=#warehouse#','main')">#WarehouseName#</td>			
						
						<cfelse>
						
						<td class="labelmedium">						
						    <input type="radio" style="height:16px;width:16px" id="warehouse" name="warehouse" value="#warehouse#" checked></td>
						<td class="labelmedium" style="height:30px;padding-left:4px;padding-right:14"><b>#WarehouseName#</td>			
											
						</cfif>
					
					</cfloop>
				
				</cfif>
			
			</cfif>
			
			<td>
			
			</td></tr>
			
			</table>
			
			
			</td>
			</tr>
			
			<TR>
			<TD height="22px" style="padding-left:6px" class="labelmedium"><cf_tl id="Request type"> <font color="FF0000">*</font>:</TD>
								
			<td id="requestypebox">
			
			<cfif url.scope eq "portal">
			
				<!--0 this screen is fully ajax refreshed once a user selects a facility --->
			
				<cfquery name="RequestTypeList" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     Ref_Request P
						WHERE    Operational = '1'	
						AND      Code IN (SELECT RequestType 
						                  FROM   Ref_RequestWorkflowWarehouse 
										  WHERE  Code = P.Code 
										  AND    Warehouse = '#url.warehouse#')
						ORDER BY ListingOrder						
				</cfquery>
			
				<cfif RequestTypeList.recordcount eq "0">
							
					<cfquery name="RequestTypeList" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   * 
							FROM     Ref_Request P
							WHERE    Operational = '1'							
							ORDER BY ListingOrder						
					</cfquery>
						
				</cfif>
								
				<select name="requesttype" id="requesttype" class="regularxl" style="width:328">
					<cfloop query="RequestTypeList">
						<option value="#Code#">#Description#</option>
					</cfloop>
				</select>			
			
			<cfelse>
			
			 <!--- this screen is not refreshed fully so we need to keep the requestype loaded for the ajax effect lower fields --->
												
			 <cfquery name="getInit" 
				 datasource="AppsSystem"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				   SELECT * 
				   FROM   Parameter			 
			 </cfquery>		
				
			 <cfif getInit.VirtualDirectory neq "">						   
			       <cfset lnk = "#getInit.VirtualDirectory#.component">						
			 <cfelse>					   
			   	   <cfset lnk = "component">						
			 </cfif>
			 										
			 <cfselect name="requesttype" 
				   id="requesttype" 
				   value="Code" display="Description"
				   class="regularxl" 
				   style="width:328"
				   bindonload="Yes"
				   bind="cfc:#lnk#.Input.InputDropdown.getStockRequestType({warehouse})"/>
				   
			</cfif>	   
				   			  					
			</td>
			</tr>
			
			<TR id="projectbox" class="hide">
				<TD height="22" style="padding-left:6px" class="labelmedium"><cf_tl id="Purpose"> <font color="FF0000">*</font>:</TD>					
				<td id="projectselect">		
					<cfdiv bind="url:#SESSION.root#/Warehouse/Portal/Checkout/getRequestProject.cfm?mission=#url.mission#&requesttype={requesttype}">		
				</td>
			</tr>				
			
									
			<TR>
				<TD height="22" style="padding-left:6px" class="labelmedium"><cf_tl id="Priority"> <font color="FF0000">*</font>:</TD>						
				<td id="requestaction">		
					<cfdiv bind="url:#SESSION.root#/Warehouse/Portal/Checkout/getRequestAction.cfm?warehouse={warehouse}&requesttype={requesttype}">		
				</td>
			</tr>		
						
			<TR>
			<TD height="22" style="padding-left:6px" class="labelmedium"><cf_tl id="Shipping Mode"> <font color="FF0000">*</font>:</TD>
			<TD>
			
			<cfquery name="ShippingMode" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     Ref_ShipToMode 	
						ORDER BY ListingOrder				
											
			</cfquery>
						
			<select name="shiptomode" id="shiptomode" class="regularxl">
				   
					<cfloop query="ShippingMode">
						<option value="#Code#">#Description#</option>
					</cfloop>					 
					
			</select>	
				   
			</TD>
			</tr>	
								
			<tr>		
				<TD height="22px" style="padding-left:6px" class="labelmedium"><cf_tl id="Due date"> <font color="FF0000">*</font>:</TD>				
				<td>
									
					<cf_intelliCalendarDate8
					FieldName="DateDue" 
					Default=""
					Class="regularxl"
					style="padding-left:4px;color:6688aa"
					AllowBlank="false"> 				
					
				</td>							
			</tr>		
													
			<tr>
			
			<TD height="22px" style="padding-left:6px" class="labelmedium"><cf_tl id="Unit">:</TD>
			<TD>
			
				<table width="528" cellspacing="0" cellpadding="0">
					<tr>
						<td style="padding-right:3px">
			
				 		<cfset link = "#SESSION.root#/warehouse/application/Stock/Transaction/getUnit.cfm?">	
										   
						<cf_selectlookup
						    box          = "unitbox"
							link         = "#link#"
							title        = ""
							icon         = "contract.gif"
							button       = "No"
							close        = "Yes"	
							filter1      = "mission"
							filter1value = "#url.mission#"					
							class        = "organization"
							des1         = "OrgUnit"
							height		 = "430"
							width        = "625">											
									
					</td>				
					
					<td width="97%"  style="padding:0px;border:1px solid silver" id="unitbox" name="unitbox">							
						<cfinclude template="../../../Stock/Transaction/getUnit.cfm">									
					</td>	
					
					<td class="hide">	
					
						<input type="text" 
							    name="orgunit" 
								id="orgunit" 
								size="4" 
								value="#url.orgunit#" 
								class="regular" 
								readonly 
								style="text-align: center;">	
								
							</td>				
									
					</tr>
				</table>
					
			</TD>
			</tr>		
			
			<TR>
			<TD height="22px" style="padding-left:6px" class="labelmedium"><cf_tl id="Contact Person">:</TD>
			<TD>			
						
			   <cfinput type="Text"
			       name="Contact"
			       value="#SESSION.first# #SESSION.last#"
			       validate="noblanks"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
				   class="regularxl"
				   style="padding-left:4px;color:6688aa"
				   message="Please enter you full name"
			       size="40"
			       maxlength="60">
				   
				   </td>
				   
			</tr>
			
			<tr>	   
				   
				   <TD height="22px" style="padding-left:6px" class="labelmedium"><cf_tl id="email">:</TD>
				   <TD>
				
				   <cfinput type="Text"
			    	   name="eMailAddress"
				       value="#client.eMail#"
				       validate="email"
				       required="Yes"
					   message="Please enter you email address"
				       visible="Yes"
				       enabled="Yes"
					   style="padding-left:4px;color:6688aa"
					   class="regularxl"
			    	   size="40"
				       maxlength="40">
					   
				   </TD>
				  			  
			</tr>
						
			<!---
			<tr>		
				<TD height="22px" width="200"><font face="Verdana"><cf_tl id="Special Instructions">:</TD>
				<TD>
				   <table cellspacing="0" cellpadding="0">
				   <tr><td style="padding-left:0px"><input type="text" name="Address1" id="Address1" value="" class="regular" size="100" maxlength="100"></td></tr>
				   <!---
				   <tr><td style="padding-left:0px"><input type="text" name="Address2" id="Address2" value="" class="regular" size="100" maxlength="100"></td></tr>
				   --->
				   </table>
				</TD>
			</tr>
			--->
			
			<input type="hidden" name="Address1" id="Address1" value="">
			
			<TR id="usage">
				<TD height="22px" style="padding-left:6px" class="labelmedium"><cf_tl id="Usage">:</TD>					
				<td id="usageselect">	
				
				<!--- check categories that have supplies defined --->
				
				<!--- check if the cart has a record in category --->
				
				<cfquery name="checkcategory" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
                    FROM   WarehouseCart
				    WHERE  Category is NULL		
				</cfquery>	
				
				<cfquery name="Category" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Category
					WHERE  Category IN ( 
									      SELECT DISTINCT Category 
		                                  FROM   WarehouseCart
										  WHERE  Warehouse = '#url.warehouse#'										  
										)					
					ORDER BY TabOrder			
				</cfquery>	
				
				<cfif Category.recordcount gte "1" and checkCategory.recordcount eq "0">		
				
					<select name="category" id="category" class="regularxl" style="width:328">				   
						<cfloop query="Category">
							<option value="#Category#">#Description#</option>
						</cfloop>					
				    </select>		
									
				
				<cfelse>
				
					<cfquery name="Category" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_Category
						WHERE  Category IN ( 
										      SELECT DISTINCT I.Category 
			                                  FROM   AssetItem AI, Item I
											  WHERE  AI.ItemNo = I.ItemNo
											  AND    AI.Mission = '#url.mission#'
											  AND    AI.AssetId IN (SELECT DISTINCT AssetId 
												                    FROM   AssetItemSupply P																			   
																	WHERE  AI.Assetid = P.Assetid)
											)					
						ORDER BY TabOrder				
					</cfquery>	
					
					<select name="category" id="category" class="regularxl" style="width:328">				   
						<cfloop query="Category">
							<option value="#Category#">#Description#</option>
						</cfloop>
						<option value="">--- any of the above ---</option>
				   </select>	
				
				</cfif>						
				
				</td>
			</tr>							     
			
			<tr>
			<TD height="22px" style="padding-top:3px;padding-left:6px" valign="top" class="labelmedium"><cf_tl id="Remarks">:</TD>
			<TD>
			   <textarea type="text" name="Remarks" id="Remarks" onkeyup="return ismaxlength(this)"	
			    style="font-size:15px;padding-left:4px;color:black;width:98%;height:45;padding:4px" class="regular" totlength="200"></textarea>
			</TD>
	        </tr>
			<tr><td height="6"></td></tr>
			
	 </TABLE>						  

</cfoutput>  