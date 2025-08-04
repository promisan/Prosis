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

<!--- workflow script to generate invoice records, add lines --->

<cfparam name="Attributes.ActionId">

<cfquery name="Check" 
    datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Accounting.dbo.TransactionHeader
		WHERE  ActionId = '#Attributes.ActionId#'	
</cfquery>

<cfif Account.recordcount eq "0">
	
		<cf_message 
		  message = "Invoice Posting Account has not been defined for this case. Operation not allowed."
		  return = "no">
		  <cfabort>
	
</cfif>

<cfquery name="Object" 
    datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM  OrganizationObject
		WHERE ObjectId IN (SELECT ObjectId 
		                   FROM   OrganizationObjectAction 
						   WHERE  ActionId = '#Attributes.ActionId#')
</cfquery>

<cfif Object.recordcount eq "1">

	<cfquery name="Account" 
	    datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM  OrganizationObjectLedger
		WHERE ObjectId  = '#Object.ObjectId#'
		AND   Area = 'Invoice'	
	</cfquery>
	
	<cfset curr  = Account.Currency>
	<cfset glacc = Account.GLAccount>
	
	<!--- retain invoiceNo --->
	
	<cfif check.recordcount eq "1">
	    <cfset trano = Check.JournalTransactionNo>
	<cfelse>
	    <cfset trano = "">
	</cfif>
	
	<!--- remove processed transaction for receipt  --->
	
	<cfquery name="CheckProcess" 
	    datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM Accounting.dbo.TransactionLine
		WHERE ParentTransactionId IN (SELECT TransactionId
		                              FROM   Accounting.dbo.TransactionHeader
									  WHERE  ActionId = '#Attributes.ActionId#')	
	</cfquery>
	
	<cfquery name="Clear2" 
	    datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Accounting.dbo.TransactionHeader
		WHERE  Journal = '#CheckProcess.Journal#'	
		AND    JournalSerialNo = '#CheckProcess.JournalSerialNo#'
	</cfquery>	
	
	<cfquery name="Clear1" 
	    datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Accounting.dbo.TransactionHeader
		WHERE  ActionId = '#Attributes.ActionId#'	
	</cfquery>
	
	<cfquery name="Lines" 
	    datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    '#glacc#' AS GLAccount, 
		          C.*, 
				  R.*
		FROM      OrganizationObjectActionCost C INNER JOIN
                  Ref_EntityDocumentItem R ON C.DocumentId = R.DocumentId AND C.DocumentItem = R.DocumentItem
		WHERE     C.Owner = 'User' 
		AND       C.ObjectId = '#Object.ObjectId#'
		AND       C.ActionStatus = '1'		
		AND       C.ObjectCostId NOT IN
		                (SELECT     ReferenceId
		                 FROM       Accounting.dbo.TransactionLine
		                 WHERE      ReferenceId IS NOT NULL
						 AND        ReferenceIdParam = 'Sales') 	
		ORDER BY P.GLAccount, C.DocumentCurrency 
	</cfquery>
	
	<cfquery name="System" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      System.dbo.Parameter
	</cfquery>
	
	<cfquery name="Parameter" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Accounting.dbo.Ref_ParameterMission
		   WHERE     Mission = '#Object.Mission#' 
	</cfquery>
	
	<cfoutput query="Lines" group="GLAccount">
		
			<cfquery name="Journal" 
			    datasource="AppsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT  *
				    FROM    Accounting.dbo.Journal
					WHERE   SystemJournal = 'Contract' 
					AND     Currency = '#curr#'  
			</cfquery>		
											
			<cf_GledgerEntryHeader
			        Datasource            = "AppsOrganization"
				    Mission               = "#Object.Mission#"
				    OrgUnitOwner          = "#Object.OrgUnit#"
				    Journal               = "#Journal.Journal#"
					JournalTransactionNo  = "#trano#"
					Description           = "Invoice"
					TransactionSource     = "InsuranceSeries"
					AccountPeriod         = "#Parameter.CurrentAccountPeriod#"					
					MatchingRequired      = "1"
					Reference             = ""       
					ReferenceName         = "#Object.ObjectReference#"
					ReferenceId           = "#Object.ObjectId#"
					ReferenceNo           = "#Object.EntityCode#"	
					ActionId              = "#Attributes.ActionId#"				
					DocumentCurrency      = "#curr#"
					DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
					DocumentAmount        = "0"
					ParentJournal         = ""
					ParentJournalSerialNo = "">
					
					<cf_GledgerEntryLine
					    Datasource            = "AppsOrganization"
						Lines                 = "1"
					    Journal               = "#Journal.Journal#"
						JournalNo             = "#JournalSerialNo#"						
						JournalTransactionNo  = "#trano#"
						AccountPeriod         = "#Parameter.CurrentAccountPeriod#"
						ExchangeRate          = "1"
						Currency              = "#Curr#"
											
						TransactionSerialNo1  = "0"
						Class1                = "Debit"
						Reference1            = "#Object.EntityCode#"       
						ReferenceName1        = "#Object.ObjectReference#"
						Description1          = ""
						GLAccount1            = "#Journal.GLAccount#"
						Costcenter1           = "#Object.OrgUnit#"
						ProgramCode1          = ""
						ProgramPeriod1        = ""
						ReferenceId1          = ""
						ReferenceNo1          = "#Object.EntityCode#"
						TransactionType1      = "Standard"
						Amount1               = "0"
						Created               = "#DateFormat(Created,CLIENT.DateFormatShow)#">
						
						<cfset num = 0>
				
					<cfoutput>			
			
					<cfset num = num+1>
					
					<cf_GledgerEntryLine
						Datasource            = "AppsOrganization"
						Lines                 = "1"
					    Journal               = "#Journal.Journal#"
						JournalNo             = "#JournalSerialNo#"
						AccountPeriod         = "#Parameter.CurrentAccountPeriod#"		
						TransactionDate       = "#dateformat(DocumentDate,CLIENT.DateFormatShow)#"				
						Currency              = "#DocumentCurrency#"
						
						TransactionSerialNo1  = "#num#"
						Class1                = "Credit"
						Reference1            = "#Object.EntityCode#"       
						ReferenceName1        = "#DocumentItemName#"
						ReferenceNo1          = "#DocumentItem#"
						Description1          = "#Description#"
						GLAccount1            = "#GLAccount#"
						Costcenter1           = "#Object.OrgUnit#"
						ProgramCode1          = ""
						ProgramPeriod1        = ""
						ReferenceId1          = "#ObjectCostId#"
						ReferenceIdParam1     = "Sales"
						TransactionType1      = "Standard"
						Amount1               = "#InvoiceAmount#"
						Created               = "#DateFormat(Created,CLIENT.DateFormatShow)#">				
					
					</cfoutput>
					
					<!--- makes the total correct --->
					
					<cf_GledgerEntryClose
			        Datasource            = "AppsOrganization"
				    Journal               = "#Journal.Journal#"
					JournalSerialNo       = "#JournalSerialNo#">				
					
	</cfoutput> 

</cfif>

