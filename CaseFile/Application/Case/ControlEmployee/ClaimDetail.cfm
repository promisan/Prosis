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
<cf_compression>
		 
<cfparam name="URL.ClaimId" default="">

<cfif URL.claimid neq "">

<cfquery name="Details" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DocumentNo,
	       ClaimMemo,
		   ActionStatus,
		   CaseNo,
		   DocumentDate
	FROM   Claim
	WHERE  ClaimId = '#URL.ClaimId#' 
</cfquery>

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr>
<td height="99%" align="left" bgcolor="EBF7FE">

	<table width="98%" height="100%" cellspacing="0" cellpadding="0" class="formpadding" align="center">
	
		<tr>
			<td align="left" width="10%" class="labelit"><b><cf_tl id="NCas Date">:</b></td>
			<td align="left" width="40%" class="labelit">#Dateformat(Details.DocumentDate, "#CLIENT.DateFormatShow#")#</td>
			<td width="10%" class="labelit"><b><cf_tl id="Initial Notification">: </b></td>
			<td class="labelit">
				<button onClick="javascript:print('#ClaimId#')" class="button3">
			     <img src="#Client.VirtualDir#/Images/print_small4.jpg" alt=""  
				  style="cursor: pointer;" alt=""border="0" align="middle">
				</button>
			</td>
		</tr>
			
		<tr>
			<td class="labelit"><b><cf_tl id="Document No">:</b></td>
			<td class="labelit">#Details.DocumentNo#</td>
		</tr>
				
	</table>
	
</td>
</tr>

<tr><td colspan="4" class="line"></td></tr>

<tr><td>

	<table width="98%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td class="labelit">#Details.ClaimMemo#</td></tr>
	</table>

</td></tr>

</table>

</cfoutput>

</cfif>
