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
<!--- show the BOM for the finished product --->
<!--- ------------------------------------- --->

<cfquery name="ItemFinished" 
		datasource="AppsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    WorkOrderLineItem 
			WHERE	WorkOrderItemId   = '#url.workorderItemId#' 		
</cfquery>

<cfquery name="ItemMaterial" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   IR.WorkorderItemIdResource,
		         IR.OrgUnit,
				 O.OrgUnitName,
								       
		           (SELECT ISNULL(SUM(RequestQuantity), 0)
		            FROM   Purchase.dbo.RequisitionLine
		            WHERE  WarehouseItemNo = IR.ResourceItemNo 
                       AND WarehouseUoM    = IR.ResourceUoM 
					   AND WorkOrderId     = '#ItemFinished.workorderid#' 
  					   AND WorkOrderLine   = '#ItemFinished.workorderline#' 
					   AND ActionStatus   != '9' 
					   AND ActionStatus   >= '1') AS Procurement,				
						
				 IR.Quantity,
				 IR.Price,
				 IR.Amount,
				 IR.Reference,
				 IR.Created,
				 I.ItemNo, 
				 I.ItemDescription,
				 I.Classification,
				 I.ItemClass,
				 U.ItemBarCode,
				 IR.Memo,
				 U.UoM,
				 U.UoMDescription
				
		FROM     WorkOrderLineItemResource IR INNER JOIN 
		         Materials.dbo.ItemUoM U ON IR.ResourceItemNo = U.ItemNo AND IR.ResourceUoM = U.UoM INNER JOIN 
				 Materials.dbo.Item I    ON IR.ResourceItemNo = I.ItemNo LEFT OUTER JOIN 
				 Organization.dbo.Organization O ON IR.OrgUnit = O.OrgUnit 
					 
		WHERE	 IR.WorkOrderItemId = '#URL.WorkOrderItemId#'
		ORDER BY IR.OrgUnit
</cfquery>	

<table width="100%">

	<tr>

		<td style="width:50px;padding-top:3px" valign="top" class="labelmedium2">
		    <cfoutput>			
			<a href="javascript:editResourceSupply('#ItemFinished.workorderid#','#ItemFinished.workorderline#','#URL.WorkOrderItemId#','','','');"><cf_tl id="Add"></a>			
			</cfoutput>
		</td>
	
		<td width="95%">
				
			<table width="100%" class="navigation_table"> 
			
				<cfset total = 0>
				
				<cfoutput query="ItemMaterial" group="OrgUnit">
					
					<tr>
						<td colspan="2"></td>
						<td colspan="8" class="labelmedium2">#OrgUnitName#</td>
					</tr>	
					
					<cfoutput>
					
					<cfif Procurement eq "0">					
						<cfset mode = "edit">
					<cfelse>					
					    <cfset mode = "view">
					</cfif> 	
					
					<cfif itemClass eq "Service">
						<cfset cl = "E3E8C6">
					<cfelse>
						<cfset cl = "white">
					</cfif> 				 
										
					<tr bgcolor="#cl#" class="navigation_row labelmedium2 line">
												
						<td width="15" style="padding-left:4px;padding-top:1px">								
						    <cf_img icon="open" onclick="editResourceSupply('#ItemFinished.workorderid#','#ItemFinished.workorderline#','#WorkOrderItemId#','#WorkOrderItemIdResource#','#ItemNo#','#UoM#');" navigation="yes">								
     					</td>						
						<td style="padding-top:2px">								
						  <cfif mode eq "Edit">				
							<cf_img icon="delete" onclick="_cf_loadingtexthtml='';deleteResourceSupply('#WorkOrderItemId#','#WorkOrderItemIdResource#','#ItemNo#','#UoM#');">	
						  </cfif>						  
						</td>						
						<td width="40%">#ItemDescription#:<font color="6688aa">#UoMDescription#</font> <cfif itembarcode neq ""> / </cfif>#itemBarcode#</td>
						<td width="10%">#Reference#</td>
						<td width="10%">#Classification#</td>						
						<td width="10%" align="right" style="padding-left:3px">#dateformat(created,client.dateformatshow)#</td>																												
						<td width="8%"  align="right">#Quantity#</td>
						<td width="10%" align="right">#numberformat(Price,",.__")#</td>
						<td width="10%" align="right" style="padding-left:10px">#numberformat(Amount,",.__")#</td>	
					</tr>	
					
					<!---
					<cfif Reference neq "" or Classification neq "" or Memo neq "">
					
					<tr class="navigation_row_child">
						<td></td>
						<td></td>
						<td>#Reference# #Classification#</td>
						<td colspan="5">#Memo#</td>
					</tr>				
					
					</cfif>					
					--->	
					
					<cfset total = total + amount>		
					
					</cfoutput>
					
				</cfoutput>
				
				<cfoutput>
				
					<tr class="labelmedium2">
						<td colspan="2"></td>
						<td colspan="7" align="right"><b>#numberformat(Total,",.__")#</td>
					</tr>	
					
				</cfoutput>	
				
				
			</table>			
		</td>
	</tr>

</table>

<cfset ajaxonload("doHighlight")>