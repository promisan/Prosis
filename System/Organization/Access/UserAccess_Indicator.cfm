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
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  R.ProgramCategory, C.Description,
		        R.IndicatorCode, R.IndicatorDescription, A.ClassParameter, A.RecordStatus, 
				AccessLevel, Number
		FROM    Ref_Indicator R INNER JOIN
                Ref_ProgramCategory C ON R.ProgramCategory = C.Code LEFT OUTER JOIN
                userQuery.dbo.#SESSION.acc#TreeAccess A ON R.IndicatorCode = A.ClassParameter		
		<cfif Role.GrantAllTrees eq "0">
		AND     A.Mission = '#URL.Mission#'		
		</cfif>
		WHERE   R.IndicatorCode IN (SELECT IndicatorCode FROM Ref_IndicatorMission WHERE Mission = '#URL.Mission#') 
		AND     R.Operational = 1
		ORDER BY R.ProgramCategory, R.IndicatorCode
		</cfquery>
	
	<cfelse>	
  
		<cfquery name="AccessList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT DISTINCT R.ProgramCategory, 
		        C.Description, 
				R.IndicatorCode, 
				R.IndicatorDescription, 
				A.ClassParameter, 
				max(A.RecordStatus) as RecordStatus,
				max(A.AccessLevel) as AccessLevel,
				count(*) as Number
		FROM    Ref_Indicator R INNER JOIN
                Ref_ProgramCategory C ON R.ProgramCategory = C.Code LEFT OUTER JOIN
                Organization.dbo.OrganizationAuthorization A ON R.IndicatorCode = A.ClassParameter
			AND     A.AccessLevel < '8'
			AND     ((A.OrgUnit     = '#URL.ID2#') 
				OR (A.OrgUnit is NULL and A.Mission = '#URL.Mission#') 
				OR (A.OrgUnit is NULL and A.Mission is NULL))
			AND     A.UserAccount = '#URL.ACC#' 
			AND     A.Role        = '#URL.ID#'			
		
		WHERE   R.Operational = 1
		AND     R.IndicatorCode IN (SELECT IndicatorCode FROM Ref_IndicatorMission WHERE Mission = '#URL.Mission#') 
		
		GROUP BY R.ProgramCategory, R.IndicatorCode, A.ClassParameter, C.Description, R.IndicatorDescription
		</cfquery>
		
	</cfif>		
	
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr>
		<td height="20" colspan="2"><b><cf_tl id="Indicator"></td>
		<cfinclude template="UserAccessSelectLabel.cfm">
	</tr>
		
		<cfoutput query="AccessList" group="ProgramCategory">
		<tr class="labelmedium line"><td colspan="#No+3#" bgcolor="e4e4e4" style="padding-left:10px">#Description#</b></td></tr>
		<cfoutput>
		<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#IndicatorCode#">
		<tr class="labelit">
		  <td width="50" style="padding-left:20px">
		    #IndicatorCode#
		  </td>
		  <td width="40%">
		    #IndicatorDescription#
		  </td>
		  <cfset row = currentrow>		
		  <cfinclude template="UserAccessSelect.cfm">
		  
		</tr>
		
		</cfoutput>
		</cfoutput>
    </table>	
	
	<cfset class = AccessList.recordcount>
	