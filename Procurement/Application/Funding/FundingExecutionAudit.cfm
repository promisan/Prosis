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

<!--- feature to show transactions that need work --->

<cf_screentop height="100%" scroll="yes" html="no" jquery="Yes">

<cf_DialogLedger>

<cfquery name="SearchResult" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    L.*, H.*, R.Description AS GLAccountName
	
	FROM      TransactionLine L INNER JOIN
	          TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo INNER JOIN
	          Ref_Account R ON L.GLAccount = R.GLAccount
			  
	WHERE     H.Mission = '#URL.Mission#'	
				  
	AND       R.ForceProgram = 1 and H.JournalTransactionNo != '0'
	
	AND       (
				L.ProgramCode is NULL or L.ProgramCode NOT IN (SELECT ProgramCode
						                				     FROM   Program.dbo.Program
															 WHERE  ProgramCode = L.ProgramCode									 														 
															)
			  )		
			  										
	ORDER BY H.Created							
</cfquery>								

<cfoutput>

	<cfif SearchResult.recordcount eq "0">
	<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td align="center" height="40">There are no records to show in this view.</td></table>
	
	<cfelse>
			
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td colspan="8" height="25" class="labelit">
	
	   <img src="#SESSION.root#/images/finger.gif" alt="" border="0" align="absmiddle">
	   <b><cf_tl id="Attention"> : <cf_tl id="The following transactions have not been associated to a program/project" class="message">.</b></td></tr>
	
	<tr><td colspan="8" class="linedotted"></td></tr>
	<tr><td colspan="8"><table width="100%" cellspacing="0" cellpadding="0">
	<cfset embed = 1>	   
	<cfinclude template="../../../Gledger/Application/Inquiry/TransactionListingLines.cfm">
	
	</td></tr>
	</table>
	</td></tr>
	</table>
	</td>
	</tr>
	</table>
		
	</cfif>
	
</cfoutput>



