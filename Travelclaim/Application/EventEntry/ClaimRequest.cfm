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

<cfquery name="Claim" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT C.*, D.DocumentNo as RequestNo
    FROM Claim C, ClaimRequest D
    WHERE ClaimId = '#URL.ClaimId#' 
	AND C.ClaimRequestId = D.ClaimRequestId
</cfquery>

<cfoutput>
<tr>
	   <td>
	   <table width="100%" border="0" bordercolor="silver" height="22" border="0" cellspacing="0" cellpadding="0">
		   <tr>
		   <td class="top3n" width="1%">&nbsp;</td>
		   <td class="top3n" width="110"><b>Request doc:</b></td>
		   <td class="top3n" width="15%">TVRQ - #Claim.RequestNo#</td>
		   <td class="top3n" width="70"><b>Voucher:</b></td>
		   <td class="top3n" width="25%"><cfif #Claim.Reference# neq "">#Claim.Reference# #Claim.ReferenceNo#<cfelse>Not assigned</cfif></td>
		   <td class="top3n" width="80"><b>Date:</b></td>
		   <td class="top3n" width="20%">#DateFormat(Claim.ClaimDate, CLIENT.DateFormatShow)#
		   <td class="top3n" width="30" align="center">
		   <img src="#SESSION.root#/Images/up2.gif" alt="Back to claim" border="0" style="cursor: hand;" onClick="goback()">
		   </td>
		   		   
		   <script language="JavaScript">
		   function goback() {
			window.location = "#SESSION.root#/Payroll/Application/Claim/ClaimEntry/ClaimEntry.cfm?ClaimId=#URL.ClaimId#&RequestId=#Claim.ClaimRequestId#&PersonNo=#Claim.PersonNo#"
		   }	
          </script>
		  		  
		   </tr>
	   </table>
	   </td>
	</tr>
</cfoutput>	