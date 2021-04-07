
<!--- drilldown to details --->

<cfquery name="get" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
    FROM      WorkOrderLineItem
	WHERE     WorkOrderItemId = '#url.drillid#' 	
</cfquery>

<cfquery name="Details" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     TOP 100 T.TransactionId,
	           T.Mission,
	           T.ItemNo, 	
			   (SELECT count(*) 
			    FROM   ItemTransactionValuation 
			    WHERE  TransactionId = T.TransactionId) as Sourced,          
	           T.ItemDescription, 
			   T.TransactionUoM, 
			   T.TransactionLot, 
			   T.Warehouse, 
			   W.WarehouseName,
			   T.TransactionType, 
			   T.TransactionDate, 
			   R.Description,
			   T.TransactionQuantity, 
			   T.TransactionReference, 
			   T.TransactionBatchNo, 
	           T.ParentTransactionId, 			  
			   T.ActionStatus,
			   T.OfficerLastName, 
			   T.OfficerFirstName, 
			   T.Created
    FROM       ItemTransaction T INNER JOIN
                  Ref_TransactionType R ON T.TransactionType = R.TransactionType INNER JOIN
                  Warehouse W ON T.Warehouse = W.Warehouse
	WHERE      RequirementId = '#url.drillid#' 
	ORDER BY   T.Created DESC
</cfquery>

<!--- added 11/2/2016 option to remove earmarked stock as long as the earmarked quantity is equal or larger than the shipped quantity 
earmarked stock is either stock received or stock transferred to this workorder line --->

<table align="center" width="99%" class="navigation_table">

<tr><td height="5"></td></tr>

<cfif details.recordcount eq "0">

	<tr><td align="center" class="labelmedium2" style="height:31"><font color="808080">No records to show in this detail view</font></td></tr>
	
<cfelse>

    <tr class="labelmedium line">
	   	<td><cf_tl id="warehouse"></td>
		<td><cf_tl id="Batch"></td>
		<td><cf_tl id="Date"></td>	
		<td><cf_tl id="Type"></td>	
		<!---
		<td><cf_tl id="Description"></td>
		--->
		<td><cf_tl id="Lot"></td>
		<td><cf_tl id="Reference"></td>
		<td><cf_tl id="Officer"></td>
		<td><cf_tl id="Act"></td>
		<td width="100" align="right"><cf_tl id="In"></td>   
		<td width="100" align="right"><cf_tl id="Out"></td>  
    </tr>
   
    <cfset Incoming = 0>
    <cfset Outgoing = 0>
           
	<cfoutput query="Details">
	
		<tr class="navigation_row labelmedium line">
		
			<td style="padding-left:3px;padding-right:3px">#WarehouseName#</td>
			<td style="padding-right:3px"><a href="javascript:batch('#transactionbatchno#','#mission#')">#TransactionBatchNo#</a></td>
			<td style="padding-right:3px">#dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td>			
			<td style="padding-right:3px">#Description#</td>
			<!---
			<td style="padding-right:3px">#ItemDescription#</td>
			--->
			<td style="padding-right:3px">#TransactionLot#</td>
			<td style="padding-right:3px">#TransactionReference#</td>
			<td style="padding-right:3px">#OfficerLastName#</td>
			
			<td style="padding-top:1px">
			
				 <!--- adjusted only the last transactions to be remove --->
			
				<cfif currentrow eq "1" and actionstatus eq "0" and Sourced eq "0">
				   	<cf_img icon="delete" 
					 onclick="ptoken.navigate('#session.root#/workorder/application/assembly/Items/FinalProduct/setEarmark.cfm?drillid=#url.drillid#&workorderid=#get.workorderid#&transactionid=#transactionid#','earmark_#url.drillid#')">				
				</cfif>
			
			    <!--- adjusted only the last transactions to be remove 
		
				<cfif transactionquantity gte "0" and Sourced eq "0">
					<cf_img icon="delete" 
					 onclick="ptoken.navigate('#session.root#/workorder/application/assembly/Items/FinalProduct/setEarmark.cfm?drillid=#url.drillid#&workorderid=#get.workorderid#&transactionid=#transactionid#','earmark_#url.drillid#')">
				</cfif>
				
				--->
			
			</td>
			
			<td align="right" style="padding-right:3px;border:1px solid silver">
					
				<!--- to check if this line can be removed, which is possible
					if shipping (2) for this workorder 
					for the same lot, warehouse, workorderitemid		
				--->
					
				<cfif transactionquantity gte "0">#numberFormat(TransactionQuantity,",._")#
					<cfset incoming = incoming+TransactionQuantity>
				</cfif>
				
			</td>
						
			<td style="padding-right:3px;border:1px solid silver" align="right">
			
				<cfif transactionquantity lte "0">#numberFormat(TransactionQuantity*-1,",._")#
					<cfset outgoing = outgoing+(TransactionQuantity*-1)>
				</cfif>
				
			</td>		   
			
		</tr>

	</cfoutput>
	
	<cfoutput>
		
	<tr class="navigation_row labelmedium">
		<td colspan="8">	</td>		
		<td class="line" style="padding-right:4px;color:gray;border:1px solid silver" align="right">#numberFormat(Incoming,",._")#</td>
		<td class="line" style="padding-right:4px;color:gray;border:1px solid silver" align="right">#numberFormat(Outgoing,",._")#</td>		   
	</tr>			
	
	</cfoutput>
	
</cfif>	
		
</table>

<cfset AjaxOnload("doHighlight")>