
<cfparam name="URL.ContributionId" default="">
<cfparam name="URL.TransactionId"  default="">

<cfparam name="URL.Mission"        default="Promisan">
<cfparam name="URL.Program"        default="">

<cfajaximport tags="cfdiv,cfform">

<cfinclude template="TransferScript.cfm">
<cf_actionlistingscript>

<cfinclude template="../Allotment/AllotmentInquiryScript.cfm">

<cf_tl id="Budget Action" var="vBudget">
<cf_tl id="Funds Redeployment" var="vFund">

<cf_screentop height="100%" line="no" jQuery="Yes" scroll="Yes" html="Yes" layout="webapp" banner="gray" label="#vBudget# : #vFund#">

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#BudgetTransfer_#client.sessionNo#"> 

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# ( 
		[SerialNo] [int] IDENTITY (1, 1) NOT NULL,			
		[ContributionLineId] uniqueidentifier NULL ,
		[Period] [varchar] (10) NULL ,
		[Editionid] [int] NULL ,
		[ProgramCode] [varchar] (20) NULL ,
		[ActionClass] [varchar] (20) NULL ,
		[Fund] [varchar] (20) NULL ,
		[ObjectCode] [varchar] (20) NULL ,
		[AmountCurrent] [float] NULL,
		[Amount] [float] NULL
	) ON [PRIMARY]
</cfquery>

<table width="100%">
<tr><td id="main">

<cfform name="transferform">

<cfif url.transactionid eq "">

	<!--- transfer on the project/program level --->
	<cfinclude template="TransferViewProgram.cfm">
	
<cfelse>

	<!--- transfer of a contribution to a different OE, Fund, Period and/or Project --->
	<cfinclude template="TransferViewContribution.cfm">

</cfif>

</cfform>

</td></tr></table>

