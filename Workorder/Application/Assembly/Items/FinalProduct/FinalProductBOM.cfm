
<!--- ------------------------------------- --->
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
				 I.ItemNo, 
				 I.ItemDescription,
				 I.Classification,
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

<table width="100%" cellspacing="0" cellpadding="0" >

	<tr>

		<td style="width:50;padding-top:3px" valign="top" class="labelit">
		    <cfoutput>			
			<a href="javascript:editResourceSupply('#ItemFinished.workorderid#','#ItemFinished.workorderline#','#URL.WorkOrderItemId#','','','');" style="color:4E79F2;">[<cf_tl id="Add">]</a>			
			</cfoutput>
		</td>
	
		<td width="90%">
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table"> 
			
				<cfset total = 0>
				
				<cfoutput query="ItemMaterial" group="OrgUnit">
					
					<tr>
						<td colspan="2"></td>
						<td colspan="7" class="labelmediumcl">#OrgUnitName#</td>
					</tr>	
					
					<cfoutput>
					
					<cfif Procurement eq "0">					
						<cfset mode = "edit">
					<cfelse>					
					    <cfset mode = "view">
					</cfif> 	 				 
										
					<tr class="navigation_row labelit">
												
						<td style="width:20px;padding-left:4px;padding-top:3px">	
							
						    <cf_img icon="edit" onclick="editResourceSupply('#ItemFinished.workorderid#','#ItemFinished.workorderline#','#WorkOrderItemId#','#WorkOrderItemIdResource#','#ItemNo#','#UoM#');" navigation="yes">	
							
     					</td>
						
						<td style="width:20px;padding-top:2px;padding-right:5px">		
						
						  <cfif mode eq "Edit">				
							<cf_img icon="delete" onclick="_cf_loadingtexthtml='';deleteResourceSupply('#WorkOrderItemId#','#WorkOrderItemIdResource#','#ItemNo#','#UoM#');">	
						  </cfif>
						  
						</td>
						
						<td colspan="2" width="65%" class="line">#ItemDescription# : #UoMDescription# </td>																						
						<td width="8%"  class="line" align="right">#Quantity#</td>
						<td width="10%" class="line" align="right">#numberformat(Price,",__.__")#</td>
						<td width="10%" class="line" align="right" style="padding-left:10px">#numberformat(Amount,",__.__")#</td>						
						
					</tr>	
					
					<cfif Reference neq "" or Classification neq "">
					
					<tr class="navigation_row_child">
						<td></td>
						<td></td>
						<td>#Reference# #Classification#</td>
						<td colspan="3">#Memo#</td>
					</tr>		
					
					</cfif>
					
					<cfset total = total + amount>		
					
					</cfoutput>
					
				</cfoutput>
				
				<cfoutput>
				
					<tr>
						<td colspan="2"></td>
						<td colspan="7" align="right" class="labelit"><b>#numberformat(Total,",__.__")#</td>
					</tr>	
					
				</cfoutput>	
				
				
			</table>			
		</td>
	</tr>

</table>

<cfset ajaxonload("doHighlight")>