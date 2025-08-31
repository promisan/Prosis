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
<cfparam name="url.currency"     default="QTZ">
<cfparam name="url.mode"         default="3">  <!--- new mode FEL by Dev which handles discounts and enforces 12% --->
<cfparam name="url.terminal"     default="">
<cfparam name="url.actionid"     default="">

<cfif url.actionid neq "">

	<cfquery name="getAction"
    datasource="AppsMaterials"
    username="#SESSION.login#"
    password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Accounting.dbo.TransactionHeaderAction TH
    	WHERE  ActionId = '#url.actionid#'		
	</cfquery>

	<cfset url.journal         = getAction.Journal>
	<cfset url.journalSerialNo = getAction.JournalSerialNo>

</cfif>

<cfquery name="qHeader"
    datasource="AppsMaterials"
    username="#SESSION.login#"
    password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Accounting.dbo.TransactionHeader TH
    	WHERE  Journal		     = '#URL.Journal#'
		AND    JournalSerialNo   = '#URL.JournalSerialNo#'		
</cfquery>

<cfif qHeader.TransactionSource eq "SalesSeries" 
   or qHeader.TransactionSource eq "WorkOrderSeries" 
   or qHeader.TransactionSource eq "AccountSeries">
   
   <!--- and url.scope eq "standalone" --->

