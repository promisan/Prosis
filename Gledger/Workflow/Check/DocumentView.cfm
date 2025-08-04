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


<!--- show the document --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionIssuedCheck
	WHERE   TransactionCheckId = '#actionid#'
</cfquery>

<cfoutput>
<table width="95%" align="right">
<tr class="labelmedium line" style="height:20px">
<td><cf_tl id="CheckNo">:</td><td style="font-size:16px">#Check.CheckNo#</td>
<td><cf_tl id="Payee">:</td><td style="font-size:16px">#Check.CheckPayee#</td>
<td><cf_tl id="Date">:</td><td style="font-size:16px">#dateformat(Check.CheckDate,client.dateformatshow)#</td>
</tr>
<tr class="labelmedium" style="height:20px">
    <td><cf_tl id="Amount">:</td><td colspan="3" style="font-size:16px">#Check.CheckAmountText# (#check.CheckAmount#)</td>
    <td><cf_tl id="Memo">:</td><td>#Check.CheckMemo#</td>
</tr>
</table>
</cfoutput>