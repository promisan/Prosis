
<cfparam name="url.unit" default="">
	
<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT      Mission, MandateNo, MissionOwner, OrgunitOperational, OrgunitName, OrgunitNameShort, 
					OrgUnitClass, HierarchyCode, OrgUnitCode, PositionNo, 
					FunctionNo, FunctionDescription, OccGroupOrder, OccGroupAcronym, OccupationalGroup, OccGroupDescription, 
					PostType, PostClass, PostClassGroup, 
					PostInBudget, 
					VacancyActionClass, ShowVacancy, PostAuthorised, PositionParentId, SourcePostNumber, 
					DateEffective, DateExpiration, PostGrade, PostOrder, 
					ApprovalPostGrade, ApprovalReference, LocationCode, PostGradeBudget, PostOrderBudget, PostGradeParent
					
		FROM        vwPosition
		WHERE       Mission = '#URL.Mission#' 
		AND         DateEffective  < '#url.selection#' 
		AND         DateExpiration > '#url.selection#'
		
		<!--- limit access to positions for which this person is HRA 
		--->
		<cfif isDefined("url.unit") AND trim(url.unit) neq "">
			AND 	OrgUnitOperational IN (#preservesingleQuotes(url.unit)#)
		<cfelse>
			AND  	1=0
		</cfif>
		
		ORDER BY    HierarchyCode, PostOrder
		
</cfquery>		

<!--- clean the field to pass only the needed ones --->

<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT     Mission, MandateNo, MissionOperational, PersonNo, IndexNo, FullName, LastName, MiddleName, FirstName, Nationality, Gender, BirthDate, 
					eMailAddress, ParentOffice, ParentOfficeLocation, PersonReference, Operational, OrgUnit, OrgUnitName, OrgUnitNameShort, OrgUnitHierarchyCode, OrgUnitClass, 
					ParentOrgUnit, OrgUnitClassOrder, OrgUnitClassName, DateEffective, DateExpiration, FunctionDescriptionActual, FunctionNo, FunctionDescription, PositionNo, 
					PositionParentId, OrgUnitOperational, OrgUnitAdministrative, OrgUnitFunctional, PostType, PostClass, LocationCode, VacancyActionClass, PostGrade, PostOrder, 
					SourcePostNumber, PostOrderBudget, PostGradeBudget, PostGradeParent, OccGroup, OccGroupName, OccGroupOrder, PostGradeParentDescription, ViewOrder, 
					ContractId, AssignmentNo, AssignmentStatus, AssignmentClass, AssignmentType, Incumbency, Remarks, ExpirationCode, ExpirationListCode, AssignmentLocation,
					(SELECT Name FROM System.dbo.Ref_Nation WHERE Code = A.Nationality) as NationalityName
		FROM       vwAssignment A
		WHERE      Mission = '#URL.Mission#' 
		AND        DateEffective  < '#url.selection#' 
		AND        DateExpiration > '#url.selection#'
		AND        AssignmentStatus IN ('0','1') 
		
</cfquery>
