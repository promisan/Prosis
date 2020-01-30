 
<!--- ------------ NOTE 5/5/2009 ------- --->

<!---

Tthe field ParentLineId is populated with

   the transactionId of the header in case of a payment
   the transactionlineId of a bank reconcilutation as you have many payments in a payment order
   the transactionLineId of a distribution of a line amount

--->

<!--- ------------ NOTE --------------- --->


<cfoutput>
  <cfparam name="URL.Journal"               default="">
  <cfparam name="URL.category"              default="">
  <cfparam name="URL.ParentJournal"         default="">
  <cfparam name="URL.ParentJournalSerialNo" default="">
  <cfparam name="URL.ParentLineId"          default="">
  
  <cfparam name="URL.Source"                default="AccountSeries">
  <cfparam name="URL.SourceNo"              default="">
  <cfparam name="URL.SourceId"              default="">
  <cfparam name="URL.ReferenceId"           default="">  
  
  <cfparam name="URL.glaccount"             default="">
  <cfparam name="URL.accounttype"           default="">
  <cfparam name="URL.amount"                default="0">
  <cfset   Journal           = "#URL.Journal#">
  <cfset   AccountPeriod     = "#URL.AccountPeriod#">
</cfoutput>

<cfif URL.Journal eq "">

	<cfquery name="Journal"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Journal J
		WHERE 1=1
		<cfif URL.category neq "">
		AND TransactionCategory = '#URL.Category#'
		</cfif>
		AND   Mission = '#URL.Mission#'
		<cfif getAdministrator(url.mission) eq "1">
			<!--- no filtering --->
		<cfelse>			
		AND Journal IN   (SELECT ClassParameter 
			       FROM   Organization.dbo.OrganizationAuthorization 
			       WHERE  UserAccount = '#SESSION.acc#' 
			       AND    Mission = '#URL.Mission#'
				   AND    AccessLevel > '0'
			       AND    Role = 'Accountant') 
		</cfif>				   
	</cfquery>
	
	<cfset Journal  = "#Journal.Journal#">

</cfif>

<!--- create temp tables --->

<cfparam name="url.referenceorgunit" default="">

<cfif isNumeric(url.referenceorgunit)>

	<cfquery name="Org"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Organization
		WHERE OrgUnit = '#url.referenceorgunit#'			   
	</cfquery>

</cfif>

