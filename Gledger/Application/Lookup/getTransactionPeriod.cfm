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
<cfparam name="url.mission"    default="">
<cfparam name="url.period"     default="">
<cfparam name="url.pap"        default="">
<cfparam name="url.account"    default="">
<cfparam name="url.glcategory" default="">

<cfquery name="Account"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Account
	WHERE     GLAccount = '#url.account#'	
</cfquery>

<cfif Account.accountClass eq "Balance">

	<!--- we take the posting period from the header for now --->
	
	<cfquery name="Period"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    H.TransactionPeriod
		FROM      TransactionHeader H INNER JOIN TransactionLine L ON H.Journal = L.Journal and H.JournalSerialNo = L.JournalSerialNo
		WHERE     H.Mission       = '#url.mission#' 
		AND       H.Journal IN (SELECT Journal 
				                FROM   Journal 
								WHERE  Journal = H.Journal
						        AND    GLCategory = '#URL.GLCategory#')
		<cfif url.period neq "all">
		AND       H.AccountPeriod = '#url.period#'	
		</cfif>
		AND       L.GLAccount = '#url.account#'
		AND       H.RecordStatus    IN ( '1')
	    AND       H.ActionStatus    IN ('0','1')
		GROUP BY  H.TransactionPeriod 
		ORDER BY  H.TransactionPeriod
				
	</cfquery>

<cfelse>

	<!--- we take the posting period from the line allowing for distribution etc. --->
	
	<cfquery name="Period"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    L.TransactionPeriod
		FROM      TransactionHeader H INNER JOIN TransactionLine L ON H.Journal = L.Journal and H.JournalSerialNo = L.JournalSerialNo
		WHERE     H.Mission       = '#url.mission#' 
		AND       H.Journal IN (SELECT Journal 
				                FROM   Journal 
								WHERE  Journal = H.Journal
						        AND    GLCategory = '#URL.GLCategory#')
		<cfif url.period neq "all">
		AND       H.AccountPeriod = '#url.period#'	
		</cfif>
		AND       L.GLAccount = '#url.account#'
		AND       H.RecordStatus    IN ( '1')
	    AND       H.ActionStatus    IN ('0','1')
		GROUP BY  L.TransactionPeriod
		ORDER BY  L.TransactionPeriod
		
	</cfquery>

</cfif>

<select id="transactionperiod" name="TransactionPeriod" class="regularxl" style="background-color:e6e6e6;border:0px" onchange="reloadForm()">

    <option value="" selected>All</option>
	<cfoutput query="Period">
		<option value="#TransactionPeriod#" <cfif url.pap eq transactionperiod>selected</cfif>>#TransactionPeriod#</option>
	</cfoutput>

</select>
	
