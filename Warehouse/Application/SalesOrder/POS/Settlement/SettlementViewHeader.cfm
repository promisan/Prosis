<cfparam name="Object.ObjectId" 	default="">	
<cfparam name="url.addressid"  		default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.batchId"  		default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.journal" 		default="">
<cfparam name="url.journalSerialNo" default="">
<cf_tl id="Settlement" var="set">


<cfif Object.ObjectId neq "">
	<cfset url.scope = "workflow">
	<cfset url.formName = "formembed">
	<script>
		<cfinclude template="../../../Stock/StockControl/SettlementScript.cfm">
	</script>	
	<cf_dialogSettlement scope="workflow">
	<cf_KeyPadScript>

	<!--- From workflow --->
	<cfquery name="qHeader" 
  	datasource="AppsMaterials" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">	
	SELECT *
	 FROM Accounting.dbo.TransactionHeader TH 
 		WHERE TransactionId='#Object.ObjectId#'
 		AND TransactionSource='SalesSeries'
	</cfquery>
 	
 	<cfif qHeader.recordcount eq 1>
		<cfquery name="qBatch" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">	
		SELECT *
		FROM Materials.dbo.WarehouseBatch B 
	 	WHERE B.BatchId = '#qHeader.TransactionSourceId#'
		</cfquery>
		
		<cfquery name="qExistingSettlement" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">	
			SELECT * 
			FROM WarehouseBatchSettlement
			WHERE BatchNo = '#qBatch.BatchNo#' 
		</cfquery>	
		
		
		<cfif qExistingSettlement.recordCount eq 0>
		
			<cfset url.batchId = qBatch.BatchId>
			<cfset url.addressId = qBatch.AddressId>
			<cfset url.warehouse = qBatch.Warehouse>
			<cfset url.customerId = qBatch.CustomerId>
			<cfset url.terminal = "">
			
			<cfset url.td = "">
			<cfset url.th = "">
			<cfset url.tm = "">
			
			<cfinclude template = "SettlementInit.cfm">
			
			<cfquery name="qWarehouse" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT * 
				FROM   Warehouse
				WHERE  Warehouse = '#URL.Warehouse#' 	
			</cfquery>	
			
			<cfquery name="Sale"
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT  *
				 FROM   ItemTransaction 
				 WHERE  TransactionBatchNo = '#qBatch.BatchNo#'	
			</cfquery> 	
			
		<cfelse>
			<cfset url.scope = "none">
			<script>
				$(document).ready(function() {
					$('#tmenu1').hide();
					$('#menu2').click();
				});
				
			</script>		
		</cfif>
	<cfelse>
		<cfset url.scope = "none">
		<script>
			$(document).ready(function() {
				$('#tmenu1').hide();
				$('#menu2').click();
			});
			
		</script>		
	</cfif>	
	<input type="hidden" name="savecustom" id="savecustom">
	<script>
	$(document).ready(function() {
		$('#EmbedSave').hide();
	});
	</script>
	
<cfelseif url.journal neq "">
	<cfset url.scope = "standalone">
		
	<cfquery name="qHeader" 
  	datasource="AppsMaterials" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">	
		SELECT *
		FROM Accounting.dbo.TransactionHeader TH 
 		WHERE Journal		='#URL.Journal#'
 		AND JournalSerialNo ='#URL.JournalSerialNo#'
 		AND TransactionSource='SalesSeries'
	</cfquery>
	
 	<cfif qHeader.recordcount eq 1>
		<cfquery name="qBatch" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">	
		SELECT *
		FROM Materials.dbo.WarehouseBatch B 
	 	WHERE B.BatchId = '#qHeader.TransactionSourceId#'
		</cfquery>
		
		<cfquery name="getSettlement" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">	
			SELECT SettleCurrency, SUM(SettleAmount) as sTotal
			FROM WarehouseBatchSettlement
			WHERE BatchNo = '#qBatch.BatchNo#' 
			GROUP BY SettleCurrency
		</cfquery>	
		
		<cfquery name="getSale"
	 	datasource="AppsMaterials" 
	 	username="#SESSION.login#" 
	 	password="#SESSION.dbpw#">
		 	SELECT   ITS.SalesCurrency, 
			  		SUM(ITS.SalesTotal) as sTotal
		 	FROM   ItemTransaction IT INNER JOIN ItemTransactionShipping ITS ON
			 	IT.TransactionId = ITS.TransactionId
		 	WHERE  IT.TransactionBatchNo = '#qBatch.BatchNo#'
		 	GROUP BY ITS.SalesCurrency	
		</cfquery>		
		
		
		<cfif getSettlement.sTotal lt getSale.sTotal >
		
			<cfset url.batchId = qBatch.BatchId>
			<cfset url.addressId = qBatch.AddressId>
			<cfset url.warehouse = qBatch.Warehouse>
			<cfset url.customerId = qBatch.CustomerId>
			<cfset url.customerIdInvoice = qBatch.CustomerIdInvoice>
			<cfset url.terminal = "">
			
			<cfset url.td = "">
			<cfset url.th = "">
			<cfset url.tm = "">
			
			
			<cfinclude template = "SettlementInit.cfm">
			
			
			<cfquery name="qWarehouse" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT * 
				FROM   Warehouse
				WHERE  Warehouse = '#qBatch.BatchWarehouse#' 	
			</cfquery>	
			
			<cfquery name="Sale"
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT  *
				 FROM   ItemTransaction 
				 WHERE  TransactionBatchNo = '#qBatch.BatchNo#'	
			</cfquery> 	
		<cfelse>
			Already settled	
			<cfabort>
			
		</cfif>
		
		<cfset AjaxOnLoad("initPOS")>
	
	</cfif>
<cfelse>
	<cfset url.scope = "settlement">
	<cfif URL.batchId neq "00000000-0000-0000-0000-000000000000" AND URL.batchId neq "">
		<cfquery name="qBatch" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">
			SELECT * 
			FROM   WarehouseBatch
			WHERE  BatchId = '#URL.BatchId#' 	
		</cfquery>
		
		<cfset URL.AddressId = qBatch.AddressId>		
	</cfif>	
	
	
	<cfquery name="qWarehouse" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT * 
		FROM   Warehouse
		WHERE  Warehouse = '#URL.Warehouse#' 	
	</cfquery>	
	
	<cfquery name="Sale"
	 datasource="AppsTransaction" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  *
		 FROM    Sale#URL.Warehouse#
		 WHERE   CustomerId = '#url.customerid#'	
	</cfquery> 
	
	<cf_screentop height="100%" scroll="no" label="#set#" banner="blue" layout="webapp" close="ColdFusion.Window.destroy('wsettle',true)">
</cfif>

<cfif url.scope neq "standalone">
	<style>
		
	.inputamount_active {	   
	    margin-left: 1px;
	    padding-left: 2px;
	    padding-right: 3px;
		text-align:right;
		color:##ffffff;
		background-color: ##3C5AAB;		
	}	
	
	.settlement_title td {
	    font-family: calibri;
	    font-size: 1em;
		font-weight:bold;
	}	
	
	.line_details td {
	    font-family: calibri;
	    font-size: 1em;
	}		

	.tdmmenu, .tdcmenu {
		font-family: calibri;
		font-size:12px;
		color:##000;
		background-color:##ffffff;
		text-decoration:none;
		cursor:pointer;
		border:0px solid ##DDD;
		text-align:center;
	}

	</style>	

	<script>
		$(document).ready(function() {
			initPOS();
		});
	</script>
</cfif>