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
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkOrderId = '#url.WorkOrderId#'			
</cfquery>

<cfquery name="line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ServiceItemDomainClass R INNER JOIN
                WorkOrderLine WL ON R.ServiceDomain = WL.ServiceDomain AND R.Code = WL.ServiceDomainClass
		WHERE   WorkOrderId = '#url.WorkOrderId#'			
		AND     WorkOrderLine = '#url.workorderline#'
</cfquery>

<cfquery name="ItemFinished" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT  WO.Mission,
				WOL.WorkOrderItemId, 
				WOL.BillingMode,
				I.ItemNo, 
				I.ItemColor,
				I.Classification,
				I.ItemDescription,
				U.UoM, 
				U.UoMDescription, 
				WOL.Quantity, 
																
				(SELECT   ISNULL(SUM(TransactionQuantity), 0) 
				 FROM     Materials.dbo.ItemTransaction
				 WHERE    WorkOrderId    = WOL.WorkOrderId
				 AND      WorkOrderLine  = WOL.WorkOrderLine					 
				 AND      RequirementId  = WOL.WorkOrderItemId
				 AND      TransactionType != '2'
				) as Earmarked,  <!--- quantity received or quantity internally produced for this workorder --->
				
				( 
				 SELECT   ISNULL(SUM(TransactionQuantity*-1), 0) 
				 FROM     Materials.dbo.ItemTransaction
				 WHERE    WorkOrderId    = WOL.WorkOrderId
				 AND      WorkOrderLine  = WOL.WorkOrderLine	
				 AND      RequirementId  = WOL.WorkOrderItemId	 
				 AND	  TransactionType IN ('2','3')  <!--- 10/3/2013 removed the '8' from the transaction type --->				
				) as Shipped, <!--- quantity shipped to customer --->
								
				WOL.Currency, 
				WOL.SalePrice, 
				WOL.SaleAmountIncome, 
				WOL.SaleAmountTax, 
				WOL.SalePayable, 
				WOL.Created
				
		FROM    WorkOrderLineItem WOL INNER JOIN Materials.dbo.Item I    ON WOL.ItemNo = I.ItemNo 
									  INNER JOIN Materials.dbo.ItemUoM U ON WOL.ItemNo = U.ItemNo AND WOL.UoM = U.UoM
						 			  INNER JOIN WorkOrder WO ON WOL.WorkOrderId = WO.WorkOrderId
		
		WHERE	WOL.WorkOrderId   = '#url.workorderid#' 
		AND     WOL.WorkOrderLine = '#url.workorderline#'
		
	    ORDER BY I.Classification, I.ItemDescription, U.UoMDescription
</cfquery>

<cfif get.ActionStatus eq "1" or get.ActionStatus eq "0">
	<cfset mode = "edit">
<cfelse>
	<cfset mode = "view">
</cfif>

<cfoutput>

<table width="100%" class="formpadding">

  <tr><td height="5"></td></tr>	
  
  <tr bgcolor="E6E6E6"><td class="labellarge" style="height:30px;padding-left:8px"><cf_tl id="Transfer and earmark"></td></tr>
  
  <tr><td height="5"></td></tr>
    
  <tr class="fixrow"><td id="boxtransferto">
  
  	  <cfset url.mission = get.Mission>
	  <cfinclude template="setWarehouseTo.cfm">
	  
	  </td>
  </tr>
      			  
  <tr><td>
			
	<table width="100%" class="navigation_table">		
		
		<tr>
			<td style="padding:3px;" height="100%">
			
				<table width="100%">			
				
					<tr class="labelmedium2 line fixlengthlist">
					
						<td></td>
						<td></td>
						<td><cf_tl id="Code"></td>
						<td><cf_tl id="Description"></td>		
						<td><cf_tl id="Color"></td>							
						<td><cf_tl id="UoM"></td>					
						<td align="right"><cf_tl id="Sales Order"></td>													
						<td style="cursor:pointer" align="right" title="Available earmarked stock"><cf_tl id="Earmarked"></td>
						<cfif line.pointerSale eq "1">
							<td align="right"><cf_tl id="Shipped"></td>
						<cfelse>
							<td align="right"><cf_tl id="Freed"></td>
						</cfif>
						<td align="right"><cf_tl id="Pending"></td>
						
					</tr>					
																					
					<cfloop query="ItemFinished">
					
						<cfset bal = quantity-shipped>
													
						<tr class="navigation_row line labelmedium2 fixlengthlist" style="height:25px">
						
							<td align="center">							    
								
								<cfif mode eq "edit">
								
									<cfif bal gt 0>	
									<input type="radio" class="radiol" name="selectline" value="#workorderitemid#">
									</cfif>
																		
								</cfif>	
															
							</td>		
							
							<td>#currentrow#.</td>					
							<td>#Classification#</td>
							<td>#ItemDescription#</td>
							<td>#ItemColor#</td>
							<td>#uoMDescription#</td>																															
							<td style="background-color:##A8EFF250" align="right">#numberformat(Quantity,'__')#</td>																
							<td align="right" style="background-color:##ffffcf80">
							
								<table width="100%">
									
										<tr class="labelmedium2">																		
										<td width="20" style="padding-left:5px">										
										<cf_img icon="expand" 
												   id="ear_#WorkOrderItemId#" 
												   toggle="Yes" 
												   onclick="toggleobjectbox('earmarkbox_#WorkOrderItemId#','earmark_#WorkOrderItemId#','Items/FinalProduct/getDetailLines.cfm?WorkOrderId=#URL.WorkOrderId#&drillid=#WorkOrderItemId#')"
												   tooltip="See outsourcing for this quote.">										
										</td>																			
										<td align="right">#numberformat(Earmarked,'__')#</td>												
										</tr>
								
								</table>		
							
							</td>
														
							<cfif BillingMode eq "None">
							
								<td align="right" colspan="2"></td>
								
							<cfelse>
								<td align="right" style="background-color:##e1e1e180">#Shipped#</td>																
								<cfif bal gt 0>
								<td style="background-color:##ffffaf80" align="right">#bal#</td>
								<cfelse>
								<td bgcolor="white" align="right">
								<img src="#session.root#/images/check_icon.gif" width="18" height="18" alt="Completed" border="0">
								</td>
								</cfif>
								
							</cfif>
							
						</tr>																					
						
						<tr id="earmarkbox_#workorderitemid#" class="hide">
						    <td></td>
						    <td colspan="9" id="earmark_#WorkOrderItemId#"></td>													
						</tr>										
																						
					</cfloop>
					
					<tr class="line">					
					<td align="center" style="height:26"><input type="radio" class="radiol" name="selectline" value="" checked></td>					
					<td colspan="9" class="labelmedium"><cf_tl id="Do not change earmark"></td>										
					</tr>					
									
				</table>
				
			</td>
		</tr>
						
	</table>
	
	</td>
	</tr>
	
</table>

</cfoutput>

<cfset AjaxOnLoad("doHighlight")>