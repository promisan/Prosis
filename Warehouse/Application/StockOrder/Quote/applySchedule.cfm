

<!--- apply customer --->

<cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   vwCustomerRequest
	WHERE  RequestNo       = '#url.Requestno#'	
</cfquery>

<cfloop query="get">
	
	<!--- get price --->
	
	<cfinvoke component  = "Service.Process.Materials.POS"  
		   method            = "getPrice" 
		   priceschedule     = "#url.priceschedule#"
		   discount          = "0"
		   warehouse         = "#warehouse#" 
		   customerid        = "#customerid#"	   
		   currency          = "#SalesCurrency#"
		   ItemNo            = "#ItemNo#"
		   UoM               = "#TransactionUom#"
		   quantity          = "#TransactionQuantity#"
		   returnvariable    = "sale">	
			              
	      <!--- apply price --->		
	
		<cfquery name="setLine"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE CustomerRequestLine 
			SET     PriceSchedule      = '#url.priceschedule#',
				  <!---	SalesCurrency,  --->
					SchedulePrice     = '#sale.scheduleprice#', 
					SalesPrice        = '#sale.price#', 
					TaxCode           = '#sale.TaxCode#',
					TaxPercentage     = '#sale.tax#',  
					TaxExemption      = '#sale.taxexemption#', 
					TaxIncluded       = '#sale.inclusive#', 
					SalesUnitPrice    = '#sale.pricenet#',
					SalesAmount       = '#sale.amount#', 		
					SalesTax          = '#sale.amounttax#',
					PersonNo          = '#client.PersonNo#',
					SalesPersonNo     = '#client.PersonNo#'  
			WHERE  TransactionId      = '#transactionid#'		
		</cfquery>		   

</cfloop>

<cfoutput>

<script>
   <cfif get.requestNo neq "">
       ptoken.navigate('getQuoteLine.cfm?action=add&requestno=#url.Requestno#&warehouse=#get.Warehouse#&action=view','boxlines') 				
	   document.getElementById('boxaction').className = "regular"
   </cfif>
</script>

</cfoutput>

<!--- refresh the lines --->
