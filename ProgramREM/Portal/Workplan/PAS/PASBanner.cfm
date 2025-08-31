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
<cf_dialogStaffing>

<script language="JavaScript">

function home()
 
 {
 <cfif #URL.scope# eq "Hyperlink">
    parent.window.close()
 <cfelse>
    parent.window.location = "../PASView/PASView.cfm?Scope=#URL.scope#&Code=#URL.Code#&ID=PAS&PersonNo=#URL.PersonNo#"
 </cfif>	
 }
 
 function help(fl)
 {
    window.open("<cfoutput>#SESSION.root#</cfoutput>/manual/flash/"+fl,"help")
 }
 
</script>

<cfparam name="URL.ID" default="PAS">

<cfquery name="System" 
datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule = 'Portal'
	AND    FunctionClass = 'SelfService'
	AND    FunctionName = '#URL.ID#' 
</cfquery>

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr class="line">
<td colspan="3" valign="top">

	<cfquery name="Contract" 
	datasource="appsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Contract
	WHERE    ContractId = '#URL.ContractId#'
	</cfquery>
	
	<cfquery name="Employee" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
	    FROM    Person
    	WHERE   PersonNo = '#Contract.PersonNo#'
	</cfquery>
	
	<cfquery name="Issued" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
	    FROM     PersonContract
	    WHERE    PersonNo = '#Contract.PersonNo#'
		AND      ActionStatus  = '1'
		AND      DateEffective <= getDate()
		AND      DateExpiration >= getDate()
		ORDER BY DateEffective DESC
	</cfquery>
	
	<cfif Issued.recordcount eq "0">
		
		<cfquery name="Issued" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 *
		    FROM     PersonContract
		    WHERE    PersonNo = '#Contract.PersonNo#'
			AND      ActionStatus  != '9'		
			ORDER BY DateEffective DESC
		</cfquery>
	
	</cfif>
		
	<cfquery name="Unit" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
	    FROM     PersonAssignment P, Organization.dbo.Organization O
	    WHERE    P.OrgUnit = O.OrgUnit
		AND      P.DateExpiration > getDate()
		AND      P.AssignmentStatus IN ('0','1') 
		AND      P.PersonNo = '#Contract.PersonNo#'
		ORDER BY P.DateEffective DESC 
	</cfquery>
	
	<cfparam name="CLIENT.Category" default="Undefined">

	<table width="100%" style="min-width:850" align="center" cellspacing="0" cellpadding="0">
		
		<tr>
		   <td>		   
		   <table cellspacing="0" cellpadding="0" class="formpadding">
			   <tr class="labelmedium">			  
			   <td height="20" style="padding-left:25px;min-width:100px;padding-right:3px"><b><cf_tl id="Name">:</b></td>
			   <td><A HREF ="javascript:EditPerson('#Employee.PersonNo#')" title="Profile">#Employee.FirstName# #Employee.LastName#</a></td>			
			   <td style="padding-left:25px;min-width:100px;padding-right:3px"><b><cfoutput>#client.IndexNoName#:</cfoutput></b></td>
			   <td>#Employee.IndexNo#</td>			  
			   <td style="padding-left:25px;min-width:60px;padding-right:3px"><b><cf_tl id="Grade">:</td>
			   <td style="padding-right:6px">#Issued.ContractLevel# / #Issued.ContractStep# <!--- <cfif SPA.recordcount gte "1">(#SPA.PostAdjustmentLevel#)</cfif> ---></td>
			   <td style="padding-left:25px;min-width:60px;padding-right:3px"><b><cf_tl id="Office">:</td>
			   <td style="padding-right:6px"><cfif Unit.OrgUnitName eq "">-<cfelse>#Unit.Mission#&nbsp;-&nbsp;#Unit.OrgUnitNameShort#</cfif></td>
			   <td style="padding-left:25px;min-width:60px;padding-right:3px"><b><cf_tl id="Period">:</td>
			   <td style="padding-right:6px">#dateFormat(Contract.DateEffective, CLIENT.DateFormatShow)# - #dateFormat(Contract.DateExpiration, CLIENT.DateFormatShow)# (#Contract.ContractNo#)</td>			  
			   </tr>
		   </table>
		   </td>
		</tr>
		
	</table>
			
	</td>
</tr>

</table>

</cfoutput>
