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
<cf_screentop html="no" jquery="yes">

<cf_ModuleInsertSubmit
	   SystemModule   = "Attendance" 
	   FunctionClass  = "Window"
	   FunctionName   = "Overtime" 
	   MenuClass      = "Dialog"
	   MenuOrder      = "1"
	   MainMenuItem   = "0"
	   FunctionMemo   = "Overtime Listing"
	   ScriptName     = ""> 
		   
<cfset url.systemfunctionid = rowguid>

<cf_ListingScript>
<cf_dialogstaffing>

<cfquery name="getSalaryTrigger" 
	datasource="AppsPayroll" 	
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM	Ref_PayrollTrigger
		WHERE	SalaryTrigger = '#url.salaryTrigger#'	
</cfquery>


<cfif getAdministrator("#url.mission#") eq "1">

	<!--- full access --->

<cfelse>
	
	<cfquery name="Access" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	      SELECT A.OrgUnit
		  FROM   OrganizationAuthorization A, 
		         Organization O
	   	  WHERE  A.UserAccount = '#SESSION.acc#' 
		  AND    A.Mission     = '#url.Mission#'
		  AND    O.OrgUnit     = A.OrgUnit
		  AND    O.Mission     = '#url.Mission#'		
		  AND    Role IN ('Timekeeper', 'HROfficer')						  
	</cfquery>

</cfif>

<cf_wfpending entityCode="EntOvertime" table="#SESSION.acc#_wfOvertime" mailfields="No" IncludeCompleted="No">

<cf_dropTable 
	tblname="#session.acc#_#SalaryTrigger#_OvertimeListing" 
	dbname="AppsQuery">  

