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
<input type="hidden" name="class" id="class" value="1">
 
<!--- check --->
 
<cfquery name="Check" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT ClaimType 
		 FROM   Ref_ClaimTypeMission 
         WHERE   Mission = '#URL.Mission#'
</cfquery>		 
   
 <cfif tree eq "1">
	
	 <cfquery name="AccessList" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT R.Code, R.Description, A.ClassParameter, A.RecordStatus,
				AccessLevel, Number
		FROM    Ref_ClaimType R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		  ON    R.Code = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		  AND   A.Mission = '#URL.Mission#'		
		</cfif>
		
		<cfif check.recordcount neq "0">
		WHERE   R.Code IN (SELECT ClaimType 
		                     FROM Ref_ClaimTypeMission 
							 WHERE Mission = '#URL.Mission#')
		</cfif>					 
		
		<!--- added in case of claim type mission 
		 WHERE  R.Mission = '#URL.Mission#'
		 --->
	</cfquery>
	
 <cfelse>
   
   <cfquery name="AccessList" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT R.Code, 
		        R.Description,				
				A.ClassParameter, 
				max(A.RecordStatus) as RecordStatus,
				max(A.AccessLevel) as AccessLevel, 
				count(*) as Number
		FROM    Ref_ClaimType R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		  ON    R.Code = A.ClassParameter 
		  AND   A.AccessLevel < '8'
		  AND   ((A.OrgUnit     = '#URL.ID2#') 
			OR   (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
			OR   (A.OrgUnit is NULL and A.Mission is NULL))
		  AND   A.UserAccount = '#URL.Acc#' 
		  AND   A.Role        = '#URL.ID#'
		  
		  <cfif check.recordcount neq "0">
		  WHERE   R.Code IN (SELECT ClaimType 
		                     FROM Ref_ClaimTypeMission 
							 WHERE Mission = '#URL.Mission#')
		  </cfif>					 
		  
		GROUP BY R.Code, R.Description, A.ClassParameter
	</cfquery>
	
</cfif>	
    
	<table width="100%" class="navigation_table">
	<tr>
	<td class="labellarge" height="20">Case Type</td>
	<td></td>
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>	
	<tr><td colspan="<cfoutput>#No+3#</cfoutput>" bgcolor="silver" height="1"></td></tr>	
	<cfoutput query="AccessList">
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
	<tr class="labelmedium navigation_row">
	  <td style="padding-left:4px">#Code# #Description#&nbsp;</td>
	  <td></td>
	  <cfset row = currentrow>		
	  <cfinclude template="UserAccessSelect.cfm">
	</tr>
	</cfoutput>
    </table>
	
	<cfset class = AccessList.recordcount>
	
	
	<cfset ajaxonload("doHighlight")>