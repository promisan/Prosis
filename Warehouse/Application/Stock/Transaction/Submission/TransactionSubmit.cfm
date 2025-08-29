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
<cfparam name="url.tsOpenDate" 	default="">
<cfparam name="url.tsOpenTime" 	default="">
<cfparam name="url.tsCloseDate" default="">
<cfparam name="url.tsCloseTime" default="">
<cfparam name="url.batchid"     default="">

<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->

<cfquery name="getMission" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   *
   FROM     Warehouse
   WHERE    Warehouse = '#url.warehouse#' 
</cfquery>

<cfset mission = getmission.mission>

<cfif url.mode eq "issue">
	
	<cfquery name="getLocation" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     WarehouseLocation
	   WHERE    Warehouse = '#url.warehouse#' 
	   AND      Location  = '#url.location#'
	</cfquery>
	
</cfif>

<cfquery name="param" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   *
   FROM     Ref_ParameterMission
   WHERE    Mission = '#mission#' 
</cfquery>

<cfquery name="Parameter" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   TOP 1 *
   FROM     WarehouseBatch
   ORDER BY BatchNo DESC
</cfquery>

<cfif Parameter.recordcount eq "0">
	<cfset batchNo = 10000>
<cfelse>
	<cfset BatchNo = Parameter.BatchNo+1>
	<cfif BatchNo lt 10000>
	     <cfset BatchNo = 10000+BatchNo>
	</cfif>
</cfif>	

<cfquery name="Lines"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     #tableName# S 
	<cfif url.mode eq "issue">
	WHERE    Warehouse       = '#url.warehouse#'
	AND      (Location       = '#url.location#' or LocationTransfer = '#url.location#')
	AND      ItemNo          = '#url.itemno#'
	AND      TransactionUoM  = '#url.uom#'
	<!--- is valid entry --->
	AND      Warehouse IN (SELECT Warehouse 
                           FROM   Materials.dbo.Warehouse 
						   WHERE  Warehouse = S.Warehouse)
	</cfif>
	ORDER BY TransactionDate DESC
</cfquery>		

<cfif lines.recordcount eq "0">

	<table align="center"><tr><td height="40" class="labelit">No records found to be submitted</td></tr></table>

