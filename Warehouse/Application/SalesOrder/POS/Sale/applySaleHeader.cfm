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
		
<!--- apply changes in the context of the sale, like customer billing, currency, sales person, schedule --->

<!--- request details --->

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT        *
	FROM         CustomerRequest
	WHERE        RequestNo = '#url.requestNo#' 
</cfquery>	

<cfparam name="url.warehouse"  		  default="#get.Warehouse#">
<cfparam name="url.customerid" 		  default="#get.CustomerId#">
<cfparam name="url.addressid"  		  default="#get.AddressId#">
<cfparam name="url.customeridinvoice" default="00000000-0000-0000-0000-000000000000">

<cfparam name="form.discount"		  default="0">

<cfif url.field neq "billing">

	<!--- --------------------------------------------------------------------------------------- --->
	<!--- method to adjust the pricing based on a selected price schedule for this sale 
		we select a schedule and the based on the currency of the sale the prices and 
		totals are redefined and then shown in the screen                                         --->
	<!--- --------------------------------------------------------------------------------------- --->	
				
	<cfif CustomerId eq "">
		
		<cf_tl id="Alert" var="vAlert">
		<cf_tl id="You need to select a valid customer record to perform this action" var="vMessage">
		<cf_tl id="Operation aborted" var="vAbort">
		
		<cfoutput>
			<script>
				alert("#vAlert#: #vMessage#.\n #vAbort#.");
			</script>
		</cfoutput>
		
		<cfabort>
	
	</cfif>
	
</cfif>	

