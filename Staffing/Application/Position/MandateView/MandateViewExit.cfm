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

<cfif URL.Act eq "1">

<!--- nada --->

<cfelse>

	<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Staffing"> 
		
	<cfquery name="Excel" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     DISTINCT 
	           P.PositionNo, 
	           P.Mission, 
			   P.MandateNo, 
			   P.MissionOperational, 
			   P.OrgUnitOperational, 
			   O.Orgunitname,
			   P.LocationCode, 
			   L.LocationName, 
			   P.OccupationalGroup,
			   P.OccGroupDescription,
			   P.FunctionNo, 
	           P.FunctionDescription, 
			   P.PostGradeParent, 
			   P.Source,
			   P.SourcePostNumber,
			   P.PostGrade AS PostGrade, 
			   P.PostGradeBudget,
			   P.PostOrderBudget,
			   P.PostOrder as PostGradeOrder, 
			   P.PostType, 
			   P.PostClass, 
			   P.PostAuthorised, 
	           P.DateEffective AS PositionEffective, 
			   P.DateExpiration AS PositionExpiration, 
			   A.AssignmentNo,
			   A.IndexNo, 
			   A.PersonNo, 
			   A.LastName, 
			   A.FirstName, 
			   A.Gender, 
	           A.Nationality, 
			   A.DateEffectiveAssignment, 
			   A.DateExpirationAssignment
	INTO       dbo.#SESSION.acc#Staffing	   
	FROM       dbo.#SESSION.acc#Post#FileNo# P INNER JOIN
               Organization.dbo.Organization O ON P.OrgUnitOperational = O.OrgUnit LEFT OUTER JOIN
               dbo.#SESSION.acc#Assignment#FileNo# A ON P.PositionNo = A.PositionNo LEFT OUTER JOIN
               Employee.dbo.Location L ON P.LocationCode = L.LocationCode
		AND    A.DateEffectiveAssignment  <= #incumdate#
	    AND    A.DateExpirationAssignment >= #incumdate# 
	</cfquery>
		
</cfif>


<script>
	Prosis.busy('no')
</script>

