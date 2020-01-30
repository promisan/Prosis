

<!--- set default linkage for position and personassignment to a position --->

<cfquery name="Default"
	datasource="appsEmployee">
	 SELECT TOP 1 FunctionNo
     FROM   Applicant.dbo.FunctionTitle
</cfquery>		
 
<cfquery name="UpdateDefault"
	datasource="appsEmployee">
		UPDATE  Position
		SET     FunctionNo = '#Default.FunctionNo#'
		WHERE   FunctionNo = '' OR FunctionNo NOT IN (SELECT FunctionNo 
		                                              FROM Applicant.dbo.FunctionTitle)
</cfquery>		

<cfquery name="UpdateDefault"
	datasource="appsEmployee">
		UPDATE  PersonAssignment
		SET     FunctionNo = '#Default.FunctionNo#'
		WHERE   FunctionNo = '' OR FunctionNo NOT IN (SELECT FunctionNo 
		                                              FROM Applicant.dbo.FunctionTitle)
</cfquery>							

<!--- clean the action tables if no presence of the detail records --->
<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "Payroll" 
		 Warning   = "No">
		 

 <cfquery name="Cleansing" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 
	 DELETE EmployeeAction	
	 WHERE  (
	 
	        (ActionSource = 'Contract'    AND  ActionSourceId NOT IN (SELECT ContractId       FROM   PersonContract                WHERE  ContractId  = ActionSourceId))	
	 OR     (ActionSource = 'Dependent'   AND  ActionSourceId NOT IN (SELECT DependentId      FROM   PersonDependent               WHERE  DependentId = ActionSourceId))								   
	 OR     (ActionSource = 'SPA'         AND  ActionSourceId NOT IN (SELECT PostAdjustmentId FROM   PersonContractAdjustment      WHERE  PostAdjustmentId = ActionSourceId))								   
	 OR     (ActionSource = 'Leave'       AND  ActionSourceId NOT IN (SELECT LeaveId          FROM   PersonLeave			       WHERE  Leaveid = ActionSourceId))		
	 <cfif operational eq "1">
	 OR     (ActionSource = 'Entitlement' AND  ActionSourceId NOT IN (SELECT EntitlementId    FROM   Payroll.dbo.PersonEntitlement WHERE  EntitlementId = ActionSourceId))	
	 </cfif>
	        ) 									 							   
			
	 AND    ActionSourceid is not NULL				 
</cfquery>

<cfquery name="LoadingDate" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	
	 UPDATE EmployeeAction
	 SET    ActionDate       = S.DateEffective, 
	        ActionExpiration = S.DateExpiration
	 FROM   EmployeeAction A INNER JOIN PersonContract S ON A.ActionSourceid = S.ContractId
	 WHERE  A.ActionSource = 'Contract'
</cfquery>	 		

<cfquery name="LoadingDate" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	
	 UPDATE EmployeeAction
	 SET    ActionDate       = S.DateEffective, 
	        ActionExpiration = S.DateExpiration
	 FROM   EmployeeAction A INNER JOIN Payroll.dbo.PersonEntitlement S ON A.ActionSourceid = S.ContractId
	 WHERE  A.ActionSource = 'Entitlement'
</cfquery>	 	

<cfquery name="LoadingDate" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	
	 UPDATE EmployeeAction
	 SET    ActionDate       = S.DateEffective, 
	        ActionExpiration = S.DateExpiration
	 FROM   EmployeeAction A INNER JOIN PersonContractAdjustment S ON A.ActionSourceId = S.PostAdjustmentId
	 WHERE  A.ActionSource = 'SPA'
</cfquery>		

<cfquery name="LoadingDate" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	
	 UPDATE EmployeeAction
	 SET    ActionDate       = S.DateEffective, 
	        ActionExpiration = S.DateExpiration
	 FROM   EmployeeAction A INNER JOIN PersonLeave S ON A.ActionSourceId = S.LeaveId
	 WHERE  A.ActionSource = 'Leave'
</cfquery>	


<!---

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

