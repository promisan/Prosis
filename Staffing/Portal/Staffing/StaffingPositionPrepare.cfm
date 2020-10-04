
<cfparam name="url.unit" default="">
	
<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT      Mission, MandateNo, MissionOwner, 'Used' as PositionGroup,
		
					<!--- owner of the position --->
		            OrgUnitOperational          as OwnerOrgUnit,
					OrgUnitName                 as OwnerOrgUnitName, 
					
					<!--- holder of the post --->
		            OperationalOrgunit          as OrgunitOperational, 
					OperationalOrgUnitName      as OrgunitName, 
					OperationalOrgUnitNameShort as OrgunitNameShort, 
					OperationalHierarchyCode    as HierarchyCode, 
					OperationalOrgUnitCode      as OrgUnitCode, 
					
					PositionNo, 
					FunctionNo, FunctionDescription, OccGroupOrder, OccGroupAcronym, OccupationalGroup, OccGroupDescription, 
					PostType, PostClass, PostClassGroup, 
					PostInBudget, 
					VacancyActionClass, ShowVacancy, PostAuthorised, PositionParentId, SourcePostNumber, 
					DateEffective, DateExpiration, 
					PostGrade, PostOrder, 
					ApprovalPostGrade, ApprovalReference, 
					LocationCode
					 					
		FROM        vwPosition
		WHERE       Mission = '#URL.Mission#' 
		AND         DateEffective  < '#url.selection#' 
		AND         DateExpiration > '#url.selection#'
		
		<!--- limit access to positions for which this person is HRA 
		--->
		<cfif isDefined("url.unit") AND trim(url.unit) neq "">
			AND 	OperationalOrgUnit IN (#preservesingleQuotes(url.unit)#)
		<cfelse>
			AND  	1=0
		</cfif>
		
				
		UNION 
		
		SELECT      Mission, MandateNo, MissionOwner, 'Loaned' as PositionGroup,
		
					<!--- owner of the position --->
		            OrgUnitOperational          as OwnerOrgUnit,
					OrgUnitName                 as OwnerOrgUnitName, 
					
					<!--- holder of the post --->
		            OrgunitOperational          as OrgunitOperational, 
					OrgUnitName      as OrgunitName, 
					OrgUnitNameShort as OrgunitNameShort, 
					HierarchyCode    as HierarchyCode, 
					OrgUnitCode      as OrgUnitCode, 
					
					PositionNo, 
					FunctionNo, FunctionDescription, OccGroupOrder, OccGroupAcronym, OccupationalGroup, OccGroupDescription, 
					PostType, PostClass, PostClassGroup, 
					PostInBudget, 
					VacancyActionClass, ShowVacancy, PostAuthorised, PositionParentId, SourcePostNumber, 
					DateEffective, DateExpiration, 
					PostGrade, PostOrder, 
					ApprovalPostGrade, ApprovalReference, 
					LocationCode
					 					
		FROM        vwPosition
		WHERE       Mission = '#URL.Mission#' 
		AND         DateEffective  < '#url.selection#' 
		AND         DateExpiration > '#url.selection#'
		
		<!--- limit access to positions for which this person is HRA 
		--->
		<cfif isDefined("url.unit") AND trim(url.unit) neq "">
			AND 	OrgUnitOperational IN (#preservesingleQuotes(url.unit)#)
			AND     OperationalOrgUnit NOT IN (#preservesingleQuotes(url.unit)#)
		<cfelse>
			AND  	1=0
		</cfif>
				
		ORDER BY    HierarchyCode, PostOrder
				
</cfquery>		

<!--- add to the result also the positions that are borrowed to a another unit which means for each unit that is shown in the above
we also add positions to it which they loaned to another unit --->


<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT     MissionOperational, 
		           PersonNo, IndexNo, FullName, LastName, MiddleName, FirstName, Nationality, Gender, BirthDate, 
				   eMailAddress, ParentOffice, ParentOfficeLocation, PersonReference, Operational, 
				   OrgUnit, OrgUnitName, OrgUnitNameShort, OrgUnitHierarchyCode, OrgUnitClass, 
				   ParentOrgUnit, OrgUnitClassOrder, OrgUnitClassName, DateEffective, DateExpiration, 
				   FunctionDescriptionActual, FunctionNo, FunctionDescription, PositionNo, 
				   PositionParentId, OrgUnitOperational, OrgUnitAdministrative, OrgUnitFunctional, 
				   PostType, PostClass, LocationCode, VacancyActionClass, PostGrade, PostOrder, 
				   SourcePostNumber, PostOrderBudget, PostGradeBudget, PostGradeParent, 
				   OccGroup, OccGroupName, OccGroupOrder, PostGradeParentDescription, ViewOrder, 
				   ContractId, AssignmentNo, AssignmentStatus, AssignmentClass, AssignmentType, Incumbency, 
				   Remarks, AssignmentLocation,
				   (SELECT Name FROM System.dbo.Ref_Nation WHERE Code = A.Nationality) as NationalityName
		FROM       vwAssignment A
		WHERE      Mission = '#URL.Mission#' 
		AND        DateEffective  < '#url.selection#' 
		AND        DateExpiration > '#url.selection#'
		AND        AssignmentStatus IN ('0','1') 	
</cfquery>
