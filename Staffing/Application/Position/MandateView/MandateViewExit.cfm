
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