---> 

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
	AS	    SELECT   TOP 100 PERCENT  
			         OrgP.Mission, 
				     OrgP.MandateNo,					  
					 Mis.MissionOwner,
					 
					 <!--- parent position --->
					 
					 (CASE WHEN DisableLoan = 0 THEN OrgP.OrgUnit ELSE Org.OrgUnit END)                   as OrgunitOperational,
					 (CASE WHEN DisableLoan = 0 THEN OrgP.OrgUnitName ELSE Org.OrgUnitName END)           as OrgunitName,
					 (CASE WHEN DisableLoan = 0 THEN OrgP.OrgUnitNameShort ELSE Org.OrgUnitNameShort END) as OrgunitNameShort,
					 (CASE WHEN DisableLoan = 0 THEN OrgP.OrgUnitClass ELSE Org.OrgUnitClass END)         as OrgUnitClass,
					 (CASE WHEN DisableLoan = 0 THEN OrgP.HierarchyCode ELSE Org.HierarchyCode END)       as HierarchyCode,
					 (CASE WHEN DisableLoan = 0 THEN OrgP.OrgUnitCode ELSE Org.OrgUnitCode END)           as OrgUnitCode,
					 (CASE WHEN DisableLoan = 0 THEN OrgP.DateExpiration ELSE Org.DateExpiration END)     as OrgExpiration,
					 (CASE WHEN DisableLoan = 0 THEN OrgP.DateEffective ELSE Org.DateEffective END)       as OrgEffective,
					 
					 <!--- parent of the usage position --->
					 
					 PAR.HierarchyCode            as ParentHierarchyCode, 
		             PAR.OrgUnitNameShort         as ParentNameShort,		
					 
					 <!--- usage --->					 
					 Po.PositionNo, 
					 Org.Mission                  as OperationalMission,
					 Org.MandateNo                as OperationalMandateNo,
					 Po.OrgUnitOperational        as OperationalOrgUnit,
					 Org.OrgUnitName              as OperationalOrgUnitName,
					 Org.OrgUnitCode              as OperationalOrgUnitCode,
					 Org.OrgUnitNameShort		  as OperationalOrgunitNameShort,
					 Org.OrgUnitClass             as OperationalOrgUnitClass,
					 Org.HierarchyCode            as OperationalHierarchyCode,
					 
					 <!--- administrative --->		 
					 Po.OrgUnitAdministrative,
					 OrgAdmin.Mission             as AdministrativeMission, 
					 OrgAdmin.OrgUnitName         as AdministrativeOrgUnitName,
					 OrgAdmin.OrgUnitCode         as AdministrativeOrgUnitCode,
					 OrgAdmin.OrgUnitClass        as AdministrativeOrgUnitClass,
					 OrgAdmin.HierarchyCode       as AdministrativeHierarchyCode,
					 
					 <!--- functional --->
					 Po.OrgUnitFunctional,
					 OrgFunction.Mission          as FunctionalMission, 
					 OrgFunction.OrgUnitName      as FunctionalOrgUnitName,
					 OrgFunction.OrgUnitCode      as FunctionalOrgUnitCode,
					 OrgFunction.OrgUnitClass     as FunctionalOrgUnitClass,
					 OrgFunction.HierarchyCode    as FunctionalHierarchyCode,
					 
					 Po.FunctionNo,
					 F.FunctionDescription,
					 Occ.ListingOrder             as OccGroupOrder,
					 Occ.Acronym                  as OccGroupAcronym,
					 Occ.OccupationalGroup        as OccupationalGroup,
					 Occ.Description              as OccGroupDescription,
					  
					 Po.PostType,
					 Po.PostClass,
					 C.PostClassGroup,
					 C.PostInBudget,
					 Po.VacancyActionClass,
					 V.ShowVacancy, <!--- added --->
					 Po.PostAuthorised,
					 Po.PositionParentId,
					 Po.SourcePostNumber,
					 Po.DateEffective,
					 Po.DateExpiration,
					 Po.PostGrade, 
					 Po.Remarks,	
					 G.PostOrder,
					 PP.ApprovalPostGrade,
					 PP.Fund,
					 Po.LocationCode, 
					 G.PostGradeBudget, 
					 G.PostOrderBudget,
					 G.PostGradeParent,
					 P.Category,
					 getDate() as Created
			 			 
			FROM    Organization.dbo.Organization PAR                                          INNER JOIN
                    Applicant.dbo.OccGroup Occ                                                 INNER JOIN
                    dbo.Position Po                                                            INNER JOIN
                    Organization.dbo.Organization Org ON Po.OrgUnitOperational = Org.OrgUnit   INNER JOIN
                    dbo.Ref_VacancyActionClass V ON Po.VacancyActionClass = V.Code	           INNER JOIN
                    dbo.Ref_PostGrade G ON Po.PostGrade = G.PostGrade                          INNER JOIN
                    dbo.Ref_PostGradeParent P ON G.PostGradeParent = P.Code                    INNER JOIN
                    dbo.Ref_PostClass C ON C.PostClass = Po.PostClass                          INNER JOIN
                    Applicant.dbo.FunctionTitle F ON Po.FunctionNo = F.FunctionNo              INNER JOIN
                    Organization.dbo.Organization OrgP                                         INNER JOIN
                    dbo.PositionParent PP ON OrgP.OrgUnit = PP.OrgUnitOperational              INNER JOIN
                    Organization.dbo.Ref_Mandate M ON OrgP.Mission = M.Mission AND OrgP.MandateNo = M.MandateNo ON 
                    Po.PositionParentId = PP.PositionParentId ON Occ.OccupationalGroup = F.OccupationalGroup INNER JOIN
                    Organization.dbo.Ref_Mission Mis ON M.Mission = Mis.Mission ON PAR.Mission = Org.Mission AND PAR.MandateNo = Org.MandateNo AND 
                    PAR.OrgUnitCode = Org.HierarchyRootUnit LEFT OUTER JOIN
					
                    Organization.dbo.Organization OrgAdmin ON Po.OrgUnitAdministrative = OrgAdmin.OrgUnit LEFT OUTER JOIN
                    Organization.dbo.Organization OrgFunction ON Po.OrgUnitFunctional  = OrgFunction.OrgUnit			  	 
		
		 WHERE     M.Operational          =  1
	    
		 ORDER BY  OrgP.Mission
		 
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
	SELECT    TOP 100 PERCENT
	          Po.Mission,
	          Po.MandateNo,
	          Po.MissionOperational,
			  Pe.PersonNo, 
			  Pe.IndexNo,
			  Pe.FullName,
			  Pe.LastName,
			  Pe.MiddleName, 
			  Pe.FirstName, 
			  Pe.Nationality, 
			  Pe.Gender,
			  Pe.BirthDate,
			  Pe.eMailAddress,
			  Pe.ParentOffice,
			  Pe.ParentOfficeLocation, 
			  Pe.Reference as PersonReference,
			  Pe.Operational,
			  A.OrgUnit, 
			  Org.OrgUnitName,
			  Org.OrgUnitNameShort,
			  Org.HierarchyCode as OrgUnitHierarchyCode,
			  Org.OrgUnitClass,
			  Org.ParentOrgUnit,
			  RC.ListingOrder as OrgUnitClassOrder,
			  RC.Description as OrgUnitClassName,
			  A.DateEffective, 
			  A.DateExpiration, 
			  A.FunctionDescription as FunctionDescriptionActual,
			  Po.FunctionNo, 
	     	  Po.FunctionDescription, 
			  A.PositionNo, 			  
			  Po.PositionParentId,
			  Po.OrgUnitOperational,
			  Po.OrgUnitAdministrative,
			  Po.OrgUnitFunctional,
			  Po.PostType,
			  Po.PostClass,
			  Po.LocationCode,
			  Po.VacancyActionClass,
			  Po.PostGrade, 
			  G.PostOrder,
			  Po.SourcePostNumber, 
			  G.PostOrderBudget, 
			  G.PostGradeBudget,
			  G.PostGradeParent,
		      Occ.OccupationalGroup AS OccGroup, 
			  Occ.Description AS OccGroupName, 
			  Occ.ListingOrder AS OccGroupOrder,
			  P.Description as PostGradeParentDescription,
			  P.ViewOrder, 
			  A.ContractId,
		      A.AssignmentNo, 
			  A.AssignmentStatus,
			  A.AssignmentClass, 
              A.AssignmentType, 			 
			  A.Incumbency,
			  A.Remarks,
			  A.ExpirationCode,
			  A.ExpirationListCode,
		      A.LocationCode AS AssignmentLocation,
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
			  
	  WHERE   Po.PositionNo          = A.PositionNo
		AND   A.PersonNo             = Pe.PersonNo		
		AND   Occ.OccupationalGroup  = F.OccupationalGroup
		AND   F.FunctionNo           = Po.FunctionNo 
		AND   G.PostGrade            = Po.PostGrade
		AND   P.Code                 = G.PostGradeParent 	
		AND   A.OrgUnit              = Org.OrgUnit
		AND   Org.OrgUnitClass       = RC.OrgUnitClass
		
	ORDER BY  Po.Mission
  </cfquery>	
    
