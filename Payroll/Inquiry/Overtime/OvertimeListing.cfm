<cf_screentop html="no" jquery="yes">

<cf_ModuleInsertSubmit
	   SystemModule   = "Attendance" 
	   FunctionClass  = "Window"
	   FunctionName   = "OvertimePortal" 
	   MenuClass      = "Dialog"
	   MenuOrder      = "1"
	   MainMenuItem   = "0"
	   FunctionMemo   = "Overtime Listing Portal"
	   ScriptName     = ""> 
		   
<cfset url.systemfunctionid = rowguid>

<cf_ListingScript>
<cf_dialogstaffing>

<cf_wfpending entityCode="EntOvertime" table="#SESSION.acc#_wfOvertime" mailfields="No" IncludeCompleted="No">

<cf_dropTable 
	tblname="#session.acc#_OvertimeListing" 
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
				(	SELECT TOP 1 PO.OrgUnitName
					FROM	Employee.dbo.PersonAssignment AS PA 
							INNER JOIN Organization.dbo.Organization AS PO 
								ON PA.OrgUnit = PO.OrgUnit
					WHERE	PA.AssignmentStatus IN ('0', '1')
					AND		PA.DateEffective <= O.OvertimeDate
					AND		PA.PersonNo = O.PersonNo
					ORDER BY PA.DateEffective DESC ) AS Organization,
				
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
				O.SalaryTrigger, 
				O.OvertimeDate, 
				O.OvertimeHours, 
				O.OvertimeMinutes, 
				(
					CASE
						WHEN LEN(CONVERT(VARCHAR(2),O.OvertimeHours)) = 1 THEN '0'+CONVERT(VARCHAR(2),O.OvertimeHours)
						ELSE CONVERT(VARCHAR(2),O.OvertimeHours)
					END
					+
					':'
					+
					CASE
						WHEN LEN(CONVERT(VARCHAR(2),O.OvertimeMinutes)) = 1 THEN '0'+CONVERT(VARCHAR(2),O.OvertimeMinutes)
						ELSE CONVERT(VARCHAR(2),O.OvertimeMinutes)
					END
				) as OvertimeTime,
				O.OvertimePayment, 
				O.Remarks, 
				O.Status, 
				O.ActionReference, 
				O.OfficerUserId, 
				O.OfficerLastName, 
				O.OfficerFirstName, 
				O.Created
		INTO	UserQuery.dbo.#session.acc#_OvertimeListing
		FROM	PersonOvertime AS O 
				INNER JOIN Employee.dbo.Person AS P 
					ON O.PersonNo = P.PersonNo
		WHERE	O.PersonNo IN
				(
					SELECT	PA.PersonNo
					FROM	Employee.dbo.PersonAssignment AS PA 
							INNER JOIN Organization.dbo.Organization AS PO 
								ON PA.OrgUnit = PO.OrgUnit
					WHERE	PA.AssignmentStatus IN ('0', '1')
					AND		PA.DateEffective <= O.OvertimeDate
					AND		PA.DateExpiration >= O.OvertimeDate
					AND		PO.OrgUnit IN
							(
								SELECT	OrgUnit
								FROM	Organization.dbo.OrganizationAuthorization
								<!--- this user --->
								WHERE	UserAccount = '#session.acc#'
								<!--- with the role of the entity --->
								AND		Role IN (SELECT Role FROM Organization.dbo.Ref_Entity WHERE EntityCode = 'EntOvertime')
								AND		(
											<!--- global access --->
											(Mission IS NULL AND OrgUnit IS NULL)
											OR
											<!--- access to the unit --->
											OrgUnit = PA.OrgUnit
											OR
											<!--- access to the root --->
											OrgUnit IN 	(
															SELECT OrgUnit 
															FROM   Organization.dbo.Organization 
															WHERE  HierarchyRootUnit = PO.HierarchyRootUnit
															AND    Mission           = PO.Mission
															AND    MandateNo         = PO.MandateNo
														)
										)	
								
							)
				)	
</cfquery>

<table width="100%" height="100%">
	<tr><td height="10"></td></tr>
	<tr>
		<td valign="top">
			<cfinclude template="OvertimeListingContent.cfm">
		</td>
	</tr>
</table>	