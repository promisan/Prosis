
<!--- based on the WorkOrderItemId determine the items and also associated items as they might have been grouped under the same
workorderlineid for stop to be reallocated 

<cf_screentop banner="Yellow" layout="webapp" html="No" scroll="Yes" label="Earmark stock">

--->

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT  * 
	FROM    WorkOrderLineItem 
	WHERE   WorkorderItemId = '#url.workorderItemId#'	
</cfquery>  

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT  * 
	FROM    WorkOrder W, Customer C 
	WHERE   WorkorderId = '#get.workorderid#'
	AND     W.Customerid = C.CustomerId
</cfquery>  

<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
   method           = "InternalWorkOrder" 
   mission          = "#WorkOrder.Mission#" 
   Table            = "WorkOrderlineItem"
   PointerSale      = "#url.pointersale#"
   workorderid      = "#get.WorkOrderId#"
   workorderline    = "#get.WorkOrderLine#"
   mode             = "view"
   returnvariable   = "NotEarmarked">	 
								
<cfquery name="stock" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT     T.ItemNo,
				   I.ItemDescription,
				   I.Classification,
				   I.ItemPrecision,
				   T.TransactionUoM,
				   U.UoMDescription,	
				   C.StockControlMode,
				   U.ItemUoMId,					
				   T.Location, 
		           WL.Description AS LocationName, 
				   T.TransactionLot, 
				   T.WorkOrderId,
				   (SELECT Reference FROM WorkOrder WHERE WorkOrderId = T.WorkOrderId) as WorkOrderReference,			   
				   T.WorkOrderLine,
				   T.RequirementId,
				   
				   ISNULL(SUM(T.TransactionQuantity), 0) AS Earmarked, 
				   PL.TransactionLotDate, 
				   PL.OrgUnitVendor,
				   PL.TransactionLotSerialNo,
				   (SELECT OrgUnitName 
				    FROM   Organization.dbo.Organization 
					WHERE  OrgUnit = PL.OrgUnitVendor) as OrgUnitName
				   
	    FROM       Materials.dbo.ItemTransaction T INNER JOIN
	               Materials.dbo.WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location INNER JOIN
	               Materials.dbo.ProductionLot PL ON T.Mission = PL.Mission AND T.TransactionLot = PL.TransactionLot INNER JOIN
		           Materials.dbo.Item I ON I.ItemNo = T.ItemNo INNER JOIN
				   Materials.dbo.Ref_Category C  ON C.Category = I.Category INNER JOIN
	               Materials.dbo.ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM
				   
	    WHERE      T.Mission        = '#workorder.mission#' 
		AND        T.Warehouse      = '#url.warehouse#'	
						
		AND        (
		
		<!--- ----------------------------------------------------------- --->
		<!--- get any items that are the same of the sales item directly  --->
		<!--- ----------------------------------------------------------- --->
		
		           (  T.ItemNo = '#get.ItemNo#' 
					  AND T.TransactionUoM = '#get.UoM#' 
					  <cfif url.pointersale eq "0">
					  AND (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#))				  
					  <cfelse>
					  AND (T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#))	
					  </cfif>
				   )  
				   
		<!--- ---------------------------------------------------------------- --->
		<!--- get any items that are associated to the sales item in the stock --->
		<!--- ---------------------------------------------------------------- --->		   
				   
				   <!--- 
				   OR
				   
				   (
				   
				   )
				   
				   --->
				   
				   )
				   	   
				   				                	            
		
		GROUP BY   T.ItemNo,
				   	I.ItemDescription,
				    I.Classification,
					I.ItemPrecision,
				    C.StockControlMode,
					
				   T.TransactionUoM,
				     U.UoMDescription,
				     U.ItemUoMId,		
				   
				   T.Location, 
				     WL.Description,
				   
		           T.TransactionLot, 			    
				     PL.TransactionLotDate, 
				     PL.OrgUnitVendor,
					 PL.TransactionLotSerialNo,  
					 
				   <!--- added 30/12 --->	   				  
				   T.RequirementId,	  
				     T.WorkOrderId,
					 T.WorkorderLine 	 	
				   
		HAVING 	   SUM(T.TransactionQuantity) > 0 	
		
		ORDER BY I.ItemDescription,
		         T.ItemNo,
				 PL.TransactionLotDate,				 
				 U.ItemUomId     					   
			   
</cfquery> 

<form name="earmarkform" 
    action="ShipmentNotEarmarkedSubmit.cfm?warehouse=#url.warehouse#&workorderid=#get.workorderid#&workorderitemid=#url.wokrorderitemid#" method="post">
			
<table width="95%" align="center" class="navigation_table">		

	<tr><td height="3"></td></tr>
	
	<tr><td colspan="9" style="font-size:24px;" class="labelmedium2">Reserve (earmark) stock that is currently not assigned to a workorder to this workorder in order for it to be shipped out.</td></tr>	
	
	<tr><td height="3"></td></tr>
	
	<tr class="line">
		<td colspan="9">

			<table>
			
			<tr> 
			
			     <td class="labelmedium"><cf_tl id="Transaction date">:</td>
				 <td style="padding-left:16px" class="labelmedium">
												
				 <cf_setCalendarDate
				      name     = "transactiondate"        				      
				      font     = "14"
					  edit     = "Yes"
					  class    = "regular"				  
				      mode     = "date"> 
					  
				 </td>				  
				
				 <td style="padding-left:10px" class="labelmedium"><cf_tl id="Reference">:</td>
				
				 <td align="right" style="padding-left:4px;padding-right:10px">			
					<input type="text" name="BatchReference" size="15" maxlength="20" class="regularxl">			
				 </td>
				 
			</tr>
			
			</table>
				  
		</td>	
		
	</tr>		
			
	<cfoutput query="stock">
	
		<cf_precision number="#ItemPrecision#">	
					
		<tr class="labelmedium2 navigation_row line">
			<td colspan="1"></td>
			<td></td>
			<td width="30%" colspan="1" style="padding-left:5px">#ItemDescription# #Classification#</td>
			<td width="14%" colspan="2" style="padding-left:5px">#LocationName#</td>
			
			<td width="10%" class="ccontent labelit line">
						    <cfif workorderreference neq "">
							<a href="javascript:workorderview('#workorderid#')">#WorkorderReference# [#WorkOrderLine#]</a>
							<cfelse>
							free
							</cfif>							
						</td>			
			
			<td width="20%" style="padding-left:5px">
				<cfif transactionlot eq "0">
					no lot
				<cfelse>
					#TransactionLot# #OrgUnitName# [#dateformat(TransactionLotDate,client.dateformatshow)#]
				</cfif>
			</td>									
			<td width="10%" align="right" style="padding-right:10">#numberformat(earmarked,pformat)#</td>
			<td width="6%" align="right" style="border-left:1px solid silver;border-right:1px solid silver;;background-color:ffffaf;">
									
			<cfif StockControlMode eq "Stock">
			
			    <cfset uomid = replace(ItemUoMId,"-","","ALL")>
				
				<!--- we allow now to replenish from different earmarked workorders, correctly back to the workorder at stake --->
				
				<cfset reqid = replace(RequirementId,"-","","ALL")>
								
				<input type= "text" 
				    name   = "earmark_#uomid#_#location#_#TransactionlotSerialno#_#reqid#" 
				    value  = "" 
					class  = "regularxl enterastab" 
					style  = "padding-right:4px;width:97%;border:0px;background-color:ffffaf;text-align:right">					
			
			</cfif>
					
			</td>			
		</tr>		
					
		<cfif StockControlMode eq "Individual">
								
				<!--- Hanno 18/11/2013 attention the below query could well not be the same as the above query for its total, 
				this has to be carefully analyses and then tuned the query to prevent it --->
								
				<cfquery name="getTransaction" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    TransactionId, 
					          ItemNo, 
							  ItemDescription, 
							  TransactionDate, 
							  TransactionReference, 
							  TransactionQuantity,
	                            (SELECT   ISNULL(SUM(TransactionQuantity), 0)
	                             FROM     Materials.dbo.ItemTransaction
	                             WHERE    TransactionidOrigin = T.TransactionId) AS QuantityUsed
					FROM       Materials.dbo.ItemTransaction T
					WHERE      T.Mission        = '#workorder.mission#'
					AND        T.Warehouse      = '#url.warehouse#'
					AND        T.Location       = '#Location#'										
					AND        T.ItemNo         = '#ItemNo#'
					AND        T.TransactionUoM = '#TransactionUoM#' 
					AND        T.TransactionLot = '#TransactionLot#'
					AND        (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#))	<!--- none sale workorders --->
					AND        T.TransactionIdOrigin IS NULL <!--- is a source transaction --->
					
					GROUP BY  TransactionId, 
					          ItemNo, 
							  ItemDescription, 
							  TransactionDate, 
							  TransactionReference, 
							  TransactionQuantity
					
					<!--- transaction was not depleted yet --->
					
					HAVING    TransactionQuantity +
	                              (SELECT     ISNULL(SUM(TransactionQuantity), 0)
	                               FROM       Materials.dbo.ItemTransaction
	                               WHERE      TransactionidOrigin = T.TransactionId) > 0
								   
				
				</cfquery>								
			
				<cfloop query="getTransaction">
				
					<cfset val = TransactionQuantity + QuantityUsed>
					
					<cfif val neq "">
				
					<tr bgcolor="f5f5f5" class="navigation_row_child">
						<td bgcolor="efefef" colspan="5"></td>					
						<td width="9%" class="labelit line" align="right" style="padding-right:10">#TransactionReference#</td>
						<td width="9%" align="right" class="labelit line" style="padding-right:3px">#numberformat(val,pformat)#</td>							
						<td width="9%" align="right" class="line">
						
							<cfset id = replace(transactionid,"-","","ALL")>
							
							<input type="checkbox" 
							 name="earmark_#id#" 
							 value="#numberformat(val,pformat)#" 								
							 style="width:60px;text-align:right">
						  
								
						</td>		
						<td></td>	
					</tr>
					
					</cfif>
							
				</cfloop>
					
			</cfif>			
												
	</cfoutput>
	
	<tr><td colspan="9" class="line"></td></tr>
	
	<tr><td colspan="9" align="center" style="height:40px" id="submitboxearmark">
	
		<cfoutput>
		<input type="button" name="Submit" value="Submit" style="heught:35px;width:240px" class="button10g" 
		  onclick="ptoken.navigate('ShipmentNotEarmarkedSubmit.cfm?warehouse=#url.warehouse#&workorderid=#get.workorderid#&workorderitemid=#url.workorderitemid#&pointersale=#url.pointersale#','submitboxearmark','','','POST','earmarkform')">
		</cfoutput>  
	
		</td>
	</tr>
			
</table>			

</form>

<cfset ajaxonload("doHighlight")>