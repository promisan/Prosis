
<cfinvoke component="Service.Presentation.Presentation"
      	   method="highlight"
		   class="highlight2"
    	   returnvariable="stylescroll"/>
	
<cfquery name="getWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Warehouse
		WHERE    Warehouse  = '#url.warehouse#'			
</cfquery>
				
<cfset client.invoiceselect = "">

<cfparam name="url.actionStatus" default="1">
<cfparam name="url.systemfunctionid" default="">

<cfquery name="getSummary" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  
	  SELECT      WL.OrgUnitOperator,
	  
	             (SELECT OrgUnitName
                  FROM   Organization.dbo.Organization 
				  WHERE  OrgUnit = WL.OrgUnitOperator) as OperatorName,
	  
	  			 YEAR(B.TransactionDate) as Year,
	             MONTH(B.TransactionDate) as Month,
				
				 B.TransactionType,			
				 T.ItemDescription, 
				 T.ItemNo,
				 T.TransactionUoM,
				 U.UoMDescription, 
				 C.Category,
				 C.Description as CategoryDescription, 
                 SUM(- T.TransactionQuantity) AS TransactionQuantity, 
				 SUM(- T.TransactionValue) AS TransactionValue, 
				 COUNT(*) AS Lines
				 
	  FROM       Item I
			     INNER JOIN Ref_Category C ON I.Category = C.Category
	             INNER JOIN AssetItem AI ON I.ItemNo = AI.ItemNo 
				 INNER JOIN ItemTransaction T ON AI.AssetId = T.AssetId
				 INNER JOIN ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
				 INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 	 
				 INNER JOIN WarehouseBatch B ON T.TransactionBatchNo = B.BatchNo


       <!--- selected warehouse / mission --->
	  WHERE      T.Mission     = '#url.mission#'
	  AND        T.Warehouse   = '#url.warehouse#'				 
	  
	  <!--- filter on issuance transactions only to be billed --->			 
	  AND        T.TransactionType = '2' 
	  
	  <!--- status --->
	  AND        T.ActionStatus = '#url.actionStatus#'
	  
	  <!--- only transactions for external --->
	  AND        T.BillingMode = 'External'
	  
	  <!--- and not billed yet --->
	  
	  AND     B.BillingStatus = '0'
	  
	  AND     T.TransactionId IN  (
				  SELECT   TransactionId
                  FROM     ItemTransactionShipping S
                  WHERE    TransactionId = T.TransactionId 
				  AND      (
				            InvoiceId IS NULL OR 
							InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
						   )
				 )		
	   
							  
	  GROUP BY   WL.OrgUnitOperator, 
	             YEAR(B.TransactionDate),
	             MONTH(B.TransactionDate),				 
				 C.Category,
	             C.Description, 
				 T.ItemNo,
				 B.TransactionType,
			     T.ItemDescription, 
				 T.TransactionUoM,
			     U.UoMDescription	
				 
	 				 
	  UNION
	  
	  
	  
	  SELECT      WL.OrgUnitOperator,
	  
	             (SELECT OrgUnitName
                  FROM   Organization.dbo.Organization 
				  WHERE  OrgUnit = WL.OrgUnitOperator) as OperatorName,
	  
	  			 YEAR(B.TransactionDate) as Year,
	             MONTH(B.TransactionDate) as Month,
				 
				 B.TransactionType,	
				 								 
				 T.ItemDescription, 
				 T.ItemNo,
				 T.TransactionUoM,
				 U.UoMDescription, 
				 B.Category, 
				 (SELECT Description FROM Ref_Category C WHERE B.Category = C.Category) as CategoryDescription,				
                 SUM(- T.TransactionQuantity) AS TransactionQuantity, 
				 SUM(- T.TransactionValue) AS TransactionValue, 
				 COUNT(*) AS Lines
				 
	  FROM       ItemTransaction T
				 INNER JOIN ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM 
				 INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 	
				 INNER JOIN WarehouseBatch B ON T.TransactionBatchNo = B.BatchNo 

      <!--- selected warehouse / mission --->
	  WHERE      T.Mission     = '#url.mission#'
	  AND        T.Warehouse   = '#url.warehouse#'				 
	  
	  <!--- filter on issuance transactions only to be billed --->				  		 
	  AND        B.TransactionType = '8' AND T.TransactionQuantity < 0
	  
	  <!--- status --->
	  AND        T.ActionStatus = '#url.actionStatus#'
	  
	  <!--- only transactions for external --->
	  AND        T.BillingMode = 'External'
	  	  
	  <!--- and not billed yet --->
	  
	  AND     B.BillingStatus = '0'
	  
	  AND     T.TransactionId IN  (
				  SELECT   TransactionId
                  FROM     ItemTransactionShipping S
                  WHERE    TransactionId = T.TransactionId 
				  AND      (
				            InvoiceId IS NULL OR 
							InvoiceId NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice WHERE InvoiceId = S.InvoiceId)
						   )
				 )			  
	 
							  
	  GROUP BY   WL.OrgUnitOperator, 
			     YEAR(B.TransactionDate),
	             MONTH(B.TransactionDate),
				 B.Category,	
				 B.TransactionType,								
				 T.ItemNo,
			     T.ItemDescription, 
				 T.TransactionUoM,
			     U.UoMDescription	
				 
				 
	  ORDER BY 	 WL.OrgUnitOperator,
			     YEAR(B.TransactionDate),
	             MONTH(B.TransactionDate),	 
				 B.TransactionType,           
				 T.ItemNo,
			     T.ItemDescription 		
			