<cfif qHeader.TransactionSource eq "SalesSeries" and url.scope eq "pos">  
		
		<!--- Dev : verify if this is still used
		
		this one makes still use of the V2 component also used for POS Cash and Carry --->
	
	    <cfquery name="qBatch"
	        datasource="AppsMaterials"
	        username="#SESSION.login#"
	        password="#SESSION.dbpw#">			
		        SELECT *
		        FROM   Materials.dbo.WarehouseBatch
		        WHERE  BatchId = '#qHeader.TransactionSourceId#' 
	    </cfquery>
	
	    <cfif url.terminal eq "">
		
	        <cfquery name="qTerminal"
	            datasource="AppsMaterials"
	            username="#SESSION.login#"
	            password="#SESSION.dbpw#">
	            	SELECT TerminalName
		            FROM   Materials.dbo.WarehouseTerminal
	    	        WHERE  TaxOrgUnitEDI = '#qHeader.OrgUnitTax#'
	        </cfquery>
	
	        <cfset url.terminal   = qTerminal.TerminalName>
	
	    </cfif>		
			
	    <cfset url.batchId           = qBatch.BatchId>
	    <cfset url.addressId         = qBatch.AddressId>
	    <cfset url.warehouse         = qBatch.Warehouse>
	    <cfset url.customerId        = qBatch.CustomerId>
	    <cfset url.customeridinvoice = qBatch.CustomerIdInvoice>
	
	    <cfquery name="qCheck"
	            datasource="AppsMaterials"
	            username="#SESSION.login#"
	            password="#SESSION.dbpw#">
			        SELECT   TOP 1 *
			        FROM     Accounting.dbo.TransactionHeaderAction
			        WHERE    Journal	     = '#URL.Journal#'
				    AND      JournalSerialNo = '#URL.JournalSerialNo#'
				    AND      ActionCode      = 'Invoice'
				    AND      ActionReference1 IS NOT NULL
				    AND      ActionReference2 IS NOT NULL
				    AND      ActionReference3 IS NOT NULL
				    ORDER BY Created DESC					
	    </cfquery>
				
	    <cfif qCheck.recordcount eq 0 OR qCheck.ActionStatus eq 9>
		
				<!--- this now will generate an invoice : we move this now to preparation mode = 3 
					
	            <cfinvoke  component      = "Service.Process.Materials.POS"
	                   method             = "initiateInvoice"
					   Journal            = "#url.journal#"
					   JournalSerialNo    = "#url.journalSerialNo#"		
	                   batchid            = "#url.batchId#"
	                   warehouse          = "#url.warehouse#"
	                   terminal           = "#url.terminal#"
	                   customerid         = "#url.customerid#"
	                   customeridinvoice  = "#url.customeridinvoice#"
	                   currency           = "#url.Currency#"
	                   Mode               = "#url.mode#"
	                   returnvariable     = "vInvoice">
					   
				--->
				
				<cfinvoke component = "Service.Process.EDI.Manager"
					   method           = "SaleIssue" 
					   Datasource       = "AppsOrganization"
					   Mission          = "#qHeader.Mission#"
					   Terminal			= "#Terminal#"
				       Mode 			= "#url.Mode#"  <!--- = 3 --->
					   Journal          = "#url.journal#"
					   JournalSerialNo  = "#url.journalSerialNo#"	
					   eMailAddress     = "#qCheck.eMailAddress#"		
					   ActionId         = "#url.actionid#"						    
					   returnvariable	= "vInvoice">									   
	
	        <cfset vActionId = vInvoice.ActionId>
	
	    <cfelse>
		
			<!--- a record was found, so we show what we have already --->
	
	        <cfset vActionId = qCheck.ActionId>
	
	    </cfif>
		
	    	<cfif url.actionid neq "">
			
					<cfset vActionId = url.actionid>	
			
			</cfif>
				
	    <cfoutput>
		
		    <!--- points to the same template as we do in the POS settlement --->
			
		    <script>
		        ptoken.navigate("#SESSION.root#/Warehouse/Application/Salesorder/POS/Settlement/SaleInvoice.cfm?actionid=#vActionId#&batchid=#URL.BatchId#&warehouse=#url.warehouse#&currency=#url.currency#&terminal=#url.terminal#", 'wsettle');
				if (document.getElementById('invoiceactionbox')) {
				    ptoken.navigate("#SESSION.root#/GLedger/Application/Transaction/View/getTransactionAction.cfm?journal=#URL.journal#&journalserialNo=#url.journalserialno#", 'invoiceactionbox');
				} 
		        try { window.opener.location.reload(); } catch(e) {}
	       </script>
			
			<!---
	        <script>
		        ptoken.navigate("#SESSION.root#/GLedger/Application/Transaction/Invoice/SaleViewInvoice.cfm?actionid=#vActionId#&journal=#URL.journal#&journalserialNo=#url.journalserialno#&currency=#url.currency#&terminal=#url.terminal#", 'wsettle');
		        try { window.opener.location.reload(); } catch(e) {}
	       </script>	
		   --->
		   
		</cfoutput>   	   
		
	<cfelse>
	
			 <cfquery name="qCheck"
	            datasource="AppsMaterials"
	            username="#SESSION.login#"
	            password="#SESSION.dbpw#">
			        SELECT   TOP 1 *
			        FROM     Accounting.dbo.TransactionHeaderAction
			        WHERE    Journal	     = '#URL.Journal#'
				    AND      JournalSerialNo = '#URL.JournalSerialNo#'
				    AND      ActionCode      = 'Invoice'
				    AND      ActionReference1 IS NOT NULL
				    AND      ActionReference2 IS NOT NULL
				    AND      ActionReference3 IS NOT NULL
				    ORDER BY Created DESC			
						
		    </cfquery>
			
		    <!--- accounting and workorder sales --->
			
			
			 <cfif url.actionid eq "">						
			 					
				<cfinvoke component = "Service.Process.EDI.Manager"
						   method           = "SaleIssue" 
						   Datasource       = "AppsOrganization"
						   Mission          = "#qHeader.Mission#"
						   Terminal			= "#Terminal#"
					       Mode 			= "#url.Mode#"  <!--- = 3 --->
						   Journal          = "#url.journal#"
						   JournalSerialNo  = "#url.journalSerialNo#"		
						   ActionId         = "#url.actionid#"					    
						   returnvariable	= "stResponse">
					
					<cfif stResponse.Status neq "OK">	
						 
						<!--- 10 retries--->							
						
						<cfloop index="rtNo" from="1" to="10">	
														
							<cfinvoke component = "Service.Process.EDI.Manager"  
									   method           = "SaleIssue" 
									   Datasource       = "AppsOrganization"
									   Mission          = "#qHeader.Mission#"
									   Terminal			= "#Terminal#"
									   Mode 			= "#url.Mode#"		
									   Journal          = "#url.journal#"
									   JournalSerialNo  = "#url.journalSerialNo#"		
									   ActionId         = "#url.actionid#"								   
									   RetryNo			= "#rtNo#"
									   returnvariable	= "stResponse">		
						
							<cfif stResponse.Status eq "OK">
								<cfbreak>
							</cfif>
								
						</cfloop> 	
		
						<cfif stResponse.Status neq "OK">	
														   					
							 <!--- manual 5/7/2021 by dev	<cfset Invoice.Mode = "1"> --->
							 <cfset Invoice.Status = "9">
							 <cfset Invoice.ErrorDescription = stResponse.ErrorDescription>
							 <cfif StructKeyExists(stResponse,"ErrorDetail")>
								 <cfset Invoice.ErrorDetail = stResponse.ErrorDetail>
							 </cfif>
							 
						</cfif>
						
						<cfset vActionId = stResponse.ActionId>
						
					<cfelse>
					
						<cfset vActionId = stResponse.ActionId>	
					
					</cfif> 	
						
		    <cfelse>
			
				<!--- a record was found, so we show what we have already --->
		
		        <cfset vActionId = qCheck.ActionId>
		
		    </cfif>		
			
			<cfif url.actionid neq "">
			
					<cfset vActionId = url.actionid>	
			
			</cfif>
			
			<cfoutput>
			
			  <!--- points to a different template --->
		
	          <script>
			  
			    _cf_loadingtexthtml='';	
		        ptoken.navigate("#SESSION.root#/GLedger/Application/Transaction/Invoice/SaleViewInvoice.cfm?actionid=#vActionId#&journal=#URL.journal#&journalserialNo=#url.journalserialno#&currency=#url.currency#&terminal=#url.terminal#", 'wsettle');
				if (document.getElementById('invoiceactionbox')) {
		        ptoken.navigate("#SESSION.root#/GLedger/Application/Transaction/View/getTransactionAction.cfm?journal=#URL.journal#&journalserialNo=#url.journalserialno#", 'invoiceactionbox');
				}				
		        try { window.opener.location.reload(); } catch(e) {}
	          </script>	
		   
		    </cfoutput>   	 
			
			<!--- dev : do record action and other stuff --->	
	
	</cfif>

<cfelse>

<table style="width:100%"><tr class="labelmedium2">
    <td align="center"><cf_tl id="Action not supported"></td></tr>
</table>

</cfif>
