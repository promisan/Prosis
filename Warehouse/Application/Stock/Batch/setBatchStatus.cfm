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
<cfquery name="Batch"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatch B,
	         Ref_TransactionType R 
	WHERE    B.TransactionType = R.TransactionType
	AND      BatchNo           = '#URL.BatchNo#'
</cfquery>
											
<cfquery name="records"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemTransaction 
	WHERE    TransactionBatchNo = '#url.BatchNo#'		
</cfquery>

<cfquery name="warehouse" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Warehouse
	WHERE Warehouse = '#Batch.Warehouse#'
</cfquery>
												
<cfquery name="check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemTransaction 
	WHERE    TransactionBatchNo = '#url.BatchNo#'	
	AND      ActionStatus = '0'
</cfquery>

<cfparam name="url.stockorderid" default="">

<cfif url.systemfunctionid eq "undefined">
	
	<cfset sid = "">
	
	<cfif getAdministrator(warehouse.mission) eq "1">
	
		<cfset fullAccess = "GRANTED">
		<cfset editAccess = "GRANTED">	
	
	<cfelse>
		
		<cfset fullAccess = "DENIED">
		<cfset editAccess = "DENIED">
		
	</cfif>
	
<cfelseif url.trigger eq "Receipt">

		<cfset fullAccess = "DENIED">
		<cfset editAccess = "GRANTED">
		
<cfelse>

	<cfset sid = url.systemfunctionid>
		
	<cfinvoke component   = "Service.Access"  
	   method         = "RoleAccess" 
	   Role           = "'WhsPick'"
	   Parameter      = "#sid#"
	   Mission        = "#Batch.mission#"  	
	   Warehouse      = "#Batch.Warehouse#"  	  
	   AccessLevel    = "'2'"
	   returnvariable = "FullAccess">	
	   
	<cfinvoke component   = "Service.Access"  
	   method         = "RoleAccess" 
	   Role           = "'WhsPick'"
	   Parameter      = "#sid#"
	   Mission        = "#Batch.mission#"  	 
	   Warehouse      = "#Batch.Warehouse#"  
	   AccessLevel    = "'1','2'"
	   returnvariable = "EditAccess">	
		
</cfif>

<cfif records.recordcount eq "0">

    <!--- empty batch --->

	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td bgcolor="red" align="center" class="labelmedium">
	
	<font color="white"><cf_tl id="Revoked"></font>
		
	</td></tr></table>

