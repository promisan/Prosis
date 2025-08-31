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
  <input type="hidden" name="class" id="class" value="1">
    
  <cfif tree eq "1">
  	
	 <cfquery name="AccessList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT R.Code, R.Description,
		        A.ClassParameter, 
				A.RecordStatus, 
				AccessLevel, Number
		FROM    Materials.dbo.Ref_WarehouseLocationClass R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		 ON     R.Code = A.ClassParameter 
			<cfif Role.GrantAllTrees eq "0">		
			AND     A.Mission = '#URL.Mission#'		
			</cfif>
		
		<cfif SESSION.isAdministrator eq "No">
		   WHERE    R.Code IN (SELECT DISTINCT ClassParameter 
					          FROM   OrganizationAuthorization
						      WHERE  Role = 'AdminUser'
						      AND    UserAccount = '#SESSION.acc#')
		<cfelse>
		
		<cfif url.id eq "OrgUnitManager">
		<!--- filter for only the owner of the mission --->
			WHERE R.Code IN (SELECT MissionOwner
		               FROM Ref_Mission 
					   WHERE Mission = '#URL.Mission#') 
		</cfif>	
		
		</cfif>
		
		</cfquery>
				
	<cfelse>

		<cfquery name="AccessList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT R.Code, R.Description, 
		         A.ClassParameter, 
				 MAX(A.AccessLevel) as AccessLevel, 
				 MAX(A.RecordStatus) as RecordStatus,
				 COUNT(*) as Number
		FROM     Materials.dbo.Ref_WarehouseLocationClass R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		 ON      R.Code = A.ClassParameter 
						AND     A.AccessLevel < '8'
						AND     ((A.OrgUnit     = '#URL.ID2#') 
						   OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
						   OR (A.OrgUnit is NULL and A.Mission is NULL))
						AND     A.UserAccount = '#URL.ACC#' 
						AND     A.Role = '#URL.ID#'
		
		<cfif SESSION.isAdministrator eq "No">
		  WHERE   R.Code IN (SELECT DISTINCT ClassParameter 
					          FROM   OrganizationAuthorization
						      WHERE  Role        = 'AdminUser'
						      AND    UserAccount = '#SESSION.acc#') 
		</cfif>			
		GROUP BY  R.Code, R.Description, A.ClassParameter 
		</cfquery>
	
	</cfif>
	
	<table width="96%" border="0" cellspacing="0" cellpadding="0" align="right" class="formpadding">
	
		<tr class="line">
		<td height="20" class="labelmedium"><cf_tl id="Code"></td>
		<cfinclude template="UserAccessSelectLabel.cfm">
		</tr>		
			
		<cfoutput query="AccessList">
		<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
		<tr class="line labelmedium">
		  <td style="padding-left:20px">#Description#</td>
		  <cfset row = currentrow>		
		  <cfinclude template="UserAccessSelect.cfm">	 
		</tr>
		</cfoutput>	
	
    </table>
	
	<cfset class = AccessList.recordcount>