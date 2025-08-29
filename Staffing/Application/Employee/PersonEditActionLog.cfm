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
<cfquery name="List" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT A.*, S.ActionFieldEffective, (SELECT TOP 1 ActionFieldValue
	               FROM   EmployeeActionSource
				   WHERE  ActionDocumentNo = S.ActionDocumentNo
				   AND    ActionStatus = '9') as FieldValue
	  FROM   EmployeeAction A,
    		 EmployeeActionSource S
	  WHERE  A.ActionDocumentNo = S.ActionDocumentNo		 
            AND    S.PersonNo  = '#URL.ID#'
	  AND    S.ActionStatus = '1'
	  AND    A.ActionStatus != '9'
	  AND    A.ActionCode      = '#URL.ActionCode#'
	  ORDER BY A.Created DESC		
   </cfquery>

<table cellspacing="0" cellpadding="0">
  <tr class="line labelmedium">
  	<td style="min-width:150">Officer</td>
	<td style="min-width:90">Recorded</td>
	<td style="min-width:90">Expiry</td>
	<td style="min-width:180">Value</td>
	<td class="fixlength">Memo</td>
  </tr>  
  <cfoutput query="List">
   <tr class="labelmedium line">
   <td>#OfficerLastName#</td>
   <td>#Dateformat(Created,CLIENT.DateFormatShow)#</td>
   <td>#Dateformat(ActionFieldEffective,CLIENT.DateFormatShow)#</td>
   <td>#FieldValue#</td>
   <td>#ActionDescription#</td>
   </tr>			  
  </cfoutput>
</table>		