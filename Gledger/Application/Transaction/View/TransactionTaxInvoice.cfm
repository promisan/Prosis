<cfset url.scope 	= "standalone">

<cfparam name="url.currency"     default="QTZ">
<cfparam name="url.mode"         default="3">  <!--- new mode FEL by Hanno which handles discounts and enforces 12% --->
<cfparam name="url.terminal"     default="">

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
  
<cfswitch expression="#qHeader.TransactionSource#">

	<cfcase value="SalesSeries">
	
		<!--- Hanno : this one makes still use of the V2 component also used for POS Cash and Carry --->
	
	    <cfquery name="qBatch"
	        datasource="AppsMaterials"
	        username="#SESSION.login#"
	        password="#SESSION.dbpw#">			
		        SELECT *
		        FROM   Materials.dbo.WarehouseBatch B
		        WHERE  B.BatchId = '#qHeader.TransactionSourceId#'
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
					
	            <cfinvoke  component = "Service.Process.Materials.POS"
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
	
	        <cfset vActionId = vInvoice.ActionId>
	
	    <cfelse>
	
	        <cfset vActionId = qCheck.ActionId>
	
	    </cfif>
	
	    <cfoutput>
		
		    <!--- points to the same template as we do in the POS settlement --->
			
	        <script>
		        ptoken.navigate("#SESSION.root#/GLedger/Application/Transaction/Invoice/SaleViewInvoice.cfm?actionid=#vActionId#&journal=#URL.journal#&journalserialNo=#url.journalserialno#&currency=#url.currency#&terminal=#url.terminal#", 'wsettle');
		        try { window.opener.location.reload(); } catch(e) {}
	       </script>	
		   
		</cfoutput>   	   
		
	</cfcase>
				
	<cfdefaultcase>
		
		    <!--- reflect the code as POS to trigger differently --->
				
			<cfinvoke component = "Service.Process.EDI.Manager"
					   method           = "SaleIssue" 
					   Datasource       = "AppsOrganization"
					   Mission          = "#qHeader.Mission#"
					   Terminal			= "#Terminal#"
				       Mode 			= "#Mode#"
					   Journal          = "#url.journal#"
					   JournalSerialNo  = "#url.journalSerialNo#"							    
					   returnvariable	= "stResponse">
					
			<cfif stResponse.Status neq "OK">	
				 
				<!--- 10 retries--->							
				
				<cfloop index="rtNo" from="1" to="10">	
												
					<cfinvoke component = "Service.Process.EDI.Manager"  
							   method           = "SaleIssue" 
							   Datasource       = "AppsOrganization"
							   Mission          = "#qHeader.Mission#"
							   Terminal			= "#Terminal#"
							   Mode 			= "#Mode#"		
							   Journal          = "#url.journal#"
							   JournalSerialNo  = "#url.journalSerialNo#"									   
							   RetryNo			= "#rtNo#"
							   returnvariable	= "stResponse">		
				
					<cfif stResponse.Status eq "OK">
						<cfbreak>
					</cfif>
						
				</cfloop> 	

				<cfif stResponse.Status neq "OK">	
												   					
					 <!--- manual 5/7/2021 by Armin	<cfset Invoice.Mode = "1"> --->
					 <cfset Invoice.Status = "9">
					 <cfset Invoice.ErrorDescription = stResponse.ErrorDescription>
					 <cfif StructKeyExists(stResponse,"ErrorDetail")>
						 <cfset Invoice.ErrorDetail = stResponse.ErrorDetail>
					 </cfif>
					 
				</cfif>
				
			</cfif>	  	
			
			<cfoutput>
			
			  <!--- points to a different template --->
		
	          <script>
		        ptoken.navigate("#SESSION.root#/GLedger/Application/Transaction/Invoice/SaleViewInvoice.cfm?actionid=#vActionId#&journal=#URL.journal#&journalserialNo=#url.journalserialno#&currency=#url.currency#&terminal=#url.terminal#", 'wsettle');
		        try { window.opener.location.reload(); } catch(e) {}
	          </script>	
		   
		    </cfoutput>   	 
			
			<!--- Armin : do record action and other stuff --->	
	
	</cfdefaultcase>
			
</cfswitch>

<cfelse>

<table style="width:100%"><tr class="labelmedium2">
    <td align="center"><cf_tl id="Action not supported"></td></tr>
</table>

</cfif>