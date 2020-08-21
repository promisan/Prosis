


<cfparam name="url.data" default="0">
<cfparam name="url.box"  default="">

<cfquery name="Mandate" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT   * 
		 FROM     Ref_Mandate 
		 WHERE    Mission = '#url.mission#' 
		 AND      DateEffective <= getDate()
		 ORDER BY DateExpiration DESC
	</cfquery>

<cfif url.orgunit neq "">

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
	
<cfelse>	

	<cfparam name="get.OrgUnitName" default="#url.mission#">	
	
</cfif>

 <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Diversity_#url.mission#">	

<cftransaction isolation="READ_UNCOMMITTED">

<cfset today = dateformat(now(),"YYYY/MM/DD")>

<cfif url.period eq "today">

	<cfset dt = dateAdd("d",0,today)>
	
<cfelse>
	
	<cfset dt = "#url.period#/01">	
	<cfset dt = dateAdd("d",0,dt)>
	<cfset dim = daysInMonth(dt)-1>
	<cfset dt = dateAdd("d",dim,dt)>	
	
	<cfif month(dt) eq month(now()) and year(dt) eq year(now())>
			<cfset dt = dateAdd("d",0,today)>	
	</cfif>
		
</cfif>

<cfoutput>

<cfsavecontent variable="vwContract">

	SELECT    PC.PersonNo, 	           			  
			  PC.ContractType,
			  CT.AppointmentType,
			  PC.ContractFunctionDescription,
			  PC.ContractLevel, 	
			  PC.ContractTime,		
			  PC.SalarySchedule,  
			  PostOrder       as ContractLevelOrder, 
			  PostGradeBudget as ContractLevelBudget,
			  PostOrderBudget as ContractLevelBudgetOrder, 
			  PostGradeParent as ContractLevelParent, 
			  PP.PostType     as ContractLevelType,
			  ContractStep,
			  PP.ViewOrder    as ContractViewOrder
			
	FROM      PersonContract PC 
					INNER JOIN (
							SELECT    PersonNo, Mission, MAX(Created) as Created
							FROM      PersonContract
							WHERE     Mission         IN ('#url.mission#','UNDEF')
							AND       DateEffective  <= #dt# 
							AND       DateExpiration >= #dt# 							
							AND       ActionStatus IN ('0','1') 
							GROUP BY  PersonNo, Mission
							) as L ON PC.PersonNo = L.PersonNo 
							      AND PC.Mission  = L.Mission 
								  AND PC.Created  = L.Created 
								  AND PC.ActionCode != '3006'
					  INNER JOIN Ref_PostGrade PG ON PG.PostGrade = PC.ContractLevel
					  INNER JOIN Ref_PostGradeParent PP ON PG.PostGradeParent = PP.Code
					  INNER JOIN Ref_ContractType CT ON CT.ContractType = PC.ContractType
						  
</cfsavecontent>
</cfoutput>

