
<!--- get stock details by WorkOrder --->


<cfquery name="workorderline" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   * 
	FROM     WorkOrderLine
	WHERE    WorkOrderId   = '#url.workorderid#'	
	AND      WorkOrderLine = '#url.workorderline#'
</cfquery>  	

<cfparam name="url.workorderidselect" default="">	

<cfif url.workorderidselect eq "">

	<!--- free stock --->

	<cfquery name="getStock" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			SELECT   SUM(T.TransactionQuantity) AS OnHand
						  
			FROM     ItemTransaction T 
					
			WHERE    T.Mission       = '#url.mission#' 
			AND      T.Warehouse     = '#url.warehouse#' 				
			AND      T.ItemNo          = '#url.itemno#' 		
			AND      T.TransactionUoM  = '#url.uom#'			
			
			<!--- not earmarked stock --->
			AND      T.WorkOrderId IS NULL 			
			AND      T.RequirementId IS NULL
											
			HAVING   SUM(TransactionQuantity) > 0.25				
		
	</cfquery>
	
	<cfoutput>
		<input type="hidden" name="ListWorkOrderItemId" value="">
	</cfoutput>

<cfelse>

	<!--- get stock --->
		
	<cfquery name="getStock" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
						
			SELECT     T.WorkOrderId, 
			           T.WorkOrderLine, 
					   T.RequirementId, 
					   W.Reference, 
					   W.OrderDate, 
					   C.CustomerName, 
	                   WL.Reference AS LineReference, 
					   SUM(T.TransactionQuantity) AS OnHand
						  
			FROM       ItemTransaction T INNER JOIN
	                   WorkOrder.dbo.WorkOrder W ON T.WorkOrderId = W.WorkOrderId INNER JOIN
	                   WorkOrder.dbo.Customer C ON W.CustomerId = C.CustomerId INNER JOIN
	                   WorkOrder.dbo.WorkOrderLine WL ON T.WorkOrderId = WL.WorkOrderId AND T.WorkOrderLine = WL.WorkOrderLine
					
			WHERE    T.Mission         = '#url.mission#' 
			AND      T.Warehouse       = '#url.warehouse#' 		
			
			AND      T.ItemNo          = '#url.itemno#' 		
			AND      T.TransactionUoM  = '#url.uom#'
			
			<!--- select correct workorder or any workorder --->
			<cfif url.workorderidselect neq "all">
			
			AND      T.WorkOrderId = '#url.workorderidselect#'
			
			<cfelse>
			
			<!--- any workorder in this mission --->
			AND      T.WorkOrderId  IN (SELECT WorkorderId 
					                    FROM   Workorder.dbo.Workorder 
									    WHERE  Mission = '#url.mission#')				
										
			</cfif>
					
			<!--- only for earmarked to workorderllineitem = FP items --->
			AND      T.RequirementId IN (SELECT WorkOrderItemId 
			                             FROM   WorkOrder.dbo.WorkOrderLineItem 
									     WHERE  WorkOrderItemId = T.RequirementId)
										 
			<!--- and Exclude the workorder which is selected !! --->			
			AND      WL.WorkOrderLineId != '#workorderline.workorderlineid#' 							 
			
			GROUP BY T.WorkOrderId,
			         T.WorkOrderLine, 
					 T.RequirementId, 
					 W.Reference, 
					 W.OrderDate, 
					 C.CustomerName, 
					 WL.Reference
					
			HAVING   SUM(TransactionQuantity) > 0.25
					
			ORDER BY C.CustomerName, T.WorkOrderId, T.WorkOrderLine
		
	</cfquery>
	
		
	<cfoutput>	
		<input type="hidden" name="ListWorkOrderItemId" value="#QuotedValueList(getStock.RequirementId)#">
	</cfoutput>

</cfif>	

<table width="100%" cellspacing="0" cellpadding="0">

<cfif getStock.recordcount eq "0">

	<tr>
	  <td class="labelit" align="center"><font color="FF0000"><cf_tl id="No earmarked stock found"></font></td>
	</tr>

<cfelseif url.workorderidselect eq "">

	<tr><td class="labelmedium" colspan="5"><b><cf_tl id="Not earmarked"></b></td></tr>
	
	<cfif getStock.recordcount gte "1">
	
		<tr>
			 <td colspan="5" id="aaa" style="padding-left:0px;padding-right:10px;padding-top:0px">
			 		
				<cfset url.workorderItemId = "">							
				<cfinclude template="getStockLevelDetail.cfm">
				
			</td>
		</tr>
		
	</cfif>
	

<cfelse>

	<cfoutput query="getStock" group="CustomerName">
	
			<tr><td class="labelmedium" colspan="5"><b>#CustomerName#</b></td></tr>
				
			<cfoutput group="Reference">
			
				<tr class="labelit"><td colspan="3" style="padding-left:0px">#reference#</td>
				    <td colspan="2" align="right" style="padding-right:9px">#dateformat(OrderDate,client.dateformatshow)#</td>
				</tr>
			
				<cfoutput group="WorkOrderLine">
				
					<tr class="labelit">
					<td class="line" colspan="5" style="padding-left:0px">								
						<a href="javascript:workorderlineopendialog('#workorderline.Workorderlineid#',document.getElementById('systemfunctionid').value)">
						<cf_tl id="workorderline">:
						<font color="0080C0">#Linereference#</font>
						</a>
					
					</td>
					</tr>
				
					<cfoutput>
					
						<tr class="labelit">
						 <td colspan="5" id="aaa" style="padding-left:0px;padding-right:10px;padding-top:0px">
						 		
							<cfset url.workorderItemId = RequirementId>							
							<cfinclude template="getStockLevelDetail.cfm">
							
						</td>
						</tr>
							
					</cfoutput>		
				
				</cfoutput>
			
			</cfoutput>   
			
	</cfoutput>
	
</cfif>	

</table>

<script>
	 document.getElementById('processbox').className = "hide"	 
</script>