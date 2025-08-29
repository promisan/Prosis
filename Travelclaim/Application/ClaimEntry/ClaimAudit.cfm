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
<!------------------------------------------------------------------------ Modification  Details ----------------------------------
				Date: 		08/08/2010
				By: 		Joseph George
				Detail:     Add a help icon indicator next to the validation message to display further help information  
							if the validation starts with E,V or R. 
							08/08/2010. Further edited the validation messages to point to their respective messages instead of the generic one.
------------------------------------------------------------------------------------------------------------------------------------>

<cfparam name="ProcessWF" default="0">

	<table width="98%" border="0" cellspacing="0" cellpadding="1" align="center">
	
	
	<!---
	<cfsilent> 
	<cfif ProcessWF eq "1" or calc.recordcount eq "0" and claim.actionStatus lte "2">

		<cfset reload = "No">
		<cfset progress = "0">
		<cfinclude template="../Process/Calculation/Calculate.cfm">		

	</cfif>	
	</cfsilent>	 
	---->
	
	
	<cfquery name="ClaimAudit" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT ADT.*,CL.documentno as claimtcpno
			 FROM   ClaimAudit ADT,claim CL
			 WHERE 			CL.ClaimId = '#ClaimId#' 
			 and ADT.claimid =CL.claimid	
	</cfquery>
	<cfoutput >
	<!---
	<cfif (Claim.ActionStatus gte "2" and Claim.ActionStatus lte "5") or Parameter.ShowValidationUser eq "1" or SESSION.isAdministrator eq "Yes">
	--->
 
	<cfif ClaimAudit.recordcount gte "0" or (SESSION.isAdministrator eq "Yes" and claim.actionStatus neq "6")>
	<!---
   <tr><td height="3"></td></tr>
	<tr>
		<td colspan="2" align="center">
		<font face="Verdana" color="FF8040">&nbsp;Claim Audited </b> <cfoutput>(last validation : #dateformat(ClaimAudit.updated,CLIENT.DateFormatShow)# #timeformat(ClaimAudit.updated,"HH:MM")#)</cfoutput></b></td>
		<cfoutput query="ClaimAudit">
		 <td> #claimidauditid#</td>
		 <cfset cde = "#claimtcpno#">
		 <td> #cde#</td>
		</cfoutput>
		</td>
	</tr>
	--->
	
 
								<cfset cde = "#claimid#">
	
								<cfquery name="Actor"
								datasource="AppsTravelClaim" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
		  
								SELECT CL.ClaimidAuditid, CL.seq_num, CL.Comments, CL.Description, CL.Supp_Tvcv_num, 
								CL.created, CL.updated, CL.userid, CL.addt_amount,
								CL.Supp_rec_num ,HDR.claimid,HDR.TCP_Documentno,HDR.f_tvrq_doc_id,HDR.Audit_status
								FROM ClaimAuditline CL,ClaimAudit HDR
								where HDR.ClaimidAuditid =CL.ClaimidAuditid
								and  HDR.claimid ='#ClaimId#' 
								ORDER BY seq_num desc
							</cfquery>
							<tr>
							<td width="4%">
		
		   <cfif actor.recordcount gte "1">
		
			   <img src="#SESSION.root#/Images/icon_expand.gif" 
				alt="Show how this validation rule enforces intervention"  
				id="#cde#Exp" border="0" class="regular" 
				align="absmiddle" style="cursor: hand;" 
				onClick="javascript:showaudit1('#cde#')">
					
					
				<img src="#SESSION.root#/Images/icon_collapse.gif" 
				id="#cde#Col" 
				alt="Hide"  border="0" 
				align="absmiddle" class="hide" style="cursor: hand;" 
				onClick="javascript:showaudit1('#cde#')">
			<td> &nbsp;<b>Audit History</b></td>&nbsp;
		   </cfif>	
				
		</td>
		</tr>
		<tr id="#cde#" class="hide" bgcolor="ffffcf">
		<td width="100"><b>Audited</b></td
		></tr>
		<tr id="#cde#" class="hide" bgcolor="ffffcf">
		<td width="80"></td>
		<td width="100"><b>Comments</b></b></td>
		<!---
		<td width="100"><b>Description</b></td>
		<td></td>
		--->
		
		<td width="100"><b>TVCV Number</b></td>
		<td width="100"><b>RCVH Number</b></td>
		<td width="100"><b>Addt Amount</b></td>
		<td width="100"><b>Date Created</b></td>
		<td width="100"><b>User ID</b></td>
		<tr><td height="1" colspan="9" bgcolor="e4e4e4"></td></tr>
		</tr>
		<!--- JG added this for audit --->

		<cfloop query="Actor">

		<tr id="#cde#" class="hide" bgcolor="ffffcf">
		    <td colspan =2>
		   
		   #comments# 
		  
		   </td>
		   <!---
		   <td colspan=2 >
		    #Description#
		   </td>
		   --->
		  
		   
		   <td>
		    #Supp_Tvcv_num#
		   
		   </td>
		   <td>
		    #Supp_rec_num#
		    </td>
			<td>
		    #addt_amount#
		    </td>
		    <td >
		    #DateFormat(created)#
		      </td>
		   <td>
		    #userid#
		    </td>
			
		</tr>
		<tr><td height="1" colspan="9" bgcolor="e4e4e4"></td></tr>
		
		</cfloop>
		
		<!--- JG added this for audit --->

   </cfif>
	</cfoutput>
  </table>
   </HTML></HEAD>
  	