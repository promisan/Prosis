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
	<cftry>
	
		<cfquery name="Test"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Settle#URL.Warehouse#
		</cfquery>
		
		<cfcatch>
		
			<CF_DropTable dbName="AppsTransaction" 
			              tblName="Settle#URL.Warehouse#"> 
						  
			<cfquery name="CreateTable"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			CREATE TABLE dbo.Settle#URL.Warehouse# (		   
			    [TransactionId] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_Settle#URL.Warehouse#] DEFAULT (newid()),		
				[RequestNo] [int] NULL,
				[CustomerId] [uniqueidentifier] NOT NULL,							
				[AddressId]  [uniqueidentifier] NULL,
				[SettleCode] [varchar] (20) NULL ,		
				[BankName] [varchar] (30) NULL ,		
				[PromotionCardNo] [varchar] (20) NULL ,		
				[CreditCardNo] [varchar] (20) NULL ,		
				[ExpirationMonth] [varchar] (2) NULL ,		
				[ExpirationYear] [varchar] (2) NULL ,											
				[ApprovalCode] [varchar] (20) NULL ,														
				[ApprovalReference] [varchar] (20) NULL ,																	
				[SettleCurrency] [varchar] (4) NULL ,			
				[SettleAmount] [float] NULL ,			
				[Created] [datetime] NULL CONSTRAINT [DF_Settle_Created#URL.Warehouse#] DEFAULT (getdate()),)
			</cfquery>			  
					
		</cfcatch>
	
	</cftry>
	
