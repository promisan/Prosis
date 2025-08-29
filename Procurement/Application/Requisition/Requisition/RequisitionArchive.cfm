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
<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*, S.Description
    FROM   RequisitionLineAction L, Status S
	WHERE  S.StatusClass = 'requisition'
	AND    L.ActionStatus = S.Status
	AND    ActionId = '#URL.ActionId#' 
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" height="100%" bgcolor="white">
<tr><td valign="top">

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td height="5"></td></tr>

<cfif Line.recordcount gt "1">
	<cfoutput>
		<tr><td height="5" colspan="2" align="center"><font color="FF0000"><cf_tl id="Attention: This line was split by the buyer in"> #line.recordcount# <cf_tl id="sublines">.</td></tr>
	</cfoutput>
	<tr><td colspan="2" class="Line"></td></tr>
</cfif>

<cfoutput query="Line" maxrows=1>

<tr class="labelmedium">
	<td width="100"><cf_tl id="Date">:</td>
	<td width="90%"><b>#Dateformat(ActionDate,CLIENT.DateFormatShow)#</td>
</tr>
<tr class="labelmedium">
	<td><cf_tl id="Officer">:</td>
	<td><b>#OfficerFirstName# #OfficerLastName#</td>
</tr>
<tr class="labelmedium">
	<td><cf_tl id="Action">:</td>
	<td><b>#Description#</td>
</tr>
<cfif ActionMemo neq "">
<tr class="labelmedium">
	<td><cf_tl id="Subject">:</td>
	<td><b>#ActionMemo#</td>
</tr>
</cfif>

<tr><td colspan="2" height="1" class="line"></td></tr>

<tr class="labelmedium"><td colspan="2">#Line.ActionContent#</td></tr>

</cfoutput>

<cfquery name="Reason" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  R.Description, A.ReasonCode, A.Remarks
	FROM    RequisitionLineActionReason A INNER JOIN
            Ref_StatusReason R ON A.ReasonCode = R.Code
	WHERE  ActionId = '#URL.ActionId#' 
</cfquery>	

	<cfif Reason.recordcount eq "0">
	
		<cfif Line.ActionContent eq "">
		
		<tr><td colspan="2" align="center">No additional reason for this action submitted</td></tr>
		
		</cfif>
	
	
	<cfelse>
	
	<tr class="labelmedium"><td colspan="2" align="center">Reasons for action</td></tr>

	<tr><td colspan="2" align="center">
	 
	<table width="96%" align="center" bgcolor="F4FBFD">
		
		<cfoutput query="Reason">
			<tr class="labelmedium">
				<td width="20">#CurrentRow#</td>
				<td width="200">#Description#</td>
				<td>#Remarks#</td>
			</tr>
		</cfoutput>				  
	
	</table>
	
	</cfif>

	</td></tr>

</table>

</td></tr></table>

