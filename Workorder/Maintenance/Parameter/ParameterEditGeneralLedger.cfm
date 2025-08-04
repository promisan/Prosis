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

<cfparam name="URL.ID1" default="">

<cfif url.id1 eq "">
	<cfset vMission = MissionList.Mission>
<cfelse>
	<cfset vMission = url.id1>
</cfif>

<cfquery name="Area" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_AreaGLedger		
		ORDER BY ListingOrder
</cfquery>

<cfquery name="GetLedger" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ParameterMissionGLedger
		WHERE	Mission = '#vMission#'
</cfquery>

<cfset areaList = "#valuelist(area.area)#">

<table class="hide">
	<tr><td><iframe name="processParameterEditGeneralLedgerSubmit" id="processParameterEditGeneralLedgerSubmit" frameborder="0"></iframe></td></tr>
</table>

<cfform method="POST" name="formWorkOrderReq" action="ParameterEditGeneralLedgerSubmit.cfm?id1=#vMission#" target="processParameterEditGeneralLedgerSubmit">

	<table width="95%" class="formpadding" cellspacing="0" cellpadding="0" align="center">
		
		<input name="mission" id="mission" type="Hidden" value="#mission#">
		<tr><td height="10"></td></tr>			
		
		<tr>
			<td width="10%" class="labelmedium"><cf_tl id="Area"></td>
			<td class="labelmedium"><cf_tl id="GL Account"></td>
		</tr>
		
		<tr><td height="5"></td></tr>
		
		<tr class="hide"><td id="process" colspan="2" class="line"></td></tr>
		
		<tr><td height="5"></td></tr>
		
		<cfloop index="vArea" list="#areaList#" delimiters=",">
		
			<TR>
		    <td class="labelmedium" width="10%"><cf_tl id="#vArea#">:</td>
		    <TD width="85%">
				<cfquery name="qGet" dbtype="query">
					SELECT	*
					FROM 	GetLedger
					WHERE	Mission = '#vMission#'
					AND 	Area = '#vArea#'
				</cfquery>	
				
				<cfquery name="GetAccount" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	*
						FROM	Ref_Account
						WHERE	GLAccount = '#qGet.GLAccount#'
				</cfquery>
				
				<table class="formspacing">
					<tr>
					
					<cfoutput>
					<td>
					<input type="text" name="glaccount_#vArea#"     id="glaccount_#vArea#"      value="#GetAccount.glaccount#"      size="5"  readonly class="regularxl clsGLAccount_#vArea#">
					</td>
					<td>
		    	    <input type="text" name="gldescription_#vArea#" id="gldescription_#vArea#"  value="#GetAccount.description#"    size="45" readonly class="regularxl clsGLAccount_#vArea#">
					</td>
					<td>
				    <input type="text" name="debitcredit_#vArea#"   id="debitcredit_#vArea#"    value="#GetAccount.accounttype#"    size="3"  readonly class="regularxl clsGLAccount_#vArea#">
					</td>
					
					<td style="padding-left:4px">	
						
					    <cf_tl id="Select account" var="vSelAcc">
					    <img src="#SESSION.root#/Images/contract.gif" title="#vSelAcc#" 
						  onMouseOver="this.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="this.src='#SESSION.root#/Images/contract.gif'"
						  style="cursor: pointer;" width="16" height="18" border="0" align="absmiddle" 
						  onClick="selectaccountgl('#vMission#','','','','applyaccount','#vArea#');">
					</td>
					
					<td style="padding-left:4px">
					    <cf_tl id="Clear account" var="vSelRem">
					    <img src="#SESSION.root#/Images/delete5.gif" title="#vSelRem#" 
					      style="cursor: pointer;" width="16" height="18" border="0" align="absmiddle" 
					      onClick="$('.clsGLAccount_#vArea#').val('');">
					 </td>
				 </tr>
				 </table>
			  
			  	</cfoutput>
			   </td>
		    </tr>
		
		</cfloop>
			
		<tr><td height="5"></td></tr>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr><td height="5"></td></tr>
		
		<tr>
			<td colspan="2" align="center">
				<cf_tl id="Save" var="vSave">
				<cf_tl id="Changing this parameters will affect the functioning of the system, do you want to continue ?" var="vConfirm">
				
				<cfinput type="Submit" 
				       class="button10g" 
					   style="width:100"
					   value="#vSave#"
				       name="Update" 
					   onclick="if (confirm('#vConfirm#')) { return true } return false">
			</td>
		</tr>
			
	</table>
	
</cfform>	