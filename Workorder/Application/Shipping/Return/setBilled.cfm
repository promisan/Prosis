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

<!--- set total billed after you submit a billing --->
				 
<cfquery name="Billed" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Currency,ISNULL(SUM(Amount), 0) AS Total
	FROM      TransactionHeader
	WHERE     ReferenceId = '#url.workorderid#'
	GROUP BY  Currency	
</cfquery>  

<cfoutput>  

 <table cellspacing="0" cellpadding="0">
	 <cfloop query="billed">
	 <tr><td  class="labelmedium">#Billed.currency# #numberformat(Billed.Total,",__.__")#</td></tr>				 
	 </cfloop>
 </table>

</cfoutput> 