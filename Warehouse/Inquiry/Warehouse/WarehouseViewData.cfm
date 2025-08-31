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
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td valign="top">

	<!---- Some table preparations --->
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Monthly"> 
	<cfquery name="Section" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		SELECT ItemNo, Year(TransactionDate) as Y, Month(TransactionDate) as M, SUM(-1*TransactionQuantity) as Monthly
		INTO #SESSION.acc#_Monthly
		FROM Materials.dbo.ItemTransaction			
		WHERE Mission = '#URL.Mission#'
		AND TransactionType = '2'
		AND ItemNo IN
		(
			SELECT ItemNo
			FROM Materials.dbo.Item
			WHERE Category = 'FUEL'
		)
		GROUP BY ItemNo,Month(TransactionDate), Year(TransactionDate)
	</cfquery>

	<cf_informationContent 
	    systemfunctionid="#url.idmenu#"
	    mission="#url.mission#">
   
    </td>
</tr>

</table>
