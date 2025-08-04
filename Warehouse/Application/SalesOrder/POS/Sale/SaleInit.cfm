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

<cfoutput>
	
<cfparam name="url.warehouse" default="BCN000">
<cfparam name="url.scope"     default="POS">

<!--- clean quotes that were only reloaded for potential reposting but were never done so --->

<cfquery name="qWarehouse"
	datasource="AppsMaterials"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	DELETE FROM   CustomerRequest
	WHERE        RequestNo IN (SELECT   RequestNo
	                           FROM     CustomerRequestLine
	                           WHERE    BatchId IS NOT NULL) 
	AND   BatchNo IS NOT NULL 
	AND   Created < GETDATE() - 1
</cfquery>

<script>
	$(document).ready(function () {
	setInterval( function() {
	time_refresh('#URL.warehouse#');}, 60000 );});	
</script>
		
<cfif url.scope eq "Quote">

    <input type="hidden" id="scope"     name="scope"     value="Quote">
	<input type="hidden" id="mission"   name="mission"   value="#url.mission#">
	<input type="hidden" id="warehouse" name="warehouse" value="#url.warehouse#">	
	
	<cfset ajaxonload("setSaleQuote")>	
	
<cfelse>

	<input type="hidden" id="scope"     name="scope"     value="POS">

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
			DELETE FROM Settle#URL.Warehouse#
			WHERE RequestNo NOT IN (SELECT RequestNo FROM Materials.dbo.CustomerRequest)
	</cfquery>

	<cfcatch>
	
		<CF_DropTable dbName="AppsTransaction" tblName="Settle#URL.Warehouse#">

		<cfquery name="CreateTable"
				datasource="AppsTransaction"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				CREATE TABLE dbo.Settle#URL.Warehouse# (
				[TransactionId] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_Settle#URL.Warehouse#] DEFAULT (newid()),
				[RequestNo] [int] NOT NULL,
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

<cfinclude template="SaleView.cfm">
