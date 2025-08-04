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
			SET    PriceSchedule      = '#url.priceschedule#',
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
