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
<cf_screentop html="no">
<cf_preventCache>

<body>

<!--- now show request for confirmation or denial --->

<cfquery name="get" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	    SELECT L.*, P.LastName, P.FirstName, P.IndexNo
		FROM PersonLeave L, Person P
        WHERE Leaveid = '#URL.ID#'
</cfquery>

<form action="DecisionSubmit.cfm" method="POST" name="leave">

<cfoutput>
<input type="hidden" name="LeaveId" value="#Get.LeaveId#">
<input type="hidden" name="OrgUnit" value="#Get.OrgUnit#">
</cfoutput>

<table width="85%" border="1" align="center" bordercolor="#008080">

<tr><td class="BannerXLN">&nbsp;<b>Process leave request</b></td></tr>

<tr><td>

<table width="100%">

<tr><td height="4" class="header"></td></tr>
<tr>
  <td width="25%" class="header">&nbsp;Name:</td>
  <td class="regular">&nbsp;<cfoutput>#Get.firstName# #Get.lastName#</cfoutput></td>
</tr>
<tr><td height="4" class="header"></td></tr>
<tr>
  <td class="header">&nbsp;IndexNo:</td>
  <td class="regular">&nbsp;<cfoutput>#Get.indexNo#</cfoutput></td>
</tr>

<cfquery name="Org" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Organization
WHERE OrgUnit = '#Get.OrgUnit#'
   </cfquery>
   
<tr><td height="4" class="header"></td></tr>
<tr>
  <td class="header">&nbsp;Unit:</td>
  <td class="regular">&nbsp;<cfoutput>#Org.OrgUnitName#</cfoutput></td>
</tr>
<tr><td height="4" class="header"></td></tr>
<tr><td height="2" colspan="2" class="top2"></td></tr>
<tr><td height="4" class="header"></td></tr>

<cfquery name="Type" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_LeaveType 
WHERE LeaveType = '#Get.LeaveType#'
   </cfquery>

<tr>
  <td valign="top" class="header">&nbsp;Type of leave:</td>
  <td width="70%" class="regular"><cfoutput query="Type" maxrows=1>&nbsp;#Type.Description#</cfoutput></td>
</tr>
	
<tr><td height="6" class="header"></td></tr>
<tr>
  <td class="header">&nbsp;Start:</td>
  <td class="regular">&nbsp;<cfoutput>#DateFormat(Get.DateEffective,CLIENT.DateFormatShow)#</cfoutput>
  </td>
</tr>
<tr><td height="6" class="header"></td></tr>

<tr>
  <td class="header">&nbsp;End:</td>
  <td class="regular">&nbsp;<cfoutput>#DateFormat(Get.DateExpiration,CLIENT.DateFormatShow)#</cfoutput>
  </td>
</tr>
<tr><td height="6" class="header"></td></tr>

<tr>
  <td class="header">&nbsp;Days:</td>
  <td class="regular">&nbsp;<cfoutput>#numberFormat(Get.DaysLeave,"__._")#</cfoutput>
  </td>
</tr>
<tr><td height="6" class="header"></td></tr>

<cfif #Get.DaysDeduct# gt "0">
<tr>
  <td class="header">&nbsp;Deduct from balance:</td>
  <td class="regular">&nbsp;<cfoutput>#numberFormat(Get.DaysDeduct,"__._")#</cfoutput>
  </td>
</tr>
<tr><td height="6" class="header"></td></tr>
</cfif>

<tr>
  <td class="header">&nbsp;Memo:</td>
  <td class="regular">&nbsp;<cfoutput>#Get.Memo#</cfoutput></td>
</tr>

<tr><td height="4" class="header"></td></tr>
<tr><td height="2" colspan="2" class="top"></td></tr>

<cfquery name="flow" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	    SELECT L.*
		FROM PersonLeaveAction L
		WHERE L.LeaveId = '#Get.LeaveId#'
		ORDER BY FlowOrder
</cfquery>

<tr>
  <td valign="top" class="header">&nbsp;Clearance(s):</td>
  <td valign="top" class="regular">
  
  <table width="100%">
  <tr>
    <td class="topN">&nbsp;#</td>
	<td class="topN">Officer</td>
	<td class="topN">Date</td>
	<td class="topN">Memo</td>
  </tr>
  <cfoutput query="Flow">
  <tr>
    <td width="5%" class="regular">&nbsp;#CurrentRow#</td>
	<td class="regular">#OfficerFirstName# #OfficerLastName#</td>
	<td class="regular">#DateFormat(OfficerDate,CLIENT.DateFormatShow)#</td>
	<td class="regular">#ActionMemo#</td>
  </tr>
  </cfoutput>
  
  </table>
  </td>
</tr>

<tr><td height="4" class="header"></td></tr>

<tr><td colspan="2">
   <cf_DecisionBlock form="leave"> 
</td></tr>   
 
</table>

</td></tr>

<tr><td height="12" colspan="2" class="BannerN">&nbsp;</td></tr>

</table>

</form>


</body>
</html>