<cfelseif check.recordcount eq "0">

	<!--- the batch is completed now --->

	<cfquery name="Update"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE WarehouseBatch
		SET   ActionStatus = '1', 
		      ActionOfficerUserId    = '#SESSION.acc#',
		      ActionOfficerLastName  = '#SESSION.last#',
			  ActionOfficerFirstName = '#SESSION.first#', 
			  ActionOfficerDate      = getDate()
		WHERE BatchNo = '#url.BatchNo#'
	</cfquery>
				
	<cfoutput>
		
	<table height="100%" class="formspacing">

		<tr><td align="center" class="labelmedium">
				<font color="008000"><cf_tl id="Confirmed"></font>
			</td>
		
				 	<!--- check if this transaction was further processed [like a sale] which then would not 
					allow it to be undone or issued again as sale --->										
										
					<cfquery name="checkProcess"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     WarehouseBatch 
						WHERE    ParentBatchNo = '#Batch.BatchNo#'
					</cfquery>
					
					<cfif checkProcess.recordcount eq "0">
					
					    <!--- sid is to define a different context not for the approval screen (Fuel) --->
						
						<cfif fullaccess eq "GRANTED" and sid neq "" and url.stockorderid eq "">
							<td class="labelmedium">
							     <a href="javascript:batchrevert('confirm','#Batch.BatchNo#')"><font color="red">[<cf_tl id="undo">]</a>
							</td>	 
						</cfif>
						
						<!--- create a sale if the warehouse is set as a sale receivable warehouse --->
												
						<cfif Warehouse.SaleMode eq "1" or Warehouse.SaleMode eq "2">
						
							<cfquery name="Customer"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     WarehouseLocation 
								WHERE    Warehouse = '#Batch.Warehouse#'
								AND      Location  = '#Batch.Location#'
							</cfquery>
							
							<cfquery name="Source"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     Warehouse
								WHERE    Warehouse = '#Batch.BatchWarehouse#'														
							</cfquery>
														
							<cfif Customer.DistributionCustomerId neq "" AND Batch.CustomerId eq "">
								
								<!--- Important to detemine if a batch can be billed as AR
								 
								   a  transaction is internal issuance/inventory in the warehouse itself for a location which is set a Consignment
								   b. transaction is a issuance/transfer to a location which is NOT operated by owner entity --->
								   				
								<cfif ( Customer.OrgUnitOperator eq "" <!--- entity operated --->
										and (Batch.TransactionType eq "2" or Batch.TransactionType eq "5") 
										and Customer.Distribution eq "2" <!--- consignment --->
										and Batch.BatchWarehouse eq Batch.Warehouse)
								
								       or 
									   
									   (Customer.OrgUnitOperator neq ""  <!--- operated by third party --->	
									    and (Batch.TransactionType eq '2' or Batch.TransactionType eq "8")								  
									    and Customer.BillingMode eq "External" <!--- third party owns stock --->									    
										and Batch.BatchWarehouse neq Batch.Warehouse <!--- transaction comes from internal warehouse 
										attention when we go through the transaction to BILL (AR) we ONLY take issuance transactions if they come
										from a location which has BillingMode eq "Internal" 
										see also cf_getWarehouseBilling --->
									   )
									   									   
									   >
																													
									<cfif fullaccess eq "GRANTED" and sid neq "" and url.stockorderid eq "">
									
										<td class="labelmedium">
											<a href="javascript:batchtosale('confirm','#Batch.BatchNo#','#Customer.DistributionCustomerId#')">[<cf_tl id="Initiate Sales Order">]</a>
										</td>
								
									</cfif>
									
								</cfif>
							
							</cfif>
						
						</cfif>													
					
					</cfif>
		
			</tr>
			
	</table>
	
	<script>
	    <!--- maybe better to do a ptoken --->
		 document.getElementById('shippingbox').className = "regular"
	</script>
		
	</cfoutput>
	
<cfelse>

	<cfquery name="Update"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE WarehouseBatch
		SET   ActionStatus = '0'
		WHERE BatchNo = '#url.BatchNo#'
	</cfquery>
	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
			<tr><td bgcolor="6688aa" align="center" class="labelmedium">
				<font color="white"><cf_tl id="Pending"></font>
			</td></tr>
	</table>

</cfif>

<!--- check if the process box can now be shown which applies only to mode <> 3 --->

<cfquery name="WorkflowTransaction"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
		    SELECT     TransactionId			  	 
					   
			FROM       ItemTransaction T	
	  		WHERE      T.TransactionBatchNo  = '#url.BatchNo#'  	
			AND        TransactionId IN
			
					   ( SELECT O.ObjectId 
					     FROM   Organization.dbo.OrganizationObject O
						 WHERE  O.EntityCode = 'WhsTransaction'
						 AND    O.Operational = 1				
						 AND    O.ObjectKeyValue4 = T.TransactionId
					   )  
						   
	</cfquery>	
		
	<cfset pendingworkflow = "0">
	
	<cfloop query="WorkflowTransaction">
		
		   <cf_wfActive ObjectKeyValue4="#transactionid#">		
		 							 										   
		   <cfif wfstatus eq "open">										   								   										  								   
				<cfset pendingworkflow = "1">
		   </cfif>
	
	</cfloop>	
	
	<cfif pendingworkflow eq "1">
	
			<script>
				try { document.getElementById("actionbox").className = "hide" } catch(e) {}
			</script>
			
	<cfelse>
	
		<script>
			try {  document.getElementById("actionbox").className = "regular" } catch(e) {}
		</script>
	
	</cfif>
