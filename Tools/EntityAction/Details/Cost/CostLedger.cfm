
<!--- create header, add lines --->

<cfparam name="URL.ObjectId" default="{418f603a-1018-0668-4397-78aa4a7f700a}">
<cfparam name="form.CostSelected" default="">

<cfif Form.CostSelected neq "">
	
	<cfquery name="Object" 
	    datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	SELECT    *
	FROM      OrganizationObject
	WHERE     ObjectId = '#url.objectid#' 
	</cfquery>
	
	<cfquery name="Invoice" 
	    datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    P.GLAccount AS GLAccount, C.*, U.FirstName+' '+U.LastName as Name
		FROM      Employee.dbo.PersonGLedger P INNER JOIN
		          System.dbo.UserNames U ON P.PersonNo = U.PersonNo INNER JOIN
		          OrganizationObjectActionCost C ON U.Account = C.OwnerAccount
		WHERE     C.Owner = 'User' 
		AND       C.ObjectId = '#url.ObjectId#'
		AND       C.ObjectCostId NOT IN
		                (SELECT     ReferenceId
		                 FROM       Accounting.dbo.TransactionLine
		                 WHERE      ReferenceId IS NOT NULL
						 AND        ReferenceIdParam = 'Cost') 
		AND       C.ObjectCostId IN (#preserveSingleQuotes(form.costselected)#)
		ORDER BY P.GLAccount, C.DocumentCurrency 
	</cfquery>
	
	<cfquery name="System" 
	    datasource="AppsSystem" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      Parameter
	</cfquery>
	
	<cfquery name="Parameter" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      Ref_ParameterMission
			WHERE     Mission = '#Object.Mission#' 
	</cfquery>
	
	<cftransaction>
	
	<cfoutput query="Invoice" group="GLAccount">
	
		<cfoutput group="DocumentCurrency">
		
			<cfquery name="Journal" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Journal
					WHERE     Mission = '#Object.Mission#'
					AND       SystemJournal = 'Procurement' 
					AND       Currency = '#DocumentCurrency#'  
			</cfquery>
			
			<cfif journal.recordcount eq "0">
			
				<!--- post in default journal --->
				
				<cfquery name="Journal" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    SELECT    *
					    FROM      Journal
						WHERE     Mission = '#Object.Mission#'
						AND       SystemJournal = 'Procurement' 
						AND       Currency = '#System.BaseCurrency#' 
				</cfquery>
			
			</cfif>
		
			<cfquery name="Total" dbtype="query">
				SELECT Sum(DocumentAmount) as Amount
				FROM   Invoice
				WHERE  GLAccount = '#GLaccount#'
				AND    DocumentCurrency  = '#DocumentCurrency#'
			</cfquery>
								
			<cf_GledgerEntryHeader
				    Mission               = "#Object.Mission#"
				    OrgUnitOwner          = "#Object.OrgUnit#"
				    Journal               = "#Journal.Journal#"
					JournalTransactionNo  = ""
					Description           = "#name#"
					TransactionSource     = "InsuranceSeries"
					AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
					TransactionCategory   = "Payables"
					MatchingRequired      = "1"
					Reference             = "Invoice"       
					ReferenceName         = ""
					ReferenceId           = "#Object.ObjectId#"
					ReferenceNo           = "#Object.EntityCode#"					
					DocumentCurrency      = "#DocumentCurrency#"
					DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
					DocumentAmount        = "#Total.amount#"
					ParentJournal         = ""
					ParentJournalSerialNo = "">
					
					<cf_GledgerEntryLine
						Lines                 = "1"
					    Journal               = "#Journal.Journal#"
						JournalNo             = "#JournalTransactionNo#"
						AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
						ExchangeRate          = "1"
						Currency              = "#DocumentCurrency#"
											
						TransactionSerialNo1  = "0"
						Class1                = "Credit"
						Reference1            = "#Object.ObjectReference#"       
						ReferenceName1        = "#Description#"
						Description1          = "#DocumentMemo#"
						GLAccount1            = "#Journal.GLAccount#"
						Costcenter1           = "#Object.OrgUnit#"
						ProgramCode1          = ""
						ProgramPeriod1        = ""
						ReferenceId1          = ""
						ReferenceNo1          = ""
						TransactionType1      = "Standard"
						Amount1               = "#Total.amount#">
						
						<cfset num = 0>
				
			<cfoutput>			
			
					<cfset num = num+1>
					
					<cf_GledgerEntryLine
						Lines                 = "1"
					    Journal               = "#Journal.Journal#"
						JournalNo             = "#JournalTransactionNo#"
						AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
						ExchangeRate          = "1"
						Currency              = "#DocumentCurrency#"
						
						TransactionSerialNo1  = "#num#"
						Class1                = "Debit"
						Reference1            = "#Description#"       
						ReferenceName1        = "#Description#"
						Description1          = "#DocumentMemo#"
						GLAccount1            = "#GLAccount#"
						Costcenter1           = "#Object.OrgUnit#"
						ProgramCode1          = ""
						ProgramPeriod1        = ""
						ReferenceId1          = "#ObjectCostId#"
						ReferenceIdParam1     = "Cost"
						ReferenceNo1          = "#DocumentNo#"
						TransactionType1      = "Standard"
						Amount1               = "#DocumentAmount#">				
						
			</cfoutput>
		</cfoutput>
	</cfoutput> 
	
	</cftransaction>
	
	<cfoutput>
	
		<cf_tl id="Cost_records" var="1" class="Message">
	    <cfset tRecords = "#Lt_text#">
		
		<table width="100%" cellspacing="0" cellpadding="0" align="center">
		<tr><td height="50"></td></tr>
		<tr>
		<td align="center"><b>#Invoice.Recordcount# #tRecords#</td>
		</tr>
		</table>
	</cfoutput>
	
<cfelse>

	<cfoutput>
	
		<cf_tl id="Cost_problem" var="1" class="Message">
	    <cfset tProblem = "#Lt_text#">
		
		<table width="100%" cellspacing="0" cellpadding="0" align="center">
		<tr><td height="50"></td></tr>
		<tr>
		<td align="center"><b>#tProblem#</b></td>
		</tr>
		</table>
	</cfoutput>
	
	
</cfif>	

