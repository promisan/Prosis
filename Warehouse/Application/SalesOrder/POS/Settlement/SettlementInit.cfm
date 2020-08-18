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
	
