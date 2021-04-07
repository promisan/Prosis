
<cfparam name="url.unit" default="">

<cfset session.portalOrgUnit = url.unit>
	
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

					(SELECT   count(*)
					 FROM     Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo
					 WHERE    D.Status = '0' <!--- at the end of the track the status is set as 1 in the workflow --->
					 AND      DP.PositionNo IN ( SELECT PositionNo
											     FROM   Position	P 
											     WHERE  PositionParentId = vw.Positionparentid )
					) as hasTrack,							 
								
					PositionNo, 
					FunctionNo, FunctionDescription, OccGroupOrder, OccGroupAcronym, OccupationalGroup, OccGroupDescription, 
					PostType, PostClass, PostClassGroup, 
					PostInBudget, 
					VacancyActionClass, ShowVacancy, PostAuthorised, PositionParentId, SourcePostNumber, 
					DateEffective, DateExpiration, 
					PostGrade, PostOrder, 
					ApprovalPostGrade, ApprovalReference, 
					LocationCode
					 					
		FROM        vwPosition vw
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
					
					(SELECT   count(*)
					 FROM     Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo
					 WHERE    D.Status = '0' <!--- at the end of the track the status is set as 1 in the workflow --->
					 AND      DP.PositionNo IN ( SELECT PositionNo
											     FROM   Position	P 
											     WHERE  PositionParentId = vw.Positionparentid )
					) as hasTrack,		
					
					PositionNo, 
					FunctionNo, FunctionDescription, OccGroupOrder, OccGroupAcronym, OccupationalGroup, OccGroupDescription, 
					PostType, PostClass, PostClassGroup, 
					PostInBudget, 
					VacancyActionClass, ShowVacancy, PostAuthorised, PositionParentId, SourcePostNumber, 
					DateEffective, DateExpiration, 
					PostGrade, PostOrder, 
					ApprovalPostGrade, ApprovalReference, 
					LocationCode
					 					
		FROM        vwPosition vw
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

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>	
--->

<!--- add to the result also the positions that are borrowed to a another unit which means for each unit that is shown in the above
we also add positions to it which they loaned to another unit --->


<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT     MissionOperational, 
		           PersonNo, IndexNo, FullName, LastName, MiddleName, FirstName, Gender, BirthDate, 
				   eMailAddress, 
				   OrgUnit, OrgUnitName, OrgUnitNameShort, OrgUnitHierarchyCode, OrgUnitClass, 
				   ParentOrgUnit, OrgUnitClassOrder, OrgUnitClassName, DateEffective, DateExpiration, 
				   FunctionDescriptionActual, FunctionNo, FunctionDescription, PositionNo, 
				   PositionParentId, OrgUnitOperational, OrgUnitAdministrative, OrgUnitFunctional, 
				   PostType, PostClass, LocationCode, VacancyActionClass, PostGrade, PostOrder, 				    
				   OccGroup, OccGroupName, OccGroupOrder, PostGradeParentDescription, ViewOrder, 
				   ContractId, AssignmentNo, AssignmentStatus, AssignmentClass, AssignmentType, Incumbency,
				   (SELECT Name FROM System.dbo.Ref_Nation WHERE Code = A.Nationality) as NationalityName
		FROM       vwAssignment A
		WHERE      Mission = '#URL.Mission#' 
		AND        DateEffective  < '#url.selection#' 
		AND        DateExpiration > '#url.selection#'
		AND        AssignmentStatus IN ('0','1') 	
		
</cfquery>

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>	
--->
