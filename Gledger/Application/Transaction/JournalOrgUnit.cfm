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
<!--- template called from a portal function from a customer --->
<!--- ------------------------------------------------------ --->

<cfparam name="URL.OrgUnit"   default="#client.orgunit#">

<cfquery name="Period" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM Period 
	  WHERE ActionStatus = 0	 
	  ORDER BY AccountPeriod
</cfquery>

<cfparam name="URL.IDStatus"  default="All">
<cfparam name="URL.IDSorting" default="Journal">
<cfparam name="URL.journal"   default="">
<cfparam name="URL.Find"      default="">
<cfparam name="URL.Month"     default="">
<cfparam name="URL.Mission"   default="">
<cfparam name="URL.Period"    default="#period.accountperiod#">

<!--- --------------- --->
<!--- hide the header --->
<!--- --------------- --->

<cfset access = "NONE">

	<!--- Query returning search results --->
	
	<cfquery name="TransactionListing"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT T.Journal, 
		       T.JournalSerialNo,
			   T.TransactionDate, 
			   T.JournalTransactionNo, 
			   T.Description,
			   T.ReferenceName, 
			   T.ReferenceNo,
			   T.Reference, 
			   T.Currency,
			   T.ActionStatus,
			   T.Amount, 
			   T.AmountOutstanding, 
			   sum(L.AmountDebit) as AmountTriggerDebit,
			   sum(L.AmountCredit) as AmountTriggerCredit
		FROM   TransactionHeader T, TransactionLine L
		WHERE  T.Journal                = L.Journal
		AND    T.JournalSerialNo        = L.JournalSerialNo
		AND    L.TransactionSerialNo    = '0'
		AND    T.ReferenceOrgUnit       = '#URL.OrgUnit#' 		
		AND    T.AccountPeriod          = '#URL.Period#'
		<cfif URL.Month neq "">
		AND    Month(T.TransactionDate) = '#URL.month#'
		</cfif>
		<cfif URL.IDStatus eq "Outstanding">
		AND    T.AmountOutstanding > 0 
		</cfif>
		<cfif URL.find neq "">
		AND    (
		       T.JournalTransactionNo LIKE '%#URL.Find#%' OR
		       T.ReferenceName    LIKE '%#URL.Find#%' OR
			   T.ReferenceNo      LIKE '%#URL.Find#%' OR
			   T.Description      LIKE '%#URL.Find#%' OR
			   T.JournalSerialNo  LIKE '#URL.Find#%'  
			   )
		
		</cfif>
		GROUP BY T.Journal, 
		       T.JournalSerialNo,
			   T.JournalTransactionNo, 
			   T.TransactionDate, 
			   T.ReferenceName, 
			   T.ReferenceNo,
			   T.Description,
			   T.Reference, 
			   T.Currency,
			   T.ActionStatus,
			   T.Amount, 
			   T.AmountOutstanding 
		 ORDER BY T.#IDSorting# DESC, T.Currency <cfif idsorting neq "transactiondate">,T.TransactionDate DESC </cfif>
	</cfquery>
	
<cfquery name="Period" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM Period 
</cfquery>
  
<cfinclude template="JournalListing.cfm">
 