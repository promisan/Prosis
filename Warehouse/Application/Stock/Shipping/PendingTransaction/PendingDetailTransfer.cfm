
<cfquery name="getPending" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  
	  SELECT     T.Mission, 
	             T.Warehouse, 
				 T.TransactionType, 
				 T.TransactionDate, 
				 T.ItemNo, 
				 T.ItemDescription, 
				 T.ItemCategory, 
				 WL.Location,
				 WL.LocationId,
				 WL.Description, 
				 T.TransactionUoM,
				 T.TransactionBatchNo,
				 T.TransactionQuantity,                
				 T.TransactionValue, 
				 T.TransactionBatchNo, 
				 T.TransactionReference,
				 T.AssetId, 
				 T.TransactionId,
				 T.TransactionSerialNo,
								 
				 (SELECT WarehouseName
				  FROM   Warehouse W, ItemTransaction WT
				  WHERE  W.Warehouse = WT.Warehouse
				  AND    WT.ParentTransactionId = T.TransactionId
				  ) as Destination,
				  
				 B.ActionOfficerUserId,
				 B.ActionOfficerLastName,
				 B.ActionOfficerFirstName, 
				 B.ActionOfficerDate, 
				 		
				 T.OfficerUserId, 
				 T.OfficerLastName, 
				 T.OfficerFirstName, 
				 T.Created
				 
		FROM     ItemTransaction T 
		         INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 
				 INNER JOIN WarehouseBatch B ON T.TransactionBatchNo = B.BatchNo
               				 
		WHERE    T.Mission     = '#url.mission#'
		AND      T.Warehouse   = '#url.warehouse#'		 
		
		<!--- filter on issuance transactions only to be billed --->			
				
		AND      B.TransactionType = '8' 
		AND      T.TransactionQuantity < 0		
		
		<!--- tagged for billing --->
		AND      T.BillingMode = 'External'      		
		
		<!--- clearned transaction --->
		AND      T.ActionStatus = '#url.actionstatus#'
							
		<!--- pending for billing --->		
		AND     B.BillingStatus = '0'
		
		<!--- and thus also not invoiced yet --->	 
	  	AND      T.TransactionId IN
	                             (
								  SELECT   TransactionId
	                              FROM     ItemTransactionShipping S
	                              WHERE    TransactionId = T.TransactionId 
								  AND      (
								            InvoiceId IS NULL 
								            OR 
											InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
										    )
								 )					
		 

		<!--- selected category only --->
		<cfif url.category eq "">
		 	AND  B.Category is NULL
		<cfelse>
		    AND  B.Category = '#url.category#'
		</cfif>		
									 
		AND      T.Location  IN (SELECT Location 
	                             FROM   WarehouseLocation 
						 		 WHERE  Warehouse       = '#url.warehouse#'
								 AND    Location        = T.Location
								 AND    OrgUnitOperator = '#url.orgunit#')			  							 
		
		<!--- localised filter by date and item category --->				
		
		AND     T.ItemNo                  = '#url.itemno#'
		AND     T.TransactionUoM          = '#url.uom#'				
		AND     YEAR(T.TransactionDate)   = '#url.year#'		
		AND     MONTH(T.TransactionDate)  = '#url.month#'					
		
		<!--- ------------------------------------------ --->
												
		ORDER BY T.TransactionDate	
								
</cfquery>		

  			
<table width="100%" cellspacing="0" cellpadding="0" align="center" style="border:1px dotted silver;">
	
	<tr>		   
		  <td class="labelit" style="padding-left:3px;padding-left:30px;">Batch No</td>
		  <td class="labelit" height="20">Submitted</td> 
		  <td class="labelit">Rec</td>
		  <td class="labelit">Confirmed by</td>
		  <td class="labelit">Date</td>
		  <td class="labelit" align="right">Quantity</td>	 
		  <td></td>		 
	 </tr>
	 
	 <cfset prior = "">

	<cfoutput query="getPending">
	
		<cfif week(TransactionDate) neq Prior>
		
			<cfset prior = week(TransactionDate)>	
			<tr><td colspan="7" class="linedotted"></td></tr>
			<tr><td colspan="6" class="labellarge" style="padding-left:4px"><font size="1">wk:&nbsp;</font><b>#Prior#</td>
			
			<td width="20" align="center" style="padding-left:13px;padding-right:14px">	
			
			 <cfif access eq "GRANTED">	
								
					<input type="checkbox" 					       
						   checked 
						   onclick="if (this.checked) {$('.toggle_transfer_#Prior#').prop('checked', true)} else {$('.toggle_transfer_#Prior#').prop('checked', false)} ;">							
						   
				</cfif>	 
				
				<td></td>
			
			</tr>
			
		</cfif>
	
		<tr><td colspan="7" class="linedotted"></td></tr>
		
		<tr bgcolor="ffffef" id="l#TransactionBatchNo#" onMouseOver="document.getElementById('l#TransactionBatchNo#').className = 'highlight2'"
             onMouseOut="document.getElementById('l#TransactionBatchNo#').className = 'regular'">			
			<td width="100" style="padding-left:30px;padding-right:5px"><a href="javascript:batch('#TransactionBatchNo#','#url.mission#','process','#url.systemfunctionid#','')"><font color="0080C0">#TransactionBatchNo#</a></td>	
			<td width="90">#dateformat(TransactionDate,CLIENT.DateFormatShow)#</td>
			<td width="130">1</td>
			<td width="90">#ActionOfficerLastName#</td>
			<td width="240">#dateformat(ActionOfficerDate,CLIENT.DateFormatShow)# #timeformat(ActionOfficerDate,"HH:MM")#</td>					
			<td align="right">#numberformat(-TransactionQuantity,"__,__._")#</td>
			<td width="20" align="center" style="padding-left:13px;padding-right:14px">		
			   
			    <cfif access eq "GRANTED">	
				
						<input type="checkbox" 
					      id="selected" name="selected" class="toggle_transfer_#Prior#" checked value="'#TransactionBatchno#'">	
						  						
				</cfif>	 
				 
			</td>	
				
		</tr>
		
	</cfoutput>

</table>
