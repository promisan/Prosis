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
<cfquery name="Drop"
	datasource="AppsQuery">
      if exists (select * from dbo.sysobjects 
	             where id = object_id(N'[dbo].[vwLedger]') 
            	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwLedger]
	</cfquery>
	
	
<!--- additional dimension like accountparent, accountgroup --->
 
<cfquery name="Dataset" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	CREATE VIEW dbo.vwLedger
	
	AS
	SELECT     H.Mission               as Entity_dim, 
	           H.Journal               as Journal_dim, J.Description AS Journal_nme, 
			   L.GLAccount             as Account_dim, L.GLAccount+' '+R.Description AS Account_nme, 	
			   R.AccountClass          as AccountClass_dim,
			   RG.AccountGroup         as AccountGroup_dim, RG.AccountGroup+' '+RG.Description AS AccountGroup_nme, RG.ListingOrder as AccountGroup_ord,
			   RP.AccountParent        as AccountParent_dim, RP.AccountParent+' '+RP.Description AS AccountParent_nme,		   
			   L.Fund                  as Fund_dim,
			   L.OrgUnit               as Center_dim, O.HierarchyCode as Center_ord, O.OrgUnitName as Center_nme,
			   L.ProgramCode           as Program_dim, P.ProgramName AS Program_nme, 
			   H.AccountPeriod         as PeriodFiscal_dim, 			   	   
			   H.TransactionPeriod     as PeriodTransactionFiscal_dim,   
			   L.TransactionPeriod     as PeriodTransactionEconomic_dim,             
			   L.Currency              as Currency_dim, 
               L.OfficerUserId         as Officer_dim, L.OfficerFirstName + ' ' + L.OfficerLastName AS Officer_nme, 
			   H.TransactionSource     as Source_dim,
			   H.TransactionCategory   as Category_dim,		
			   J.GLCategory			   as TransactionMode_dim,	
			   L.TransactionDate, 
			   L.JournalTransactionNo,
			   L.Reference,		
			   round((L.AmountDebit-AmountCredit),2) as Amount,	   
			   round(L.AmountDebit,2) as AmountDebit, 
               round(L.AmountCredit,2) as AmountCredit, 
			   round((L.AmountBaseDebit-AmountBaseCredit),2) as AmountBase,	
			   round(L.AmountBaseDebit,2) as AmountBaseDebit, 
			   round(L.AmountBaseCredit,2) as AmountBaseCredit, 
			   L.TransactionType, 
			   L.TransactionLineId AS FactTableid
			   
	FROM       Accounting.dbo.TransactionHeader AS H INNER JOIN
               Accounting.dbo.TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
               Accounting.dbo.Ref_Account AS R ON L.GLAccount = R.GLAccount INNER JOIN
			   Accounting.dbo.Ref_AccountGroup AS RG ON R.AccountGroup = RG.AccountGroup INNER JOIN
			   Accounting.dbo.Ref_AccountParent AS RP ON RG.AccountParent = RP.AccountParent INNER JOIN			 
               Accounting.dbo.Journal J ON H.Journal = J.Journal LEFT OUTER JOIN
               Program.dbo.Program AS P ON L.ProgramCode = P.ProgramCode LEFT OUTER JOIN
               Organization.dbo.Organization AS O ON O.OrguNit = L.OrgUnit
	WHERE      H.ActionStatus IN ('0','1')
	AND        H.RecordStatus != '9'
</cfquery>	