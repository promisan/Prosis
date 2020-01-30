
<!--- drilldown to details --->

<cfquery name="Details" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    TOP 100 T.ItemNo, 	          
	          T.ItemDescription, 
			  T.Mission,
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
    FROM         ItemTransaction T INNER JOIN
                      Ref_TransactionType R ON T.TransactionType = R.TransactionType INNER JOIN
                      Warehouse W ON T.Warehouse = W.Warehouse
	WHERE     RequirementId = '#url.drillid#' 
	ORDER BY T.Created
</cfquery>

<table align="center" width="99%" class="navigation_table">

<cfif details.recordcount eq "0">

	<tr><td align="center" bgcolor="D3F5F8" class="labelit" style="height:31"><font color="808080">Sorry, no records to show in this detail view</font></td></tr>
	
<cfelse>

   <tr class="labelit">
   	<td width="100"><cf_tl id="warehouse"></td>
	<td width="50"><cf_tl id="Batch"></td>
	<td width="100" class="labelit"><cf_tl id="Date"></td>	
	<td width="80" class="labelit"><cf_tl id="Type"></td>	
	<td width="180" class="labelit"><cf_tl id="Description"></td>
	<td width="90"  class="labelit"><cf_tl id="Lot"></td>
	<td width="90"  class="labelit"><cf_tl id="Reference"></td>
	<td width="100" class="labelit"><cf_tl id="Officer"></td>
	<td width="100" class="labelit" align="right"><cf_tl id="In"></td>   
	<td width="100" class="labelit" align="right"><cf_tl id="Out"></td>  
   </tr>
   
   <cfset Incoming = 0>
   <cfset Outgoing = 0>
           
	<cfoutput query="Details">
	
	<tr class="navigation_row">
		<td class="labelit line">#WarehouseName#</td>
		<td><a href="javascript:batch('#transactionbatchno#','#mission#')"><font color="0080C0">#TransactionBatchNo#</a></td>
		<td class="labelit line">#dateformat(TransactionDate,client.dateformatshow)#</td>
		
		<td class="labelit line">#Description#</td>
		<td class="labelit line">#ItemDescription#</td>
		<td class="labelit line">#TransactionLot#</td>
		<td class="labelit line">#TransactionReference#</td>
		<td class="labelit line">#OfficerLastName#</td>
		<td class="labelit line" align="right">
		<cfif transactionquantity gte "0">#numberFormat(TransactionQuantity,",__._")#
		<cfset incoming = incoming+TransactionQuantity>
		</cfif>
		</td>
		<td class="labelit line" align="right">
		<cfif transactionquantity lte "0">#numberFormat(TransactionQuantity*-1,",__._")#
		<cfset outgoing = outgoing+(TransactionQuantity*-1)>
		</cfif>
		</td>		   
	</tr>

	</cfoutput>
	
	<cfoutput>
	
	<tr class="navigation_row line">
		<td class="labelit line" colspan="8"></td>		
		<td class="labelit line" align="right"><b>#numberFormat(Incoming,",__._")#</td>
		<td class="labelit line" align="right"><b>#numberFormat(Outgoing,",__._")#</td>		   
	</tr>
	
	</cfoutput>
	
</cfif>	
		
</table>

<cfset ajaxonload="doHighlight">