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
<cfparam name="url.action"   default="">
<cfparam name="url.serialno" default="">

<cfquery name="get" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT R.*, U.UoMDescription
		  FROM   Request R, ItemUoM	U
		  WHERE  R.RequestId    = '#URL.RequestId#'			 
		  AND    R.ItemNo       = U.ItemNo
		  AND    R.UoM          = U.UoM
</cfquery>

<cfquery name="uom" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     SELECT * 
	     FROM   ItemUoM		 
	     WHERE  ItemNo  = '#get.ItemNo#'	
</cfquery>

<cfquery name="getTaskWarehouse" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Warehouse W		  
	  WHERE  W.Mission = '#get.Mission#'
	  AND    W.Operational = 1
	 
	  		 
	  AND    (
	  
	          Warehouse = '#get.Warehouse#' <!--- itself --->
	  		  
		      OR SupplyWarehouse = '#get.Warehouse#' <!--- children --->
			  
			  OR SupplyWarehouse IN (SELECT Warehouse 
			                         FROM   Warehouse 
									 WHERE  Mission = '#get.Mission#'
									 AND    SupplyWarehouse = '#get.Warehouse#') <!--- children of the children --->								 
			)
			
															 
          <!--- has the requested item --->
	   		  
	   AND    Warehouse IN (   SELECT WL.Warehouse 
		                       FROM   WarehouseLocation WL, ItemWarehouseLocation IWL 
							   WHERE  WL.Warehouse    = W.Warehouse 
							   AND    WL.Warehouse    = IWL.Warehouse
							   AND    WL.Location     = IWL.Location
							   AND    IWL.ItemNo      = '#get.itemno#'	
						       AND    IWL.UoM         = '#get.uom#'	
							   AND    WL.Operational  = 1						   
							   AND    Distribution    = '1' 
						   )							   
					
						   
      ORDER BY WarehouseDefault DESC 						   
</cfquery>
	

<cfset refresh = "0">

<cfif url.action eq "cancel" and url.serialno neq "">
		
	<cfquery name="TaskSetStatus" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      UPDATE RequestTask
			  SET    RecordStatus        = '9', 
			         RecordStatusDate    = getDate(), 
					 RecordStatusOfficer = '#SESSION.acc#'
			  WHERE  RequestId           = '#URL.RequestId#'
			  AND    TaskSerialNo        = '#URL.SerialNo#'
	</cfquery>
			
	<cfset refresh = "1">
	
</cfif>

<cfquery name="TaskedBase" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   RequestTask
		  WHERE  RequestId = '#URL.RequestId#'		 
</cfquery>

<cfquery name="Tasked" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   RequestTask
		  WHERE  RequestId = '#URL.RequestId#'
		  <!--- only valid order lines --->
		  AND    RecordStatus != '9'
		  ORDER BY TaskSerialNo
</cfquery>

<cfif url.serialno neq "">

	<cfquery name="Check" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   RequestTask
		  WHERE  RequestId = '#URL.RequestId#'
		  <!--- only valid order lines --->
		  AND    RecordStatus != '9'
		  AND    TaskSerialNo = '#url.serialno#'
		  ORDER BY TaskSerialNo
	</cfquery>
	
	<cfif check.recordcount eq "0">
		
	    <cfset refresh = "1">
		<cfset url.serialno = tasked.taskserialno>
		
	</cfif>

<cfelse>
  
 
	<cfif tasked.taskserialno gt "1">
		<cfset url.serialno = tasked.taskserialno>	
		<cfset refresh = "1">
	</cfif>	
		
</cfif>

<cfform name="taskorderform" id="taskorderform" style="height:100%">
	
