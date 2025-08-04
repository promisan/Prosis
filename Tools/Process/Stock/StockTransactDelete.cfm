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

<cfparam name="Attributes.Alias"                default = "AppsMaterials">
<cfparam name="Attributes.TransactionId"        default = "">
<cfparam name="Attributes.ParentTransactionId"  default = "">
<cfparam name="Attributes.Mode"                 default = "Purge">

<!--- the deny transaction needs to have a valid new date --->

<cfif attributes.mode eq "Purge">

	<cf_assignid>
	
	<cfif Attributes.Parenttransactionid eq "">
	
		<cfquery name="Move"
			datasource="#attributes.Alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				DELETE FROM Materials.dbo.ItemTransactionDeny
				WHERE TransactionId = '#Attributes.TransactionId#'
		</cfquery>
				
	</cfif>
			
	<cfquery name="Move"
		datasource="#attributes.Alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			INSERT INTO Materials.dbo.ItemTransactionDeny
			
					  ( TransactionId, 
						TransactionIdOrigin,
						Mission, Warehouse, TransactionLot,
						TransactionType, TransactionTimeZone, TransactionDate, 
						ItemNo, ItemDescription, ItemCategory, ItemPrecision, ItemTrackingNo, 
			            Location, BillingMode, TransactionReference, 
						TransactionMetric, TransactionQuantity, TransactionUoM, TransactionUoMMultiplier,  
			            TransactionCostPrice, TransactionValue, TransactionBatchNo, ReceiptId, ReceiptCostPrice, ReceiptPrice, 
						RequestId, TaskSerialNo, CustomerId, AssetId, WorkOrderId, WorkOrderLine, RequirementId, BillingUnit, ProgramCode, 
						PersonNo, OrgUnit, OrgUnitCode, OrgUnitName, 
						TransactionLocationId,
						Remarks, ActionStatus, 
						GLAccountDebit, GLAccountCredit, 
			            Source,ParentTransactionId, TransactionSerialNo, 
						OfficerUserId, OfficerLastName, OfficerFirstName, Created)
					  
			SELECT      <cfif Attributes.Parenttransactionid neq "">'#rowguid#'<cfelse>TransactionId</cfif>, 
			            TransactionIdOrigin,			
						Mission, Warehouse, TransactionLot,
						TransactionType, TransactionTimeZone, TransactionDate, 
						ItemNo, ItemDescription, ItemCategory, ItemPrecision, ItemTrackingNo, 
	                    Location, BillingMode, TransactionReference, 
						TransactionMetric, TransactionQuantity, TransactionUoM, TransactionUoMMultiplier, 
	                    TransactionCostPrice, TransactionValue, TransactionBatchNo, ReceiptId, ReceiptCostPrice, ReceiptPrice, 
						RequestId, TaskSerialNo, CustomerId, AssetId, WorkOrderId, WorkOrderLine, RequirementId, BillingUnit, ProgramCode, 
						PersonNo, OrgUnit, OrgUnitCode, OrgUnitName, 
						TransactionLocationId, 
						Remarks, ActionStatus, 
						GLAccountDebit, GLAccountCredit, 	
						Source,		
					    <cfif Attributes.Parenttransactionid neq "">'#Attributes.Parenttransactionid#'<cfelse>ParentTransactionId</cfif>, 
						TransactionSerialNo, 
						'#SESSION.acc#','#SESSION.last#', '#SESSION.first#', getDate()
					  
			FROM      Materials.dbo.ItemTransaction WITH (NOLOCK)
			WHERE     TransactionId = '#Attributes.TransactionId#'
	</cfquery>
	

	<cfquery name="MoveTransactionShipping"
		datasource="#attributes.Alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			
		INSERT INTO Materials.dbo.ItemTransactionShippingDeny
		           (TransactionId
		           ,ActionStatus
				   ,SalesQuantity
		           ,PriceSchedule
				   ,SalesPersonNo
		           ,SalesCurrency
		           ,SchedulePrice
		           ,SalesPriceFixed
		           ,SalesPriceVariable
		           ,SalesPrice
		           ,TaxCode
		           ,TaxPercentage
		           ,TaxExemption
		           ,TaxIncluded
		           ,SalesAmount
		           ,SalesTax
		           ,ExchangeRate
		           ,SalesBaseAmount
		           ,SalesBaseTax
		           ,ShippingBatchNo
		           ,ConfirmationDate
		           ,ConfirmationUserId
		           ,ConfirmationLastName
		           ,ConfirmationFirstName
		           ,ConfirmationMemo
		           ,QuantityReturned
		           ,InvoiceId
				   ,Journal
				   ,JournalSerialNo				   
		           ,OfficerUserId
		           ,OfficerLastName
		           ,OfficerFirstName
		           ,Created)
		           
		 SELECT     <cfif Attributes.Parenttransactionid neq "">'#rowguid#'<cfelse>TransactionId</cfif>
		           ,ActionStatus
				   ,SalesQuantity
		           ,PriceSchedule
				   ,SalesPersonNo				   
		           ,SalesCurrency
		           ,SchedulePrice
		           ,SalesPriceFixed
		           ,SalesPriceVariable
		           ,SalesPrice
		           ,TaxCode
		           ,TaxPercentage
		           ,TaxExemption
		           ,TaxIncluded
		           ,SalesAmount
		           ,SalesTax
		           ,ExchangeRate
		           ,SalesBaseAmount
		           ,SalesBaseTax
		           ,ShippingBatchNo
		           ,ConfirmationDate
		           ,ConfirmationUserId
		           ,ConfirmationLastName
		           ,ConfirmationFirstName
		           ,ConfirmationMemo
		           ,QuantityReturned
		           ,InvoiceId
				   ,Journal
				   ,JournalSerialNo		
		           ,OfficerUserId
		           ,OfficerLastName
		           ,OfficerFirstName
		           ,Created
		FROM    Materials.dbo.ItemTransactionShipping WITH (NOLOCK)
		WHERE   TransactionId = '#Attributes.TransactionId#'	
	</cfquery>	
				
	
	<!--- added by hanno to remove any related logging --->
		
	<cfquery name="Delete"
		datasource="#attributes.Alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			DELETE FROM Materials.dbo.AssetItemAction 
			WHERE  TransactionId = '#Attributes.TransactionId#'
	</cfquery>				

	<cfquery name="DeleteBeneficiary"
		datasource="#attributes.Alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			DELETE FROM Materials.dbo.ItemTransactionBeneficiary 
			WHERE  TransactionId = '#Attributes.TransactionId#'
	</cfquery>

		
	<cfquery name="Delete"
		datasource="#attributes.Alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			DELETE FROM Materials.dbo.ItemTransaction 
			WHERE  TransactionId = '#Attributes.TransactionId#'
	</cfquery>

