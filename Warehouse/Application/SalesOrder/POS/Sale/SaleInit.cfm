
<cfoutput>
	
	<cfparam name="url.warehouse" default="BCN000">
	<cfparam name="url.scope"     default="POS">

	<script>
		$(document).ready(function () {
		setInterval( function() {
		time_refresh('#URL.warehouse#');}, 60000 );});	
	</script>

<cfif url.scope eq "Quote">

	<input type="hidden" id="mission"   name="mission"   value="#url.mission#">
	<input type="hidden" id="warehouse" name="warehouse" value="#url.warehouse#">	
	
	<cfset ajaxonload("setSaleQuote")>	

</cfif>

</cfoutput>

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
