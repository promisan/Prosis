
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT  * 
	FROM    WorkOrder W, Customer C 
	WHERE   WorkorderId = '#url.workorderid#'
	AND     W.Customerid = C.CustomerId
</cfquery>  

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="navigation_table"
    style="padding-left:34px;padding-right:34px;border-top:0px dotted silver">

	<tr class="line labelmedium2 fixrow fixlengthlist">
	    <td rowspan="2"></td>
		<td rowspan="2" align="center" style="border-left:1px solid silver"><cf_tl id="Class"></td>
		<td rowspan="2" align="center" style="border-left:1px solid silver"><cf_tl id="Item"></td>
		<td rowspan="2" align="center" style="border-left:1px solid silver"><cf_tl id="UoM"></td>
		<td rowspan="2" align="center" style="border-left:1px solid silver"><cf_tl id="Code"></td>
		<td rowspan="2" align="center" style="border-left:1px solid silver"><cf_tl id="Ordered"></td>
		<td colspan="3" style="background-color:f4f4f4;height:30px;border-bottom:1px solid silver;border-left:1px solid silver" 
		             align="center"><cf_tl id="Available stock"></td>	
		<td rowspan="2" align="center" style="border-left:1px solid silver"><cf_tl id="Shipped"></td>
	</tr>

	<tr class="labelit line fixlengthlist">	   									
		<td align="center" style="border-left:1px solid silver"><cf_tl id="Earmarked"><br><cf_tl id="This Order"></td>		
		<td align="center" style="border-left:1px solid silver"><cf_tl id="Non"><br><cf_tl id="earmarked"></td>
		<td align="center" style="border-left:1px solid silver"><cf_tl id="Earmarked Other"></td>		
	</tr>

<!--- line filtering --->

<td style="padding-left:5px" colspan="9">

	<cfinvoke component = "Service.Presentation.TableFilter"  
	   method           = "tablefilterfield" 
	   filtermode       = "direct"
	   name             = "filtersearch"
	   style            = "font:13px;height:21;width:120"
	   rowclass         = "clsWarehouseRow"
	   rowfields        = "ccontent">
	   
</td>

<!--- get the sales workorder items for each workorderline --->

<cfquery name="getLines" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   * 
	FROM     WorkOrderLine WL  INNER JOIN
			 Ref_ServiceItemDomainClass C ON WL.ServiceDomain = C.ServiceDomain AND WL.ServiceDomainClass = C.Code
	WHERE    WorkorderId = '#url.workorderid#'	
	AND      C.PointerSale = '1'	
	ORDER BY WorkOrderLine
</cfquery>  

