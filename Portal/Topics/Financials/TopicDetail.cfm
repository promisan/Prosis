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
<cfquery name="ObjectGroup"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   G.GLAccount, G.Description, round(SUM((L.AmountBaseDebit - L.AmountBaseCredit)/1000),2) AS Total
	FROM     TransactionLine L INNER JOIN
             Journal J ON L.Journal = J.Journal INNER JOIN
             Ref_Account G ON L.GLAccount = G.GLAccount INNER JOIN
             Ref_AccountGroup P ON G.AccountGroup = P.AccountGroup
	WHERE     (G.AccountType = 'Debit') AND (G.AccountClass = 'Result')
	AND     J.Mission = '#url.mission#'
	AND J.Journal IN
                       (SELECT   Journal
                        FROM     Journal
					WHERE 
					GLCategory IN ('Actuals','Obligation')
					AND (SystemJournal != 'Opening' OR SystemJournal IS NULL))
	AND P.Description = '#URL.ObjectClass#'				
	GROUP BY G.GLAccount, G.Description	
	ORDER BY G.GLAccount
  </cfquery>	

<table width="480" align="center" cellspacing="0" cellpadding="0" border="1" bordercolor="d3d3d3" class="formpadding"> 
<tr><td colspan="3"><cfoutput><b>#URL.ObjectClass#</cfoutput></td></tr> 
<cfoutput query="ObjectGroup">
	<tr>
	<td width="70">#GLAccount#</td>
	<td width="280">#Description#</td>
	<td width="130" align="right">#numberformat(total,"__,__.__")#</td>
	</tr>	
</cfoutput>

<cfquery name="Total"        
         dbtype="query">
		SELECT   sum(Total) as Total
		FROM ObjectGroup
</cfquery>	

<tr>
	<td colspan="2" width="200"><b>Total</td>
	<td align="right"><b><cfoutput>#numberformat(total.total,"__,__.__")#</cfoutput></td>
	</tr>	
</table>