<!--- ----------------------------------------------------- --->  
<!--- ---- sync applicat records and personnel records ---- --->
<!--- ----------------------------------------------------- --->  

<!--- remove invalid links to employee records --->

<cfquery name="RemoveInValidLink" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Applicant
	 SET    EmployeeNo = NULL
	 WHERE  EmployeeNo NOT IN (SELECT PersonNo FROM Employee.dbo.Person)
</cfquery>

<!--- update IndexNo in applicant once a records has a valid link to PersonNo --->

<cfquery name="SyncIndexNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Applicant
	 SET    IndexNo      = P.IndexNo
	 FROM   Applicant A, Employee.dbo.Person P
	 WHERE  A.EmployeeNo = P.PersonNo	 
	 AND    A.IndexNo <> P.IndexNo
</cfquery>

<!--- update employee No if IndexNo exists in Applicant but no EmployeeNo yet  --->

	<!--- Pending  25/12/2009 --->

<!--- validate the mapping from Candidate to Employee wth Employee based on reasonable similar data on both sides --->

	<!--- Pending  25/12/2009 --->

<!--- add entries into applicant if we have reasonable certainty the record does not exist yet  --->

 <cfquery name="MissingCandidates" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT    A.PersonNo AS Appl, P.Gender, P.PersonNo, P.IndexNo, P.MaidenName, P.MiddleName, P.LastName, P.FirstName, P.Nationality, P.BirthDate,P.BirthNationality,P.eMailAddress
		FROM      Person P LEFT OUTER JOIN
	              Applicant.dbo.Applicant A ON left(P.FirstName,2) = left(A.FirstName,2) AND P.LastName = A.LastName AND P.Nationality = A.Nationality AND P.BirthDate = A.DOB
		WHERE     P.BirthDate > 01/01/1940					  
		AND       P.PersonNo IN
	                          (SELECT     PersonNo
	                            FROM      PersonAssignment
	                            WHERE     PositionNo IN
	                                                       (SELECT  PositionNo
	                                                         FROM   Position
															 WHERE Mission IN (SELECT Mission FROM Ref_ParameterMission WHERE StaffingApplicant = 1)
															)
								)
		 <!--- exclude employees that have a specifically mapped record through EmployeeNo --->						
	     AND P.PersonNo NOT IN
	                   (SELECT   EmployeeNo
	                    FROM     Applicant.dbo.Applicant
	                    WHERE    EmployeeNo IS NOT NULL) 
		
		<!---									
		 AND P.IndexNo NOT IN
	                   (SELECT     IndexNo
	                    FROM          Applicant.dbo.Applicant
	                    WHERE      IndexNo IS NOT NULL)
		--->		
		AND P.IndexNo is not NULL					
	    GROUP BY A.PersonNo, A.IndexNo, P.BirthNationality, P.PersonNo, P.IndexNo, P.MaidenName, P.LastName, P.FirstName, P.MiddleName, P.Nationality, P.BirthDate, P.Gender,P.eMailAddress						
	    HAVING   A.PersonNo is NULL
	    ORDER BY P.LastName, P.FirstName, P.Nationality, P.BirthDate
