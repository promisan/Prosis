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

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfinvoke component="Service.Access"
	Method="Program"
	ProgramCode="#URL.ProgramCode#"
	Period="#URL.Period#"	
	Role="'ProgramOfficer'"	
	ReturnVariable="Access">
	
<cfif access eq "EDIT" or access eq "ALL">
 <cfset url.mode = "Edit">
<cfelse>
 <cfset url.mode = "View"> 
</cfif>

<cfquery name="Roles" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_AuthorizationRole
	  WHERE  Role IN ('BudgetOfficer','ProgramOfficer','ProgressOfficer')	
	</cfquery>

	<cfajaximport tags="cfwindow">
		
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td style="padding:10px">
		<cfinclude template="../Header/ViewHeader.cfm">
		</td>
	</tr>
	
	<tr><td style="padding-left:10px;padding-top:15px">

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	<cfset list = valueList(Roles.Role)>
	<cfset list = replaceNoCase(list,",",":","ALL")> 
				
	<cfloop query="Roles">			
				
		<tr class="linedotted">
		<td align="left" class="labellarge">
		
		<table width="100%"><tr>
		
		   <td class="labelit" width="100" style="height:40px;padding-left:15px"><cf_tl id="Grant access">:</td>
		   <td class="labellarge">			
		
		   <cfif url.mode eq "edit">

		   <font color="gray">
		   
		   <cfset link = "#SESSION.root#/ProgramREM/Application/Program/Authorization/AuthorizationAccess.cfm?mode=edit&programCode=#url.ProgramCode#&list=#list#&box=#role#">
				   
		   <cf_selectlookup
			    class    = "User"
			    box      = "#role#"
				title    = "#Description#"
				link     = "#link#"					
				dbtable  = "ProgramAccessAuthorization"
				des1     = "Account">
				
			</cfif>
				
				</td>
				<td colspan="2" align="right" class="labelit" style="padding-left:10px"><font color="gray">#RoleMemo#</td>
				
				</tr></table>	
					
		</td>
		</tr>			
											
		<tr class="linedotted">
	    <td width="60%" colspan="2" align="right" style="padding-left:40px;padding-right:20px">		
			<cf_securediv bind="url:#SESSION.root#/ProgramREM/Application/Program/Authorization/AuthorizationAccess.cfm?programCode=#url.ProgramCode#&role=#role#&mode=#url.mode#" id="#role#"/>		
		</td>
		</tr>  
				
	</cfloop>		
	
    </table>
	
	</td></tr>
	
 </table>
      
</cfoutput>