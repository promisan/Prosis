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
		SELECT  R.Code, 
		        A.ClassParameter, 
				A.RecordStatus, 
				AccessLevel, Number
		FROM    Ref_AuthorizationRoleOwner R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		 ON     R.Code = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		AND     A.Mission = '#URL.Mission#'		
		</cfif>
		</cfquery>
	
	<cfelse>
	
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#TreeAccess2">			
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#TreeAccess1">	

		<cfquery name="AccessList" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		<!--- set base --->
		SELECT * 
		INTO    userQuery.dbo.#SESSION.acc#TreeAccess1
		FROM    OrganizationAuthorization A
		WHERE   A.UserAccount = '#URL.ACC#' 
		AND     A.Role        = '#URL.ID#'
		AND     A.AccessLevel < '8'
		AND     ((A.OrgUnit   = '#URL.ID2#') 
		   OR (A.OrgUnit is NULL  <!--- removed for new mission provision  and A.Mission = '#URL.Mission#' --->)
		   OR (A.OrgUnit is NULL and A.Mission is NULL)
		        ) 
		</cfquery>
		
		<!--- this is the actual base --->
		
		<cfquery name="AccessBase" 
		datasource="AppsSelection"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT S.Owner AS Code, O.OccupationalGroup, O.Description
		INTO   userQuery.dbo.#SESSION.acc#TreeAccess2
		FROM   FunctionOrganization F INNER JOIN
               Ref_SubmissionEdition S ON F.SubmissionEdition = S.SubmissionEdition INNER JOIN
               FunctionTitle FT ON F.FunctionNo = FT.FunctionNo INNER JOIN
               OccGroup O ON FT.OccupationalGroup = O.OccupationalGroup
		<cfif SESSION.isAdministrator eq "No">
		WHERE S.Owner IN (SELECT ClassParameter 
		                  FROM   Organization.dbo.OrganizationAuthorization 
						  WHERE  UserAccount  = '#SESSION.acc#' 
						  AND    Role = 'AdminUser')	
		
		</cfif>					  
		ORDER BY Code, O.Description						 	
		</cfquery>
		
		<cfquery name="AccessList" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT B.Code, 
		         B.OccupationalGroup, 
				 B.Description, 
				 A.Mission,
		         max(A.AccessLevel) as AccessLevel, 
				 max(A.RecordStatus) as RecordStatus,
				 count(*) as Number
		FROM     userQuery.dbo.#SESSION.acc#TreeAccess2 B LEFT OUTER JOIN		        
				 userQuery.dbo.#SESSION.acc#TreeAccess1 A ON B.Code = A.ClassParameter AND B.OccupationalGroup = A.GroupParameter 
		GROUP BY B.Code, B.OccupationalGroup, B.Description, A.Mission
		ORDER BY  B.Code, B.Description
		</cfquery>
	
	</cfif>
	
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#TreeAccess2">			
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#TreeAccess1">			
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	<tr class="line">
	<td height="20" colspan="labelmedium"><cf_tl id="Owner"></td>
	<td></td>	
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>
		
	<cfoutput query="AccessList" group="Code">
	<tr class="line">
	  <td height="20" style="padding-left:10px"><b>#Code#</b></td>
	  <td colspan="5"></td>	
	</tr>
	
	<cfoutput>
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
	<input type="hidden" name="#ms#_groupparameter_#CurrentRow#" id="#ms#_groupparameter_#CurrentRow#" value="#OccupationalGroup#">
			
	<tr class="labelmedium line">
	  <td colspan="2" style="padding-left:20px" width="30%">#Description#</td>	  
	   <cfset row = currentrow>		
	   <cfinclude template="UserAccessSelect.cfm">	  
	</tr>	
	
	</cfoutput>	
	</cfoutput>
    </table>
	
	<cfset class = AccessList.recordcount>