<cftry>
	
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#GledgerHeader_#client.sessionNo#"> 
	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#GledgerLine_#client.sessionNo#"> 
	
	<cfquery name="SearchResult"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#GledgerHeader_#client.sessionNo# ( 
		[Journal] [varchar] (10) NULL ,
		[JournalSerialNo] [int] NULL ,
		[TransactionId] uniqueidentifier NULL ,
		[Mission] [varchar] (30) NULL ,
		[OrgUnitOwner] [int] NULL ,
		[JournalTransactionNo] [varchar] (20) NULL ,
		[JournalBatchNo] [int] NULL ,
		[JournalBatchDate] [datetime] NULL ,
		[Description] [varchar] (100) NULL ,	
		[TransactionSource] [varchar] (20) NULL ,
		[TransactionSourceNo] [varchar] (20) NULL ,
		[TransactionSourceId] uniqueidentifier NULL ,
		[TransactionDate] [datetime] NULL ,
		[AccountPeriod] [varchar] (10) NULL ,
		[TransactionCategory] [varchar] (20) NULL ,
		[MatchingRequired] [bit] NOT NULL CONSTRAINT [#SESSION.acc#_#Client.sessionNo#_Transaction_MatchingRequired] DEFAULT (0),
		[ReferenceOrgUnit] [int] NULL ,
		[ReferencePersonNo] [varchar] (20) NULL ,
		[Reference] [varchar] (20) NULL ,
		[ReferenceName] [varchar] (80) NULL ,
		[ReferenceNo] [varchar] (30) NULL ,
		[ReferenceId] uniqueidentifier NULL ,	
		[DocumentCurrency] [varchar] (4) NULL ,
		[DocumentAmount] [float] NULL ,
		[DocumentDate] [datetime] NULL ,
		[ExchangeRate] [float] NULL ,
		[Currency] [varchar] (4) NULL ,
		[Amount] [float] NULL ,
		[AmountOutstanding] [float] NULL ,
		[ActionFund] [varchar] (20) NULL ,
		[ActionType] [varchar] (10) NULL ,
		[ActionTerms] [int] NULL ,
		[ActionDiscountDays] [int] NULL ,
		[ActionDiscount] [float] NULL ,
		[ActionDiscountDate] [datetime] NULL ,
		[ActionBefore] [datetime] NULL ,
		[ActionBankId] uniqueidentifier NULL ,
		[ActionAccountNo] [varchar] (30) NULL ,
		[ActionAccountName] [varchar] (40) NULL ,
		[ActionAccountABA] [varchar] (30) NULL ,
		[ActionGLAccount] [varchar] (20) NULL ,
		[ParentJournal] [varchar] (10) NULL ,
		[ParentJournalSerialNo] [int] NULL ,
		[ParentTransactionId] uniqueidentifier NULL ,
		[ParentLineId] uniqueidentifier NULL ,
		[OfficerUserId] [varchar] (20) NULL ,
		[OfficerLastName] [varchar] (40) NULL ,
		[OfficerFirstName] [varchar] (30) NULL ,
		[ContraGLAccount] [varchar] (20) NULL ,
		[ContraGLAccountType] [varchar] (10) NULL 
	) ON [PRIMARY]
	</cfquery>
	
	<cfquery name="JournalSelect"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT J.*, C.ExchangeRate
		FROM   Journal J, Currency C
		WHERE  Journal = '#Journal#' 	
		AND    J.Currency = C.Currency
	</cfquery>

	
	<cfquery name="DefaultContraAccount"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
		FROM   JournalAccount A
		WHERE  Journal = '#Journal#' 	
		AND    Mode = 'Contra'
		ORDER BY ListDefault DESC <!--- first the default --->
	</cfquery>
	
	<cfquery name="Header"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  TransactionHeader
		WHERE Journal = '#URL.ParentJournal#' 
		AND   JournalSerialNo = '#URL.ParentJournalSerialNo#'	
	</cfquery>
	
	<!--- populate table --->
	
	<cfoutput query="JournalSelect">
	   <cfquery name="UpdateHeader"
	   datasource="AppsQuery" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   INSERT 
	   INTO [#SESSION.acc#GledgerHeader_#client.sessionNo#] 
	   (Journal,
	    Mission, 
		TransactionId,
		OrgUnitOwner, 
		<cfif isNumeric(url.referenceorgunit)>
		ReferenceName,
		ReferenceOrgUnit,
		</cfif>	
		<cfif url.referenceid neq "">
		ReferenceId,
		</cfif>	
		TransactionDate,
		TransactionCategory,
		AccountPeriod,
		DocumentCurrency,
		ExchangeRate,
		DocumentDate,
		DocumentAmount,
		<cfif url.source neq "">
			TransactionSource,
			TransactionSourceNo,
			<cfif url.sourceid neq "">
				TransactionSourceId,
			</cfif>
		</cfif>
		
		<cfif url.ParentJournal neq "">
		ParentJournal,
		ParentJournalSerialNo,
		ParentTransactionId,		
			<!--- added for the distribution of an amount of a line 5/5/2009 --->
			<cfif url.parentlineid neq "">
			ParentLineId,
			</cfif>
		</cfif>
		Currency,
		ContraGLAccount,
		ContraGLAccountType)
	   VALUES 
	   ('#Journal#',
	    '#URL.Mission#',
		newid(),
		'#URL.OrgUnitOwner#',
		<cfif isNumeric(url.referenceorgunit)>
		'#org.orgunitname#',
		'#url.referenceorgunit#', 
		</cfif>	
		<cfif url.referenceid neq "">
		'#url.ReferenceId#',
		</cfif>		
		getDate(),
		'#TransactionCategory#',
		'#AccountPeriod#',
		'#Currency#',
		'1',
		getDate(),
		'#URL.amount#',
		<cfif url.source neq "">
		'#url.source#',
		'#url.sourceno#',  
			<cfif url.sourceid neq "">
			'#url.sourceid#',
			</cfif>	
		</cfif>
			
		<cfif url.ParentJournal neq "">
		'#URL.ParentJournal#',
		'#URL.ParentJournalSerialNo#',
		'#Header.TransactionId#',	    
			<!--- associate the transaction to a triggering line (distribution) --->
			<cfif url.parentlineid neq "">
			'#url.ParentLineId#',
			</cfif>
		</cfif>
		'#Currency#',
		
		<cfif url.glaccount eq "">
		
		'#DefaultContraAccount.GLAccount#',
		'#AccountType#'
		
		<cfelse>
		
		<!--- this is passed from the edit screen --->
		
		'#url.GLAccount#',
		'#url.AccountType#' 
		</cfif>)
				
	   </cfquery>	   
	   
	</cfoutput>	
	
	<cfquery name="Lines"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#GledgerLine_#Client.sessionNo# (
	    [SerialNo] [int] IDENTITY (1, 1) NOT NULL,
		[Journal] [varchar] (10) NOT NULL ,
		[JournalSerialNo] [int] NULL ,
		[TransactionSerialNo] [int] NULL ,
		[TransactionLineId] uniqueidentifier NULL ,
		[ParentLineId] uniqueidentifier NULL ,
		[GLAccount] [varchar] (20) NOT NULL ,
		[JournalTransactionNo] [varchar] (20) NULL ,
		[ReconciliationPointer] [bit] NOT NULL CONSTRAINT [#SESSION.acc#_Transaction_ReconciliationPointer_#Client.sessionNo#] DEFAULT (0),
		[Memo] [varchar] (80) NULL ,
		[OrgUnit] [int] NULL ,
		[ProgramCode] [varchar] (20) NULL ,	
		[ProgramCodeProvider] [varchar] (20) NULL ,	
		[Fund] [varchar] (20) NULL ,
		[ProgramPeriod] [varchar] (10) NULL ,
		[ObjectCode] [varchar] (10) NULL ,
		[ContributionLineId] uniqueidentifier NULL ,
		[WorkOrderLineId] uniqueidentifier NULL ,
		[AccountPeriod] [varchar] (10) NULL ,
		[TransactionDate] [datetime] NULL ,
		[TransactionPeriod] [varchar] (30) NULL ,
		[TransactionType] [varchar] (30) NULL ,
		[Reference] [varchar] (100) NULL ,
		[ReferenceName] [varchar] (80) NULL ,
		[ReferenceNo] [varchar] (30) NULL ,
		[ReferenceId] uniqueidentifier NULL ,
		[Warehouse] [varchar] (20) NULL ,
		[WarehouseItemNo] [varchar] (20) NULL ,
		[WarehouseItemUoM] [varchar] (10) NULL ,
		[WarehouseQuantity] [float] NULL ,
		[TransactionCurrency] [varchar] (4) NULL ,
		[TransactionAmount] [float] NULL ,
		[TransactionTaxCode] [varchar] (10) NULL ,
		[ExchangeRate] [float] NULL ,
		[Currency] [varchar] (4) NULL ,
		[AmountDebit] [float] NULL ,
		[AmountCredit] [float] NULL ,
		[ExchangeRateBase] [float] NULL ,
		[TransactionAmountBase] [float] NULL ,
		[AmountBaseDebit] [float] NULL ,
		[AmountBaseCredit] [float] NULL ,
		[ParentJournal] [varchar] (10) NULL ,
		[ParentJournalSerialNo] [int] NULL ,
		[ParentTransactionId] uniqueidentifier NULL ,
		[ActionType] [varchar] (10) NULL ,
		[ActionCondition] [varchar] (40) NULL ,
		[ActionDiscount] [float] NULL ,
		[ActionDiscountDate] [datetime] NULL ,
		[ActionBefore] [datetime] NULL ,
		[ActionBank] [varchar] (20) NULL ,
		[ActionAccountNo] [varchar] (30) NULL ,
		[ActionAccountName] [varchar] (40) NULL ,
		[ActionAccountABA] [varchar] (30) NULL ,
		[ActionGLAccount] [varchar] (20) NULL ,
		[ActionGLAccountType] [varchar] (10) NULL ,
		[OfficerUserId] [varchar] (20) NULL ,
		[OfficerLastName] [varchar] (40) NULL ,
		[OfficerFirstName] [varchar] (30) NULL ,
		[Created] [datetime] NULL 
		) ON [PRIMARY]
	
	</cfquery>
	
	<cfcatch>
	
	    <script language="JavaScript">
	        window.close()
		</script>
	
	</cfcatch>
	 
</cftry>

<cf_screentop html="No" jQuery="Yes" scroll="Yes" menuAccess="Context">

<cfinclude template="Transaction.cfm">

 



