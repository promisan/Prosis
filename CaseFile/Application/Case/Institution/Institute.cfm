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
<cfquery name="Claim" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Claim
			WHERE ClaimId = '#URL.claimid#'	
</cfquery>


<cfquery name="Insert" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ClaimOrganization 
                (ClaimId, ClaimRole, OfficerUserId, OfficerLastName, OfficerFirstName)
	SELECT      '#url.claimid#', ClaimRole, '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#'
	FROM        Ref_ClaimRole
	WHERE       ClaimType = '#Claim.ClaimType#' 
	AND         ClaimRole NOT IN
                          (SELECT     ClaimRole
                            FROM          ClaimOrganization
							WHERE ClaimId = '#URL.ClaimId#')
</cfquery>							
    
<cfquery name="Parameter" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_ParameterMission
		WHERE Mission = '#Claim.Mission#'	
</cfquery>		
		
<cfquery name="Get" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     R.ClaimRole, R.OrgUnitClass, R.Description, O.OrgUnitName, C.*
	FROM       ClaimOrganization C INNER JOIN
               Ref_ClaimRole R ON C.ClaimRole = R.ClaimRole LEFT OUTER JOIN
               Organization.dbo.Organization O ON C.OrgUnit = O.OrgUnit
	WHERE      C.ClaimId = '#URL.ClaimId#'	
	ORDER BY ListingOrder	   
</cfquery>	
		
<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<cfform>


<tr><td height="5"></td></tr>

<tr><td colspan="5" class="labelmedium"><font size="2" color="FF8000"><b><cf_tl id="Attention">:</b> <cf_tl id="any changes on this tab are immediately posted">.</td></tr>

<tr><td height="5"></td></tr>

<cfinvoke component="Service.Access"  
     method="CasefileManager" 
     mission="#Claim.Mission#" 
	 claimtype="#claim.claimtype#"
     returnvariable="access">
 			
		<cfoutput query="Get">																								
					
			<cfset org = orgunit>
					
			<TR>
			   <td width="20" class="labelit">#currentrow#.</td>
			   <td width="140" height="20" class="labelit">#Description#:</b></td>
			   <td width="50%" class="labelit">
			   
			     <cfif orgunitclass neq "Contact">
				   				   
				   	   <cfquery name="Select" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  *
								FROM    Organization 
								WHERE   Mission = '#Claim.Mission#'	
								AND     OrgUnitClass = '#OrgUnitClass#'
					   </cfquery>
				   
					   <cfif Access eq "EDIT" or Access eq "ALL">	
					   				 
						 <select name="OrgUnit_#ClaimRole#" 
						     onchange="getunit('#claimrole#',this.value)">
						     <option value="" selected>[select]</option>
							 <cfloop query="Select">
							 	<option value="#OrgUnit#" <cfif orgunit eq org>selected</cfif>>#OrgUnitName#</option>
							 </cfloop>					 
						 </select>
						 					 
					   <cfelse>			   
						   #OrgUnitName#
					   </cfif>	
					   					   
					   <cfset p = ClaimRole>								
										  				   
				 <cfelse>								   
				 				 				   
				     <cfif Access eq "EDIT" or Access eq "ALL">	
					 									
					 	<cfselect name="OrgUnit_#ClaimRole#"
							onchange="getunit('#claimrole#',this.value)"	
							bindOnLoad="yes"
							bind="cfc:service.Input.InputDropdown.DropdownSelect('AppsOrganization','Organization','OrgUnit','HierarchyCode','OrgUnitName','','','Mission','#Claim.Mission#','ParentOrgUnit',{OrgUnit_#p#},'#orgunit#')">				
					    </cfselect>
																					 					 
					   <cfelse>			   
						   #OrgUnitName#
					   </cfif>			   
								   
				 </cfif>
				   
				   
			   </td>
			   <td class="labelit">#OfficerFirstName# #OfficerLastName#</td>	
			   <td class="labelit">#dateformat(created,CLIENT.DateFormatShow)#</td>				  	
			</tr>
			
			<tr><td colspan="5">
			
			<!--- &addresstype=#Parameter.addresstype# --->
			
			<cfdiv bind="url:#SESSION.root#/System/Organization/Application/Address/UnitAddressInfo.cfm?orgunit=#orgunit#" 
			       id="a#claimrole#">
				   
			</td>
			</tr>
			
			<tr><td colspan="5" class="linedotted"></td></tr>
					
		</cfoutput>											
</cfform>		

</table>
