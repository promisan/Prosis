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
	
	 <cfquery name="Category" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT DISTINCT I.Category FROM Item I 
		 WHERE I.Mission = '#url.mission#'
		 UNION
		 SELECT DISTINCT I.Category FROM Item I, ItemUomMission M
		 WHERE  I.ItemNo = M.ItemNo
		 AND    M.Mission = '#url.mission#'
	</cfquery>	 	
		
	<cfset cat = quotedValueList(Category.Category)>							   
	
	<cfif tree eq "1">
	
		 <cfquery name="AccessList" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT R.Category, A.ClassParameter, R.Description,
			        A.RecordStatus, 
					AccessLevel, Number
			FROM    Ref_Category R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A 
			     ON R.Category = A.ClassParameter 
			<cfif Role.GrantAllTrees eq "0">
			    AND A.Mission = '#URL.Mission#'		
			WHERE  R.Category IN (#preservesingleQuotes(cat)#)				                                
			</cfif>
		</cfquery>
	
	<cfelse>
  
		<cfquery name="AccessList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT R.Category, R.Description,
		        A.ClassParameter, 
				max(A.AccessLevel) as AccessLevel,
				max(A.RecordStatus) as RecordStatus, 
				count(*) as Number
		FROM    Ref_Category R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A 
			     ON R.Category = A.ClassParameter 
			AND A.AccessLevel < '8'
			AND ((A.OrgUnit     = '#URL.ID2#') 
				OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
				OR (A.OrgUnit is NULL and A.Mission is NULL))
			AND A.UserAccount = '#URL.ACC#' 
			AND A.Role        = '#URL.ID#'
		WHERE  R.Category IN (#preservesingleQuotes(cat)#)					
		GROUP BY R.Category, A.ClassParameter, R.Description
		</cfquery>
			
	</cfif>
		
	
	<table width="100%" class="formpadding">
	<tr>
	<td height="20" class="labelmedium"><b>Item Category</td>
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>
	
	<tr><td colspan="<cfoutput>#No+2#</cfoutput>" class="linedotted"></td></tr>	
	
	<cfoutput query="AccessList">
	<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#Category#">
	<tr class="linedotted">
	  <td class="labelit">
	    &nbsp;#Category# #Description#
	  </td>
	  <cfset row = currentrow>		
	  <cfinclude template="UserAccessSelect.cfm">	  
	</tr>	
	</cfoutput>
    </table>
	
	<cfset class = AccessList.recordcount>