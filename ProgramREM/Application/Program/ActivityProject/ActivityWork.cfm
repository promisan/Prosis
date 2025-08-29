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
<cfoutput>

	<cfquery name="Time" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		SELECT     W.PersonNo, 
		           W.ActionCode, 
				   SUM(HourSlotMinutes)/60 AS Hours, 
				   P.LastName, 
				   P.FirstName, 
				   P.Gender, 
				   P.Nationality
		FROM       PersonWorkDetail W INNER JOIN
	               Person P ON W.PersonNo = P.PersonNo
		WHERE      W.ActionCode = '#URL.ActivityId#'
		GROUP BY W.PersonNo, W.ActionCode, P.LastName, P.FirstName, P.Gender, P.Nationality
	</cfquery>	
	
	<table width="93%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="e4e4e4" class="formpadding">
	<cfif time.recordcount eq "0">
		<tr class="labelmedium">
		  <td height="40" align="center">No work attendance has been recorded.</b></td>
		</tr>
	<cfelse>
	    <tr class="line labelmedium">
		   <td height="17">&nbsp;  </td>
		   <td><cf_tl id="Name"></td>
		   <td><cf_tl id="Gender"></td>
		   <td><cf_tl id="Nat"></td>
		   <td align="right"><cf_tl id="Hours"></td>
		</tr>		
		<cfloop query="Time">
		<tr class="linedotted labelmedium">
		  <td height="20" align="center" width="45">
		  
			<img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
				id="#personNo#Exp" border="0" class="show" 
				align="absmiddle" style="cursor: pointer;" 
				onClick="time('#PersonNo#','#URL.ActivityId#')">
				
				<img src="#SESSION.root#/Images/icon_collapse.gif" 
				id="#PersonNo#Col" alt="" border="0" 
				align="absmiddle" class="hide" style="cursor: pointer;" 
				onClick="time('#PersonNo#','#URL.ActivityId#')">
		  
		  </td>
		  <td><a href="javascript:time('#PersonNo#','#URL.ActivityId#')"><font face="Calibri" size="3">#FirstName# #LastName#</a></td>
		  <td>#Gender#</td>
		  <td>#Nationality#</td>
		  <td align="right">#Hours#</td>
		</tr>
		<tr id="d#PersonNo#" class="hide"><td></td><td colspan="4" style="padding:4px;" id="i#PersonNo#"></td></tr>
		</cfloop>
	</cfif>
	</table>
	
</cfoutput>	