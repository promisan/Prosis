<!--
    Copyright © 2025 Promisan

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
<cfset url.scope 	= "standalone">
<cfparam name="url.currency"          default="QTZ">
<cfparam name="url.mode"              default="1">
		
<cfquery name="qHeader" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	SELECT *
	FROM   Accounting.dbo.TransactionHeader TH 
	WHERE  Journal		     = '#URL.Journal#'
	AND    JournalSerialNo   = '#URL.JournalSerialNo#'
	AND    TransactionSource = 'SalesSeries'
</cfquery>
	
<cfif qHeader.recordcount eq 1>

		<cfquery name="qBatch" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">	
			SELECT *
			FROM   Materials.dbo.WarehouseBatch B 
	 		WHERE  B.BatchId = '#qHeader.TransactionSourceId#'
		</cfquery>		

		<cfset url.batchId    = qBatch.BatchId>
		<cfset url.addressId  = qBatch.AddressId>
		<cfset url.warehouse  = qBatch.Warehouse>
		<cfset url.customerId = qBatch.CustomerId>
		<cfset url.customeridinvoice = qBatch.CustomerIdInvoice>
		<cfset url.terminal   = "">
			
		<cfquery name="qCheck" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">				
			SELECT * 
			FROM   Accounting.dbo.TransactionHeaderAction
			WHERE  Journal	       = '#URL.Journal#'
			AND    JournalSerialNo = '#URL.JournalSerialNo#'
			AND    ActionCode      = 'Invoice'			
		</cfquery>
		
		<cfif qCheck.recordcount eq 0>
		
			<cfinvoke  component = "Service.Process.Materials.POS"  
			   method             = "initiateInvoice" 
			   batchid            = "#url.batchId#"
			   warehouse          = "#url.warehouse#" 
			   terminal           = "#url.terminal#"
			   customerid         = "#url.customerid#"
			   customeridinvoice  = "#url.customeridinvoice#"
			   currency           = "#url.Currency#"	
			   Mode               = "#url.mode#"	   
			   returnvariable     = "vInvoice">
			
			<cfset vActionId = vInvoice.ActionId>
			
		<cfelse>
		
			<cfset vActionId = qCheck.ActionId>		
			
		</cfif>	
		
		<cfoutput>	
		<script>
			ptoken.navigate("#SESSION.root#/Warehouse/Application/Salesorder/POS/Settlement/SaleInvoice.cfm?actionid=#vActionId#&batchid=#URL.BatchId#&warehouse=#url.warehouse#&currency=#url.currency#&terminal=#url.terminal#", 'wsettle');
			try { window.opener.location.reload(); } catch(e) {}			
		</script>
		</cfoutput>			   

</cfif>			


