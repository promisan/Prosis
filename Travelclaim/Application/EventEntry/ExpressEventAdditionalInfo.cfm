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
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Dev van Pelt</proOwn>
	<proDes></proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	This template is the is the main template for view only purposes of the additional information. 
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<cfset header = "ffffff">

<cfquery name="ClaimTitle" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT C.*, 
	       R.PointerStatus, 
		   R.Description as StatusDescription, 
		   P.Description as Purpose,
		   Org.OrgUnitName
	FROM   ClaimRequest C, 
	       Ref_Status R, 
		   Ref_ClaimPurpose P,
		   Organization.dbo.Organization Org
	WHERE  ClaimRequestId = '#Claim.ClaimRequestId#'
	AND C.ActionStatus *= R.Status
	AND C.ActionPurpose *= P.Code
	AND C.OrgUnit *= Org.OrgUnit 
	AND R.StatusClass = 'ClaimRequest'
</cfquery>

<cfoutput>

<tr><td height="6"></td></tr>
	<tr><td colspan="9" height="30">
		<cf_summaryheader name="Additional Information">
	</td></tr>

<font color="E9ECF5"></font>
<cfset topic = "E9ECF5">

<cfinclude template="../Inquiry/eMail/eMail.cfm">
 
		<!---
<tr><td colspan="8">

	<table width="97%" align="center" border="0" cellspacing="1" cellpadding="1" bordercolor="eaeaea">
	
	<tr bgcolor="#header#">
		<td colspan="2">
		<table cellspacing="0" cellpadding="0">
		<tr>
		  <td width="30" align="center"><img src="#SESSION.root#/images/bullet.gif" alt="Travel Advance" border="0" align="absmiddle"></td>
		  <td><font face="Verdana">Travel Advance&nbsp;</td>
		</tr>
		</table>
		</td>
		
	</tr>
			 
	<tr>	
		<td width="100%">
		<table width="93%" align="right" cellspacing="0" cellpadding="0">
			<tr><td>
				<cfinclude template="../ClaimEntry/ClaimAdvance.cfm">
			</td></tr>	
						
		</table>
		</td>
	</tr>
	
	<cfif len(claim.remarks) gte "10">
	
	<tr bgcolor="#header#">
		<td colspan="2">
		<table cellspacing="0" cellpadding="0">
		<tr>
		  <td width="30" align="center"><img src="#SESSION.root#/images/bullet.gif" alt="Remarks" border="0" align="absmiddle"></td>
		  <td><font face="Verdana">Remarks:&nbsp;</td>
		</tr>
		</table>
		</td>
		
	</tr>
		
	<tr><td><table width="100%" cellspacing="0" cellpadding="0">
	    <tr><td width="30"></td>
		<td bgcolor="FfFfFf">
		<table width="100%" cellspacing="2" cellpadding="2" style="border: 1px solid Silver;"><tr><td>
		#claim.remarks#		
		</td></tr>		
		<tr><td height="1" bgcolor="C0C0C0"></td></tr>
		 <tr><td colspan="1" align="center">
	 	<img src="#SESSION.root#/images/finger.gif" alt="" border="0" align="absmiddle">
		<font color="3388aa"><b>Attention</b>: You entered remarks so this claim will be sent to EO/Substantive office for additional review</font>		
	     </td></tr>
		 </table>
		</td></tr>
		
		</table>
	</td></tr>	
			
	</cfif>
	--->
	<tr bgcolor="#header#">
		<td colspan="4">
		<table cellspacing="0" cellpadding="0">
		<tr>
		  <td width="30" align="center"><img src="#SESSION.root#/images/bullet.gif" alt="Remarks" border="0" align="absmiddle"></td>
		  <td><font face="Verdana">Attachments:</td>
		</tr>
		</table>
		</td>
		
	</tr>
		
	<tr><td>
		    <cfset url.mode = "Inquiry">
		    <cfinclude template="ClaimEventAdditionalAttachment.cfm">		
	</td></tr>	
	
	<cfquery name="Payment" 
	   datasource="appsTravelClaim" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			SELECT *
		    FROM Ref_PaymentMode
			WHERE Code = '#Claim.PaymentMode#'
    </cfquery>
	
	<tr bgcolor="#header#">
		<td colspan="2">
		<table cellspacing="0" cellpadding="0">
		<tr>
		  <td width="30" align="center"><img src="#SESSION.root#/images/bullet.gif" alt="Mode of payment" border="0" align="absmiddle"></td>
		  <td width="200"><font face="Verdana">Payment&nbsp;Instructions:<b>&nbsp; </td>
		  <td><cfif Payment.Description eq "">Undefined<cfelse>#Payment.Description#</cfif>&nbsp;[#Claim.PaymentCurrency#]</td>
		</tr>
		</table>
		</td>
		
	</tr>
		
	<tr bgcolor="#header#">
		<td colspan="2" height="23">
		<table cellspacing="0" cellpadding="0">
		  <tr>
		  <td width="30" align="center"><img src="#SESSION.root#/images/bullet.gif" alt="EMail address" border="0" align="absmiddle"></td>
		  <td width="200"><font face="Verdana">Correspondence to:</td>
		  <td><b>#mail#</b>&nbsp;</td>
		  </tr>		 
		 </table>
		</td>
	</tr>	
				
	</table>
	
</td>
</tr>	
	
</cfoutput>