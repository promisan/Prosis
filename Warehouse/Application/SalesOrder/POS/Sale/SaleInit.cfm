
<cfoutput>

	<cfparam name="url.mode" default="embed">
	<cfparam name="url.QuoteId" default="">

	<cfif Len(URL.QuoteId) eq 73>
		<cfset aQuote = ListToArray(URL.QuoteId,"|")>
		<cfset URL.CustomerId = aQuote[1]>
		<cfset URL.AddressId = aQuote[2]>
	</cfif>
<!--- this is for embedding the sales screen in a different context --->

	<cfif url.mode neq "embed">

		<cf_screentop height="100%" label="POS" jquery="Yes" html="No">

		<cfquery name="Parameter"
				datasource="AppsPurchase"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission
			WHERE  Mission = '#URL.Mission#'
		</cfquery>

		<cfajaximport tags="cfform,cfwindow">

		<cfquery name="Param"
				datasource="AppsMaterials"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission
			WHERE  Mission = '#URL.Mission#'
		</cfquery>

		<input type="hidden" id="mission"   name="mission"   value="#url.mission#">
			<input type="hidden" id="warehouse" name="warehouse" value="#url.warehouse#">

		<cfinclude template="../../../Stock/StockControl/StockScript.cfm">

	</cfif>


	<cfparam name="url.warehouse" default="BCN000">

	<script>

	$(document).ready(function () {
	setInterval( function() {
	time_refresh('#URL.warehouse#');
}, 60000 );
});


</script>

</cfoutput>

