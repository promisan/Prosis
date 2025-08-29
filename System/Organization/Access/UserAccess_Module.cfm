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
	<cfif tree eq "1">
	
	 	<cfquery name="AccessList" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT R.SystemMode, 
		       R.Description,
		        A.ClassParameter,
				A.RecordStatus, 
				'Manual' as Source,
				AccessLevel, Number
		FROM    Ref_SystemModule R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		  ON    R.SystemModule = A.ClassParameter  AND  R.MenuOrder < '90'
		<cfif Role.GrantAllTrees eq "0">
		AND     A.Mission = '#URL.Mission#'	
		</cfif>
		 AND  R.Operational = 1
		 WHERE  R.MenuOrder < '90'  
		ORDER BY R.MenuOrder
		</cfquery>
	
	<cfelse>
		
	   <cfquery name="AccessList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT R.SystemModule, 
		                R.Description,
						R.MenuOrder,	
		                A.ClassParameter, 						
						max(A.AccessLevel) as AccessLevel, 
						max(A.RecordStatus) as RecordStatus,
						count(*) as Number
		FROM      System.dbo.Ref_SystemModule R LEFT OUTER JOIN OrganizationAuthorization A
		  ON      R.SystemModule = A.ClassParameter 
		  AND     A.AccessLevel < '8'
		  AND     ((A.OrgUnit     = '#URL.ID2#') 
		    OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
		    OR (A.OrgUnit is NULL and A.Mission is NULL)) 
		  AND     A.UserAccount = '#URL.ACC#' 
		  AND     A.Role = '#URL.ID#'		
		  AND  R.Operational = 1
		  WHERE  R.MenuOrder < '90'  
		GROUP BY R.MenuOrder, R.SystemModule, A.ClassParameter, R.Description		
		ORDER BY R.MenuOrder		
		</cfquery>
	
	
	</cfif>
		
	<table width="95%" align="center" cellspacing="0" cellpadding="0">
		    
			<tr class="labelmedium line">
			<td height="20"><cf_tl id="Module"></td>
			<cfinclude template="UserAccessSelectLabel.cfm">
			</tr>	
			
			<cfoutput query="AccessList" group="SystemModule">
				
				<cfif source eq "Manual">
				<cfset cl = "ffffff">
				<cfelse>
				<cfset cl = "ffffcf">
				</cfif>
				
				<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#SystemModule#">
				<tr bgcolor="#cl#"  class="labelmedium line">
				  <td style="padding-left:4px">#Description#</td>	
				  <cfset row = currentrow>		
				  <cfinclude template="UserAccessSelect.cfm">		 
				</tr>
				
		    </cfoutput>
		
	</table>
	
	<cfset class = AccessList.recordcount>