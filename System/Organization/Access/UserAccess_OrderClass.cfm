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
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  R.Code, 
		        A.ClassParameter, 
				A.RecordStatus, 
				AccessLevel, Number
		FROM    Ref_OrderClass R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		   ON   R.Code = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		AND     A.Mission = '#URL.Mission#'		
		</cfif>
		</cfquery>
	
	<cfelse>
  
		<cfquery name="AccessList" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT R.Code, 
		        A.ClassParameter, 
				max(A.AccessLevel) as AccessLevel, 
				max(A.RecordStatus) as RecordStatus,
				count(*) as Number
		FROM    Ref_OrderClass R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		   ON   R.Code = A.ClassParameter 
		  AND   A.AccessLevel < '8'
		  AND     ((A.OrgUnit     = '#URL.ID2#') 
			  OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
  			  OR (A.OrgUnit is NULL and A.Mission is NULL))
		  AND     A.UserAccount = '#URL.ACC#' 
		  AND     A.Role        = '#URL.ID#'
		GROUP BY R.Code, A.ClassParameter
		</cfquery>
	
	</cfif>
		
	
	<table width="100%" class="formpadding">
	<tr>
	<td height="20"  class="labelmedium line">Class</td>
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>		
	<cfoutput query="AccessList">
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Code#">
	<tr  class="labelmedium line">
	  <td>#Code#</td>
	  <cfset row = currentrow>		 
	  <cfinclude template="UserAccessSelect.cfm">	 
	</tr>
	</cfoutput>
    </table>
		
	<cfset class = #AccessList.recordcount#>