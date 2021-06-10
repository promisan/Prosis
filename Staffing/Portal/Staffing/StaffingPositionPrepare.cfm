
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
					
					ParentFunctionNo, ParentFunctionDescription,			
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
					
					ParentFunctionNo, ParentFunctionDescription,
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
		
		<!--- limit access to positions for which this person is HRA --->
		<cfif isDefined("url.unit") AND trim(url.unit) neq "">
			AND 	OrgUnitOperational IN (#preservesingleQuotes(url.unit)#)
			AND     OperationalOrgUnit NOT IN (#preservesingleQuotes(url.unit)#)
		<cfelse>
			AND  	1=0
		</cfif>
		
		UNION
		
		SELECT      Mission, MandateNo, MissionOwner, 'Float' as PositionGroup,
		
					<!--- owner of the position --->
		            vw.OrgUnitOperational          as OwnerOrgUnit,
					vw.OrgUnitName                 as OwnerOrgUnitName, 
					
					<!--- beneficiary of the post --->
		            A.Orgunit          as OrgunitOperational, 
					A.OrgUnitName      as OrgunitName, 
					A.OrgUnitNameShort as OrgunitNameShort, 
					A.HierarchyCode    as HierarchyCode, 
					A.OrgUnitCode      as OrgUnitCode, 
					
					(SELECT   count(*)
					 FROM     Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo
					 WHERE    D.Status = '0' <!--- at the end of the track the status is set as 1 in the workflow --->
					 AND      DP.PositionNo IN ( SELECT PositionNo
											     FROM   Position	P 
											     WHERE  PositionParentId = vw.Positionparentid )
					) as hasTrack,		
					
					ParentFunctionNo, ParentFunctionDescription,
					vw.PositionNo, 
					A.FunctionNo, A.FunctionDescription, OccGroupOrder, OccGroupAcronym, OccupationalGroup, OccGroupDescription, 
					PostType, PostClass, PostClassGroup, 
					PostInBudget, 
					VacancyActionClass, ShowVacancy, PostAuthorised, PositionParentId, SourcePostNumber, 
					DateEffective, DateExpiration, 
					PostGrade, PostOrder, 
					ApprovalPostGrade, ApprovalReference, 
					A.LocationCode
					 					
		FROM        vwPosition vw INNER JOIN 
		
					(
					SELECT      P.PositionNo, 
					            PA.OrgUnit, 
								O.OrgUnitName, 
								O.OrgUnitNameShort, 
								O.HierarchyCode, 
								O.OrgUnitCode, 
								PA.LocationCode, 
								PA.FunctionNo, 
								PA.FunctionDescription
								
					FROM        Position AS P INNER JOIN
			                    PersonAssignment AS PA ON PA.PositionNo = P.PositionNo 
								             AND PA.AssignmentStatus IN ('0', '1') 
											 AND PA.DateEffective  <= '#url.selection#' 
											 AND PA.DateExpiration >= '#url.selection#'
											 AND P.OrgUnitOperational <> PA.OrgUnit 
											 AND PA.Incumbency <> 0
								INNER JOIN Organization.dbo.Organization O ON PA.OrgUnit = O.Orgunit
											 
					WHERE       P.Mission = '#url.mission#' 
					AND         P.DateEffective <= '#url.selection#'  
					AND         P.DateExpiration >= '#url.selection#'
					
					) as A ON vw.PositionNo = A.PositionNo
				
		WHERE       Mission = '#URL.Mission#' 
		AND         DateEffective  <= '#url.selection#' 
		AND         DateExpiration >= '#url.selection#'
		
		<!--- limit access to positions for which this person is HRA --->
		<cfif isDefined("url.unit") AND trim(url.unit) neq "">
			AND 	A.OrgUnit IN (#preservesingleQuotes(url.unit)#)			
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
		AND        DateEffective  <= '#url.selection#' 
		AND        DateExpiration >= '#url.selection#'
		<!--- draft change we do not show the person if he/she is not working for that unit --->		
		AND        AssignmentStatus IN ('0','1') 	
		
</cfquery>

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>	
--->
