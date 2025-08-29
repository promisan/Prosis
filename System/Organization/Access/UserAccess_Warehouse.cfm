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
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  R.SystemFunctionId, 
		        R.FunctionName, 
				R.FunctionClass, 
				A.ClassParameter, 
				A.RecordStatus, 
				R.MenuOrder,
				AccessLevel, 
				Number
		FROM    Ref_ModuleControl R LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#TreeAccess A
		 ON     R.SystemFunctionId = A.ClassParameter 
		<cfif Role.GrantAllTrees eq "0">
		   AND  A.Mission = '#URL.Mission#'		
		</cfif>
		WHERE   (R.SystemModule = 'Warehouse'  or R.SystemModule = 'WorkOrder')
		AND      R.FunctionClass IN ('Stock','StockTask','StockSale','Transaction','Inquiry','Location','Inspection')		
		AND      Operational = 1
		AND      MainMenuItem = 0
		ORDER BY R.FunctionClass, R.MenuOrder
		</cfquery>
	
	<cfelse>
		  
		<cfquery name="AccessList" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT  DISTINCT R.SystemFunctionId, 
		        R.FunctionName, 
				R.FunctionClass, 
				R.MenuOrder,
		        A.ClassParameter, 
				MAX(A.RecordStatus) as RecordStatus,
				MAX(A.AccessLevel) as AccessLevel, 
				
				(
				SELECT TOP 1 MAX(A.AccessLevel) as Level 
				FROM   Organization.dbo.OrganizationAuthorization GA
				WHERE  R.SystemFunctionId = GA.ClassParameter
				AND    Mission     = '#URL.Mission#'
				AND    OrgUnit 		is NULL 				 
				AND    UserAccount  = '#URL.ACC#' 
				AND    GA.Role      = '#URL.ID#'  
				
				) as hasMissionGlobal,				
				
				COUNT(*) as Number
				
		FROM     Ref_ModuleControl R LEFT OUTER JOIN Organization.dbo.OrganizationAuthorization A
		  ON     R.SystemFunctionId = A.ClassParameter 
		 AND     A.AccessLevel < '8'
		 AND    ((A.OrgUnit     = '#URL.ID2#') 
			OR  (A.OrgUnit is NULL and A.Mission = '#URL.Mission#')
			OR  (A.OrgUnit is NULL and A.Mission is NULL))
		 AND     A.UserAccount = '#URL.ACC#' 
		 AND     A.Role        = '#URL.ID#' 
		 
		WHERE    (R.SystemModule = 'Warehouse' or R.SystemModule = 'WorkOrder')
		AND      R.FunctionClass IN ('Stock','StockTask','StockSale','Transaction','Inquiry','Location','Inspection')
		AND      Operational = 1
		AND      MainMenuItem = 0
		
		GROUP BY R.SystemFunctionId, R.FunctionName, R.FunctionClass, A.ClassParameter, R.MenuOrder
		ORDER BY R.FunctionClass, R.MenuOrder
		
		</cfquery>
	
	</cfif>		
	
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	<td height="20" class="labelmedium"><b>Task</td>
	<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>	
	<tr><td colspan="<cfoutput>#No+2#</cfoutput>" class="linedotted"></td></tr>		
	
	<cfoutput query="AccessList" group="FunctionClass">
	<tr><td style="padding:2px" class="labelmedium">#FunctionClass#</td></tr>
	<tr><td style="border-top: dotted 1px silver" colspan="5"></td></tr>
		<cfoutput>
			<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#SystemFunctionId#">
			<tr class="labelmedium linedotted">
			  <td style="height:20px;padding-left:15px">&nbsp;#FunctionName#</td>
			   <cfset row = currentrow>		
			   <cfinclude template="UserAccessSelect.cfm">	 
			</tr>
		</cfoutput>
	
	
	</cfoutput>
    </table>	
	
	<cfset class = AccessList.recordcount>