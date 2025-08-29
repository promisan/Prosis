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
<cfparam name="client.category" default="_">

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT C.*, D.DocumentNo as RequestNo
    FROM Claim C, ClaimRequest D
    WHERE ClaimId        = '#URL.ClaimId#' 
	AND C.ClaimRequestId = D.ClaimRequestId
</cfquery>

<cfoutput>

	   <table width="100%" height="22" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" rules="rows">
	   	   
		<cfquery name="Employee" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		    FROM stPerson
		    WHERE PersonNo = '#Claim.PersonNo#' 
		</cfquery>
	   
		<tr bgcolor="f0f0f0">
		    <td width="27" align="center">
							
			   </td>
			   <td height="22" width="80"><b>Name:</b></td>
			   <td width="20%">
			   <A HREF ="javascript:EditPerson('#Employee.PersonNo#')" title="Profile">#Employee.FirstName# #Employee.LastName#</a></td>
			   <td width="80"><b>Index No:</b></td>
			   <td width="20%">#Employee.IndexNo#</td>
			   <td><b>Category:</td>
			   <td>#client.category#&nbsp;</td>
		</tr>
		
			 <tr><td height="1" colspan="7" bgcolor="silver"></td></tr>
		 	   
		  <tr bgcolor="ffffff">
		   
			   <td height="20" width="1%">&nbsp;</td>
			   <td width="150"><b>Travel&nbsp;Request&nbsp;No:&nbsp;</b></td>
			   <td width="15%">TVRQ - #Claim.RequestNo#</td>
			   <td width="130"><b>Travel&nbsp;Claim&nbsp;No:&nbsp;</b></td>
			   <td width="25%"><cfif #Claim.Reference# neq "">#Claim.Reference# #Claim.ReferenceNo#<cfelse>Not assigned</cfif></td>
			   <td width="80"><b>Date:</b></td>
			   <td width="20%">#DateFormat(Claim.ClaimDate, CLIENT.DateFormatShow)#
			  			  		   
			   <script language="JavaScript">
			   function goback()
			   {
				window.location = "#SESSION.root#/Payroll/Application/Claim/ClaimEntry/ClaimEntry.cfm?ClaimId=#URL.ClaimId#&RequestId=#Claim.ClaimRequestId#&PersonNo=#Claim.PersonNo#"
			   }	
	          </script>
		  		  
		   </tr>
		   
		   <tr><td height="1" colspan="7" bgcolor="silver"></td></tr>
		   
		   
	   </table>
	   
	  
</cfoutput>	