<!--- CURRENT --->
<cfquery name="getStaff" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
	 
		 SELECT      A.Mission, MandateNo, MissionOperational, 
		             A.PersonNo, IndexNo, FullName, LastName, MiddleName, FirstName, A.Nationality, N.Name as NationalityName, N.ISOCODE2,					
					 Gender, BirthDate, 
                     eMailAddress, ParentOffice, ParentOfficeLocation, PersonReference, A.Operational, 
					 
					 OrgUnit, OrgUnitName, OrgUnitNameShort, OrgUnitHierarchyCode, OrgUnitClass, 
					 (SELECT OrgUnitCode
					  FROM   Organization.dbo.Organization
					  WHERE OrgUnit = A.OrgUnit) as OrgUnitCode,
                     ParentOrgUnit, OrgUnitClassOrder, OrgUnitClassName, 
					 A.DateEffective, A.DateExpiration, 
					 FunctionDescriptionActual, FunctionNo, FunctionDescription, PositionNo, 
                     PositionParentId, OrgUnitOperational, OrgUnitAdministrative, OrgUnitFunctional, 
					 A.PostType, 
					 A.PostClass, 
					 
					 PC.PostClassGroup as PostClassDescription, 
					 PC.PresentationColor as PostClassColor,
					 UPPER(LocationCode) as LocationCode,
					 
					 (SELECT  LocationNameShort
					  FROM 	  Location L
					  WHERE   L.LocationCode = A.LocationCode	) as LocationName,											
					  
					 (SELECT Country
					  FROM   Location L
				 	  WHERE  L.LocationCode = A.LocationCode	) as LocationCountry,	
					  					  
					 VacancyActionClass, SourcePostNumber,
					 
					 PostGrade, PostOrder, PostOrderBudget, PostGradeBudget, PostGradeParent, ViewOrder,
					 
					 SalarySchedule,  
					 
					 C.AppointmentType, AT.Description as AppointmentTypeDescription, 
					 
					 AT.PresentationColor as AppointmentColor, 
					 
					 ContractFunctionDescription,
					 
					 ContractLevel,  ContractLevelorder,  ContractLevelBudget, ContractLevelBudgetOrder, ContractLevelType, ContractLevelParent, ContractStep, ContractTime, ContractViewOrder,
					 
					 (SELECT  MAX(DateEffective)
					  FROM    PersonContract
					  WHERE   PersonNo 	=  C.PersonNo
					  AND     Mission 	= '#url.Mission#' 
					  AND     ActionCode IN
					               (SELECT   ActionCode
					                FROM     Ref_Action
					                WHERE    ActionSource = 'Contract' 
					 			    AND      CustomForm = 'Insert')) 
					   as EOD,	
					   
					   (SELECT  CONVERT(VARCHAR(10), MAX(DateEffective), 120)
					  FROM    PersonContract
					  WHERE   PersonNo 	=  C.PersonNo
					  AND     Mission 	= '#url.Mission#' 
					  AND     ActionCode IN
					               (SELECT   ActionCode
					                FROM     Ref_Action
					                WHERE    ActionSource = 'Contract' 
					 			    AND      CustomForm = 'Insert')) 
					   as EODNoTime,	
					 					 
					 OccGroup, OccGroupName, OccGroupOrder, PostGradeParentDescription, 
					 ContractId, AssignmentNo, 
					 AssignmentStatus, AssignmentClass, AssignmentType, 
					 Incumbency, ExpirationCode, ExpirationListCode, 
					 AssignmentLocation,
					 
					 ( 	SELECT 	Ox.OrgUnitName
					 	FROM 	Organization.dbo.Organization Ox
					 	WHERE 	Ox.HierarchyCode = LEFT(A.OrgUnitHierarchyCode,2)
					 	AND 	Ox.Mission       = A.Mission
					 	AND 	Ox.MandateNo     = A.MandateNo
					 ) as ParentOrgUnitName
					 
					 <cfif url.data eq "1">
					 INTO userquery.dbo.#SESSION.acc#Diversity_#url.mission#
					 </cfif>
					 
		FROM         vwAssignment A 
					 INNER JOIN Ref_PostClass PC ON A.PostClass = PC.PostClass
					 LEFT OUTER JOIN System.dbo.Ref_Nation N 
					 	ON A.Nationality = N.Code 
					 INNER JOIN (#preservesingleQuotes(vwContract)#) C ON A.PersonNo = C.PersonNo
					 INNER JOIN Ref_AppointmentType AT ON C.AppointmentType = AT.AppointmentType
						
		WHERE        A.Mission           = '#url.mission#' 
		<!--- situation at the end of the month --->
		AND          A.DateEffective    <= #dt# 
		AND          A.DateExpiration   >= #dt# 
		<cfif url.category neq "" and url.category neq "all">
			<cfif url.category eq "0">
				AND A.Incumbency = '0'
			</cfif>
			<cfif url.category eq "100">
				AND A.Incumbency > '0'
			</cfif>
		</cfif>
		AND          A.AssignmentStatus IN ('0','1')	
		AND          A.AssignmentType    = 'Actual'	
		
		<cfif url.cstf neq "">
			<cfif find("TPE_",url.cstf)>			    
				AND          ContractLevelType = '#right(url.cstf,len(url.cstf)-4)#'			
			<cfelse>
				AND          ContractLevelParent = '#url.cstf#'
			</cfif>
		</cfif>	
		
		<cfif url.authorised neq "">		
		AND          PositionNo IN (SELECT PositionNo 
		                            FROM   Position P 
									WHERE  PositionNo = A.PositionNo 
									AND    P.PostAuthorised = '#url.authorised#')
		</cfif>		
		
		<cfif url.postclass neq "">		
		AND          A.PostClass = '#url.postclass#'
		</cfif>
		
		<cfif url.orgunit neq "">
		AND       OrgUnitOperational IN (SELECT OrgUnit 
		                                 FROM   Organization.dbo.Organization
										 WHERE  Mission   = '#url.mission#'
										 AND    MandateNo = '#Mandate.MandateNo#'
										 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
										)  
		</cfif>
		    
</cfquery>	



<cfif url.data eq "1">

	<cfset client.table1   = "#SESSION.acc#Diversity_#url.mission#">

<cfelse>
		
		<cfquery name="Summary" dbtype="query">
		  	SELECT  COUNT(DISTINCT PersonNo) as Total
		 	FROM    GetStaff			  	
		</cfquery>	
		
		<!--- obtain the people onboard the prior month to determine difference this month.
			person this month not in prior month.
			person in prior month, not in this month
		--->
		
		<cfif url.period eq "today">
			<cfset prior = dateAdd("d",day(dt)*-1,dt)>
		<cfelse>    	
			<cfset prior = dateAdd("d",daysInMonth(dt)*-1,dt)>	
		</cfif>
		
		<!--- PRIOR --->
		
		<cfoutput>
		<cfsavecontent variable="vwContract">
		
			SELECT    PC.PersonNo, 
			          PC.SalarySchedule, 			 
					  PC.ContractType,
					  CT.AppointmentType,
					  PC.ContractLevel, 					  
					  PostOrder       as ContractLevelOrder, 
				  	  PostGradeBudget as ContractLevelBudget,
					  PostOrderBudget as ContractLevelBudgetOrder, 
					  PostGradeParent as ContractLevelParent, 
					  PP.PostType     as ContractLevelType,
					  ContractStep,
					  PP.ViewOrder    as ContractViewOrder
					
			FROM      PersonContract PC 
							INNER JOIN (
									SELECT    PersonNo, Mission, MAX(Created) as Created
									FROM      PersonContract
									WHERE     Mission  IN ('#url.mission#','UNDEF')
									AND       DateEffective  <= #prior# 
									AND       DateExpiration >= #prior# 												
									AND       ActionStatus IN ('0','1') 
									GROUP BY  PersonNo, Mission
									) as L ON PC.PersonNo = L.PersonNo 
									      AND PC.Mission  = L.Mission 
										  AND PC.Created  = L.Created 
										  AND PC.ActionCode != '3006'
							  INNER JOIN Ref_PostGrade PG ON PG.PostGrade = PC.ContractLevel
							  INNER JOIN Ref_PostGradeParent PP ON PG.PostGradeParent = PP.Code
						      INNER JOIN Ref_ContractType CT ON CT.ContractType = PC.ContractType						  
		</cfsavecontent>
		</cfoutput>
		
		<cfquery name="getPriorMonth" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">	 
			 
				SELECT       A.PersonNo,
							 A.IndexNo,
							 A.FullName,
							 A.OrgUnitName,
							 A.PostGrade,
							 A.DateEffective,
							 A.DateExpiration,
							 A.LocationCode,
							 A.PostClass,
							 -- PC.Description as PostClassDescription,
							 PC.PostClassGroup as PostClassDescription, 
							 PC.PresentationColor as PostClassColor,
							 C.AppointmentType,
							 AT.Description as AppointmentTypeDescription,
							 AT.PresentationColor as AppointmentColor,
							 C.SalarySchedule,
							 C.ContractLevelParent,							
							 C.ContractLevel,
							 C.ContractLevelBudget,
							 C.ContractLevelBudgetOrder,
							 (
							 	SELECT 	Ox.OrgUnitName
							 	FROM 	Organization.dbo.Organization Ox
							 	WHERE 	Ox.HierarchyCode = LEFT(A.OrgUnitHierarchyCode,2)
							 	AND 	Ox.Mission = A.Mission
							 	AND 	Ox.MandateNo = A.MandateNo
							 ) as ParentOrgUnitName
							 
				FROM         vwAssignment A 
							INNER JOIN Ref_PostClass PC ON A.PostClass = PC.PostClass
							INNER JOIN Location L ON A.LocationCode = L.LocationCode 
							INNER JOIN (#preservesingleQuotes(vwContract)#) C ON A.PersonNo = C.PersonNo
							INNER JOIN Ref_AppointmentType AT ON C.AppointmentType = AT.AppointmentType
				WHERE        A.Mission = '#url.mission#' 
				<!--- situation at the end of the month --->
				AND          A.DateEffective <= #prior# 
				AND          A.DateExpiration >= #prior# 
				AND          A.AssignmentStatus IN ('0','1')
				<cfif url.category neq "" and url.category neq "all">
					<cfif url.category eq "0">
						AND A.Incumbency = '0'
					</cfif>
					<cfif url.category eq "100">
						AND A.Incumbency > '0'
					</cfif>
				</cfif>
				AND          A.AssignmentType = 'Actual'
				
				<cfif url.cstf neq "">
					<cfif find("TPE_",url.cstf)>			    
						AND          ContractLevelType = '#right(url.cstf,len(url.cstf)-4)#'			
					<cfelse>
						AND          ContractLevelParent = '#url.cstf#'
					</cfif>
				</cfif>				
				
				<cfif url.authorised neq "">		
				AND          PositionNo IN (SELECT PositionNo FROM Position WHERE PositionNo = A.PositionNo and PostAuthorised = '#url.authorised#')
				</cfif>		
				<cfif url.postclass neq "">		
				AND          A.PostClass = '#url.postclass#'
				</cfif>
				<cfif url.orgunit neq "">
				AND       OrgUnitOperational IN (SELECT OrgUnit 
				                                 FROM   Organization.dbo.Organization
												 WHERE  Mission   = '#url.mission#'
												 AND    MandateNo = '#get.MandateNo#'
												 AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
												)  
				</cfif>
			    
		</cfquery>	
		
		<cfquery name="getPriorMonthAll" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">	 
			 
				SELECT       A.PersonNo,
							 A.IndexNo,
							 A.FullName,
							 A.OrgUnitName,
							 A.PostGrade,
							 A.DateEffective,
							 A.DateExpiration,
							 A.LocationCode,
							 A.PostClass,
							 -- PC.Description as PostClassDescription,
							 PC.PostClassGroup as PostClassDescription, 
							 PC.PresentationColor as PostClassColor,
							 C.AppointmentType,
							 AT.Description as AppointmentTypeDescription,
							 AT.PresentationColor as AppointmentColor,
							 C.ContractLevelParent,
							 C.ContractLevel,
							 C.ContractLevelBudget,
							 C.ContractLevelBudgetOrder,
							 (
							 	SELECT 	Ox.OrgUnitName
							 	FROM 	Organization.dbo.Organization Ox
							 	WHERE 	Ox.HierarchyCode = LEFT(A.OrgUnitHierarchyCode,2)
							 	AND 	Ox.Mission = A.Mission
							 	AND 	Ox.MandateNo = A.MandateNo
							 ) as ParentOrgUnitName
							 
				FROM         vwAssignment A 
							INNER JOIN Ref_PostClass PC ON A.PostClass = PC.PostClass
							INNER JOIN Location L ON A.LocationCode = L.LocationCode 
							INNER JOIN (#preservesingleQuotes(vwContract)#) C ON A.PersonNo = C.PersonNo
							INNER JOIN Ref_AppointmentType AT ON C.AppointmentType = AT.AppointmentType
				WHERE        A.Mission = '#url.mission#' 
				<!--- situation at the end of the month --->
				AND          A.DateEffective <= #prior# 
				AND          A.DateExpiration >= #prior# 
				AND          A.AssignmentStatus IN ('0','1')
				<cfif url.category neq "" and url.category neq "all">
					<cfif url.category eq "0">
						AND A.Incumbency = '0'
					</cfif>
					<cfif url.category eq "100">
						AND A.Incumbency > '0'
					</cfif>
				</cfif>
				AND          A.AssignmentType = 'Actual'
				
				<cfif url.cstf neq "">
					<cfif find("TPE_",url.cstf)>			    
						AND          ContractLevelType = '#right(url.cstf,len(url.cstf)-4)#'			
					<cfelse>
						AND          ContractLevelParent = '#url.cstf#'
					</cfif>
				</cfif>				
				
				<cfif url.authorised neq "">		
				AND          PositionNo IN (SELECT PositionNo FROM Position WHERE PositionNo = A.PositionNo and PostAuthorised = '#url.authorised#')
				</cfif>		
				<cfif url.postclass neq "">		
				AND          A.PostClass = '#url.postclass#'
				</cfif>				
			    
		</cfquery>
		
		
		
</cfif>		
			
</cftransaction>