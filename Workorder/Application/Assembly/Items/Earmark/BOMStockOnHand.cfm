
<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Warehouse
    WHERE     Warehouse = '#url.warehouse#'    									  
</cfquery>

<cfquery name="Workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Workorder
    WHERE     WorkorderId = '#url.workorderid#'    									  
</cfquery>
						
<cfquery name="Line" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrderLine WL LEFT OUTER JOIN
                   Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
	WHERE    WL.WorkOrderId   = '#url.workorderid#' 
	AND      WL.WorkOrderLine = '#url.workorderline#'
</cfquery>		

	<cfset show = 0>

<!---
<form name="collectionform" id="collectionform">
--->
	
	<table width="96%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
		<tr><td height="10"></td></tr>
		<tr class="labelit">
			
			<td style="height:20px"><cf_tl id="No"></td>			
			<td><cf_tl id="ItemName"></td>
			<td><cf_tl id="Classification"></td>
			<td><cf_tl id="UoM"></td>			
			<td width="100" style="padding-right:12px" align="right"><cf_tl id="Required"></td>	
			<td width="100" colspan="2" bgcolor="yellow" style="border:1px solid silver;padding-left:8px" style="padding-right:12px" align="center"><cf_tl id="Collection"></td>			
			<td colspan="3" align="center" width="100" bgcolor="B9FFB9"  style="border:1px solid silver;padding-left:8px"><cf_tl id="Available for collection in"><cfoutput><b>#warehouse.warehousename#</cfoutput></td>
						
		</tr>
	
		<tr>
			
			<td class="labelit line"></td>
			<td class="labelit line"></td>
			<td class="labelit line"></td>
			<td class="labelit line"></td>
			
			<td width="100" class="labelit line" align="right"></td>				
			<td width="100" align="center" bgcolor="ffffbf" class="labelit line" style="border-bottom:1px solid silver;border-left:1px solid silver;;padding-left:5px" align="right"><cf_tl id="Calculated"></td>		
			<td width="100" align="center" bgcolor="ffffbf" class="labelit line" style="border-bottom:1px solid silver;border-left:1px solid silver;;padding-left:5px" align="right"><cf_tl id="Actual"></td>				
			<td width="100" align="center" bgcolor="B9FFd9" class="labelit" style="border-bottom:1px solid silver;border-left:1px solid silver;padding-left:8px"><cf_tl id="Earmarked"></td>				
			<td width="100" align="center" bgcolor="B9FFd9" style="border-bottom:1px solid silver;border-left:1px solid silver;;padding-left:5px" class="labelit"><cf_tl id="Not Earmarked"></td>			
			<td width="100" align="center" bgcolor="B9FFd9" style="border-bottom:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;padding-left:5px;" class="labelit"><cf_tl id="Total"></td>
			
		</tr>	
		
		   <!--- obtain a query content #url.pointersale# --->
											
			<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
			   method           = "InternalWorkOrder" 
			   mission          = "#WorkOrder.Mission#" 
			   workorderid      = "#url.WorkOrderId#"
		       workorderline    = "#url.WorkOrderLine#"
			   Table            = "WorkOrderLineResource"  
			   PointerSale      = "#url.pointersale#" <!--- pass from the resource, maybe we have to widen this --->
			   mode             = "view"
			   returnvariable   = "NotEarmarked">	
		   
				<cfquery name="getStock" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					
					SELECT     WIR.WorkOrderId,
					           WIR.WorkOrderLine, 
							   WIR.ResourceId,
							   WIR.ResourceItemNo, 					  
							   I.ItemDescription, 
							   I.Classification,
							   I.ItemClass,
							   I.Category,
							   C.Description,
							   I.ItemPrecision,					   
							   WIR.ResourceUoM, 
							   UoM.UoMDescription, 					  
							   SUM(WIR.Quantity) AS Quantity, 
							   							   
							   (
							    
								SELECT    ISNULL(SUM(CalculatedConsumption),0) AS CalculatedConsumption
	                       
								FROM      (SELECT     WL.WorkOrderId, 
								                      WL.WorkOrderLine, 
													  WLI.WorkOrderItemId, 
													  WLI.ItemNo, 
													  WLI.UoM, 
													  WLI.Quantity AS QuantityRequested,
													  
													  <!---
													  
		                                                  (SELECT    ISNULL(SUM(TransactionQuantity * - 1), 0)
		                                                    FROM     Materials.dbo.ItemTransaction
		                                                    WHERE    RequirementId = WLI.WorkOrderItemId AND TransactionType IN ('2','3')) AS QuantityShipped, 
															
													  --->
																	
													  WLIR.ResourceItemNo, 
													  WLIR.ResourceUoM, 
				                                      WLIR.Quantity AS QuantityNeed,
													  
				                                      (SELECT  ISNULL(SUM(TransactionQuantity), 0)
				                                       FROM    Materials.dbo.ItemTransaction
				                                       WHERE   RequirementId = WLI.WorkOrderItemId 
													   <!--- excluded shipped and return transactions.\,  
													   we determine the total generated and transferred and apply the ratio to the requirement 
													   for BOM --->
													   AND     TransactionType NOT IN ('2','3')) / WLI.Quantity * WLIR.Quantity AS CalculatedConsumption
															 
					                       FROM       WorkOrder W INNER JOIN
				    	                              WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
				                                      WorkOrderLineItem WLI ON WL.WorkOrderId = WLI.WorkOrderId AND WL.WorkOrderLine = WLI.WorkOrderLine INNER JOIN
				                                      WorkOrderLineItemResource WLIR ON WLI.WorkOrderItemId = WLIR.WorkOrderItemId
				        	               WHERE      WL.WorkOrderId   = '#url.workorderid#' 
										   AND        WL.WorkorderLine = '#url.workorderline#'
										   ) FP					   
										   
							    WHERE   FP.WorkorderId    = WIR.WorkorderId
							    AND     FP.WorkorderLine  = WIR.WorkOrderLine
							    AND     FP.ResourceItemNo = WIR.ResourceItemNo
							    AND     FP.ResourceUoM    = WIR.ResourceUoM ) as Calculated,						   											   				  
							   
							   <!--- already issued for this requirement --->				   
							   
							   (
							    
								SELECT   ISNULL(SUM(TransactionQuantity*-1), 0)
					            FROM     Materials.dbo.Itemtransaction
					            WHERE    Mission         = '#workorder.mission#'  <!--- ANY warehouse --->								
								
								<cfif line.PointerStock eq "1">									
								
								  AND    RequirementId   = WIR.ResourceId								  
								  
								<cfelse>	
															
								  <!--- same item as required --->
								  AND    ItemNo          = WIR.ResourceItemNo 
					              AND    TransactionUoM  = WIR.ResourceUoM								 
								  
								</cfif> 				
								
								 AND     TransactionType = '2' <!--- any status --->
								 AND     WorkOrderId     = WIR.WorkOrderId 
								 AND     WorkOrderLine   = WIR.WorkOrderLine) AS Consumed,		
								 					
					           <!--- earmarked for workorder of the BOM requirement to be reviewed if
								   we take here only the resourceid insteead of the mapping of the item
								   itself which would give a bit more flexibility as we could have different
								   items earmarked --->	
									       											   
							   (SELECT  ISNULL(SUM(TransactionQuantity), 0)
					            FROM    Materials.dbo.Itemtransaction
					            WHERE   Mission         = '#workorder.mission#' 
								AND     Warehouse       = '#url.warehouse#' 
								AND     WorkOrderId     = WIR.WorkOrderId 
								AND     WorkOrderLine   = WIR.WorkOrderLine
								AND     RequirementId   = WIR.ResourceId
		
								<!--- more correct to use the resourceid as per above as it is more robust for the case we receive variations of the item
								in RI Hanno or in earmarking 28/11
								
								AND      ItemNo         = WIR.ResourceItemNo 
								AND      TransactionUoM = WIR.ResourceUoM  		
								--->
								
								<!--- confirmed --->
								AND    (
									     (ActionStatus   = '1' AND TransactionType NOT IN ('2','8')) 
									                       OR
									     (ActionStatus  IN ('0','1') AND TransactionType IN ('2','8'))
									   )							   
								)  AS Earmarked,
								
							  <!--- not earmarked or earamrked to a none sale workorder --->		
							  
							  ( SELECT  ISNULL(SUM(TransactionQuantity),0)
					            FROM    Materials.dbo.Itemtransaction T
					            WHERE   Mission        = '#workorder.mission#' 
								AND     Warehouse      = '#url.warehouse#'
								
								<!--- to be adjusted to show also related items already here ? 28/11 --->
								
								<cfif line.PointerStock eq "1">		
				
								AND       T.ItemNo IN (
								                       SELECT ItemNo 
										               FROM   Materials.dbo.Item 
													   WHERE  (ParentItemNo	= I.ParentItemNo or ItemNo = WIR.ResourceItemNo)
														) 
														 
								<cfelse>	
									
								AND       T.ItemNo =  WIR.ResourceItemNo	
								
								</cfif>			
																										
					            AND       T.TransactionUoM = WIR.ResourceUoM
								
							   <!--- confirmed --->
								AND    (
									     (ActionStatus   = '1' AND TransactionType NOT IN ('2','8'))   <!--- confirmed --->
									                       OR
									     (ActionStatus  IN ('0','1') AND TransactionType IN ('2','8'))  <!--- we take them proactively --->
									   )		
								
								<!--- not earmarked for this workorder or 
								                   earmarked to a production workorder --->
									   
								AND    (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(notEarmarked)#))
								
								
								     ) AS NotEarmarked																
								   														   										
						FROM         WorkOrderLineResource WIR INNER JOIN
					                 Materials.dbo.Item I ON WIR.ResourceItemNo = I.ItemNo   INNER JOIN
									 Materials.dbo.Ref_Category C ON I.Category = C.Category INNER JOIN
					                 Materials.dbo.ItemUoM UoM ON WIR.ResourceItemNo = UoM.ItemNo 
									                          AND WIR.ResourceUoM = UoM.UoM 
					
					    <!--- get all resource lines --->
						WHERE        WIR.WorkOrderId   = '#url.workorderid#' 
						AND          WIR.WorkOrderLine = '#url.workorderline#'
						AND          I.Category        = '#url.category#'
						
						AND          I.ItemClass = 'Supply'
						AND          WIR.ResourceMode != 'NONE'
						
						<!--- not needed as items in the requirement are not duplicated by the generating method --->
						
						GROUP BY     WIR.WorkOrderId, 
						             WIR.WorkOrderLine, 
									 WIR.ResourceItemNo, 
									 WIR.ResourceUoM,				 
									 WIR.ResourceId,							
									 I.ItemDescription, 
									 I.ItemClass,
									 I.Classification,
									 I.Category,	
									 I.ParentItemNo,
									 C.Description,	
									 I.ItemPrecision,		 
									 UoM.UoMDescription		
									 
						ORDER BY I.Category			
																				
				</cfquery>
				
				
<!---		

				<cfoutput>#preserveSingleQuotes(notEarmarked)#</cfoutput>
				
				--->
				
				

		<cfoutput>
		
			<input type="hidden" name="ResourceId" value="#quotedValueList(getStock.ResourceId)#">
			
		</cfoutput>
				
		<cfoutput query="getStock" group="Category">
		
			<tr><td colspan="10" class="line labelmedium" style="height:40px;font-weight:200;font-size:22px;padding-top:5px">#Description#</td></tr>
					
			<cfoutput>			
										
				<cf_precision number="#ItemPrecision#">
			
				<tr style="height:24" class="navigation_row labelmedium">
				    <td style="padding-left:3px;padding-right:4px" class="line">#ResourceItemNo#</td>			    
					<td class="line">#ItemDescription#</td>
					<td class="line">#Classification# </td>
					<td class="line">#UoMDescription#</td>
					<td class="line" style="border-left:1px solid silver;;padding-left:5px;padding-right:3px;" align="right">#numberformat(Quantity,pformat)#</td>
					<td class="line" style="border-left:1px solid silver;;padding-right:8px;" align="right">#numberformat(Calculated,pformat)#</td>									
					<td class="line" style="border-left:1px solid silver;;padding-right:8px;" align="right"><cfif Consumed gt Calculated><font color="FF0000"></cfif>#numberformat(Consumed,pformat)#</td>				
					
					<td class="line" bgcolor="B9FFB9" style="border-left:1px solid silver;;padding-left:5px;padding-right:3px;" align="right">#numberformat(Earmarked,pformat)#</td>								
					<td class="line" bgcolor="B9FFB9" style="border-left:1px solid silver;;padding-left:5px;padding-right:3px;" align="right">#numberformat(NotEarmarked,pformat)#</td>				
					<cfset total = Earmarked+NotEarmarked>				
					<td class="line" bgcolor="B9FFB9" style="border-left:1px solid silver;;padding-left:5px;padding-right:3px;width:100;padding-right:4px" align="right">#numberformat(total,pformat)#</td>								
				</tr>						 
			
						
			    <cfif Earmarked gt 0 or notEarmarked gt "0" or Line.PointerOverDraw eq "1">
				
				<cfset show = "1">
			
				<tr>
				<td colspan="10">	
				
				     <cfset missing = calculated-consumed>
				     <!--- now we show the stock we have for each BOM item to be selected --->
				  
				     <cfdiv  id="#resourceid#" 
					  bind="url:#session.root#/workorder/Application/Assembly/Items/Earmark/BOMStockOnHandDetail.cfm?warehouse=#url.warehouse#&resourceid=#resourceid#&missing=#missing#&pointersale=#url.pointersale#">	
					  					  					  
					 </cfdiv> 				   
				</td>
				
				</tr>
								
			    </cfif>
							
			</cfoutput>
		
		</cfoutput>
		
		<cfif show eq "1">
		
			<tr><td colspan="10" style="padding-top:4px;height:35">
			
			<cfoutput>
	
				<table class="formspacing" align="right">
				
					<tr><td colspan="2" class="labelit" id="process"><!--- cotentbox for processing stock ---></td></tr>
					
					<tr>
										
					<cfif url.mode eq "FinalProduct">
					
						<td id="reserve" class="hide">
						
						  <!--- transfer --->	
						
						 <cf_tl id="Earmark" var="tEarmark">
						 <cf_tl id="Transfer stock" var="tTransferWorkOrder">
						 <cf_tl id="Destination" var="vDestination">
						 
						  <input type="button" 
							  style="width:240;height:28;font-size:12" 
							  onclick= "try { ColdFusion.Window.destroy('dialogdestination',true)} catch(e){};ColdFusion.Window.create('dialogdestination', '#vDestination#', '',{x:200,y:100,height:280,width:450,resizable:false,modal:true,center:false});ColdFusion.navigate('#SESSION.root#/Workorder/Application/Assembly/Items/Earmark/dialogBOMDestination.cfm?mode=#url.mode#&action=8&workorderid=#url.workorderid#&workorderline=#workorderline#&warehouse=#url.warehouse#&category=#url.category#&pointersale=#url.pointersale#','dialogdestination')"					  
							  value=" #tEarmark# / #tTransferWorkOrder#" 		  
							  class="button10g">
									  
						</td>
						
						<td id="unreserve" class="hide">
						
						  <!--- transfer back to unearmarked stock --->	
						
						 <cf_tl id="UnEarmark" var="tUnEarmark">
						 <cf_tl id="Transfer stock" var="tTransferWorkOrder">
						 <cf_tl id="Destination" var="vDestination">
						 
						  <input type="button" 
							  style="width:240;height:28;font-size:12" 
							  onclick= "try { ColdFusion.Window.destroy('dialogdestination',true)} catch(e){};ColdFusion.Window.create('dialogdestination', '#vDestination#', '',{x:200,y:100,height:280,width:450,resizable:false,modal:true,center:false});ColdFusion.navigate('#SESSION.root#/Workorder/Application/Assembly/Items/Earmark/dialogBOMDestinationRF.cfm?mode=#url.mode#&action=8&workorderid=#url.workorderid#&workorderline=#workorderline#&warehouse=#url.warehouse#&category=#url.category#&pointersale=#url.pointersale#','dialogdestination')"					  
							  value=" #tUnEarmark# / #tTransferWorkOrder#" 		  
							  class="button10g">
									  
						</td>
					  
					</cfif>					  
										  
					<td>
					  
					  <!--- issue/pickticket --->
					  <cf_tl id="CONSUME Stock" var="tConsume">
					  					  
					  <input type="button" 
						  style="width:240;height:28;font-size:12" 
						  onclick="Prosis.busy('yes');ColdFusion.navigate('#session.root#/workorder/Application/Assembly/Items/Earmark/BOMEarmarkSubmit.cfm?mode=#url.mode#&action=2&workorderid=#url.workorderid#&workorderline=#workorderline#&warehouse=#url.warehouse#&category=#url.category#&pointersale=#url.pointersale#','process','','','POST','fGeneration')"
						  value="#tConsume#" 
						  class="button10g">
					  
					</td>
								
					</tr>
					
				</table>
			
			</cfoutput>  
		
		</td></tr>
		
		</cfif>
	
	</table>

	<!---
</form>
--->

<cfset ajaxOnLoad("doHighlight")>