</cfquery>			

<cfinvoke component = "Service.Access"  
     method             = "roleaccess"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 missionorgunitid   = "#getWarehouse.MissionOrgUnitId#"
	 Parameter          = "#url.SystemFunctionId#" 
	 AccessLevel        = "'1','2'"
	 returnvariable     = "access">	 	

<table width="100%"><tr><td style="padding-left:15px;padding-right:15px">

<form method="post" name="transactionform" id="transactionform">

<table width="100%" cellspacing="0" cellpadding="0" align="center">

	<tr><td class="linedotted" colspan="8"></td></tr>

	<tr><td colspan="5" class="labellarge" style="padding-bottom:4px;padding-top:10;font-size:25">
		<b>Issuances Pending for Billing	
	</td>
	
	<tr><td height="5" id="process"></td></tr>
		
	<tr><td colspan="8" class="linedotted"></td></tr>
	
	<tr>	 
	  <td height="17" class="labelit">Date</td>   
	  <td></td>
	  <td></td>
	  <td class="labelit">Equipment</td>
	  <td class="labelit" align="center">Lines</td>
	  <td class="labelit">Product</td>
	  <td class="labelit">UoM</td>	  
	  <td align="right">Total</td>  
	</tr>
	  
	<tr><td colspan="8" class="linedotted"></td></tr>
	
	<cfif getSummary.recordcount eq "0">
	
	<tr><td colspan="8" align="center" style="height:30px" class="labelmedium"><font color="green">Good, there are no more transactions pending.</td></tr>
		
	</cfif>
		
	<cfoutput query="getSummary" group="OrgUnitOperator">

		<tr>
		  
		  <td colspan="8" align="center" style="height:30px;padding-right:4px" class="labelmedium">
		  
		  <cfif access eq "GRANTED">
		  
		  	<input type     = "button" 
				style       = "width:400px;height:28;font-size:14px"				
				class       = "button10g"
				value       = "Submit the selected #OperatorName# transactions" 			
				onClick     = "initpayable('#url.mission#','#url.warehouse#','#orgunitoperator#','#url.systemfunctionid#')"					
				id          = "Payable">   		 		 
		 		   
		  </cfif>
		  						   
		  </td>
		</tr>	
		<tr><td colspan="8" class="linedotted"></td></tr>
		
	<cfoutput group="Year">	
	
	<cfoutput group="Month">
	
		<tr>			    
			<td colspan="6" style="padding-top:4px; padding-bottom:3px"><font face="Calibri" size="3">		
			#MonthAsString(month)# #year#				
			</td>
			<td align="right" class="label" colspan="2"></td>
		</tr>
		
		<tr><td colspan="8" class="linedotted"></td></tr>
		
		<cfoutput group="TransactionType">
								
		<cfquery name="getType" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_TransactionType
				WHERE    TransactionType  = '#TransactionType#'			
		</cfquery>
		
		<tr>			    
			<td colspan="6" style="padding-left:4px;padding-top:4px; padding-bottom:3px" class="labelmedium"><font color="808080">#getType.Description#</td>
			<td align="right" class="label" colspan="2"></td>
		</tr>
		
		<tr><td colspan="8" class="linedotted"></td></tr>
		
			<cfoutput>
			
				<!--- summary by item / uom / category --->
							
				<cfset name = "xdetail_#url.actionstatus#_#currentrow#">		
											
				<cfset link = "Warehouse/Application/Stock/Shipping/PendingTransaction/PendingDetail.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&warehouse=#url.warehouse#&itemno=#itemno#&uom=#transactionuom#&year=#year#&month=#month#&transactiontype=#transactiontype#&category=#category#&actionstatus=#url.actionstatus#&orgunit=#orgunitoperator#">
												
				<tr onclick="drilldownbox('#name#','#link#','#client.VirtualDir#');do_toggle('id','#name#_twistie')" #stylescroll#>
				    <td style="width:1%" height="19"></td>
					<td style="width:1%"></td>
					
					<td style="width:5%" style="cursor: pointer; padding-right:5px">				
					   <cf_img icon="expand" id="#name#_twistie">				  											
					</td>
					
					<td class="label" style="cursor:pointer"><font color="0080C0">#CategoryDescription#</font></td>
					<td class="label" align="center">#Lines#</td>	
					<td class="label"><a href="javascript:item('#ItemNo#','#url.systemfunctionid#','#url.mission#')"><font color="0080C0">#ItemDescription#</font></a></td>
					<td class="label">#UoMDescription#</td>						
					<td class="label" align="right" style="padding-right:4px">#numberformat(TransactionQuantity,"__,__._")#</td>					
				</tr>
				
				<tr id="#name#_box" class="hide">
				   <td colspan="2"></td>
				   <td colspan="6" id="#name#_content" style="padding-top:2px;padding-bottom:4px;padding-right:20px"></td>
		 	    </tr>
				
				<tr><td></td><td colspan="7" class="linedotted"></td></tr>
			
		    </cfoutput>
			
		</cfoutput>
			
	</cfoutput>	
		
	</cfoutput>
	
	</cfoutput>

</table>

</form>


</td></tr></table>