<table cellspacing="0" cellpadding="0" align="left">
												
	<tr>
	
	<cfset percent = "#100/tasked.recordcount#">
						
	<cfoutput query="Tasked">
	
		<td style="padding:2px;border-radius:10px;border:1px solid silver">
		
																		
			<cfif url.serialno eq taskserialno>
			
				<table width="250" cellspacing="0" cellpadding="0" align="center" class="highlight" id="taskbox_#taskserialno#">		
					  
			<cfelse>
			
			    <table width="250" cellspacing="0" cellpadding="0"  align="center" class="regular"  id="taskbox_#taskserialno#">		
								
			</cfif>
												
				<tr bgcolor="d4d4d4">
				    <td colspan="1" class="top3n"
					    height="20" width="90%"
						id="box_#taskserialno#"
						style="padding-left:10px;cursor:pointer" 
						onclick="taskselect('#URL.RequestId#','#taskserialno#','#taskedbase.recordcount#','enforce')">
						<font face="Calibri" size="1">Tasked to:
						
						<cfif TaskType eq "Purchase">
						
							<cfquery name="Source" 
								  datasource="AppsPurchase" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								      SELECT *
								      FROM   Organization.dbo.Organization
									  WHERE  OrgUnit = (SELECT OrgUnitVendor 
									                    FROM   Purchase 
														WHERE  PurchaseNo IN (SELECT PurchaseNo 
														                      FROM   PurchaseLine 
																			  WHERE  RequisitionNo = '#sourceRequisitionno#'))									  
							</cfquery>
							
							<b>#Source.OrgUnitName#
						
						<cfelse>						
												
							<cfquery name="Source" 
								  datasource="AppsMaterials" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								      SELECT *
								      FROM   WarehouseLocation
									  WHERE  Warehouse = '#sourcewarehouse#'
									  AND    Location  = '#sourcelocation#'		  
							</cfquery>
						
							<b>#source.Description#
												
						</cfif>												
						
					</td>		
												
					<td align="right" style="padding-right:2px" class="top3n">
					
						<table cellspacing="0" cellpadding="0" class="formpadding">
						
							<tr>
							
							<td style="padding-top:4px">
							<cfif tasked.recordcount gt "1">
							
								<img src="#SESSION.root#/images/delete5.gif" 
								  height="14" 
								  width="14"
								  onclick="ColdFusion.navigate('TaskViewItem.cfm?action=cancel&serialno=#taskserialno#&requestid=#url.requestid#','taskorder')">
								  
							</cfif>  
							</td>
												
							</tr>
							
						</table>
						
					</td>
				</tr>
				
				<tr><td colspan="2" class="linedotted"></td></tr>
				<tr><td height="3"></td></tr>
				
				<tr>
				<td height="4" colspan="2" id="#taskserialno#box">
				
				<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
				<tr>
				<td colspan="2" style="padding-left:10px" class="labelit">Managed by:</td>
				<td style="padding-left:4px;padding-right:10px" align="right">
								
				<select name="#taskserialno#_warehouse" id="#taskserialno#_warehouse" class="enterastab" style="height:23px;font-size:14px" 
				  onchange="taskedit('#requestId#','#taskserialno#','warehouse',this.value)">
				<cfloop query="getTaskWarehouse">
					<option value="#Warehouse#" <cfif warehouse eq tasked.sourcewarehouse>selected</cfif>>#WarehouseName#</option>
				</cfloop>
				</select>
				
				</td>
				</tr>			
				
				<tr>
				    <td colspan="2" style="cursor:pointer;padding-left:10px" onclick="taskselect('#URL.RequestId#','#taskserialno#','#taskedbase.recordcount#','enforce')" class="labelit">Requested</td>
					<td style="padding-right:10px" align="right">
						<table cellspacing="0" cellpadding="0">
							<tr>
							<td style="padding-right:5px" class="labelit">#get.uomDescription#</td>
							<td>
							   <input type="text" 
								   name="#taskserialno#_quantity" 
								   id="#taskserialno#_quantity" 
								   value="#TaskQuantity#"
							       size="2" 
								   class="regularh enterastab" 
								   maxlength="5" 
								   style="width:70;text-align: right;"					  
							       onchange="taskedit('#requestId#','#taskserialno#','quantity',this.value)">		
							</td>   
							</tr>
						</table> 					
					</td>									
				</tr>
				
				<tr>
					
				    <td colspan="3" align="right" style="padding-left:10px">
					
						<table width="100%" cellspacing="0" cellpadding="0">
						<tr>
						<td style="cursor:hand" onclick="taskselect('#URL.RequestId#','#taskserialno#','#taskedbase.recordcount#','enforce')" style="padding-left:20px"  class="labelit">Task&nbsp;as</td>				
							
							<td align="left" width="200" style="padding-left:1px;padding-right:2px">	
							
							<table cellspacing="0" cellpadding="0">	
							<tr>
							
								<cfloop query="uom">
								
								<cfset ch = "">
								
								<cfif tasked.taskuom eq "">
									<cfif uom eq get.uom>
										<cfset ch = "checked">
									</cfif>
								<cfelse>
									<cfif uom eq tasked.taskuom>
										<cfset ch = "checked">
									</cfif>
								</cfif>	
												
								<td>
								<input type="radio" name="#tasked.taskserialno#_taskuom" value="#uom#" #ch# onclick="taskedit('#Tasked.requestId#','#Tasked.taskserialno#','taskuom','#uom#')" class="enterastab" >	
								</td>
								<td style="padding-left:2px" class="labelit">
								#UoMdescription#
								</td>
																					
								</cfloop>				
							</tr>
							
							</table>
														
							
							</td>
												
						
					
					<td id="box_#taskserialno#_taskquantity" style="padding-right:10px" style="border:0px solid silver" align="right">
						   
						   #numberformat(TaskUoMQuantity,'__._')#
						   
						   <input type="hidden" name="#taskserialno#_taskquantity" id="#taskserialno#_taskquantity" value="#numberformat(TaskUoMQuantity,'__._')#" class="enterastab" 
					        readonly>		
					</td>   
					
					</tr>
						</table> 
						
					</td>		
				
				</tr>
				
				<tr>
				  <td height="20" style="cursor:pointer;padding-left:10px" onclick="taskselect('#URL.RequestId#','#taskserialno#','#taskedbase.recordcount#','enforce')" class="labelit">Destination:</td>
				  <td style="padding-right:10px" width="80%" colspan="2" align="right">
				  
				  <!--- allow to change to any warehouse where the original requester has access to --->
				  
				  <cfquery name="Warehouse" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT *
					      FROM   Warehouse
						  WHERE  Mission   = '#get.Mission#'
						  AND    Operational = 1		
						  <cfif getAdministrator(get.mission) eq "1">
	
						  <!--- no filtering --->

						  <cfelseif get.ShipToWarehouse neq "">
						  
						  AND    (
						  			MissionOrgUnitId IN
						  
									  (
									  SELECT DISTINCT O.MissionOrgUnitId
									  FROM   Organization.dbo.OrganizationAuthorization OA INNER JOIN
						                     Organization.dbo.Organization O ON OA.OrgUnit = O.OrgUnit 
									  WHERE  (OA.UserAccount = '#get.OfficerUserId#') 
									  AND    (OA.Role        = 'WhsRequester')
									  )
						  
						  		   OR
								   						  	
						  		   Warehouse = '#get.ShipToWarehouse#'	
								   
						         )
								 
						  </cfif>	 
															 						
													  
					</cfquery>
					
					<select name="#taskserialno#_shiptowarehouse" id="#taskserialno#_shiptowarehouse"
					    style="height:23px;font-size:14px" class="enterastab" 
						onchange="taskedit('#requestId#','#taskserialno#','shiptowarehouse',this.value)">
						<cfloop query="Warehouse">
						<option value="#Warehouse#" <cfif warehouse eq tasked.shiptowarehouse>selected</cfif>>#WarehouseName#</option>
						</cfloop>
					</select>					  					  
				  
				  </td>
				</tr>	
					
				<tr>
				  <td height="20" colspan="2" style="padding-left:10px"  class="labelit">Delivery&nbsp;by:</td>
				  <td align="right" style="padding-right:10px">	
				 
				 <cf_space spaces="36">
				 
				  <cf_intelliCalendarDate8
					  FieldName  = "#taskserialno#_shiptodate" 
					  Manual     = "True"	
					  class      = "regularxl enterastab"																									
					  Default    = "#dateformat(shiptodate,CLIENT.DateFormatShow)#"
					  AllowBlank = "False">	 
				
				  	  <!--- trigger a script to be run from the date picker ---> 		
					  <cfajaxproxy bind="javascript:taskedit('#requestId#','#taskserialno#','shiptodate',{#taskserialno#_shiptodate})">			
				  														  			  
				  </td>
				</tr>
				
				<tr>
				  <td colspan="2" height="20" style="padding-left:10px"  class="labelit">Mode&nbsp;of&nbsp;Supply:</td>
				  <td style="padding-right:10px" align="right">
				  
				  					
					<select name="#taskserialno#_shiptomode" id="#taskserialno#_shiptomode" class="enterastab" 
					    style="height:23px;font-size:14px"
						onchange="taskedit('#requestId#','#taskserialno#','shiptomode',this.value)">
						
						 <cfquery name="ShipTo" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						      SELECT *
						      FROM   Ref_ShipToMode		
							  ORDER BY ListingOrder				 				 						
						</cfquery>
						
						<cfloop query="shipto">
							<option value="#code#" <cfif code eq tasked.shiptomode>selected</cfif>>#Description#</option>						
						</cfloop>
						
					</select>					  					  
				  
				  </td>
				</tr>	
				
				<tr>	
					<td colspan="2" height="20" style="padding-left:10px"  class="labelit">Estimated&nbsp;value:</td>
					<td id="#taskserialno#_taskvalue" style="padding-right:10px" align="right" class="labelmedium">
					<font size="1">					
					#TaskCurrency#</font> #numberformat(TaskAmount,'__,__.__')# 
						<cfif taskcurrency neq APPLICATION.BaseCurrency>
							(#numberformat(TaskAmountBase,'__,__.__')# )
						</cfif>			
					
					</td>
				</tr>														
								
				</table>
				
				</td>
				</tr>
			
			</table>
						
		</td>
	
	</cfoutput>
	
	<td width="5%"></td>
			
	</tr>
			
</table>

</cfform>

<cfoutput>

<cfif refresh eq "1">
    <script language="JavaScript">	  	    
	  taskselect('#URL.RequestId#','#url.serialno#','#taskedbase.recordcount#','enforce')
	</script>
</cfif>


</cfoutput>