<cftry>

	<cfquery name="Test"
			datasource="AppsTransaction"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT *
		FROM   Sale#URL.Warehouse#
	</cfquery>

	<cfcatch>

		<CF_DropTable dbName="AppsTransaction"
				tblName="Sale#URL.Warehouse#">

		<cfquery name="CreateTable"
				datasource="AppsTransaction"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			CREATE TABLE dbo.Sale#URL.Warehouse# (
		[TransactionId] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_Sale#URL.Warehouse#] DEFAULT (newid()),
		[SourceBatchNo] [varchar] (20) NULL ,
		[BatchId] [uniqueidentifier],
		[TransactionType] [varchar] (2) NOT NULL ,
		[TransactionDate] [datetime] NOT NULL ,
		[TransactionReference] [varchar] (50) NULL ,
		[ItemNo] [varchar] (20) NOT NULL ,
		[ItemClass] [varchar] (10) NOT NULL ,
		[ItemDescription] [varchar] (200) NOT NULL ,
		[ItemCategory] [varchar] (20) NOT NULL ,
		[Mission] [varchar] (30) NOT NULL ,
		[Warehouse] [varchar] (20) NULL ,
		[Location] [varchar] (20) NULL ,
		[TransactionUoM] [varchar] (30) NOT NULL ,
		[TransactionQuantity] [float] NOT NULL ,
		[AddressId] [uniqueidentifier] NULL,
		[TransactionLot] [varchar] (20) NULL ,
		[PersonNo] [varchar] (20) NULL ,
		[CustomerId] [uniqueidentifier] NULL,
		[CustomerIdInvoice] [uniqueidentifier] NULL,
		[SalesPersonNo] [varchar] (20) NULL,
		[ProgramCode] [varchar] (20) NULL ,
		[PriceSchedule] [varchar] (10) NULL ,
		[SalesCurrency] [varchar] (4) NOT NULL ,
		[SchedulePrice] [float] NULL ,
		[PromotionId] [uniqueidentifier] NULL,
		[PromotionRun] [int] NULL ,
		[PromotionType] [varchar] (10) NULL ,
		[PromotionDiscount] [float] NULL ,
		[SalesDiscount] [float] NULL ,
		[SalesPrice] [float] NOT NULL ,
		[TaxCode] [varchar] (10) NULL ,
		[TaxPercentage] [float] NULL CONSTRAINT [DF_Sale_TaxPercetage#URL.Warehouse#] DEFAULT (0),
		[TaxExemption] [bit] NOT NULL CONSTRAINT [DF_Sale_TaxExemption#URL.Warehouse#] DEFAULT (0),
		[TaxIncluded] [bit] NOT NULL CONSTRAINT [DF_Sale__TaxIncluded#URL.Warehouse#] DEFAULT (0),
		[SalesAmount] [float] NULL ,
		[SalesTax] [float] NULL ,
		[SalesTotal] AS ([SalesAmount] + [SalesTax]) ,
		[OrgUnit] [int] NULL ,
		[OrgUnitCode] [varchar] (20) NULL ,
		[OrgUnitName] [varchar] (100) NULL ,
		[OfficerUserId] [varchar] (20) NULL ,
		[OfficerLastName] [varchar] (40) NULL ,
		[OfficerFirstName] [varchar] (30) NULL ,
		[Created] [datetime] NOT NULL CONSTRAINT [DF_Sale_Created#URL.Warehouse#] DEFAULT (getdate()),)
		</cfquery>

		<cfquery name="CreateTableIndexes"
				datasource="AppsTransaction"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">

			ALTER TABLE [dbo].[Sale#URL.Warehouse#] ADD  CONSTRAINT [PK_Sale#URL.Warehouse#] PRIMARY KEY CLUSTERED
		(
		[TransactionId] ASC
		) ON [PRIMARY];

		CREATE NONCLUSTERED INDEX [_dta_index_CustomerId_Warehouse_ItemNo_TransactionUoM] ON [dbo].[Sale#URL.Warehouse#]
		(
		[CustomerId] ASC,
		[Warehouse] ASC,
		[ItemNo] ASC,
		[TransactionUoM] ASC
		)
		ON [PRIMARY];

		</cfquery>

	</cfcatch>

</cftry>


<cftry>

	<cfquery name="Test"
			datasource="AppsTransaction"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Sale#URL.Warehouse#Transfer
	</cfquery>

	<cfcatch>

		<CF_DropTable dbName="AppsTransaction"
				tblName="Sale#URL.Warehouse#Transfer">

		<cfquery name="CreateTableTransfer"
				datasource="AppsTransaction"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				CREATE TABLE dbo.Sale#URL.Warehouse#Transfer (
				[TransactionId]       [uniqueidentifier] NOT NULL ,
				[Warehouse]           [varchar] (20) NULL ,
				[Location]            [varchar] (20) NULL ,
				[ItemNo]              [varchar] (20) NOT NULL ,
				[TransactionLot]      [float] NULL CONSTRAINT [DF_Sale#URL.Warehouse#_Lot] DEFAULT (0),
				[TransactionUoM]      [varchar] (30) NOT NULL ,
				[TransactionQuantity] [float] NOT NULL ,
				[TransactionTransfer] [float] NOT NULL ,
				[TransactionLocation] [varchar] (20) NULL ,
				[OfficerUserId]       [varchar] (20) NULL ,
				[OfficerLastName]     [varchar] (40) NULL ,
				[OfficerFirstName]    [varchar] (30) NULL ,
				[Created] [datetime] NOT NULL CONSTRAINT [DF_SaleTransfer_Created#URL.Warehouse#] DEFAULT (getdate()),)
		</cfquery>

	</cfcatch>

</cftry>

<cfquery name="qWarehouse"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
	SELECT *
	FROM   Warehouse
	WHERE  Warehouse = '#URL.Warehouse#'
</cfquery>

<cfif qWarehouse.beneficiary eq 1>

	<cftry>

		<cfquery name="Test"
				datasource="AppsTransaction"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Sale#URL.Warehouse#Beneficiary
		</cfquery>

		<cfcatch>

			<CF_DropTable dbName="AppsTransaction"
					tblName="Sale#URL.Warehouse#Beneficiary">

			<cfquery name="CreateTableBeneficiaryDetails"
					datasource="AppsTransaction"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					CREATE TABLE dbo.Sale#URL.Warehouse#Beneficiary	(
					[CustomerId] [uniqueidentifier] NOT NULL,
					[BeneficiaryId] [uniqueidentifier] NOT NULL,
					[TransactionId] [uniqueidentifier] NOT NULL,
					[LastName] [varchar](40) NULL,
					[FirstName] [varchar](30) NULL,
					[Relationship] [varchar](20) NULL,
					[Birthdate] [datetime] NULL,
					[Gender] [varchar](6) NULL,
					[OfficerUserId] [varchar](20) NULL,
					[OfficerLastName] [varchar](40) NULL,
					[OfficerFirstName] [varchar](30) NULL,
					[Operational] [bit] NULL,
					[Created] [datetime] NOT NULL CONSTRAINT [DF_SaleBeneficiary_Created#URL.Warehouse#] DEFAULT (getdate())
					)
			</cfquery>

		</cfcatch>

	</cftry>

</cfif>


<cftry>

	<cfquery name="Test"
			datasource="AppsTransaction"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Settle#URL.Warehouse#_#SESSION.acc#
	</cfquery>

	<cfcatch>

		<CF_DropTable dbName="AppsTransaction"
				tblName="Settle#URL.Warehouse#_#SESSION.acc#">

		<cfquery name="CreateTable"
				datasource="AppsTransaction"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			CREATE TABLE dbo.Settle#URL.Warehouse#_#SESSION.acc# (
			[TransactionId] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_Settle#URL.Warehouse#_#SESSION.acc#] DEFAULT (newid()),
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
			[Created] [datetime] NULL CONSTRAINT [DF_Settle_Created#URL.Warehouse#_#SESSION.acc#] DEFAULT (getdate()),)
		</cfquery>

	</cfcatch>

</cftry>

<cfinclude template="SaleView.cfm">

