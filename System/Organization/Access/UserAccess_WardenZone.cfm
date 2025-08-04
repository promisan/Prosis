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
         	
	<cfif tree eq "1">
	
	 	<cfquery name="AccessList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT R.Code, 
		       R.Description,
		        A.ClassParameter,
				A.RecordStatus, 
				'Manual' as Source,
				AccessLevel, Number
		FROM    Ref_AddressZone R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		  ON    R.Code = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		AND     A.Mission = '#URL.Mission#'			
		</cfif>
		WHERE   R.Mission = '#url.mission#'
		ORDER BY R.Code	
		</cfquery>
	
	<cfelse>
		
	   <cfquery name="AccessList" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT R.Code,
		                R.Description, 
		                A.ClassParameter, 						
						max(A.AccessLevel) as AccessLevel, 
						max(A.RecordStatus) as RecordStatus,
						count(*) as Number
		FROM      Employee.dbo.Ref_AddressZone R LEFT OUTER JOIN OrganizationAuthorization A
		  ON      R.Code = A.ClassParameter 		  
		  AND     A.AccessLevel < '8'
		  AND     ((A.OrgUnit     = '#URL.ID2#') 
		    OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
		    OR (A.OrgUnit is NULL and A.Mission is NULL)) 
		  AND     A.UserAccount = '#URL.ACC#' 
		 
		  AND     A.Role = '#URL.ID#'	
		WHERE  R.Mission = '#url.mission#'  	
		GROUP BY R.Code, R.Description, A.ClassParameter				
		</cfquery>
	
	
	</cfif>
		
	<table width="95%" align="center" cellspacing="0" cellpadding="0">
		    
			<tr>
			<td height="20">Code</td>
			<td>Name</td>
			<cfinclude template="UserAccessSelectLabel.cfm">
			</tr>	
			<tr><td colspan="<cfoutput>#No+3#</cfoutput>" style="border-top:1px dotted gray" height="1"></td></tr>	
		
			<cfif Accesslist.recordcount eq "0">			
			<tr><td colspan="<cfoutput>#No+3#</cfoutput>" height="40" align="center">No access criteria found</td></tr>	
			</cfif>
			
		
		<cfoutput query="AccessList" group="Code">
			
			<cfif source eq "Manual">
			<cfset cl = "ffffff">
			<cfelse>
			<cfset cl = "ffffcf">
			</cfif>
			
			<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
			<tr bgcolor="#cl#">
			  <td>#Code#</td>	
			  <td>#description#</td>
			  <cfset row = currentrow>		
			  <cfinclude template="UserAccessSelect.cfm">		 
			</tr>
			
	    </cfoutput>
	</table>
	<cfset class = AccessList.recordcount>