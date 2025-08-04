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

<!--- this template 
	1. adds a line to the list which it receives from the extended listing which has a form which passes
	2. refreshes the listing 
--->

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTE = dateValue>
	
<cfset dte = DateAdd("h","#url.hour#", dte)>
<cfset dte = DateAdd("n","#url.minu#", dte)>

<!--- refresh the lines view --->
<cfparam name="url.requestno" 		   default="">
<cfparam name="url.customerid"         default="">
<cfparam name="url.customerinvoiceid"  default="">
<cfparam name="url.salespersonno"      default="">
<cfparam name="url.currency"           default="USD">
<cfparam name="url.addressid" 		   default="00000000-0000-0000-0000-000000000000">

<cfif url.requestNo eq "">

	<cf_setCustomerRequest>
	<cfset url.requestNo = thisrequestNo>

</cfif>

<cfif url.customerid eq "">

	<script>
		alert("Customer could not be determined.")
	</script>
	<cfabort>

</cfif>

<cfquery name="warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    * 
	FROM      Warehouse
	WHERE     Warehouse = '#url.Warehouse#' 
</cfquery>	

<cfquery name="get" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT    *
         FROM      Item
         WHERE     ItemNo = '#url.ItemNo#'		 				 		 
</cfquery>

<cfquery name="getMode" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
         SELECT    W.*, P.LotManagement
         FROM      Warehouse W, Ref_ParameterMission P
         WHERE     W.Warehouse = '#url.warehouse#'		 				 
		 AND       W.Mission = P.Mission 
</cfquery>

<!--- line op the items in the same order --->

<cfif getMode.LotManagement eq "0" or get.ItemClass neq "Supply">
			
   <cfquery name="getItems" 
      datasource="AppsMaterials" 
  	  username="#SESSION.login#" 
      password="#SESSION.dbpw#">
  	    SELECT    *, 0 as TransactionLot
        FROM      ItemUoM
        WHERE     ItemNo = '#url.itemno#'		
	    AND       Operational = 1 				 
   </cfquery>   

<cfelse>
			
   <cfquery name="getItems" 
      datasource="AppsMaterials" 
  	  username="#SESSION.login#" 
      password="#SESSION.dbpw#">
   
	   SELECT   DISTINCT U.ItemNo, U.UoM, U.UoMDescription, U.ItemBarcode,T.TransactionLot
	   FROM     ItemTransaction T INNER JOIN
	            ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN
	            ProductionLot L ON T.Mission = L.Mission AND T.TransactionLot = L.TransactionLot
	   WHERE    T.Warehouse   = '#url.warehouse#'
	   AND      T.ItemNo      = '#url.itemno#'
	   AND      U.Operational = 1
	   ORDER BY T.TransactionLot, 
		        U.UoM	    	   	 			 
   </cfquery>     
   
</cfif>

<cfloop query="getItems">	

    <cfparam name="Form.Quantity_#currentrow#" default="0">

	<cfset qty   = evaluate("Form.Quantity_#currentrow#")>

	<cfif qty neq "0">
		
		  <cfinvoke component   = "Service.Process.Materials.POS"  
			   method           = "getPrice" 
			   warehouse        = "#url.warehouse#" 
			   priceschedule    = "#url.priceschedule#"
			   discount         = "#url.discount#"
			   customerid       = "#url.customerid#"
			   customeridTax    = "#url.customeridInvoice#"
			   currency         = "#url.Currency#"
			   ItemNo           = "#itemno#"
			   UoM              = "#uom#"
			   quantity         = "#qty#"
			   returnvariable   = "sale">	
			
			   <!--- ---------------------------------------------- --->
			   <!--- DEFINE the location from where it is retrieved --->			
			   <!--- ---------------------------------------------- --->			
						
		  <cf_assignid>		
		   
		  <cfquery name="getLines" 
			datasource="AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT   *
				FROM     vwCustomerRequest T
				WHERE    T.CustomerId = '#url.customerid#'
		  		AND  	 T.Warehouse  = '#url.warehouse#'
		  		AND      T.RequestNo = '#url.RequestNo#'
		  </cfquery>
		
		  <cfif getLines.recordcount gte warehouse.salelines>
		
		    <cfoutput>
		    <cf_tl id="Maximum sales lines reached">
			<script>
			alert("#lt_text#")
			</script>
			</cfoutput>
		  <cfelse>
			
		   <cfquery name="Insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				INSERT INTO dbo.CustomerRequestLine  	
				
				         (	RequestNo,
						    TransactionId, 
							TransactionType, 
							TransactionDate, 
							ItemNo, 
							ItemClass,
							ItemDescription, 
							ItemCategory, 	
							<!---					
							Mission, 
							Warehouse, 
							--->
								
				            TransactionUoM, 
							TransactionLot,
							TransactionQuantity, 
							<!---           
							CustomerId, 
							AddressId,
							--->
							CustomerIdInvoice,							
							PriceSchedule,
							SalesCurrency, 
							SchedulePrice, 
							SalesPrice, 
							TaxCode,
							TaxPercentage, 
							TaxExemption, 
							TaxIncluded, 
							SalesUnitPrice,
							SalesAmount, 
							SalesTax, 			           
							PersonNo,
							SalesPersonNo,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )  
								
				VALUES ('#url.RequestNo#',
				        '#rowguid#',
					    '2',
					    #dte#,
					    '#url.itemno#', 
						'#sale.ItemClass#',
						'#sale.ItemDescription#', 
						'#sale.Category#',
						<!---
						'#sale.Mission#', 
						'#url.warehouse#', 
						--->
						
						'#uom#',    
						'#TransactionLot#',        
						'#qty#',			
						<!---           
						'#url.CustomerId#', 
						'#url.addressId#',	
						--->
						<cfif url.CustomerIdInvoice neq "">
							'#url.customerIdinvoice#', 
						<cfelse>
							'#url.CustomerId#',
						</cfif>				
						
						'#sale.priceschedule#',
						'#url.currency#', 
						'#sale.scheduleprice#', 
						'#sale.price#', 
						'#sale.TaxCode#',
						'#sale.tax#', 
						'#sale.taxexemption#', 
						'#sale.inclusive#', 
						'#sale.pricenet#',
						'#sale.amount#', 
						'#sale.amounttax#', 			           
						'#client.PersonNo#',
						'#url.salespersonno#',
						'#session.acc#',
						'#session.last#',
						'#session.first#' 
						)		
						  
			</cfquery>	
						
			</cfif>			

	</cfif>
	
</cfloop>	

<script language="JavaScript">
  try {
	  document.getElementById('vaction').className = "regular"
	  document.getElementById('dlist').className   = "hide" 
  } catch(e) {}
</script>

<cfinclude template="SaleViewLines.cfm">
<cfinclude template="setTotal.cfm">
