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
<cfparam name="URL.Status" default="1">

<cfset url.mode = "request">

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>

<table width="95%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		<cfquery name="Cart" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   WarehouseCart
		WHERE  UserAccount = '#SESSION.acc#'
		</cfquery>
		
		<tr height="20px"><td colspan="3" style="padding-top:2px; padding-bottom:2px">
		
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		
			<cfquery name="WarehouseSelect" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   * 
					FROM     Warehouse
					WHERE    Mission = '#URL.Mission#' 
					AND      Warehouse IN (SELECT Warehouse 
					                       FROM   WarehouseCategory 
			                               WHERE  Operational = 1
										   AND    SelfService = 1)
					AND      Distribution = 1					   
					ORDER BY WarehouseDefault DESC
			</cfquery>
				
			<cfparam name="URL.Warehouse" default="#WarehouseSelect.warehouse#">
				
			<cfif url.warehouse eq "">						
				<cfset url.warehouse = WarehouseSelect.warehouse>							
			</cfif>						
			
			<tr>
			
			<cfoutput>
			
			<td height="26">
			
				<table>
					<tr><td style="padding-top:4px" class="labelit"><cf_tl id="Facility"></td></tr>
					<tr><td style="padding-top:4px">
						<select name="warehouse" 
						        id="warehouse" 
								class="regularxl"
								onchange="ColdFusion.navigate('Requester/CartRequest.cfm?webapp=#url.webapp#&mission=#url.mission#&warehouse='+this.value,'menucontent')">
								<cfloop query="WarehouseSelect">
									    <option value="#Warehouse#" <cfif URL.Warehouse eq Warehouse>selected</cfif>>#WarehouseName#</option>
								</cfloop>
						</select>	
						</td>
					</tr>	
				</table>						
			</td>		
			
			</cfoutput>					
				
			<td align="left" height="26" style="padding-left:0px; padding-top:3px; padding-bottom:3px" valign="middle">
				<table>
				
					<tr><td class="labelit" style="padding-top:4px"><cf_tl id="Search for Products"></td></tr>
					<tr><td style="padding-top:4px">
					
					<table cellspacing="1" cellpadding="1">
						<tr>
						<td>
							<INPUT style="width:150px;" class="regularxl" NAME="find" id="find" onkeyup="search()" TITLE="Enter Criteria" MAXLENGTH="255" VALUE="" >&nbsp;
							<cf_tl id="Search" var="1">
						</td>
						<td>
						<button name="go"
						   id="go"
						   class="button10g"
					       value="#lt_text#"
					       style="height:25; width:35" 
					       onClick="javascript:list('1'); mainmenu('','4'); catsel('','2')">
						  Go
						</button>
						</td>
						</tr>
					</table>
					</td>
					</tr>
				</table>
			</td>		
							
			<cfoutput>		
			
			<input type="hidden"    name="webapp"    id="webapp"   value="#URL.webapp#">
			<input type="hidden"    name="mission"   id="mission"  value="#URL.Mission#">
			<input type="hidden"    name="category"  id="category" value="all">
			
			<cfinvoke component="Service.Presentation.Presentation"
			    method="highlight" class="highlight3"
			    returnvariable="stylescroll"/>
				
			<cfset menu = 4>
								
			<td id="smenu1"	
				name="smenu1"		
				align="center"
				style="cursor:pointer"
				width="120px"
			    onClick="mainmenu('1','#menu#'); cart();"  <!--- catsel('','2') --->
				#stylescroll#>
				
				<cfif cart.recordcount neq "0">
				
				    <cfinclude template="CartStatus.cfm">
					
				</cfif>
									
			</td>					
						
			<cfquery name="Pending" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     top 1 Reference
			FROM       Request R
			WHERE      R.Status IN ('i','1','2','2b')
			  AND      R.OfficerUserId = '#SESSION.acc#'  
			</cfquery>
					
			<cfif Pending.recordcount gte "1">
			
				<td align="center" id="smenu2" name="smenu2" class="labelit" width="130" onclick="mainmenu('2','#menu#'); reqstatus('pending');" #stylescroll#  style="cursor: pointer; padding-top:2px">
				<table cellspacing="0" align="center" cellpadding="0">
					<tr><td align="center"><img src="<cfoutput>#SESSION.root#</cfoutput>/images/view_pending.png"  height="48" align="absmiddle" alt="" border="0"></td></tr>
					<tr><td class="labelit"><cf_tl id="Pending Requests"></td></tr>
				</table>
				</td>
				
				<!--- catsel('','2') --->
			
			</cfif>
			
			<cfquery name="Shipped" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 Reference
				FROM   Request R
				WHERE  R.Status IN ('3')
				AND    R.OfficerUserId = '#SESSION.acc#'  
			</cfquery>
					
			<cfif Shipped.recordcount gte "1">
			
				<td align="center" id="smenu3" name="smenu3" class="labelit" #stylescroll# onclick="mainmenu('3','#menu#');reqstatus('shipped')" width="130"  style="cursor: pointer;">
				<img src="<cfoutput>#SESSION.root#</cfoutput>/images/logos/system/Registration.png" 
				   height="48" 
				   align="absmiddle" 
				   alt="Shipped Orders" 
				   border="0">	<bR>				
				  <cf_tl id="Completed Requests">
				</td>
			
			</cfif>
			
			<!--- update --->
			
			<cfquery name="aDD" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ItemTransactionShipping
						(TransactionId,OfficerUserId,OfficerLastName,OfficerFirstName)
				SELECT  TransactionId, '#SESSION.acc#','#SESSION.last#','#SESSION.first#'
				FROM    ItemTransaction
				WHERE   TransactionType = '2'
				AND     TransactionId NOT IN (SELECT TransactionId FROM ItemTransactionShipping)
			</cfquery>		
					
			<cfquery name="Shipping" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     IT.*
				FROM       ItemTransaction IT INNER JOIN
				           ItemTransactionShipping S ON IT.TransactionId = S.TransactionId INNER JOIN
				           ItemUoM U ON IT.ItemNo = U.ItemNo AND IT.TransactionUoM = U.UoM INNER JOIN
				           Request R ON IT.RequestId = R.RequestId INNER JOIN
				           Item ON IT.ItemNo = Item.ItemNo INNER JOIN
				           RequestHeader H ON R.Reference = H.Reference 
				WHERE      1=1
				<cfif Parameter.UnitConfirmation eq "1">
					AND 		(
					            R.OfficerUserId = '#SESSION.acc#' 
								OR
								H.OrgUnit IN (SELECT OrgUnit 
								              FROM   Organization.dbo.OrganizationAuthorization 
											  WHERE  UserAccount = '#SESSION.acc#'
											  AND    Role = 'ReqClear')   
								)			      
				<cfelse>
					AND 		R.OfficerUserId = '#SESSION.acc#'
				</cfif>				
				AND       (S.ActionStatus = '0' or S.ConfirmationDate > getdate()-1)
			</cfquery>		
			
			
			<cfif Shipping.recordcount gte "1">
							
				<!---catsel('','2') --->
							
				<td align="center" id="smenu4" name="smenu4" class="labelit" width="130" #stylescroll# onclick="mainmenu('4','#menu#');shipstatus('#url.mission#');"  style="cursor: pointer;">
					<img src="<cfoutput>#SESSION.root#</cfoutput>/images/confirm_delivery.png" align="absmiddle"  height="48" alt="" border="0"><br><cf_tl id="Confirm Delivery">				
				</td>
			
			</cfif>		
					
			</cfoutput>
				
			</tr>
		
		</table>
	
	</td></tr>
	
	
	<tr><td height="6"></td></tr>
	
	<tr height="20px">
		<td style="padding-left:19px;padding-right:19px">
					
			<table width="100%" height="100%">
				<tr height="20px">
					
					<td align="left" width="40%" valign="top">
			
						<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" bordercolor="e4e4e4">
						
						    <cfset fav = "5">
							
						  	<cfoutput>
						    <tr><td width="200" height="26" style="padding-left:4px" > 							
							<font face="Verdana" size="2"><cf_tl id="My"><cf_tl id="top">#fav#<cf_tl id="products">&nbsp;
							</cfoutput>
							</td></tr>
							<tr><td height="1" class="linedotted"></td></tr>
							<tr><td>
						
								<cfquery name="top5" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT     TOP #fav# R.ItemNo, R.UoM, 
									           COUNT(*) AS total, I.ItemDescription, UoM.UoMDescription
									FROM       Request R INNER JOIN Item I ON R.ItemNo = I.ItemNo
											   INNER JOIN ItemUoM UOM ON R.ItemNo = UoM.ItemNo AND R.UoM = UoM.UoM
									WHERE      R.OfficerUserId = '#SESSION.acc#'
									AND        R.Warehouse     = '#url.warehouse#'
									
									AND        I.ItemProcessMode = 'Pickticket'
									
									AND        R.Warehouse IN (
									                        SELECT Warehouse
														    FROM   WarehouseCategory 
												            WHERE  Warehouse = R.Warehouse
												     	    AND    Category = I.Category
														    AND    SelfService = 1
															)				   					  
									
									GROUP BY   R.ItemNo, R.UoM, I.ItemDescription,UoM.UoMDescription
									ORDER BY   COUNT(*) DESC
								</cfquery>
							
								<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="left">
								   
								   <tr><td height="1"></td></tr>
									   
								   <cfoutput query="top5">
									    <tr><td height="1" colspan="2"></td></tr>
										<TR>
											<td width="20" align="center"><img src="#SESSION.root#/images/pointer.gif" alt="#ItemDescription#" border="0"></td>
										   	<td height="25" class="regular">
											<A href="javascript:add('#itemno#','#uom#')">#ItemDescription# [#UOMDescription#]</td>
										</TR>					
								   </cfoutput>
								 
								</table> 
							
							</td></tr>
								
						</table>  	
				
								       
					</td>
					
					<td width="60%"
					    align="right"
					    valign="top"
					    style="border-left: 1px dotted Silver;">
						
					    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="right">
					   					        										
							<cfquery name="ProductClass" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   Category,Description
								FROM     #Client.LanPrefix#Ref_Category								
								<!--- show only categories enabled for this warehouse as supplier --->
								WHERE    Category IN (SELECT Category 
								                      FROM   WarehouseCategory C
								                      WHERE  Warehouse = '#url.warehouse#'
													  AND    Operational = 1
													  AND    SelfService = 1
													  AND    Category IN (SELECT DISTINCT Category 
													                       FROM  Item 
																		   WHERE ItemProcessMode = 'Pickticket'
																		   AND   Category = C.Category) )				
							</cfquery>
							
							<cfoutput>
								<input type="hidden" name="searchgroup" id="searchgroup" value="#ProductClass.recordcount#">
							</cfoutput>
							
							<cfoutput>
						    <tr><td width="200" height="26" style="padding-left:4px" > 							
							<font face="Verdana" size="2"><cf_tl id="Product"><cf_tl id="Class">&nbsp;
							</td>
							</tr>
							<tr><td height="1" class="linedotted"></td></tr>
							</cfoutput>
														
							<tr><td>
								
							     <table width="100%" cellspacing="0" cellpadding="0">     		 
						          <cfoutput query="ProductClass">
								  
									  <cfif CurrentRow Mod 2><TR></cfif>
							            <td id="1_#Currentrow#" name="1_#Currentrow#" class="regular" width="5%">
											&nbsp;<img src="#SESSION.root#/images/pointer.gif" align="absmiddle" alt="" border="0">
										</td>
							        	<td class="regular" width="45%"
										    id="2_#Currentrow#" name="2_#Currentrow#" height="16"
										    style="cursor: pointer;padding:2px" class="<cfif currentrow eq 1>highlight</cfif>"
										    onClick="catsel('#Category#','#currentRow#'); mainmenu('','4')">
										    <font face="Verdana" size="2">#Description#</font>
										</td>
							          <cfif CurrentRow Mod 2><cfelse></tr>
										  <cfif CurrentRow neq Recordcount>
											  <tr><td colspan="4" bgcolor="E5E5E5"></td></tr>
										  </cfif>
									  </cfif>
								  
						          </cfoutput>		
								  </table>   
								    
							 </td></tr>	 
							 
						 </table>
						
					</td>		
				</tr>	
			</table>
			
		</td>
	</tr>
				
	<tr><td colspan="4" height="10px" style="padding-top:5px; "><cfdiv id="reqtop"></td></tr>		
		
	<!--- main container --->	
	<tr>
		<td colspan="4" valign="top">
			<cf_divscroll>
			<table cellpadding="0" cellspacing="0" width="100%" height="100%">			
				<tr>
					<td colspan="4" id="reqmain" name="reqmain" valign="top">	
						
			<cfif URL.Mode eq "history">					
			     <cfinclude template="HistoryList.cfm">
			<cfelseif URL.Mode eq "Cart">						
			     <cfinclude template="Cart.cfm">   
			<cfelseif ProductClass.recordcount eq "1">
			     <cfset url.category = ProductClass.category>
				 <cfset url.find = "">
			     <cfinclude template="ItemList.cfm"> 	 
			</cfif>		
					</td>
				</tr>
			</table>
			</cf_divscroll>
		</td>
	</tr>	
		
</table>