<cfelseif attributes.mode eq "Log">

		<cf_assignid>

		<cfquery name="Move"
		datasource="#attributes.Alias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			INSERT INTO Materials.dbo.ItemTransactionDeny
			
			   	    (TransactionId,
	                Mission, 
					Warehouse, 
					TransactionIdOrigin,
					TransactionLot,
					TransactionType, 
					TransactionTimeZone, TransactionDate, 
					ItemNo, ItemDescription, ItemCategory, ItemPrecision, ItemTrackingNo, 
                    Location, 
					BillingMode, 
					TransactionReference, TransactionMetric, TransactionQuantity, 
					TransactionUoM, TransactionUoMMultiplier, 
                    TransactionCostPrice, TransactionValue, 
					TransactionBatchNo, 
					ReceiptId, ReceiptCostPrice, ReceiptPrice, 
					RequestId, TaskSerialNo, 
					CustomerId, AssetId, WorkOrderId, WorkOrderLine, RequirementId, BillingUnit, ProgramCode, 
					PersonNo, OrgUnit, OrgUnitCode, OrgUnitName, 
					Remarks,ActionStatus, 
					GLAccountDebit, GLAccountCredit, 
                    ParentTransactionId, 
					Source,
					TransactionSerialNo, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName, 
					Created)
			  					  
			SELECT  '#rowguid#', 
	                Mission, 
					Warehouse, 
					TransactionIdOrigin,
					TransactionLot,
					TransactionType, 
					TransactionTimeZone, TransactionDate, 
					ItemNo, ItemDescription, ItemCategory, ItemPrecision, ItemTrackingNo, 
                    Location, 
					BillingMode, 
					TransactionReference, TransactionMetric, TransactionQuantity, 
					TransactionUoM, TransactionUoMMultiplier, 
                    TransactionCostPrice, TransactionValue, 
					TransactionBatchNo, 
					ReceiptId, ReceiptCostPrice, ReceiptPrice, 
					RequestId, TaskSerialNo, 
					CustomerId, AssetId, WorkOrderId, WorkOrderLine, RequirementId, BillingUnit, ProgramCode, 
					PersonNo, OrgUnit, OrgUnitCode, OrgUnitName, 
					Remarks,ActionStatus, 
					GLAccountDebit, GLAccountCredit, 
                    '#Attributes.Transactionid#', 
					'Log',
					TransactionSerialNo, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName, 
					Created
					  
			FROM    Materials.dbo.ItemTransaction WITH (NOLOCK)
			WHERE   TransactionId = '#Attributes.TransactionId#'
		</cfquery>
				
		<cfquery name="MoveTransactionShipping"
			datasource="#attributes.Alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			
			INSERT INTO Materials.dbo.ItemTransactionShippingDeny
			           (TransactionId
			           ,ActionStatus
			           ,PriceSchedule
					   ,SalesPersonNo
			           ,SalesCurrency
			           ,SchedulePrice
					   ,SalesUom
					   ,SalesQuantity					  
			           ,SalesPriceFixed
			           ,SalesPriceVariable
			           ,SalesPrice
			           ,TaxCode
			           ,TaxPercentage
			           ,TaxExemption
			           ,TaxIncluded
			           ,SalesAmount
			           ,SalesTax
			           ,ExchangeRate
			           ,SalesBaseAmount
			           ,SalesBaseTax
			           ,ShippingBatchNo
			           ,ConfirmationDate
			           ,ConfirmationUserId
			           ,ConfirmationLastName
			           ,ConfirmationFirstName
			           ,ConfirmationMemo
			           ,QuantityReturned
			           ,InvoiceId
			           ,OfficerUserId
			           ,OfficerLastName
			           ,OfficerFirstName
			           ,Created)
		           
			 SELECT    '#rowguid#'
			           ,ActionStatus
			           ,PriceSchedule
					   ,SalesPersonNo				   
			           ,SalesCurrency
			           ,SchedulePrice
					   ,SalesUom
					   ,SalesQuantity					  
			           ,SalesPriceFixed
			           ,SalesPriceVariable
			           ,SalesPrice
			           ,TaxCode
			           ,TaxPercentage
			           ,TaxExemption
			           ,TaxIncluded
			           ,SalesAmount
			           ,SalesTax
			           ,ExchangeRate
			           ,SalesBaseAmount
			           ,SalesBaseTax
			           ,ShippingBatchNo
			           ,ConfirmationDate
			           ,ConfirmationUserId
			           ,ConfirmationLastName
			           ,ConfirmationFirstName
			           ,ConfirmationMemo
			           ,QuantityReturned
			           ,InvoiceId
			           ,OfficerUserId
			           ,OfficerLastName
			           ,OfficerFirstName
			           ,Created
			FROM    Materials.dbo.ItemTransactionShipping WITH (NOLOCK)
			WHERE   TransactionId = '#Attributes.TransactionId#'	
	</cfquery>		
	
		
</cfif>