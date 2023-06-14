
<!--- get all the transactionso of this batch --->

<cfparam name="URL.SystemFunctionId"   default="">
<cfparam name="URL.StockOrderId"       default="">
<cfparam name="URL.Trigger"            default="">

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

<cfset enforcelines = "0">
							
<cfquery name="Check"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseTransaction 
		WHERE    Warehouse       = '#Batch.warehouse#'					
		AND      TransactionType = '#Batch.TransactionType#' 
</cfquery>
	
<cfif check.clearancemode gte "2">
			
	<!--- we enforce individual clearance based on the deeper level --->							
	<cfset enforcelines = "1">

</cfif>

<cfquery name="warehouse" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Warehouse
	WHERE Warehouse = '#Batch.Warehouse#'
</cfquery>

<cfquery name="Actors"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatchActor 
	WHERE    BatchNo = '#URL.BatchNo#'
	ORDER BY Created DESC
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#Warehouse.Mission#'
</cfquery>

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
		
<cfelseif url.trigger eq "WorkOrder">

		<cfset fullAccess = "DENIED">
		<cfset editAccess = "GRANTED">		
		
<cfelse>

	<cfset sid = url.systemfunctionid>
		
	<cfinvoke component   = "Service.Access"  
	   method         = "RoleAccess" 
	   Role           = "'WhsPick'"
	   Parameter      = "#sid#"
	   Mission        = "#Warehouse.mission#"  	
	   Warehouse      = "#Batch.Warehouse#"  	  
	   AccessLevel    = "'2'"
	   returnvariable = "FullAccess">	
	   
	<cfinvoke component   = "Service.Access"  
	   method         = "RoleAccess" 
	   Role           = "'WhsPick'"
	   Parameter      = "#sid#"
	   Mission        = "#Warehouse.mission#"  	 
	   Warehouse      = "#Batch.Warehouse#"  
	   AccessLevel    = "'1','2'"
	   returnvariable = "EditAccess">	
		
</cfif>
	

<cfoutput>

<script>

function mail2(mode,id) {
	  ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplateMultiple#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
}	
	
function openreference(id) {
      mail2('print',id)
}	
	
</script>

</cfoutput>

<!--- batch transaction approval --->
		
<cfoutput>	
		