<cfoutput query="getLines">

	<tr><td style="height:20"></td></tr>		
			
		<!--- the lines can be supply lines and service lines, however the allocated and shipped always refer to the items that are associated
		to a requirement --->
		
		<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
		   method           = "InternalWorkOrder" 
		   mission          = "#WorkOrder.Mission#" 
		   Table            = "WorkOrderlineItem"
		   workorderid      = "#url.WorkOrderId#"
		   workorderline    = "#WorkOrderLine#"
		   PointerSale      = "0"  
		   Mode             = "view"
		   returnvariable   = "NotEarmarked">	
		   
		<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
		   method           = "InternalWorkOrder" 
		   mission          = "#WorkOrder.Mission#" 
		   Table            = "WorkOrderlineItem"
		   workorderid      = "#url.WorkOrderId#"
		   workorderline    = "#WorkOrderLine#"
		   PointerSale      = "1"  
		   Mode             = "view"
		   returnvariable   = "OtherEarmarked">	   
		  
		<!--- these are the sales requested lines --->		
		
		
		<cfquery name="getDetail" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT   I.WorkOrderItemId, 
				         I.WorkOrderId, 
						 I.WorkOrderLine, 
						 I.ItemNo, 
						 R.ItemPrecision,
						 R.ItemClass,
						 R.ItemDescription, 
						 UoM.UoM,
						 UoM.UoMDescription, 
						 UoM.ItemBarCode,
						 R.Classification, 
						 I.Quantity AS Ordered, 
						 I.Currency, 
						 I.SalePrice,
						 
						 <!--- warehouse has had stock issuances for this item before --->
						 
						 (SELECT     count(*)
			               FROM      Materials.dbo.ItemTransaction T
			               WHERE     T.Mission        = '#workorder.mission#' 			
						   AND       T.Warehouse      = '#url.warehouse#'   
						   <!--- to adjust to allow also similar items to be selected ?? --->
						   AND       T.ItemNo         = I.ItemNo 			   
						   <!--- 18/11 maybe we need to adjust to inherit based on the code and not on the UoM --->
						   AND       T.TransactionUoM = I.UoM 
						   AND       T.TransactionType = '2'
						  ) AS hasIssuances,    
						 
						 <!--- quantities received=1/produced=0/issued=2/transferred=8 and thus earmarked for this FP line in particular workorderline  --->
						 
			             (SELECT     ISNULL(SUM(TransactionQuantity), 0)
			               FROM      Materials.dbo.ItemTransaction T
						   WHERE     T.Mission     = '#workorder.mission#' 	
						   AND       T.Warehouse   = '#url.warehouse#'   
			               AND       RequirementId = I.WorkOrderItemId) AS Earmarked,   						   
						 				 
						 <!--- onhand for NOT earmarked for other Sale workorders for the same requested item --->		
						 				   
			             (SELECT     ISNULL(SUM(TransactionQuantity), 0)
			               FROM      Materials.dbo.ItemTransaction T
			               WHERE     T.Mission        = '#workorder.mission#' 			
						   AND       T.Warehouse      = '#url.warehouse#'   
						   <!--- to adjust to allow also similar items to be selected ?? --->
						   AND       T.ItemNo         = I.ItemNo 			   
						   <!--- 18/11 maybe we need to adjust to inherit based on the code and not on the UoM --->
						   AND       T.TransactionUoM = I.UoM 
						   AND      (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#)) ) AS OtherOnHand,  						   
						 						   
						 <!--- onhand for EARMARKED for other Sale workorders for the same requested item --->		
						 				   
			             (SELECT     ISNULL(SUM(TransactionQuantity), 0)
			               FROM      Materials.dbo.ItemTransaction T
			               WHERE     T.Mission        = '#workorder.mission#' 			
						   AND       T.Warehouse      = '#url.warehouse#'   
						   <!--- to adjust to allow also similar items to be selected ?? --->
						   AND       T.ItemNo         = I.ItemNo 			   
						   <!--- 18/11 maybe we need to adjust to inherit based on the code and not on the UoM --->
						   AND       T.TransactionUoM = I.UoM 
						   AND       T.RequirementId IN (#preserveSingleQuotes(OtherEarmarked)#) ) AS OtherEarmarked,    
						 
						 <!--- quantities issued for this workorder sale line --->  			   
						 
			             (SELECT     ISNULL(SUM(TransactionQuantity*-1), 0)
			               FROM      Materials.dbo.ItemTransaction
			               WHERE     RequirementId = I.WorkOrderItemId AND TransactionType IN ('2','3')) AS Shipped			   
						   
			    FROM     WorkOrderLineItem I INNER JOIN
			             Materials.dbo.Item R ON I.ItemNo = R.ItemNo INNER JOIN
			             Materials.dbo.ItemUoM UoM ON I.ItemNo = UoM.ItemNo AND I.UoM = UoM.UoM INNER JOIN
						 WorkOrder.dbo.WorkOrderLine WL ON I.WorkOrderId = WL.WorkOrderId AND I.WorkOrderLine = WL.WorkOrderLine 
				
				WHERE    I.WorkOrderId   = '#url.workorderid#' 
				AND      I.WorkOrderLine = '#workorderline#'					
				
				ORDER BY I.WorkOrderLine, 
				         R.Classification, 
						 R.ItemDescription, 
						 UoM.UoMDescription
			
		</cfquery>		
			
			
		<cfloop query="getDetail">
		
			<cf_precision number="#ItemPrecision#">
			
			<tr class="labelmedium2 line navigation_row fixlengthlist">
			
			    <td style="padding-left:4px;padding-right:5px;padding-top:1px;height:25px">
				<cf_img icon="open" navigation="Yes" onclick="item('#itemno#','#url.systemfunctionid#','#workorder.mission#')" >
				</td>
				<td>#ItemClass#</td>
			    <td>#ItemNo# #ItemDescription#</td>
				<td>#UoMDescription#</td>
				<td><cfif ItemBarCode neq "">#ItemBarCode#<cfelse>#Classification#</cfif></td>
				<td style="padding-right:3px;border-left:1px solid silver" align="right">#numberformat(ordered,pformat)#</td>
				<td id="#workorderitemid#_earmarked" style="padding-right:3px;border-left:1px solid silver" align="right">#numberformat(earmarked,pformat)#</td>
				<td align="right" bgcolor="FAE7AB" style="padding-right:3px;border-left:1px solid silver">
				
				    <cfif OtherOnHand lte "0">
					
						<table cellspacing="0" cellpadding="0">
							<tr>
							<td class="labelmediumn2" id="#workorderitemid#_onhand"></td>					
							</tr>
						</table>
									
					<cfelse>
					
						<table>
							<tr>
							<td class="labelmediumn2" id="#workorderitemid#_onhand">#numberformat(otheronhand,pformat)#</td>
							<td style="padding-left:4px;padding-right:2px;cursor:pointer" onclick="earmarkstock('#url.warehouse#','#workorderitemid#','0')">
							<img src="#session.root#/images/earmark.gif" alt="" border="0" width="14" height="14">
							</td>
							</tr>
						</table>
					
					</cfif>
					
				</td>
				
				<td align="right" bgcolor="FAE7AB" style="padding-right:3px;border-left:1px solid silver">
				
				    <cfif OtherEarmarked lte "0">
					
						<table cellspacing="0" cellpadding="0">
							<tr>
							<td class="labelmediumn2" id="#workorderitemid#_other"></td>					
							</tr>
						</table>
									
					<cfelse>
					
						<table>
							<tr>
							<td class="labelmediumn2" id="#workorderitemid#_other">#numberformat(otherearmarked,pformat)#</td>
							<td style="padding-left:4px;padding-right:2px;cursor:pointer" onclick="earmarkstock('#url.warehouse#','#workorderitemid#','1')">
							<img src="#session.root#/images/earmark.gif" alt="" width="14" height="14" border="0">
							</td>
							</tr>
						</table>
					
					</cfif>
					
				</td>
				<cfif shipped gte ordered>
				<td align="right" bgcolor="80FF80" style="padding-right:3px;border-left:1px solid silver;padding-right:5px">#numberformat(shipped,pformat)#</td>				
				<cfelse>
				<td style="padding-right:3px;border-left:1px solid silver;padding-right:5px" align="right">#numberformat(shipped,pformat)#</td>				
				</cfif>
				
			</tr>
					
			<!--- now we show whatever is onhand here per workorderlitemid --->		
				
			<tr>
									
				<td colspan="10">	
												
				     <cfif Earmarked gt "0" or (hasIssuances gte "1" and getLines.PointerOverdraw eq "1")>	
					 
					     <cf_getMId>							 						 				 				 
					     <cfdiv id="#workorderitemid#" 
							  bind="url:ShipmentEntryDetailEarmarked.cfm?warehouse=#url.warehouse#&workorderitemid=#workorderitemid#&mid=#mid#">					   				  
							  
					 <cfelse>			 
					
						  <cfdiv id="#workorderitemid#">					  
						  
					 </cfif> 
					 
				</td>
				
			</tr>			
						
		</cfloop>
			
</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>	