<cfswitch expression="#url.field#">		
	
	<cfcase value="billing">				
	
		<!--- --------------------------------------------------------- --->
		<!--- ------ Apply change in the invoice NIT to the sale ------ --->
		<!--- --------------------------------------------------------- --->
		
		<cfparam name="url.init"              default="0">
		<cfparam name="url.batchid"           default="">
		
		<cfif url.customeridinvoice eq "00000000-0000-0000-0000-000000000000">
		    <script>
			try {
				document.getElementById('customerinvoiceselect').value = ''
				document.getElementById('addressidselect').value = ''
				document.getElementById('customerinvoiceselect').focus()
			} catch(e) {}
			</script>
		</cfif>	
	
		<cfif (url.customeridinvoice eq "" or url.customeridinvoice eq "insert") and url.init eq "0">
					    	    	
			<script language="JavaScript">
			
			<cf_tl id="Customer not found. Do you want to record customer" var="1">
			
			 <cfoutput>
			 			 
			 // if (!!Prosis) {
				 //Hide all notifications
			 //    Prosis.notification.hide();
			 // }
			
			 if (confirm("#lt_text#?")) {
			 
			  ref = document.getElementById("customerinvoiceidselect_val").value			  
			  ProsisUI.createWindow('customeradd', 'Add Customer', '',{x:100,y:100,width:700,height:700,resizable:false,modal:true,center:true})			  
	  	      ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/addCustomer.cfm?mission=#url.mission#&warehouse=#url.warehouse#&mode=invoice&reference='+ref,'customeradd');
		  			  	
  			  } else {
			    document.getElementById('customerinvoiceselect').focus()
			  }
			
			 </cfoutput>
			
			</script>
							
			<cfabort>
				
		<cfelse>		
		
			<cfif url.customeridinvoice eq "" or url.customeridinvoice eq "00000000-0000-0000-0000-000000000000">
		
				<cf_tl id="Alert" var="vAlert">
				<cf_tl id="You need to select a valid customer record to perform this action" var="vMessage">
				<cf_tl id="Operation aborted" var="vAbort">
				
				<cfoutput>
					<script>
						alert("#vAlert#: #vMessage#.\n #vAbort#.");
					</script>
				</cfoutput>
				
				<cfabort>
		
			</cfif>				
		
			<cfif url.requestno neq "">
			
				<cfquery name="getLines"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     vwCustomerRequest
						WHERE    RequestNo = '#url.RequestNo#'						
				</cfquery>
				
				<!--- apply the customer invoice id no longers updates the lines 
				
				<cfloop query="getLines"> 	
										
					<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "getPrice" 
					   warehouse        = "#warehouse#" 
					   priceschedule    = "#priceschedule#"
					   discount         = "#form.discount#"
					   customerid       = "#customerid#"
					   customeridtax    = "#url.customeridInvoice#"
					   currency         = "#SalesCurrency#"
					   ItemNo           = "#itemno#"
					   UoM              = "#TransactionUoM#"
					   quantity         = "#TransactionQuantity#"
					   returnvariable   = "sale">						   		   
					   
					<cfquery name="setLine"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE   CustomerRequestLine 
							SET      CustomerIdInvoice = '#url.customeridInvoice#', 
							         PriceSchedule     = '#Priceschedule#',		
							         SchedulePrice     = '#sale.scheduleprice#', 
									 SalesCurrency     = '#SalesCurrency#', 
									 SalesPrice        = '#sale.price#',
									 TaxCode           = '#Sale.TaxCode#',
									 TaxPercentage     = '#Sale.Tax#', 
									 TaxExemption      = '#Sale.TaxExemption#', 						
									 TaxIncluded       = '#sale.inclusive#', 
									 SalesUnitPrice    = '#sale.PriceNet#', 
									 SalesAmount       = '#sale.amount#', 
									 SalesTax          = '#sale.amounttax#' 									 	 
							WHERE    TransactionId = '#TransactionId#'		
					</cfquery>
										
				</cfloop>
				
				--->
								
				<cfinclude template="SaleViewLines.cfm">
				<cfinclude template="setTotal.cfm">
			
			</cfif>
							
			<cfoutput>
						
				<script language="JavaScript">
		
				 // show the customer billing information in the box
				 ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/getCustomerBilling.cfm?customerid=#url.customeridInvoice#&warehouse=#url.warehouse#','customerinvoicebox')	
				 
				 document.getElementById('ItemSelect').focus()	// data entry of items
				 
				 <cfif url.customerid eq "" or url.customerid eq "00000000-0000-0000-0000-000000000000" or url.customerid eq "insert"> //In case they enter the customer invoice first.
					 if (confirm('We noticed that you have not selected a customer yet.\nDo you want the customer to be the same as the customer billing you just entered?')){
						 ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#&customerid=#url.customeridInvoice#&addressid=#url.addressid#','customerbox');
					 }
				 </cfif>
					 
				</script>	
			
			</cfoutput>
							
		</cfif>	
		
	</cfcase>	
	
	<cfcase value="currency">
				
		<!--- --------------------------------------------------------- --->
		<!--- ------ Apply change in the currency to the sale --------- --->
		<!--- --------------------------------------------------------- --->
		
		<cfif CustomerId eq "">
			
			<cf_tl id="Alert" var="vAlert">
			<cf_tl id="You need to select a valid customer record to perform this action" var="vMessage">
			<cf_tl id="Operation aborted" var="vAbort">
			
			<cfoutput>
				<script>
					alert("#vAlert#: #vMessage#.\n #vAbort#.");
				</script>
			</cfoutput>
			
			<cfabort>
			
		</cfif>
		
		<cfquery name="getLines"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     vwCustomerRequest
						WHERE    RequestNo = '#url.RequestNo#'						
				</cfquery>
		
		<!--- apply the rate using a different currency : pending tuning --->
		
		<cfloop query="getLines">
		
			<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "getPrice" 
					   warehouse        = "#warehouse#" 
					   priceschedule    = "#priceschedule#"
					   discount         = "#form.discount#"
					   customerid       = "#customerid#"
					   customeridTax    = "#url.customeridInvoice#"
					   currency         = "#url.Currency#"
					   ItemNo           = "#itemno#"
					   UoM              = "#TransactionUoM#"
					   quantity         = "#TransactionQuantity#"
					   returnvariable   = "sale">			   
				   
				<cfquery name="setLine"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE   CustomerRequestline 
						SET      PriceSchedule  = '#Sale.priceschedule#',	
						         SalesCurrency  = '#url.Currency#', 	
						         SchedulePrice  = '#Sale.scheduleprice#', 
								 SalesPrice     = '#Sale.price#',
								 TaxCode        = '#Sale.TaxCode#',
								 TaxPercentage  = '#Sale.Tax#', 
								 TaxExemption   = '#Sale.TaxExemption#', 
								 TaxIncluded    = '#Sale.inclusive#',  
								 SalesUnitPrice = '#sale.PriceNet#',
								 SalesAmount    = '#Sale.amount#', 
								 SalesTax       = '#Sale.amounttax#' 	 
						WHERE    TransactionId  = '#TransactionId#'		
				</cfquery>
		
		</cfloop>
		
		<cfinclude template="SaleViewLines.cfm">
		<cfinclude template="setTotal.cfm">
	
	</cfcase>	
	
	<cfcase value="salesperson">		
		
		<!--- --------------------------------------------------------- --->
		<!--- ------ Apply change in the sales person to the sale ----- --->
		<!--- --------------------------------------------------------- --->
				
		<cfquery name="getLines"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     vwCustomerRequest
						WHERE    RequestNo = '#url.RequestNo#'						
				</cfquery>
		
		<!--- apply the rate using a different currency : pending tuning --->
		
		<cfloop query="getLines">
				   
				<cfquery name="setLine"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE   CustomerRequestline 
						SET      SalesPersonNo = '#url.personno#'
						WHERE    TransactionId = '#getLines.TransactionId#'		
				</cfquery>
		
		</cfloop>
		
		<cfinclude template="SaleViewLines.cfm">
		<cfinclude template="setTotal.cfm">
			
	</cfcase>
		
	<cfcase value="schedule">
		
		<cfquery name="getLines"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     vwCustomerRequest
				WHERE    RequestNo = '#url.RequestNo#'						
		</cfquery>
		
		<cfloop query="getLines">
			
			<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "getPrice" 
					   warehouse        = "#warehouse#" 
					   priceschedule    = "#url.priceschedule#"
					   discount         = "#form.discount#"
					   customerid       = "#customerid#"
					   customeridtax    = "#url.customeridInvoice#"
					   currency         = "#form.Currency#"
					   ItemNo           = "#itemno#"
					   UoM              = "#TransactionUoM#"
					   quantity         = "#TransactionQuantity#"
					   returnvariable   = "sale">			   
					   
					<cfquery name="setLine"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE   CustomerRequestline 
							SET      PriceSchedule  = '#url.priceschedule#',		
							         SchedulePrice  = '#sale.scheduleprice#', 
									 SalesCurrency  = '#form.Currency#', 
									 SalesPrice     = '#sale.price#',
									 TaxCode        = '#Sale.TaxCode#',
									 TaxPercentage  = '#Sale.Tax#', 
									 TaxExemption   = '#Sale.TaxExemption#', 						
									 TaxIncluded    = '#sale.inclusive#',
									 SalesUnitPrice = '#sale.PriceNet#',  
									 SalesAmount    = '#sale.amount#', 
									 SalesTax       = '#sale.amounttax#' 	 
							WHERE    TransactionId  = '#TransactionId#'		
					</cfquery>
		
		</cfloop>
	
		<cfinclude template="SaleViewLines.cfm">
		<cfinclude template="setTotal.cfm">
		
	</cfcase>
	
	<cfcase value="discount">
		
		<cfquery name="getLines"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     vwCustomerRequest
				WHERE    RequestNo = '#url.RequestNo#'						
		</cfquery>
		
		<cfloop query="getLines">
			
			<cfinvoke component = "Service.Process.Materials.POS"  
				   method           = "getPrice" 
				   warehouse        = "#warehouse#" 
				   priceschedule    = "#form.priceschedule#"
				   discount         = "#form.discount#"
				   customerid       = "#customerid#"
				   customeridtax    = "#url.customeridInvoice#"
				   currency         = "#form.Currency#"
				   ItemNo           = "#itemno#"
				   UoM              = "#TransactionUoM#"
				   quantity         = "#TransactionQuantity#"
				   returnvariable   = "sale">						 		  
				  
				<cfquery name="setLine"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">						
						UPDATE   CustomerRequestLine 
						SET      PriceSchedule = '#form.priceschedule#',									 
						         SchedulePrice = '#sale.Scheduleprice#', 									 								
								 SalesCurrency  = '#form.Currency#', 
								 SalesDiscount  = '#form.Discount#',
								 SalesPrice     = '#sale.price#',
								 TaxCode        = '#Sale.TaxCode#',
								 TaxPercentage  = '#Sale.Tax#', 
								 TaxExemption   = '#Sale.TaxExemption#', 						
								 TaxIncluded    = '#sale.inclusive#',  
								 SalesUnitPrice = '#sale.PriceNet#',
								 SalesAmount    = '#sale.amount#', 
								 SalesTax       = '#sale.amounttax#' 	 
						WHERE    TransactionId  = '#TransactionId#'		
				</cfquery>
		
		</cfloop>
	
		<cfinclude template="SaleViewLines.cfm">
		<cfinclude template="setTotal.cfm">
		
	</cfcase>
		

	<cfcase value="salepersonline">		
		
		<!--- --------------------------------------------------------- --->
		<!--- ------ Apply change in the sales person to the sale ----- --->
		<!--- --------------------------------------------------------- --->
				   
		<cfquery name="setLine"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE   CustomerRequestLine  
				SET      SalesPersonNo = '#url.personno#'
				WHERE    TransactionId = '#URL.TransactionId#'		
		</cfquery>		
		
		<cfinclude template="SaleViewLines.cfm">
		<cfinclude template="setTotal.cfm">
			
	</cfcase>		
		
</cfswitch>