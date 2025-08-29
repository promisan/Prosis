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

	<!----
		Function: AddCustomerAddress
		Purpose:  To add the address where the customer was registered (city and country of the warehouse)
	---->
	
	<cffunction name="CustomerReceivables" access="public" returntype="struct" displayname="Add Customer">
			 
			 <!--- obtain the current value of AR for a warehouse POS customer ---> 
		
			<cfargument name="mission"          type="string"  required="true"      default="">		
			<cfargument name="customerId"       type="string"  required="true"      default="">			
			<cfargument name="balancecurrency"  type="string"  required="true"      default="#application.BaseCurrency#">
			<cfargument name="amountcurrency"   type="string"  required="true"      default="#application.BaseCurrency#">
			<cfargument name="amount"           type="string"  required="true"      default="0">
			
			<cfif isValid("GUID",customerid)>
			
			<cfelse>				
			
				<cfset customerid = "00000000-0000-0000-0000-000000000000">
			
			</cfif>
			
			<cfquery name="threshold" 
			 datasource="AppsLedger" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">			
				 SELECT      *
			     FROM        Materials.dbo.Customer			
			     WHERE       Customerid = '#customerid#'			
		 	</cfquery>
			
			<cfif threshold.ThresholdCredit neq "">
				
				<!--- field 1 --->
				<cfset customer.threshold = threshold.ThresholdCredit>
			
				<cfquery name="get" 
				 datasource="AppsLedger" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">		
				
				 SELECT      TH.Currency, 
				             SUM(TH.Amount) as Amount, 
							 SUM(TH.AmountOutstanding) as AmountOutstanding
			     FROM        TransactionHeader AS TH INNER JOIN
			                 Materials.dbo.WarehouseBatch AS WB ON TH.TransactionSourceId = WB.BatchId
			     WHERE       TH.TransactionCategory = 'Receivables' 
				 AND         TH.AmountOutstanding > 0
				 AND		 TH.RecordStatus != '9'
				 AND         WB.CustomerIdInvoice = '#customerid#'
				 AND         WB.Mission           = '#mission#'		
				 GROUP BY TH.Currency 
			 	</cfquery>
				
				<cfset outstanding = "0">
				
				<cfloop query="get">
				
					<cfif currency eq balancecurrency>
					
						<cfset outstanding = outstanding + AmountOutstanding>
						
					<cfelse>	
					
						<cf_exchangeRate currencyFrom = "#currency#" 
						                 currencyTo   = "#balancecurrency#">
										 
						<cfset amt = AmountOutstanding / exc>
						<cfset outstanding = outstanding + amt>
				
					</cfif>
				
				</cfloop>
				
				<!--- field 2 --->
				<cfset customer.Outstanding  = outstanding>	
				
				<cfif amount gte "0">
				
					<cf_exchangeRate currencyFrom = "#amountcurrency#" 
		                 currencyTo   = "#balancecurrency#">
				
					<cfset amt = amount / exc>		
					
					<cfset bal = threshold.ThresholdCredit - outstanding - amt>
					
				<cfelse>
				
					<cfset bal = threshold.ThresholdCredit - outstanding>									
				
				</cfif>
				
				<cfif bal gte "0">
							
					<!--- field 3 --->
					<cfset customer.result = "1">	
					
				<cfelse>
				
					<cfset customer.result = "0">	
					
				</cfif>
				
			<cfelse>
			
				<cfset customer.result = "0">		
				
			</cfif>	
			
			<cfreturn customer>			
					
	</cffunction>		
	
	<cffunction name="AddCustomer" access="public" displayname="Add Customer from db.workorder">
			
		<cfargument name="customerId"  type="guid"    required="true"  default="">
		
		<cfquery name="load" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
		 	INSERT INTO Customer 
			       (CustomerId, 
				    Mission, 
					OrgUnit, 
					PersonNo, 
					CustomerName, 
					Reference, 
					PhoneNumber, 
					eMailAddress, 
                    Memo, 
					TaxExemption, 
					Terms, 
					Operational, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
					
			SELECT  CustomerId, 
			        Mission, 
					OrgUnit, 
					PersonNo, 
					CustomerName, 
					Reference, 
					PhoneNumber,  
					eMailAddress,  
					Memo, 
					TaxExemption, 
					Terms,  
					Operational, OfficerUserId, OfficerLastName, OfficerFirstName, Created
					
			FROM    WorkOrder.dbo.Customer
			WHERE   CustomerId = '#customerid#'
		</cfquery>	
	
	</cffunction>		
	
	<cffunction name="AddCustomerAddress"
             access="public"
             returntype="any"
             displayname="Add Customer">
		
		<cfargument name="mission"     type="string"  required="true"  default="">
		<cfargument name="warehouse"   type="string"  required="true"  default="">		
		<cfargument name="customerId"  type="guid" required="true" default="">
		
		<cfquery name="Parameter" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 	SELECT *
			FROM   Ref_ParameterMission
			WHERE  Mission = '#mission#'
		 </cfquery>		
		
		<cfif Parameter.DefaultAddressType neq ""> 
		
			<cftransaction>

				<cfquery name="warehouseAddress" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 
					SELECT * 
					FROM   Warehouse
					WHERE  Warehouse = '#warehouse#'
				 
				</cfquery>	
		
				<cf_assignid>
		
				<cfset addressId = rowguid>
			
				<cfquery name="createAddressRecord" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 
				 	INSERT INTO System.dbo.Ref_Address (
					  [AddressId],
		    		  [AddressScope],
				      [AddressCity],
				      [Country],
				      [OfficerUserId],
				      [OfficerLastName],
				      [OfficerFirstName],
				      [Created] )
					  
					VALUES (
						'#addressId#',
						'Customer',
						'#warehouseAddress.City#',
						'#warehouseAddress.Country#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#',
						getdate()
					)
				 
				 </cfquery>				 

				<cfquery name="insertCustomerAddress" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 
				 	INSERT INTO CustomerAddress(
						 	 [CustomerId],
					      	 [AddressId],
					         [AddressType],
				             [DateEffective],
				      	 	 [ActionStatus],
				      	 	 [OfficerUserId],
				      		 [OfficerLastName],
				      		 [OfficerFirstName],
				      		 [Created] )
					VALUES ( '#customerId#',
							 '#addressId#',
							 '#Parameter.DefaultAddressType#',
							 getdate(),
							 1,
							 '#SESSION.acc#',
							 '#SESSION.first#',
							 '#SESSION.last#',
							 getdate()	)
				 
				 </cfquery>
		
			</cftransaction>
		
		 </cfif>
		
	</cffunction>	
		
</cfcomponent>