</cfquery>

<cfloop query="MissingCandidates">
	
	<!--- temp measure --->
     <cfquery name="Last" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT    TOP 1 ApplicantNo AS LastNo
	     FROM      ApplicantSubmission
		 ORDER BY  ApplicantNo DESC
     </cfquery>
	 
	 <cfif Last.LastNo neq "">
	    <cfset new = Last.LastNo+1>
	 <cfelse>	
	    <cfset new = "1">
	 </cfif> 

   <cfquery name="AssignNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     UPDATE Parameter SET ApplicantNo = #new#
		 UPDATE Parameter SET PersonNo    = PersonNo+1
     </cfquery>
    
     <cfquery name="LastNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * FROM Parameter
	 </cfquery>
	 
     <cfquery name="InsertApplicant" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO Applicant 
         (PersonNo,
		 IndexNo, 
		 EmployeeNo,
		 LastName,
		 MaidenName,
		 FirstName,
		 MiddleName,
		 DOB,
		 Gender,
		 Nationality,		
		 BirthNationality,		 
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Remarks,			
		 eMailAddress)
      VALUES ('#LastNo.PersonNo#',
          '#IndexNo#',
		  '#PersonNo#',
		  '#LastName#',
		  '#MaidenName#',
		  '#FirstName#',
		  '#MiddleName#',
		  '#BirthDate#',
		  '#Gender#',		
		  '#Nationality#',
		  <cfif BirthNationality neq "">
		  '#BirthNationality#',
		  <cfelse>
		  '#Nationality#',
		  </cfif>		
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  'Staffing Table',		 
	      '#eMailAddress#')
      </cfquery>	
		  
     <!--- Submit submission --->

     <cfquery name="InsertApplicant" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     INSERT INTO ApplicantSubmission
	         (PersonNo,
			 ApplicantNo,
	  		 SubmissionDate,
			 ActionStatus,
			 Source,
			 eMailAddress,
			 LanguageId,
		 	 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES (
		      '#LastNo.PersonNo#',
		      '#LastNo.ApplicantNo#', 
	          '#DateFormat(Now(),CLIENT.DateSQL)#',
			  '0',
			  '#LastNo.PHPSource#',		 
			  '#eMailAddress#',
			  '001',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#'
			  )
     </cfquery>

</cfloop>
    
<!--- ---------------------- --->  
<!--- ---current contract--- --->
<!--- ---------------------- --->
  
<cf_droptable dbname="AppsEmployee" tblname="skPersonContract">
  		   
<cfquery name="LastGrade2" 
    datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  G.*,
	        P.IndexNo, 
			S.Description as PersonStatusDescription, 
			P.PersonStatus
	INTO  	dbo.skPersonContract	
	FROM	PersonContract G, 
	        Person P,
			Ref_Personstatus S,
			(	SELECT   IndexNo, 
				         MAX(PC.Created) AS Posted			
				FROM     PersonContract PC, Person P
				WHERE    PC.PersonNo = P.PersonNo
				AND      ActionStatus != '9' 						 
				GROUP BY IndexNo ) 
			as C
			
	WHERE 	P.IndexNo      = C.IndexNo
	AND     G.PersonNo     = P.PersonNo
	AND     P.PersonStatus = S.Code
	AND     G.Created      = C.Posted 
	AND     P.Operational  = 1
	AND     G.ActionStatus != '9'		
</cfquery> 

<!--- create index --->

<cfquery name="IndexNo" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE  INDEX [IndexNo] 
		   ON dbo.skPersonContract([IndexNo]) ON [PRIMARY]
		</cfquery>			

<cfquery name="IndexNo" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE  INDEX [PersonNo] 
		   ON dbo.skPersonContract([PersonNo]) ON [PRIMARY]
		</cfquery>				

<cf_droptable dbname="AppsQuery" tblname="tmpContract">
  
  