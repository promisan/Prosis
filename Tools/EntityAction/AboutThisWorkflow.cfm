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
<cfquery name="Object" 
datasource="AppsOrganization"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     OrganizationObject
	WHERE    ObjectId = '#url.ObjectId#' 	
</cfquery>		

<table width="100%" height="100%">
<tr>
	<td bgcolor="f9f9f9" valign="top" style="padding-top:4px">
	
	<cfoutput>
	
	<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		<tr class="line labelmedium"><td style="padding:3px;min-width:150" width="100"><cf_tl id="Entity">:</td>
		    <td colspan="2" width="76%" style="background-color:C6F2E2;padding-left:4px">#Object.Mission#</td>
		</tr>		
		
		<cfif Object.OrgUnit neq "">
		
			<cfquery name="Unit" 
			datasource="AppsOrganization"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Organization
				WHERE    OrgUnit = '#Object.OrgUnit#' 	
			</cfquery>		
			
			
			<tr class="line labelmedium"><td style="padding:3px" width="100"><cf_tl id="Unit">:</td>
			    <td width="76%" style="background-color:C6F2E2;padding-left:4px" id="orgunit_#Object.objectid#">#Unit.OrgUnitName#</td>
				
				<cfif getAdministrator(Object.mission) eq "1">	
						 	
					 <td style="padding-right:1px">		
						 			 
			     		<img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
							  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
							  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
							  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
							  onClick="selectorgN('#Object.mission#','','#Object.objectid#','setwforgunit','orgunit_#Object.objectid#','1','modal')">
								  
	             		</td>						
										 
					
			</cfif>			
				
			</tr>	
			
		</cfif>	
		
		<cfif Object.PersonNo neq "">
		
			<cfquery name="Person" 
			datasource="AppsEmployee"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Person
				WHERE    PersonNo = '#Object.PersonNo#' 	
			</cfquery>		
				
		<tr class="line labelmedium"><td style="padding:3px"><cf_tl id="Staff">:</td>		
		    <td colspan="2" style="background-color:C6F2E2;padding-left:4px">#Person.FirstName# #Person.LastName#</td>
		</tr>
		
		</cfif>
		
		<tr class="line labelmedium"><td style="padding:3px">Owner:</td>		
		    <td colspan="2" style="background-color:C6F2E2;padding-left:4px">#Object.OfficerFirstName# #Object.OfficerLastName#</td>
		</tr>
				
		<cfquery name="Entity" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_Entity
			WHERE    EntityCode = '#Object.EntityCode#' 	
		</cfquery>
				
		<tr class="line labelmedium"><td style="padding:3px">Object:</td>
		    <td colspan="2" style="background-color:C6F2E2;padding-left:4px">#Entity.EntityDescription#</td>
		</tr>
				
		<cfquery name="Class" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_EntityClass
			WHERE    EntityCode  = '#Object.EntityCode#' 	
			AND      EntityClass = '#Object.EntityClass#' 	
		</cfquery>
		
		<tr class="line labelmedium"><td style="padding:3px"><cf_tl id="Workflow">:</td>
		    <td colspan="2" style="background-color:C6F2E2;padding-left:4px">#Class.EntityClassName#</td>
		</tr>
				
		<tr class="line labelmedium"><td style="padding:3px"><cf_tl id="Initiated"></td>
		    <td colspan="2" style="background-color:C6F2E2;padding-left:4px">#DateFormat(Object.Created,CLIENT.DateFormatShow)#</td>
		</tr>
				
		<cfquery name="getProgram" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Program.dbo.Program
			WHERE    ProgramCode  = '#Object.ProgramCode#' 					
		</cfquery>
		
		<tr class="labelmedium"><td style="padding:3px"><cf_tl id="Project / Component"></td>
		    <td colspan="2" style="background-color:C6F2E2;padding-left:4px"><cfif getProgram.recordcount eq "1">#getProgram.ProgramName#<cfelse>N/A</cfif></td>
		</tr>
			
	</table>
	
	</cfoutput>
	
	</td>
</tr>
</table>