<table width="100%" height="100%">
    
	<tr><td>		
	
		<table width="100%" class="formpadding" align="center">
		
		<tr class="labelmedium">				    		   
	    	<td width="10" style="padding:4px"></td>
			<td style="font-size:16px;border:1px solid silver;padding:4px">
						
				
				<cfif Batch.BatchClass eq "WhsSale">				
				
					<cfquery name="getHeader"
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">			  
						  SELECT    *	
						  FROM      Accounting.dbo.TransactionHeader
						  WHERE     TransactionSourceId = '#Batch.BatchId#' 
						  AND       TransactionCategory = 'Receivables'
						  -- AND       RecordStatus = '1'
				    </cfquery>
				
					<cfif getHeader.recordcount eq "1">
					
					    <cfif getHeader.recordStatus eq "9">
							<cfset cl = "red">
						<cfelse>
						    <cfset cl = "black">
						</cfif>
									
						<a style="color:#cl#" title="Open Receivable" href="javascript:ShowTransaction('#getHeader.Journal#','#getHeader.JournalSerialNo#','','tab','')">#Batch.BatchNo#</a>
						
					<cfelse>
					
						#Batch.BatchNo#		
					
					</cfif>	
					
				<cfelse>	
				
						#Batch.BatchNo#		
				
							
				</cfif>
				
				<cfif Batch.ParentBatchNo neq "">
				
				[<a style="font-size:11px" href="javascript:batch('#batch.ParentBatchNo#')">#batch.ParentBatchNo#</a>]
				
				</cfif>
				
				<cfquery name="getBatchNext"
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">			  
						  SELECT    *	
						  FROM      WarehouseBatch
						  WHERE     ParentBatchNo = '#Batch.BatchNo#' 						
			    </cfquery>	
				
				<cfif getBatchNext.recordcount eq "1">
				
				[<a title="Superseded by" style="font-size:11px" href="javascript:batch('#getBatchNext.BatchNo#')">#getBatchNext.BatchNo#</a>]
				
				</cfif>	
				
				/ #Batch.BatchDescription# <font size="2"><cfif Batch.DeliveryMode eq "1">[<cf_tl id="Delivery">]</cfif></font></b>
				
			</td>	
					    
			<td width="80" style="border-left:0px dotted silver;padding-left:20px"><font color="808080"><cf_tl id="Warehouse"></td>
			<td colspan="3" style="font-size:16px;border:1px solid silver;padding-left:4px;">#Warehouse.WarehouseName#<br><font size="1">#Warehouse.City# #Warehouse.Address#</td>
			<td style="min-width:100px;border-left:0px dotted silver;padding-left:20px;"><font color="808080"><cf_tl id="Document date"></td>
			<td align="center" style="font-size:16px;border:1px solid silver;padding:4px">#dateformat(Batch.TransactionDate,CLIENT.DateFormatShow)#</td>	
			
			<cfif batch.transactiontype eq "2" or batch.transactiontype eq "8">
			
				<td style="padding-left:5px;"><font color="808080"><cf_tl id="Collection"></td>
				<td style="font-size:16px;max-width:96px;min-width:86px;border:1px solid silver;padding:4px" id="collection">
				
					<table width="100%">
					<tr class="labelmedium">
					<td style="font-size:16px;">
					
					<!--- obtain collection date --->
					
					<cfquery name="BatchCollection"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     WarehouseBatchAction
						WHERE    BatchNo           = '#URL.BatchNo#'
						AND      ActionCode        = 'Collection'
					</cfquery>
					
					<cfif BatchCollection.ActionDate eq "">			
					#dateformat(Batch.TransactionDate,CLIENT.DateFormatShow)#
					<cfelse>
					#dateformat(BatchCollection.ActionDate,CLIENT.DateFormatShow)#
					</cfif>
					</td>
					
					<cfif batch.ActionStatus eq "0">
					<td align="right" style="padding-right:3px">
					    <cf_img icon="edit" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setBatchAction.cfm?action=collection&systemfunctionid=#url.systemfunctionid#&batchno=#url.batchno#','collection')">															
					</td>
					</cfif>
					
					</tr>
					</table>
					
				</td>		
			
			</cfif>			
						
		</tr>
		
		
		
		<cfif Batch.BatchMemo neq "">
		
			<tr  class="labelmedium">				    		   
		    	<td width="40" style="min-width:60px;border-left:0px dotted silver;padding:4px"><font color="808080"><cf_tl id="Memo">:</td>
			    <td colspan="7" style="font-size:16px;border:1px solid silver;padding:4px">#Batch.BatchMemo#</td>		    					
			</tr>
		
		</cfif>
						
		
		<tr  class="labelmedium"><td class="fixlength" width="10"></td>
		    <td class="fixlength" style="font-size:16px;border:1px solid silver;padding:4px">#Batch.OfficerFirstName# #Batch.OfficerLastName#</td>
	    	<td class="fixlength" style="padding-left:20px"><font color="808080"><cf_tl id="Status">:</td>
			<td class="fixlength" colspan="3" id="status" height="200" style="font-size:16px;border:1px solid silver;padding:4px">
						
			    <cfif Batch.ActionStatus eq "0">
				
				      <font color="FF0000"><cf_tl id="Pending Confirmation"></font>
					
				<cfelseif Batch.ActionStatus eq "1">
				
				    <font color="green"><cf_tl id="Confirmed">&nbsp;
															
				    <!--- check if this transaction was further processed [like a sale] --->										
										
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
						
																		
						<!--- added 15/4/2016 to prevent reverting a batch if the transaction has been shipped AND invoiced AR --->
						
							<cfquery name="checkPostingPOS"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT    *
								FROM      Accounting.dbo.TransactionHeader 
								WHERE     TransactionSourceId = '#Batch.BatchId#' 
								AND       TransactionSource   = 'WarehouseSeries'
								AND       TransactionCategory != 'Inventory' 
								AND       ActionStatus = '1'
								AND       RecordStatus = '1'
							</cfquery>
							
							<cfquery name="checkPostingShipping"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
								SELECT    *
								FROM      Accounting.dbo.TransactionHeader 
								WHERE     TransactionSourceId = '#Batch.BatchId#' 
								AND       TransactionSource   = 'SalesSeries'
								AND       TransactionCategory = 'Receivables' 
								AND       ActionStatus = '1'
								AND       RecordStatus = '1'
								
							</cfquery>		
							
							<!--- the transaction is denied and revoke it will not work 
								SELECT    *
								FROM      ItemTransaction T INNER JOIN
					                      ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId INNER JOIN
		            			          Accounting.dbo.TransactionHeader TH ON TS.Journal = TH.Journal AND TS.JournalSerialNo = TH.JournalSerialNo
								WHERE     T.TransactionBatchNo = '#Batch.BatchNo#'
								AND       TH.ActionStatus = '1'
								AND       TH.RecordStatus = '1' 
								
							--->	
																	
						
							<cfif checkPostingPOS.recordcount gte "1" or checkPostingShipping.recordcount gte "1">												
								<font color="gray"><cf_tl id="Batch was billed">
							<cfelse>
						        <a href="javascript:batchrevert('confirm','#Batch.BatchNo#')"><font color="red">[<cf_tl id="undo">]</a>
							</cfif>
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
									
										<a href="javascript:batchtosale('confirm','#Batch.BatchNo#','#Customer.DistributionCustomerId#')"><font color="0080FF">[<cf_tl id="Initiate Sales Order">]</a>
								
									</cfif>
									
								</cfif>
							
							</cfif>
						
						</cfif>		
											
					
					</cfif>
						
										 
				<cfelseif Batch.ActionStatus eq "9">
					<font color="red"><b><cf_tl id="Revoked"></b>&nbsp;

					<cfif fullaccess eq "GRANTED" and sid neq "" and url.stockorderid eq "">
						<a href="javascript:batchrevert('deny','#Batch.BatchNo#')"><font color="red">[<cf_tl id="undo">]</a>
					<cfelseif getAdministrator("*") eq "1">	
					    <a href="javascript:batchrevert('deny','#Batch.BatchNo#')"><font color="red">[<cf_tl id="undo">]</a>
					</cfif>
				
				</cfif>
				
			</td>	
										  			   
		    <td width="40" class="fixlength" style="border-left:0px dotted silver;padding-left:20px"><font color="808080"><cf_tl id="Usage">:</td>
			<td id="usage" class="fixlength" style="font-size:16px;border:1px solid silver;padding:4px">   								   
					
					<cfquery name="Category"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_Category 
						WHERE    Category = '#Batch.Category#'
					</cfquery>
					
					<cfif category.recordcount eq "0">
					
						<font color="808080"><cf_tl id="n/a">
					
					<cfelseif category.recordcount neq "1">
					
						<font color="808080"><cf_tl id="multiple">
					
					<cfelse>
										
						#Category.Description#
					
					</cfif>
			</td>	
			
			<td class="fixlength" style="border-left:0px dotted silver;padding-left:5px"><font color="808080"><cf_tl id="Last update">:</td>
			<td id="usage" class="fixlength" style="font-size:16px;border:1px solid silver;padding:4px">   								   
					
					<cfquery name="getTra"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   TOP 1 *
						FROM     ItemTransaction 
						WHERE    TransactionBatchNo = '#Batch.BatchNo#'
						ORDER BY Created
					</cfquery>
																				
						#dateformat(getTra.Created,client.dateformatshow)#
						#timeformat(getTra.Created,"HH:MM")#
						<font size="1">#getTra.officerLastName#</font>
					
					
			</td>	
		
		</tr>	
		
		<cfif batch.AddressId neq "" and Batch.CustomerId neq "">
				
		<tr  class="labelmedium">	
		        <td></td>
				
				<cfquery name="customer" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Customer
					WHERE Customerid = '#Batch.CustomerId#'
				</cfquery>
				
		        <td style="background-color:ffffaf;font-size:16px;border:1px solid silver;padding:4px">#Customer.CustomerName#</td>		    		   
		    	<td style="border:0px solid silver;padding-left:20px"><cf_tl id="Address">:</td>
				
				<cfquery name="Address"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT        *
					FROM            System.dbo.Ref_Address
					WHERE Addressid = '#batch.AddressId#'
				</cfquery>
				
			    <td colspan="3" style="background-color:ffffaf;font-size:16px;border:1px solid silver;padding:4px">#Address.AddressCity# / #Address.Country#</td>		    					
				
				<td width="40" class="fixlength" style="border-left:0px dotted silver;padding-left:20px"><font color="808080"><cf_tl id="Shipping">:</td>
				<td id="shipping" colspan="3" class="fixlength" style="font-size:16px;border:1px solid silver;padding:4px">   
				
				        <table style="width:100%"><tr><td align="right">
				
						<input type="button" name="Shipping" value="Shipping" class="button10g" onclick="delivery('#batch.BatchId#')">
						
						</td></tr></table>
				
				</td>	
			
			</tr>
		
		
		</cfif>
		
		<cfif Batch.BatchReference neq "" or actors.recordcount gte "1">				
			
			<tr  class="labelmedium fixlengthlist"><td width="10" style="padding:4px"><font color="808080"></td>
				<td style="font-size:16px;border:1px solid silver;padding:4px">#Batch.BatchReference#</td>
				<td style="border:0px solid silver;padding-left:20px"><cf_tl id="Action">:</td>
				
				<td colspan="3" style="border:1px solid silver;padding:0px">
					<table>
					
					<cfloop query="actors">
					<tr>
						<td class="labelit" style="padding-left:5px">#role#</td>
						<td style="font-size:16px;border:0px solid silver;padding:0px" class="labelit"><cfif actorLastName eq "">n/a<cfelse>#ActorFirstName# #ActorLastName# #dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</cfif></td>				
					</tr>	
					</cfloop>
					
					</table>
				</td>
			</tr>		
		
		</cfif>
		
		<cfif Batch.ReadingOpening gt "0">
				
			<tr><td colspan="8" class="line"></td></tr>
			<tr><td width="40" class="labelit" style="border-left:0px dotted silver;padding:4px"><font color="808080"><cf_tl id="Opening">:</td>
				<td style="border:1px solid silver;padding:4px" class="labelmedium"><b>#Batch.ReadingOpening#</td>
				<td width="40" class="labelit" style="border-left:0px dotted silver;padding-left:20px"><font color="808080"><cf_tl id="Closing">:</td>
				<td style="border:1px solid silver;padding:4px" class="labelmedium"><b>#Batch.ReadingClosing#</td>		
				<td width="40" class="labelit" style="border-left:0px dotted silver;padding-left:20px"><font color="808080"><cf_tl id="Measurement Date">:</td>
				<td style="border:1px solid silver;padding:4px" class="labelit">#dateformat(Batch.ReadingClosingDate,client.dateformatshow)#</td>				
			</tr>		
		
		</cfif>				
				
		  <cf_fileExist 
			DocumentPath  = "WhsBatch" 
			SubDirectory  = "#Batch.BatchId#"
			Filter        = ""> 
			
		<cfif files gte "1">	
		
			<tr><td colspan="8" class="line"></td></tr>
		
			<tr>
			  <td class="labelit" style="border-left:0px dotted silver;padding:4px"><font color="808080"><cf_tl id="Attachments">:</td>
			  <td colspan="8">
			  
				  <cf_filelibraryN 
					DocumentPath  = "WhsBatch" 
					SubDirectory  = "#Batch.BatchId#" 
					Filter        = "" 
					Insert        = "no" 
					Remove        = "no" 
					LoadScript    = "yes" 
					rowHeader     = "no" 
					ShowSize      = "yes"> 
			  
			  </td>		
			</tr>
		
		</cfif>
		
		</table>
		
	</td></tr>	
	
	<tr><td height="5"></td></tr>
	
	<tr valign="top" height="90%" style="padding-left:11;padding-top:3px;padding-bottom:1px;padding-right:11px">
	
		<td style="height:100%;" id="main">		
		
		 <cfif url.stockorderid eq "">							
			<cfinclude template="BatchViewTransactionLines.cfm">   								
		 <cfelse>						
			<cfinclude template="BatchViewTransactionLines.cfm">   								
		 </cfif>		
				 
		</td>
	
	</tr>
					
</table>	

</cfoutput>	