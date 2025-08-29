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
<cfquery name="Lines"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionLine
	WHERE   Journal         = '#url.journal#' 
	AND     JournalSerialNo = '#url.journalserialNo#'
    AND     GLAccount      != '#url.glaccount#'
</cfquery>	

<!--- show other lines of that transaction --->

<table width="100%" cellspacing="0" cellpadding="0">
<cfoutput query="Lines">
	<tr>
		<td width="50" class="labelit">#currentrow#.</td>
		<td width="70%" class="labelit">#Reference# #Memo#</td>
		<td width="30" class="labelit">#currency#</td>
		<td width="100" class="labelit" align="right">#numberformat(amountDebit,",.__")#</td>
		<td width="100" class="labelit" align="right">#numberformat(amountCredit,",.__")#</td>
	</tr>
</cfoutput>	
</table>