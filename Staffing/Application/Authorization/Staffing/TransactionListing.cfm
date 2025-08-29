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
<cfquery name="Result" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   A.ActionDocumentNo, R.Description, AL.ActionStatus, A.OfficerUserId, A.OfficerLastName, A.OfficerFirstName, A.Created, Ass.DateEffective, Ass.DateExpiration, 
         Ass.LocationCode, Ass.FunctionNo, Ass.FunctionDescription, Person.PersonNo, Person.IndexNo, Person.LastName, Person.FirstName, Ass.AssignmentStatus
FROM     EmployeeAction A INNER JOIN
         EmployeeActionSource AL ON A.ActionDocumentNo = AL.ActionDocumentNo INNER JOIN
         PersonAssignment Ass ON AL.PersonNo = Ass.PersonNo AND AL.ActionSourceNo = Ass.AssignmentNo INNER JOIN
         Ref_Action R ON A.ActionCode = R.ActionCode INNER JOIN
         Person ON Ass.PersonNo = Person.PersonNo
WHERE    Ass.PositionNo IN (SELECT PositionNo 
                            FROM Position 
							WHERE PositionParentId  = '#URL.PositionParentId#')
ORDER BY A.ActionDocumentNo DESC, AL.ActionStatus ASC
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
<tr><td height="1" colspan="6" bgcolor="C0C0C0"></td></tr>
<cfif result.recordcount eq "0">
<tr><td colspan="6" height="30" align="center">No assignment actions occurred</b></td></tr>
</cfif>

<cfinvoke component="Service.Access"  
  method="useradmin" 
  role="'AdminUser'"
  returnvariable="access">

<cfoutput query="Result" group="ActionDocumentNo">
<tr>
<td height="22"><!--- #ActionDocumentNo# ---></td>
<td>#Description#</td>
<td><b>for:</b>&nbsp;<a href="javascript:EditPerson('#PersonNo#')">#FirstName# #LastName#<a/></td>
<td>#IndexNo#</td>
<td><b>recorded by:</b> 
<cfif access neq "NONE">
<a href="javascript:ShowUser('#OfficerUserId#')">#OfficerLastName#, #OfficerFirstName#</a>
</cfif></td>
<td><b>on:</b> #DateFormat(Created,CLIENT.DateFormatShow)# #timeFormat(Created,"HH:MM")#</td>
</tr>
<cfoutput>
<tr>
<td colspan="6">
<table width="100%" cellspacing="0" cellpadding="0">
<cfif ActionStatus lte "1">
  <cfset cl = "ffffdf">
<cfelse>
  <cfset cl = "FFC2A6">
</cfif>  
  
<tr bgcolor="#cl#">
<td width="50" bgcolor="white"></td>
<td width="50">&nbsp;<cfif ActionStatus lte "1"><img src="#SESSION.root#/Images/join.gif" alt="" border="0"><cfelse>Prior</cfif></td>
<td width="300">#FunctionDescription#</td>
<td width="80">#LocationCode#</td>
<td width="100">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
<td width="100">#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>	
<td></td>
</tr>
</table>
</tr>

</cfoutput>
</cfoutput>
</table>