<cfelse>

	<cftransaction>
		
		<cfset go = "1">
		
		<cfif url.mode eq "issue">
		
			<cfquery name="Total"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 
			 	SELECT   SUM(TransactionQuantity) as Quantity
				FROM     userTransaction.dbo.#tableName# 
				WHERE    Warehouse       = '#url.warehouse#'
				AND      Location        = '#url.location#'
				AND      ItemNo          = '#url.itemno#'
				AND      TransactionUoM  = '#url.uom#'
								
			</cfquery>		
			
			<cfquery name="Reading"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   *
				FROM     ItemWarehouseLocation 	
				WHERE    Warehouse = '#url.warehouse#'
				AND      Location  = '#url.location#'
				AND      ItemNo    = '#url.itemno#'
				AND      UoM       = '#url.uom#'	
			</cfquery>
					
			<!--- opening reading meter --->
			<cfset ope = reading.ReadingOpening>
			<cfset opeDate = "#dateFormat(now(),'yyyy-mm-dd')#T#timeFormat(now(),'HH:mm')#:00">
			<cfif url.tsOpenDate neq "">
				<cfset selDate = replace("#url.tsOpenDate#","'","","ALL")>
				<cfset dateValue = "">
				<cf_dateConvert Value="#SelDate#">
				<cfset vDateEffective = dateValue>
				<cfset opeDate = "#dateFormat(dateValue,'yyyy-mm-dd')#T#url.tsOpenTime#">
			</cfif>
			
			<!--- closing reading meter --->
			<cfset cls = reading.ReadingClosing>
			<cfset clsDate = "#dateFormat(now(),'yyyy-mm-dd')#T#timeFormat(now(),'HH:mm')#:00">
			<cfif url.tsCloseDate neq "">
				<cfset selDate = replace("#url.tsCloseDate#","'","","ALL")>
				<cfset dateValue = "">
				<cf_dateConvert Value="#SelDate#">
				<cfset vDateEffective = dateValue>
				<cfset clsDate = "#dateFormat(dateValue,'yyyy-mm-dd')#T#url.tsCloseTime#">
			</cfif>
					
			<cfif reading.readingenabled eq "1">
									
				<cfif reading.readingClosing eq "" or reading.ReadingOpening eq "">
				
						<script>
							alert("You must enter a meter reading opening and closing")
						</script>
						
						<cfset go = "0">
																
				<cfelse>
					
					<cfset diff = reading.readingClosing - reading.ReadingOpening>		
					
					 <!--- apply the validation rule enabled for the meter reading --->			
			    	 <cf_applyBusinessRule			 
				       datasource   = "appsMaterials" 
				       triggergroup = "MeterReading"
					   mission      = "#mission#"
					   sourceid     = "#reading.ItemLocationId#"
					   sourcevalue  = "#total.quantity#">
					   
					 <cfif _ValidationStopper eq "yes">
					 	<cfset go = "0">
					 </cfif>
				
				</cfif>
										
			</cfif>	
		
		</cfif>
		
		<!--- validation
		
		1. check if the transaction is a log transaction so we get the reading values, in case of reading
		we match the opening and closing with the total quantity to make a validation 
		
		2. check the last recorded reading for the asset and make sure this one is higher
		
		--->	
		
		<cfif go eq "1">
		
				<cf_assignid>
				
				<cfquery name="Insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WarehouseBatch
							    (Mission,
								 Warehouse, 
								 BatchWarehouse,
								 <cfif url.mode eq "issue">
									 Location,
									 ItemNo,
									 UoM,							 
									 ReadingOpening,
									 ReadingOpeningDate,
									 ReadingClosing,
									 ReadingClosingDate,
								 </cfif>
							 	 BatchNo, 	
								 BatchId,
								 BatchDescription,	
								 BatchClass,					
								 TransactionDate,
								 TransactionType, 
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
					VALUES ('#Lines.mission#',
					        '#Lines.warehouse#',
							'#Lines.warehouse#',
							 <cfif url.mode eq "issue">
								'#url.location#',
								'#url.itemno#',
								'#url.uom#',
								'#ope#',
								'#opeDate#',
								'#cls#',
								'#clsDate#',
							</cfif>			
				    	    '#batchNo#',	
							<cfif url.batchid eq "">
								'#rowguid#',
							<cfelse>
								'#url.batchid#',
							</cfif>
							
							<!--- fixed description --->
							
							<cfif url.mode eq "issue">
								'Issuance',		
								'WhsIssue',
							<cfelseif url.mode eq "sale">
								'Retail',
								'WhsSale',
							<cfelseif url.mode eq "disposal">	
								'Stock Disposal',
								'WhsDispose',
							<cfelseif url.mode eq "initial">	
								'Initial Stock',
								'WhsInitial',		
							<!--- disabled 							
							<cfelseif url.mode eq "externalsale">
							    'Customer Issuance',
								'WhsIssue',
								--->	
							<cfelse>
								'Issuance',
								'WhsIssue',	
							</cfif>
									
							'#Lines.TransactionDate#',
							'#url.tratpe#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')
				</cfquery>
				
				<cfparam name="cls" default="">
				
				<cfif cls neq "">
							
					<cfquery name="update" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE ItemWarehouseLocation 
						SET    ReadingOpening = #cls#, ReadingClosing = NULL	
						WHERE  Warehouse      = '#Lines.warehouse#'	
						AND    Location       = '#url.location#'	
						AND    ItemNo         = '#url.itemno#'
						AND    UoM            = '#url.UoM#' 				
					</cfquery>
				
				</cfif>	
				
					
				<cfloop query="Lines">
				
				    <cfparam name="TransactionLot" default="0">
				
					<cfquery name="check" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT TransactionId
						FROM   ItemTransaction 
						WHERE  TransactionId = '#transactionid#'								
					</cfquery>
					
					<!--- we create the lot --->
					
					<cfif Param.LotManagement eq "1">
													
						<cfinvoke component = "Service.Process.Materials.Lot"  
						   method             = "addlot" 					 
						   mission            = "#Lines.Mission#" 
						   transactionlot     = "#Lines.TransactionLot#"
						   TransactionLotDate = "#dateFormat(now(), CLIENT.DateFormatShow)#">	
					   
					</cfif>   
									
					<cfif check.recordcount eq "0">
					
					
					<cfif workorderid neq "" and billingunit neq "">
					
						<cfquery name="getTax" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
							SELECT   TOP 1 *
							FROM     WorkOrder.dbo.ServiceItemUnitMission S INNER JOIN
					                 WorkOrder.dbo.WorkOrder W ON S.Mission = W.Mission AND S.ServiceItem = W.ServiceItem
							WHERE    W.WorkOrderId = '#workorderid#' 
							AND      S.ServiceItemUnit = '#billingunit#'
							ORDER BY DateExpiration DESC
							
						</cfquery>
						
						<cfset txc = getTax.TaxCode>
						
						<cfquery name="getCustomer" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
							SELECT   S.*
							FROM     WorkOrder.dbo.Customer S, 
					                 WorkOrder.dbo.WorkOrder W
							WHERE    W.WorkOrderId = '#workorderid#' 
							AND      S.CustomerId = W.CustomerId							
						</cfquery>
						
						<cfset exe = getCustomer.TaxExemption>
						
					<cfelse>
					
						<cfquery name="getTax" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
							SELECT   TOP 1 *
							FROM     ItemWarehouse
							WHERE    Warehouse = '#workorderid#' 
							AND      ItemNo    = '#ItemNo#'
							AND      UoM       = '#TransactionUoM#'							
						</cfquery>				
						
						<cfset txc   = getTax.TaxCode>
						<cfset exe   = "0">
										
					</cfif>
																
					<cf_StockTransact 
					    DataSource            = "AppsMaterials" 
						TransactionId         = "#transactionid#"	
					    TransactionType       = "#TransactionType#"
						TransactionSource     = "WarehouseSeries"
						ItemNo                = "#ItemNo#" 
						Mission               = "#Mission#" 
						Warehouse             = "#Warehouse#" 
						TransactionLot        = "#TransactionLot#" 
						BillingMode           = "#BillingMode#"
						Location              = "#Location#"
						TransactionReference  = "#transactionreference#"
						TransactionCurrency   = "#APPLICATION.BaseCurrency#"
						TransactionQuantity   = "#TransactionQuantity#"
						TransactionUoM        = "#TransactionUoM#"
						TransactionCostPrice  = "#TransactionCostPrice#"
						TransactionLocalTime  = "Yes"
						TransactionDate       = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
						TransactionTime       = "#timeformat(TransactionDate,'HH:MM')#"
						TransactionBatchNo    = "#batchno#"
						Remarks               = "#remarks#"
						SalesPrice            = "#salesPrice#"
						GLTransactionNo       = "#batchNo#"
						
						WorkOrderId           = "#workorderid#"
						WorkOrderLine         = "#workorderline#"	
						CustomerId            = "#customerid#"
						BillingUnit           = "#billingunit#"
						
						TaxCode               = "#txc#"
						TaxExemption		  = "#exe#"
						
						OrgUnit               = "#orgunit#"
						OrgUnitCode           = "#orgunitcode#"
						OrgUnitName           = "#orgunitName#"
						LocationId            = "#getMission.LocationId#"
						AssetId               = "#assetid#"
						PersonNo              = "#personno#"	
						
						ProgramCode           = "#ProgramCode#"
						GLCurrency            = "#APPLICATION.BaseCurrency#"
						GLAccountDebit        = "#GLAccountDebit#"
						GLAccountCredit       = "#GLAccountCredit#">
					
						<cfif AssetId neq "" and AssetMetric1 neq "">
						
							<cf_AssetAction 
							    DataSource         = "AppsMaterials" 
								TransactionId      = "#transactionid#"	
								AssetId            = "#AssetId#"
								TransactionDate    = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#"
								TransactionTime	   = "#timeformat(TransactionDate,'HH:MM')#"
								ActionType         = "Standard"
							    Metric1            = "#AssetMetric1#" 
							    MetricValue1       = "#AssetMetricValue1#"
							    Metric2            = "#AssetMetric2#" 
							    MetricValue2       = "#AssetMetricValue2#"
							    Metric3            = "#AssetMetric3#" 
							    MetricValue3       = "#AssetMetricValue3#"
							    Metric4            = "#AssetMetric4#" 
							    MetricValue4       = "#AssetMetricValue4#"																		
							    Metric5            = "#AssetMetric5#" 
							    MetricValue5       = "#AssetMetricValue5#">
								
						</cfif>		
						
						<!--- added for aircraft refuiling as it is a context --->				
						
						<cfif AssetId neq "" and Event1 neq "">
						
							<cf_AssetEvent
							    DataSource         = "AppsMaterials" 
								TransactionId      = "#transactionid#"	
								AssetId            = "#AssetId#"
								
							    Event1             = "#Event1#" 
							    EventDate1         = "#EventDate1#"
							    EventDetails1      = "#EventDetails1#"							
	
							    Event2             = "#Event2#" 
							    EventDate2         = "#EventDate2#"
							    EventDetails2      = "#EventDetails2#"														
								
							    Event3             = "#Event3#" 
							    EventDate3         = "#EventDate3#"
							    EventDetails3      = "#EventDetails3#"							
								
							    Event4             = "#Event4#" 
							    EventDate4         = "#EventDate4#"
							    EventDetails4      = "#EventDetails4#"							
								
							    Event5             = "#Event5#" 
							    EventDate5         = "#EventDate5#"
							    EventDetails5      = "#EventDetails5#">
								
						</cfif>		
						
					</cfif>										
			
				</cfloop>	
			
				<!--- clear the posted lines --->
				
				<cfquery name="removeLines"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    DELETE FROM  userTransaction.dbo.#tableName# 
					<cfif url.mode neq "issue">
					WHERE  TransactionType = '#url.tratpe#'
					<cfelse>
					WHERE    Warehouse        = '#url.warehouse#'
					AND      (Location        = '#url.location#' or LocationTransfer = '#url.location#')
					AND      ItemNo           = '#url.itemno#'
					AND      TransactionUoM   = '#url.uom#'
					</cfif>	
				</cfquery>				
				
				<!--- batch actors --->
				
				<cfquery name="Actors" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      Ref_TaskTypeActor
						WHERE     Code = 'Internal'  
						AND       EnableDistribution = 1
						ORDER BY  ListingOrder
				</cfquery>
				
				<cfloop query="Actors">
					
					<cfif isDefined("url.role_#role#")>
					
						<cf_assignId>
						<cfset vRole = trim(evaluate("url.role_#role#"))>
						<cfset vReference = trim(evaluate("url.reference_#role#"))>
						<cfset vPerson = trim(evaluate("url.personno_#role#"))>
						<cfset vFirst = trim(evaluate("url.firstname_#role#"))>
						<cfset vLast = trim(evaluate("url.lastname_#role#"))>
						
						<cfquery name="Insert" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO WarehouseBatchActor
									(
										BatchNo,
										ActorId,
										<cfif vRole neq "">Role,</cfif>
										<cfif vPerson neq "">ActorPersonNo,</cfif>
										<cfif vReference neq "">ActorReference,</cfif>
										<cfif vLast neq "">ActorLastName,</cfif>
										<cfif vFirst neq "">ActorFirstName,</cfif>
										OfficerUserId,
										OfficerLastName,
										OfficerFirstName
									)
								VALUES
									(
										'#batchNo#',
										'#rowguid#',
										<cfif vRole neq "">'#vRole#',</cfif>
										<cfif vPerson neq "">'#vPerson#',</cfif>
										<cfif vReference neq "">'#vReference#',</cfif>
										<cfif vLast neq "">'#vLast#',</cfif>
										<cfif vFirst neq "">'#vFirst#',</cfif>
										'#SESSION.acc#',
										'#SESSION.last#',
										'#SESSION.first#'
									)
						</cfquery>
					</cfif>
					
				</cfloop>
							
		</cfif>	
			
	</cftransaction>

	<cfif go eq "1">
	
		<table width="100%" height="90%" cellspacing="0" cellpadding="0" align="center">
		   <tr><td class="linedotted"></td></tr>
		   <tr><td align="center" style="height:30" class="labelmedium"><cf_tl id="Transactions were submitted for clearance under No">:<b><cfoutput>#batchNo#</cfoutput></td></tr>
		   <tr><td class="linedotted"></td></tr>
		</table>
		
		<!--- trigger a mail to the submitter --->
		
		<!--- ------------------------------------------------------------------------------------------------------ --->
		<!--- here we trigger an email to the user which is tashed to submit the request for this warehouse/facility --->
		<!--- ------------------------------------------------------------------------------------------------------ --->
		 				 
		<cfquery name="Check"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     ItemWarehouseLocationTransaction 
			WHERE    Warehouse       = '#url.warehouse#'
			<cfif url.mode eq "issue">
			AND      Location        = '#url.Location#'
			AND      ItemNo          = '#url.itemno#'
			AND      UoM             = '#url.uom#'
			</cfif>
			AND      TransactionType = '#url.tratpe#'
		</cfquery>
		 
		<cfif check.notification eq "1">
		 	 
			<cfquery name="getBatch" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT   *
			   FROM     ItemTransaction
			   WHERE    TransactionBatchNo = '#BatchNo#' 
			</cfquery>
			
			<cfquery name="getBatchDetail" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT   CONVERT(VARCHAR(10),TransactionDate,126) as TransactionDate, sum(TransactionQuantity*-1) as Quantity, 
					   count(*) as Lines
			   FROM     ItemTransaction
			   WHERE    TransactionBatchNo = '#BatchNo#' 
			   GROUP BY CONVERT(VARCHAR(10),TransactionDate,126) 
			   ORDER BY CONVERT(VARCHAR(10),TransactionDate,126) 
			</cfquery>
			
			<cfoutput>		
																				
			<cfsavecontent variable="body">		
			    <table>
				<tr><td colspan="2">
					<font face="Calibri" size="5" color="black"><b><u>#getMission.WarehouseName# NOTIFICATION</u></b></font>
				</td>
				</tr>
				
				<tr><td sthle="height:10"></td></tr>
				
				<cfif url.mode eq "issue">
				<tr>
					<td style="padding-left:8px"><font face="Calibri" size="2" color="gray"><i>Location:</font></td>
					<td><b><font face="Calibri" size="3" color="gray">#getLocation.Description#</b></font></td>
				</tr>
				</cfif>
							
				<tr>
					<td style="padding-left:8px;padding-right:15px"><font face="Calibri" size="2" color="gray"><i>Document date:</td>
					<td><b><font face="Calibri" size="3" color="gray">#dateformat(Lines.TransactionDate,client.dateformatshow)#</b></font></td>
				</tr>			
				
				
				<tr><td style="padding-left:8px"><font face="Calibri" size="2" color="gray"><i>Event:</td>
					<td><font face="Calibri" size="3" color="gray"><b>Transaction batch No: <u>#BatchNo#</u> successfully submitted.</font>	</td>
				</tr>
				
				<tr><td style="height:10"></td></tr>
				
				<tr><td style="padding-left:8px" colspan="2"><font face="Calibri" size="2" color="gray"><i><u>Document details</td></tr>
				
				<tr><td colspan="2" style="padding-left:15px">					
					<table cellspacing="0" cellpadding="0">
					<tr><td style="width:110"><font face="Calibri" size="2" color="gray"><i>Date</td>
						<td><font face="Calibri" size="2" color="gray">Lines</td>
					    <td><font face="Calibri" size="2" color="gray">Quantity</td>
					</tr>
					<cfloop query="getBatchDetail">
					<tr><td style="width:110"><font face="Calibri" size="2" color="gray">#dateformat(TransactionDate,client.dateformatshow)#</td>
						<td align="right"><font face="Calibri" size="2" color="gray">#Lines#</td>
					    <td align="right"><font face="Calibri" size="2" color="gray">#quantity#</td>
					</tr>
					</cfloop>				
					</table>
				</td>
				</tr>
				
				<tr><td style="height:10"></td></tr>
				
			</cfsavecontent>
			</cfoutput>
			
			<cfif getmission.eMailAddress neq "">
			  <cfset ccemail = getmission.eMailAddress>
			<cfelse>
			  <cfset ccemail = "">  
			</cfif>
								
			<cf_mailsend class="Batch" 
	             subject="#ucase('#SESSION.welcome# NOTIFICATION')#" 
				 referenceid="#BatchNo#" 
	             ToClass="User" 
				 CC="#ccemail#"
				 SaveMail="1"
				 To="#session.acc#" 												
				 bodycontent="#body#">						
						 
		</cfif>				 
				
		<!--- refresh --->
		 
		 <cfoutput>
		 
			 <script language="JavaScript">
			 		 
			 if (document.getElementById('locbox')) {	 
			 	try {
			     ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getLocation.cfm?mode=#url.mode#&warehouse='+document.getElementById('warehouse').value+'&itemno='+ document.getElementById('itemno').value + '&uom=' + document.getElementById('uom').value,'locbox')				
			 	}catch(e){
				}
			 }			
			 
			 if (document.getElementById('assetbox')) {				  	
				ColdFusion.navigate('../Transaction/getAsset.cfm?mission=','assetbox')
				try {
				document.getElementById('assetselect').value            = ''			
				document.getElementById('transactionreference').value   = ''
				document.getElementById('transactionquantity').value    = ''					
				} catch(e) {}
			 }		
			 
			 if (document.getElementById('transactionOpening')) {	
				 document.getElementById('transactionOpening').value = "#cls#"
				 document.getElementById('transactionClosing').value = ""		  
			 }
			
		
			</script>
				 
		 </cfoutput>
				
	<cfelse>
		
		<cfinclude template="../TransactionDetailLines.cfm">	
				
	</cfif>	
	
	<cfif url.mode eq "workorder">
		
		<script>		    	
			parent.window.close()
			try { parent.opener.applyfilter('1','','content') } catch(e) {}
		</script>
	
	</cfif>
	
	<script>
		try { ColdFusion.Window.destroy('dialogMeterReadings',true)} catch(e){};
	</script>
		
</cfif>	
