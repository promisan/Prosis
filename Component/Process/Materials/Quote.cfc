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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="AddQuote"
             access="public"
             returntype="any"
             displayname="Create a new quote for a store">
		
		<cfargument name="Mission"   	type="string"  required="true"  default="">
		<cfargument name="Warehouse"   	type="string"  required="true"  default="">
		<cfargument name="CustomerId"   type="string"  required="true"  default="00000000-0000-0000-0000-000000000000">
		<cfargument name="AddressId"   	type="string"  required="true"  default="00000000-0000-0000-0000-000000000000">

		<cfquery name="InsertQuote"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DECLARE @ThisQuote TABLE (RequestNo INT);

				INSERT INTO CustomerRequest ( 	
					Mission, 
					Warehouse, 				
					CustomerId,
					AddressId, 				
					Source, 
					ActionStatus,
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName )

				OUTPUT INSERTED.RequestNo INTO @ThisQuote  
								
				VALUES ( '#arguments.Mission#', 
						'#arguments.Warehouse#', 
						'#arguments.CustomerId#', 
						'#arguments.AddressId#',
						'Quote',
						'0',
						'#session.acc#',
						'#session.last#',
						'#session.first#' );

				SELECT	*
				FROM	@ThisQuote;	
		</cfquery>

		<cfquery name="getNewQuote"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   CustomerRequest
				WHERE  RequestNo = '#InsertQuote.RequestNo#'
		</cfquery>
		
		<cfreturn getNewQuote>
		
	</cffunction>	
	
	<cffunction name="addQuoteItem"
             access="public"
             returntype="any"
             displayname="Add an item to a quote">
		
		<cfargument name="CustomerId"   	type="string"  required="true"  default="00000000-0000-0000-0000-000000000000">
		<cfargument name="RequestNo"      	type="string"  required="true"  default="0">
		<cfargument name="PriceSchedule"  	type="string"  required="true"  default="">
		<cfargument name="ItemNo"         	type="string"  required="true"  default="">
		<cfargument name="UoM"            	type="string"  required="true"  default="">
		<cfargument name="TransactionLot"	type="string"  required="true"  default="0">
		<cfargument name="mission"     		type="string"  required="true"  default="">
		<cfargument name="Quantity"       	type="string"  required="true"  default="">
		<cfargument name="Currency"       	type="string"  required="true"  default="">
		<cfargument name="Seller"       	type="string"  required="true"  default="">

		<cfset vSeller = arguments.Seller>
		<cfif isDefined("client.personNo")>
			<cfset vSeller = client.personNo>
		</cfif>

		<cfset qty = arguments.Quantity>
			
		<!--- defined price : determine customer and currency to be passed --->
				
		<cfinvoke component  = "Service.Process.Materials.POS"  
				method            = "getPrice" 
				mission           = "#arguments.mission#"
				priceschedule     = "#arguments.priceschedule#"
				discount          = "0"	   
				currency          = "#arguments.Currency#"
				ItemNo            = "#arguments.itemno#"
				UoM               = "#arguments.uom#"
				quantity          = "1"
				returnvariable    = "sale">	
	
		<!--- check if item is already requested by the same customer, in that case we add  --->
			
		<cfquery name="get"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   vwCustomerRequest
			WHERE  RequestNo       = '#arguments.Requestno#'		
			AND    ItemNo          = '#arguments.itemno#'
			AND    TransactionUoM  = '#arguments.uom#'	
		</cfquery>
	
		<cfif get.recordcount eq "1">				
					
			<cfset qty = get.TransactionQuantity+qty>
					
			<cfset price = get.SalesPrice>
			<cfset tax   = get.TaxPercentage>
					
			<cfif get.TaxIncluded eq "0">
													
				<cfset amountsle  = price * qty>
				<cfset amounttax  = (tax * price) * qty>	
					
			<cfelse>				
												
				<cfset amounttax  = ((tax/(1+tax))*price)*qty>	
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
						SalesTax            = '#amounttax#'
				WHERE  TransactionId       = '#get.transactionid#'		
			</cfquery>
						
		<cfelse>	
				
			<cfquery name="getLines" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
					SELECT   *				
					FROM     CustomerRequestLine
					WHERE    RequestNo = '#arguments.RequestNo#'				
			</cfquery>
			
			<cf_assignid>
							
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
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )  
								
				VALUES ('#arguments.requestNo#',
						'#rowguid#',
						'2',
						getDate(),
						'#arguments.itemno#', 
						'#sale.ItemClass#',
						'#sale.ItemDescription#', 
						'#sale.Category#',										
						'#arguments.uom#',     
						'#arguments.transactionlot#',       
						'#qty#',	
						'#sale.priceschedule#',
						'#arguments..currency#', 
						'#sale.scheduleprice#', 
						'#sale.price#', 
						'#sale.TaxCode#',
						'#sale.tax#', 
						'#sale.taxexemption#', 
						'#sale.inclusive#', 
						'#sale.pricenet#',
						'#sale.amount#', 
						'#sale.amounttax#', 			           
						'#vSeller#',
						'#session.acc#',
						'#session.last#',
						'#session.first#' )		  
						
			</cfquery>
				
		</cfif>	
				
	</cffunction>	
	
</cfcomponent>	