<cfquery name="getData" 
	datasource="AppsPayroll" 	
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	
				P.PersonNo, 
				
				(
					CASE
					WHEN P.IndexNo IS NULL THEN P.Reference
					WHEN LTRIM(RTRIM(P.IndexNo)) = '' THEN P.Reference
					ELSE P.IndexNo
					END
				) as IndexNo, 
				
				P.LastName, 
				P.FirstName, 
				P.Gender, 
				P.Nationality, 
				P.BirthDate, 
				(P.LastName + ', ' + P.FirstName) as PersonName,
				O.OvertimeId, 
				O.OvertimePeriodStart, 
				O.OvertimePeriodEnd,
				
				(	SELECT TOP 1 PO.OrgUnitCode+' '+PO.OrgUnitName
					FROM	Employee.dbo.PersonAssignment AS PA 
							INNER JOIN Organization.dbo.Organization AS PO 
								ON PA.OrgUnit = PO.OrgUnit
					WHERE	PA.AssignmentStatus IN ('0', '1')
					AND		PA.DateEffective <= O.OvertimeDate
					AND		PA.PersonNo = O.PersonNo
					ORDER BY PA.DateEffective DESC ) AS Organization,
					
				(	SELECT TOP 1 PO.HierarchyCode
					FROM	Employee.dbo.PersonAssignment AS PA 
							INNER JOIN Organization.dbo.Organization AS PO 
								ON PA.OrgUnit = PO.OrgUnit
					WHERE	PA.AssignmentStatus IN ('0', '1')
					AND		PA.DateEffective <= O.OvertimeDate
					AND		PA.PersonNo = O.PersonNo
					ORDER BY PA.DateEffective DESC ) AS Organization_ord,	
				
				(	SELECT TOP 1 P.OrgUnitNameShort
					FROM	Employee.dbo.PersonAssignment AS PA 
							INNER JOIN Organization.dbo.Organization AS PO ON PA.OrgUnit = PO.OrgUnit
							INNER JOIN Organization.dbo.Organization P ON PO.Mission = P.Mission AND PO.MandateNo = P.MandateNo AND LEFT(PO.HierarchyCode, 5) = P.HierarchyCode	
					WHERE	PA.AssignmentStatus IN ('0', '1')
					AND		PA.DateEffective <= O.OvertimeDate
					AND		PA.PersonNo = O.PersonNo
					ORDER BY PA.DateEffective DESC	) as Parent,
										
				(	SELECT TOP 1 PA.FunctionDescription
					FROM	Employee.dbo.PersonAssignment AS PA 
					WHERE	PA.AssignmentStatus IN ('0', '1')
					AND		PA.DateEffective <= O.OvertimeDate
					AND		PA.PersonNo = O.PersonNo
					ORDER BY PA.DateEffective DESC ) AS FunctionalTitle, 
					
				O.DocumentReference, 
				 
				O.OvertimeDate, 
				O.OvertimeHours, 
				O.OvertimeMinutes,		
				(
				CASE 
					WHEN LEN(CAST(OvertimeMinutes AS varchar)) = 1 
					THEN CAST(OvertimeHours AS varchar)+':0'+CAST(OvertimeMinutes AS varchar)
					ELSE CAST(OvertimeHours AS varchar)+':'+CAST(OvertimeMinutes AS varchar)
				END	) as OverTimeTime,
				
				O.OvertimePayment, 
				O.Remarks, 
				O.Status, 				
				O.OfficerUserId, 
				O.OfficerLastName, 
				O.OfficerFirstName, 
				O.Created
		INTO	UserQuery.dbo.#session.acc#_#SalaryTrigger#_OvertimeListing
		
		FROM	PersonOvertime AS O 
				INNER JOIN Employee.dbo.Person AS P ON O.PersonNo = P.PersonNo
					
		WHERE	EXISTS (SELECT 'X'
		                FROM   Organization.dbo.OrganizationObject OO
						WHERE  ObjectKeyValue4 = O.OverTimeId
						AND    OO.Mission = '#URL.Mission#')
												
		AND		EXISTS  (SELECT 'X' 
		                 FROM   PersonOverTimeDetail 
						 WHERE  PersonNo      = O.PersonNo 
						 AND    OverTimeId    = O.OvertimeId 
						 AND    SalaryTrigger = '#url.salaryTrigger#')		
						 
		<!--- person has an assignment in the mission at that time 
		O.PersonNo IN
				(
					SELECT	PA.PersonNo
					FROM	Employee.dbo.PersonAssignment AS PA 
							INNER JOIN Organization.dbo.Organization AS PO 
								ON PA.OrgUnit = PO.OrgUnit
					WHERE	PA.AssignmentStatus IN ('0', '1')
					AND		PO.Mission = '#url.mission#' 
					AND		PA.DateEffective <= O.OvertimeDate
					AND		PA.DateExpiration >= O.OvertimeDate
				)					 
				--->
						   
		<cfif getAdministrator("#url.mission#") eq "0">
		<!--- the monitor has access to that unit and then will see all overtime historically of that unit --->
		AND     EXISTS (SELECT 'X'
		                FROM   Organization.dbo.OrganizationObject OO
						WHERE  ObjectKeyValue4 = O.OverTimeId
						AND    OO.OrgUnit IN (SELECT A.OrgUnit
				                              FROM   Organization.dbo.OrganizationAuthorization A, 
		                  		                     Organization.dbo.Organization O
         			   	                      WHERE  A.UserAccount = '#SESSION.acc#' 
				                              AND    A.Mission     = '#url.Mission#'
				                              AND    O.OrgUnit     = A.OrgUnit
				                              AND    O.Mission     = '#url.Mission#'		
				                              AND    Role IN ('Timekeeper', 'HROfficer')
        									)	
					)							   
		</cfif>				   			       		    
</cfquery>

<table width="100%" height="100%">
	<tr><td height="5"></td></tr>
	<tr class="line"><td class="labelmedium" style="padding-left:15px; font-size:22px; "><cfoutput>#getSalaryTrigger.Description#</cfoutput></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td valign="top" id="overtimebox">
			<cfinclude template="OvertimeListingContent.cfm">
		</td>
	</tr>
</table>	