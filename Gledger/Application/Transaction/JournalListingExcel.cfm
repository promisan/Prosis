<!--
    Copyright © 2025 Promisan B.V.

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
<CF_DropTable dbName="AppsQuery" tblName="vwListingJournal#SESSION.acc#">
<CF_DropTable dbName="AppsQuery" tblName="vwListingLines#SESSION.acc#">

<!--- variable to content the records shown in this view --->
<cfparam name="session.SelectedId" default="">

<cfif session.selectedid eq "">

	<table width="100%" height="100%">
		<tr><td align="center" height="70" class="labelmedium">
		Sorry, no records to show in this export view
		</td>
		</tr>
	</table>

	<cfabort>

<cfelse>	

   <cftransaction isolation="READ_UNCOMMITTED">
	
	<cfquery name="TransactionListing"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT T.Journal, 
			       T.JournalSerialNo,			   	  
				   T.TransactionDate, 
				   T.JournalTransactionNo, 
				   T.Description,
				   T.ReferencePersonNo,
				   (SELECT IndexNo  FROM Employee.dbo.Person WHERE PersonNo = T.ReferencePersonNo) as PersonIndexNo,
				   (SELECT FullName FROM Employee.dbo.Person WHERE PersonNo = T.ReferencePersonNo) as PersonName,					
				   T.ReferenceName, 
				   T.ReferenceNo,
				   T.Reference, 
				   T.TransactionSource,
				   T.AccountPeriod,
				   T.TransactionPeriod,
				   T.TransactionCategory,
				   T.OfficerUserId,
				   T.OfficerLastName,
				   T.OfficerFirstName,
				   T.Created as Posted,
				   T.Currency,
				   T.ExchangeRate,
				   T.ActionStatus,
				   T.Amount as DocumentAmount, 
				   T.AmountOutstanding as DocumentAmountOutstanding, 			   
				   
				   (SELECT sum(AmountDebit) 
				   FROM TransactionLine L 
				   WHERE  T.Journal = L.Journal
					AND   T.JournalSerialNo = L.JournalSerialNo) as DocumentAmountDebit,
					
				   (SELECT sum(AmountCredit) 
				   FROM TransactionLine L 
				   WHERE  T.Journal = L.Journal
					AND   T.JournalSerialNo = L.JournalSerialNo) as DocumentAmountCredit
					
			INTO   userQuery.dbo.vwListingJournal#SESSION.acc#	   
			FROM   TransactionHeader T
							
			WHERE  T.Journal = '#url.journal#'
			AND    T.JournalSerialNo IN (#preservesinglequotes(session.Selectedrecords)#)
					
			ORDER BY T.Journal,T.JournalSerialNo
			
								
		</cfquery>

		
		<cfquery name="TransactionListing"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT     H.Journal, 
			           H.JournalSerialNo, 
					   H.JournalTransactionNo, 
					   H.ReferencePersonNo,
					   (SELECT IndexNo  FROM Employee.dbo.Person WHERE PersonNo = H.ReferencePersonNo) as PersonIndexNo,
					   (SELECT FullName FROM Employee.dbo.Person WHERE PersonNo = H.ReferencePersonNo) as PersonName,
					   H.ReferenceName as ReferenceMemo,
					   L.TransactionSerialNo, 
					   L.GLAccount, 
					   Ref_Account.Description, 
					   L.OrgUnit,
                          (SELECT     OrgUnitName
                            FROM          Organization.dbo.Organization
                            WHERE      (OrgUnit = L.OrgUnit)) AS OrgUnitName, L.Fund, L.ProgramCode,
                          (SELECT     ProgramName
                            FROM          Program.dbo.Program
                            WHERE      (ProgramCode = L.ProgramCode)) AS ProgramName, L.ProgramPeriod,
                          (SELECT     Reference
                            FROM          Program.dbo.ProgramPeriod
                            WHERE      (ProgramCode = L.ProgramCode) AND (Period = L.ProgramPeriod)) AS ProgramReference, L.ObjectCode,
                          (SELECT     Description
                            FROM          Program.dbo.Ref_Object
                            WHERE      (Code = L.ObjectCode)) AS ObjectDescription,
                          (SELECT     O.OrgUnitName
                            FROM          Program.dbo.ContributionLine AS CL INNER JOIN
                                                   Program.dbo.Contribution AS C ON CL.ContributionId = C.ContributionId INNER JOIN
                                                   Organization.dbo.Organization AS O ON C.OrgUnitDonor = O.OrgUnit
                            WHERE      (CL.ContributionLineId = L.ContributionLineId)) AS Donor,
                          (SELECT     Reference
                            FROM          Program.dbo.ContributionLine
                            WHERE      (ContributionLineId = L.ContributionLineId)) AS DonorReference, 
					  L.AccountPeriod, 
					  L.TransactionDate, 
					  L.TransactionType, 
					  L.Reference, 
					  L.ReferenceName, 
                      L.ReferenceNo, 
					  L.TransactionCurrency, 
					  L.TransactionAmount, 
					  L.TransactionTaxCode, 
					  L.ExchangeRate, 
					  L.Currency, 
					  L.AmountDebit, 
					  L.AmountCredit, 
                      L.ExchangeRateBase, 
					  L.AmountBaseDebit, 
					  L.AmountBaseCredit, 
					  L.OfficerUserId, 
					  L.OfficerLastName, 
					  L.OfficerFirstName, 
					  L.Created

			INTO    userQuery.dbo.vwListingLines#SESSION.acc#	
					  		
			FROM    TransactionHeader AS H INNER JOIN
                    TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
                    Ref_Account ON L.GLAccount = Ref_Account.GLAccount
			
			WHERE   L.Journal = '#url.journal#'
			AND     L.JournalSerialNo IN (#preservesinglequotes(session.SelectedRecords)#)
			
			ORDER BY H.Journal, H.JournalSerialNo, L.TransactionSerialNo		
							
		</cfquery>	
		
		</cftransaction>
		
		<cfset table1   = "vwListingJournal#SESSION.acc#">		
		<cfset table2   = "vwListingLines#SESSION.acc#">		

</cfif>