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

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTE = dateValue>
	
<cfset dte = DateAdd("h","#url.hour#", dte)>
<cfset dte = DateAdd("n","#url.minu#", dte)>

<cfparam name="url.requestno" 			default="">
<cfparam name="url.customerId" 			default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.CustomerIdInvoice" 	default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.refreshContent" 		default="1">


<!--- this template 
1. adds a line to the list which it receives from the extended listing which has a form which passes
2. refreshes the listing 
--->

<!--- lets add an option to select a quote no as well --->

<cfif url.requestNo eq "">

	<cf_setCustomerRequest>
	<cfset url.requestNo = thisrequestNo>

</cfif>

<!--- defined price --->

<cfif isDefined("url.CustomerIdInvoice")>
	<cfif len(url.CustomerIdInvoice) lte 0>
		<cfset url.CustomerIdInvoice ="00000000-0000-0000-0000-000000000000">
	</cfif>
</cfif>

<cfquery name="getUoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      ItemUoM
	WHERE     ItemUoMId = '#url.ItemUoMId#' 
</cfquery>	

<cfset qty = "1">

<cfif isDefined("url.BOMId")>
	
	<cfif trim(url.BOMId) neq "">
	
		<cfquery name="qGetItemBOM" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT    *
				FROM      ItemBOM
				WHERE     BOMId = '#url.BOMId#'   	
		</cfquery>
		
		<cfquery name="qGetItemClass" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT    *
				FROM      Item
				WHERE     ItemNo = '#qGetItemBOM.ItemNo#'  	
		</cfquery>
			
		<cfif qGetItemClass.itemClass eq "Bundle">
		
			<cfquery name="qGetItemBundle" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT 	*
					FROM    ItemBOMDetail
					WHERE   BOMId          = '#url.BOMId#'  
					AND		MaterialItemNo = '#getUoM.ItemNo#'  		 							   		      
					AND		MaterialUoM    = '#getUoM.UoM#'
			</cfquery>
		
			<cfif qGetItemBundle.recordCount eq 1>
				<cfset qty = qGetItemBundle.MaterialQuantity>
			</cfif>
		
		</cfif>
		
	</cfif>

</cfif>		
		
<cfinvoke component  = "Service.Process.Materials.POS"  
	   method            = "getPrice" 
	   priceschedule     = "#url.priceschedule#"
	   discount          = "#url.discount#"
	   warehouse         = "#url.warehouse#" 
	   customerid        = "#url.customerid#"
	   customeridTax     = "#url.customeridInvoice#"
	   currency          = "#url.Currency#"
	   ItemNo            = "#getUoM.itemno#"
	   UoM               = "#getUoM.uom#"
	   quantity          = "#qty#"
	   returnvariable    = "sale">	
   
   <cfquery name="getCategory" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_Category
		WHERE     Category = '#sale.Category#' 
	</cfquery>	
	
	<!--- DEFINE he location from where it is retrieved --->			
	<!--- --------------------------------------------- --->			
	
	<!--- transaction id --->
	<cf_assignid>
	
	<!--- check if item is already requested by the same customer, in that case we add  --->
		
	<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   vwCustomerRequest
		WHERE  RequestNo       = '#Requestno#'		
		AND    ItemNo          = '#getUoM.itemno#'
		AND    TransactionUoM  = '#getUoM.uom#'	
	</cfquery>
	
	<cfif get.recordcount eq "1" and getCategory.commissionMode eq "0">
	
		<cfset qty = get.TransactionQuantity+qty>
				
		<cfset price = get.SalesPrice>
		<cfset tax   = get.TaxPercentage>
				
		<cfif get.TaxIncluded eq "0">
								   
			<cfset amountsle  = price * qty>
			<cfset amounttax  = (tax * price) * qty>	
				
		<cfelse>				
					
			<cfset amounttax  = ((tax/(1+tax))*price)*qty>	
			<!--- <cfset amountsle = ((1/(1+tax))*price)*qty> --->
			<!--- changed way of calculating amountsle as otherwise sometimes we have .01 data loss ---->
			<cfset amountsle  = (price * qty) - amounttax>	
			
		</cfif>
		
		<cfset unitprice = amountsle / qty>
		
		<cfif get.TaxExemption eq "1">
		  <cfset amounttax = 0>
		</cfif>
	
		<cfquery name="setLine"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE CustomerRequestLine 
			SET    TransactionQuantity = #qty#,
				   SalesUnitPrice      = '#unitprice#',	
			       SalesAmount         = '#amountsle#',
				   SalesTax            = '#amounttax#',
				   SalesPersonNo       = '#url.salespersonno#'
			WHERE  TransactionId       = '#get.transactionid#'		
		</cfquery>
		
	<cfelse>	
	
		<cfquery name="warehouse" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Warehouse  
			WHERE     Warehouse = '#url.Warehouse#' 
		</cfquery>	
	
	    <cfquery name="getLines" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT   *				
				FROM     CustomerRequestLine
				WHERE    RequestNo       = '#url.RequestNo#'				
		</cfquery>
		
		<cfif getLines.recordcount gte warehouse.salelines>
		
			<cf_tl id="Maximum sale request lines reached">
			<cfoutput>
			<script>
			alert("#lt_text#")
			</script>
			</cfoutput>
		
		<cfelse>													 
					
			<cfquery name="InsertLine" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				INSERT INTO dbo.CustomerRequestLine ( 				   
						RequestNo,
						TransactionId, 
						TransactionType, 
						TransactionDate, 
						ItemNo, 
						ItemClass,
						ItemDescription, 
						ItemCategory, 											
			            TransactionUoM, 
						TransactionLot,
						TransactionQuantity,  					
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
								
				VALUES ('#url.requestNo#',
				        '#rowguid#',
					    '2',
					    #dte#,
					    '#getUoM.itemno#', 
						'#sale.ItemClass#',
						'#sale.ItemDescription#', 
						'#sale.Category#',										
						'#getUoM.uom#',     
						'#url.transactionlot#',       
						'#qty#',									
						'#url.CustomerIdInvoice#', 						
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
						'#session.first#' )		  
						
				</cfquery>
			
			</cfif>
		
	</cfif>	

<cfif url.refreshContent eq 1>
	<!--- refresh the lines view --->
	<cfinclude template="SaleViewLines.cfm">
	<cfinclude template="setTotal.cfm">
</cfif>

