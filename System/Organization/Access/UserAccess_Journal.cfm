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
  
 <cfif tree eq "1">
	
	 <cfquery name="AccessList" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT R.Journal, R.Description,R.Currency, A.ClassParameter, A.RecordStatus,
				AccessLevel, Number
		FROM    Journal R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		  ON    R.Journal = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		  AND   A.Mission = '#URL.Mission#'		
		</cfif>
		 WHERE  R.Mission = '#URL.Mission#'
	</cfquery>
	
 <cfelse>
   
   <cfquery name="AccessList" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT R.Journal, 
		        R.Description,
				R.Currency, 
				A.ClassParameter, 
				max(A.RecordStatus) as RecordStatus,
				max(A.AccessLevel) as AccessLevel, 
				count(*) as Number
		FROM    Journal R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		  ON    R.Journal = A.ClassParameter 
		  AND   A.AccessLevel < '8'
		  AND   ((A.OrgUnit     = '#URL.ID2#') 
			OR   (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
			OR   (A.OrgUnit is NULL and A.Mission is NULL))
		  AND   A.UserAccount = '#URL.Acc#' 
		  AND   A.Role        = '#URL.ID#'
		  WHERE   R.Mission = '#URL.Mission#'
		GROUP BY R.Journal, R.Description, R.Currency,A.ClassParameter
	</cfquery>
	
</cfif>	
    
	<table width="100%" class="formpadding">
	<tr class="labelmedium line">
	<td height="20"><cf_tl id="Journal"></td>
	<td><cfinclude template="UserAccessSelectLabel.cfm"></td>
	</tr>		
	<cfoutput query="AccessList">
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Journal#">
	<tr class="labelmedium line">
	  <td style="padding-left:4px">#Journal# #Description#</td>
	  <td style="padding-left:4px">#Currency#</td>
	  <cfset row = currentrow>		
	  <cfinclude template="UserAccessSelect.cfm">
	</tr>
	</cfoutput>
    </table>
	
	<cfset class = AccessList.recordcount>