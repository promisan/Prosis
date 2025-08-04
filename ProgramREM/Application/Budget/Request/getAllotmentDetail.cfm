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

<cfquery name="Allotment" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   PAD.OfficerUserId, 
		         PAD.OfficerLastName, 
				 PAD.OfficerFirstName, 
				 PAD.TransactionDate,
				 PAD.TransactionType, 
				 PAA.Reference, 
				 SUM(PADR.Amount) AS Allotted
		FROM     ProgramAllotmentRequest PAR INNER JOIN
                 ProgramAllotmentDetailRequest PADR ON PAR.RequirementId = PADR.RequirementId INNER JOIN
                 ProgramAllotmentDetail PAD ON PADR.TransactionId = PAD.TransactionId LEFT OUTER JOIN
                 ProgramAllotmentAction PAA ON PAD.ActionId = PAA.ActionId
		WHERE    PAR.RequirementIdParent = '#url.RequirementIdParent#' 
		AND      PAR.ObjectCode          = '#url.ObjectCode#'
		AND      PAD.Status = '1'
		GROUP BY PAD.OfficerUserId, PAD.OfficerLastName, PAD.OfficerFirstName, PAD.TransactionDate, PAD.TransactionType, PAA.Reference
</cfquery>

<table width="100%">

<cfif Allotment.recordcount eq "0">
<tr><td align="center" class="labelit">No allotments issued at this date</td></tr>
</cfif>

<cfoutput query="Allotment">
	<tr bgcolor="FFFF80" class="labelit">
	 <td width="30%" style="padding-left:10px">#OfficerFirstName# #OfficerLastName#</td>
	 <td width="100">#dateformat(TransactionDate,client.dateformatshow)#</td>
	 <td width="10%">#TransactionType#</td>
	 <td width="20%">#Reference#</td>
	 <td align="right" width="30%" style="padding-right:10px">#numberformat(allotted,'_,__.__')#</td>
    </tr>
</cfoutput>

</table>		