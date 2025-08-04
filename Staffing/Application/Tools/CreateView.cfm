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

<!--- ------------------------------------------------------ --->
<!--- Hanno 15/8 discontinued, part of staffing stats script 

<cfquery name="Check" 
  datasource="AppsQuery" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     sysobjects
  WHERE    name IN ('vwPosition','vwAssignment')
</cfquery>

<cfif Check.recordcount eq "2">

	<cfset td = dateformat(#Check.crdate#,"d")>
	<cfset cd = dateformat(#now()#,"d")>
			
	<cfif td eq cd>
		<!--- view exist already, by pass step --->
		<cfexit method="EXITTEMPLATE"> 
	</cfif>

</cfif>

  <cftry>

  <cfquery name="Drop"
	datasource="appsEmployee">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwPosition]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwPosition]
  </cfquery>
  
	  <cfcatch></cfcatch>
  
  </cftry>
    
  <cfquery name="CreateView"
	datasource="appsEmployee">
	CREATE VIEW dbo.vwPosition
	AS
    SELECT   TOP 100 PERCENT  
	         OrgP.Mission, 
		     OrgP.MandateNo,
			 PAR.HierarchyCode AS ParentHierarchyCode, 
             PAR.OrgUnitNameShort AS ParentNameShort,
			 Mis.MissionOwner,
			 OrgP.OrgUnit as OrgUnitOperational,
			 OrgP.OrgUnitName,
			 orgP.OrgUnitNameShort,
			 OrgP.OrgUnitClass,
			 OrgP.HierarchyCode,
			 Post.PositionNo, 
			 Org.Mission                  as OperationalMission,
			 Org.MandateNo                as OperationalMandateNo,
			 Post.OrgUnitOperational      as OperationalOrgUnit,
			 Org.OrgUnitName              as OperationalOrgUnitName,
			 Org.OrgUnitNameShort		  as OperationalOrgunitNameShort,
			 Org.OrgUnitClass             as OperationalOrgUnitClass,
			 Org.HierarchyCode            as OperationalHierarchyCode,
			 
			 Post.OrgUnitAdministrative,
			 OrgAdmin.Mission             as AdministrativeMission, 
			 OrgAdmin.OrgUnitName         as AdministrativeOrgUnitName,
			 OrgAdmin.OrgUnitClass        as AdministrativeOrgUnitClass,
			 OrgAdmin.HierarchyCode       as AdministrativeHierarchyCode,
			 
			 Post.OrgUnitFunctional,
			 OrgFunction.Mission          as FunctionalMission, 
			 OrgFunction.OrgUnitName      as FunctionalOrgUnitName,
			 OrgFunction.OrgUnitClass     as FunctionalOrgUnitClass,
			 OrgFunction.HierarchyCode    as FunctionalHierarchyCode,
			 
			 Post.FunctionNo,
			 Post.FunctionDescription,
			 Occ.ListingOrder             as OccGroupOrder,
			 Occ.Acronym                  as OccGroupAcronym,
			 Occ.OccupationalGroup        as OccupationalGroup,
			 Occ.Description              as OccGroupDescription,
			 			 
			 Post.PostType,
			 Post.PostClass,
			 Post.PostAuthorised,
			 Post.SourcePostNumber,
			 Post.DateEffective,
			 Post.DateExpiration,
			 Post.PostGrade, 
			 G.PostOrder,
			 Post.LocationCode, 
			 G.PostGradeBudget, 
			 G.PostOrderBudget,
			 G.PostGradeParent,
			 P.Category,
			 getDate() as Created
			 
		FROM         Organization.dbo.Organization PAR INNER JOIN
                      Applicant.dbo.OccGroup Occ INNER JOIN
                      dbo.Position Post INNER JOIN
                      Organization.dbo.Organization Org ON Post.OrgUnitOperational = Org.OrgUnit INNER JOIN
                      dbo.Ref_PostGrade G ON Post.PostGrade = G.PostGrade INNER JOIN
                      dbo.Ref_PostGradeParent P ON G.PostGradeParent = P.Code INNER JOIN
                      Applicant.dbo.FunctionTitle F ON Post.FunctionNo = F.FunctionNo INNER JOIN
                      Organization.dbo.Organization OrgP INNER JOIN
                      dbo.PositionParent PP ON OrgP.OrgUnit = PP.OrgUnitOperational INNER JOIN
                      Organization.dbo.Ref_Mandate M ON OrgP.Mission = M.Mission AND OrgP.MandateNo = M.MandateNo ON 
                      Post.PositionParentId = PP.PositionParentId ON Occ.OccupationalGroup = F.OccupationalGroup INNER JOIN
                      Organization.dbo.Ref_Mission Mis ON M.Mission = Mis.Mission ON PAR.Mission = Org.Mission AND PAR.MandateNo = Org.MandateNo AND 
                      PAR.OrgUnitCode = Org.HierarchyRootUnit LEFT OUTER JOIN
                      Organization.dbo.Organization OrgAdmin ON Post.OrgUnitAdministrative = OrgAdmin.OrgUnit LEFT OUTER JOIN
                      Organization.dbo.Organization OrgFunction ON Post.OrgUnitFunctional = OrgFunction.OrgUnit
					  
		 WHERE M.Operational          =  1			  
					  	 
		 ORDER BY OrgP.Mission
		 
	</cfquery>
	
	<cftry>
	
	<cfquery name="Drop"
	datasource="appsEmployee">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwAssignment]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwAssignment]
  </cfquery>
  
    <cfcatch></cfcatch>
  
  </cftry>
  
  <cfquery name="CreateView"
	datasource="appsEmployee">
	CREATE VIEW dbo.vwAssignment
	AS
	SELECT    TOP 100 PERCENT  Po.Mission,
			  Pe.PersonNo, 
			  Pe.IndexNo,
			  Pe.FullName,
			  Pe.LastName, 
			  Pe.FirstName, 
			  Pe.Nationality, 
			  Pe.Gender,
			  Pe.BirthDate,
			  Pe.eMailAddress,
			  Pe.ParentOffice,
			  Pe.ParentOfficeLocation, 
			  A.OrgUnit, 
			  Org.OrgUnitName,
			  Org.HierarchyCode as OrgUnitHierarchyCode,
			  Org.OrgUnitClass,
			  RC.ListingOrder as OrgUnitClassOrder,
			  RC.Description as OrgUnitClassName,
			  A.DateEffective, 
			  A.DateExpiration, 
			  A.ExpirationCode,
			  A.ExpirationListCode,
			  A.FunctionDescription as FunctionDescriptionActual,
	     	  Po.FunctionDescription, 
			  A.PositionNo, 
			  Po.OrgUnitOperational,
			  Po.PostType,
			  Po.PostGrade, 
			  Po.SourcePostNumber, 
			  G.PostOrderBudget, 
			  G.PostGradeBudget,
			  G.PostGradeParent,
		      Occ.OccupationalGroup AS OccGroup, 
			  Occ.Description AS OccGroupName, 
			  Occ.ListingOrder AS OccGroupOrder,
			  P.Description as PostGradeParentDescription,
			  P.ViewOrder, 
		      A.AssignmentNo, 
			  A.AssignmentStatus,
			  A.AssignmentClass, 
              A.AssignmentType, 
			  A.Incumbency, 
			  getDate() as Created
	  FROM    PersonAssignment A, 
		      Person Pe, 
		      Position Po, 
			  Applicant.dbo.Occgroup Occ, 
			  Applicant.dbo.FunctionTitle F, 
			  Ref_PostGrade G, 
			  Ref_PostGradeParent P,
			  Organization.dbo.Organization Org,
			  Organization.dbo.Ref_OrgUnitClass RC
		WHERE Po.PositionNo          = A.PositionNo
		AND   A.PersonNo             = Pe.PersonNo
		AND   Occ.OccupationalGroup  =  F.OccupationalGroup
		AND   F.FunctionNo           =  Po.FunctionNo 
		AND   G.PostGrade            = Po.PostGrade
		AND   P.Code                 = G.PostGradeParent 	
		AND   A.OrgUnit              = Org.OrgUnit
		AND   Org.OrgUnitClass       = RC.OrgUnitClass
		ORDER BY Po.Mission
  </cfquery>	
  
  --->