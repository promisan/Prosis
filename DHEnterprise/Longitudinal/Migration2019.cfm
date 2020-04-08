<!--- 2019 transition --->

<!---since positionParent does a cascade delete over position, we reset the assignments in case there are 
removed temporarily as I am only loading missing from Ruy--->
<!-----

<cfquery name="resetAssignmentsP001" 
	datasource="AppsEmployee">	
	DELETE FROM PersonAssignment
	WHERE PositionNo in (
		SELECT PositionNo 
		FROM	Employee.dbo.Position 
		WHERE   PositionParentID IN (
			SELECT PositionParentId FROM
			PositionParent
			WHERE Mission IN (
				/*'DPPA-DPO'*/
				/*'DOS'*/
				/*,'HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY'*/
			)
			AND MandateNo = 'P001'
			AND OrgUnitOperational NOT IN (
				select orgunit from Organization.dbo.Organization where HierarchyCode like '05.%' and Mission ='DPPA-DPO'
			)
		)
			
	)
	AND AssignmentStatus !='9'
	
	xxxxxx
	
</cfquery>
------->

<cfquery name="resetAssignmentsP002" 
	datasource="AppsEmployee">	
	DELETE FROM PersonAssignment
	WHERE PositionNo in (
		SELECT PositionNo 
		FROM	Employee.dbo.Position 
		WHERE   PositionParentID IN (
			SELECT PositionParentId FROM
			PositionParent
			WHERE Mission IN (
				'CAAC'/*,'OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA'*/
			)
			AND MandateNo = 'P002'
		)
			
	)
	AND AssignmentStatus !='9'
	
</cfquery>

<!-----

<cfquery name="reset001" 
	datasource="AppsEmployee">	
	DELETE FROM PositionParent
	WHERE Mission IN (
		'DPPA-DPO'
		/*'DOS' */
		/*,'HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY'*/
	)
	AND MandateNo = 'P001'
	AND OrgUnitOperational NOT IN (
		select orgunit from Organization.dbo.Organization where HierarchyCode like '05.%' and Mission ='DPPA-DPO'
	)

</cfquery>	
---->

<cfquery name="reset002" 
	datasource="AppsEmployee">	
	DELETE FROM PositionParent
	WHERE Mission IN (
		'CAAC'/*,'OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA'*/
	)
	AND MandateNo = 'P002'
	
</cfquery>	
--->

<!-----
<cfquery name="resetAssignments" 
	datasource="AppsEmployee">	
	DELETE FROM PersonAssignment
	WHERE PositionNo in (
		SELECT PositionNo 
		FROM	Employee.dbo.Position 
		WHERE   PositionParentID IN (
			SELECT PositionParentId FROM
			PositionParent
			WHERE Mission IN ('OICT')
			AND   MandateNo = 'P003'
		)
			
	)
	AND AssignmentStatus !='9'
</cfquery>	

<cfquery name="reset" 
	datasource="AppsEmployee">	
	DELETE FROM PositionParent
	WHERE Mission IN ('OICT')
	AND   MandateNo = 'P003'
</cfquery>	
----->

<!--- load position already in Nova --->

<cfquery name="PositionParent" 
	datasource="AppsEmployee">		
	
	INSERT INTO PositionParent (
			Mission,MandateNo, 
			OrgUnitOperational, 
			FunctionNo, FunctionDescription, PostGrade, PostType, 
			SourcePostNumber, DateEffective, DateExpiration, 
			SourcePositionNo, 
			ApprovalDate, ApprovalReference, ApprovalPostGrade, ApprovalLocationCode, 
			Fund, OfficerUserId, OfficerLastName,OfficerFirstName )
	
	SELECT  M.Mission, 
			CASE	WHEN M.Mission ='OICT' THEN 'P003'
					WHEN M.Mission IN('DPPA-DPO','DOS','HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY') THEN 'P001'
					WHEN M.Mission IN('CAAC','OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA') THEN 'P002'
			ELSE
				'P001' 
			END AS MandateNo,
	        M.NovaOrgUnit, 
			PP.FunctionNo, 
	        PP.FunctionDescription, PP.PostGrade, PP.PostType, 
			M.SourcePostNumber, '01/01/2019', ISNULL(m.ExpDate,'2050-12-31'), 
			M.FromNovaPositionNo, 
			PP.ApprovalDate, PP.ApprovalReference, PP.ApprovalPostGrade, PP.ApprovalLocationCode, 
			PP.Fund, 'rfuentes', 'FUENTES', 'Ronmell'
	FROM    PositionParent AS PP INNER JOIN
	        Position AS P ON PP.PositionParentId = P.PositionParentId INNER JOIN
	        _MappingJan19 AS M ON P.PositionNo = M.FromNovaPositionNo	
	WHERE   NovaOrgUnit is not NULL 
	AND     FromNovaPositionNo is not NULL	
	AND        M.loadType IN ('4JAN19L3')
				
						  
</cfquery>					  

<cfquery name="Position" 
	datasource="AppsEmployee">		
	
	INSERT INTO Position (
	
	         PositionParentId, 
	         Mission, MandateNo, 
			 MissionOperational, 
			 OrgUnitOperational, 
			 LocationCode, 
             FunctionNo, FunctionDescription, PostGrade, PostType, PostClass, PostAuthorised, 
			 VacancyActionClass, Source, 
			 SourcePostNumber, DateEffective, DateExpiration, 
             PositionStatus, 
			 SourcePositionNo, 
			 DisableLoan, 
			 Remarks, 
			 OfficerUserId, OfficerLastName, OfficerFirstName
	
			)
		
	
	SELECT  (SELECT PositionParentId 
	         FROM   PositionParent 
			 WHERE  Mission = M.Mission 
			 AND    SourcePositionNo = M.FromNovaPositionno
			 AND    MandateNo = CASE WHEN M.Mission ='OICT' THEN 'P003'
									WHEN M.Mission IN('DPPA-DPO','DOS','HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY') THEN 'P001'
									WHEN M.Mission IN('CAAC','OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA') THEN 'P002'
								ELSE
									'P001' 
								END
			) as PositionParentId,
	        M.Mission, 
			CASE WHEN M.Mission ='OICT' THEN 'P003'
				WHEN M.Mission IN('DPPA-DPO','DOS','HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY') THEN 'P001'
				WHEN M.Mission IN('CAAC','OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA') THEN 'P002'
				ELSE
				'P001' 
				END AS MandateNo,
			M.Mission,
	        M.NovaOrgUnit, 
			P.LocationCode,
			P.FunctionNo, P.FunctionDescription, P.PostGrade, P.PostType, P.PostClass, P.PostAuthorised,
			P.VacancyActionClass, P.Source,
			M.SourcePostNumber, '01/01/2019', ISNULL(m.ExpDate,'2050-12-31'), 
			'0',
			M.FromNovaPositionNo, 
			P.DisableLoan,
			P.Remarks,
			'rfuentes', 'FUENTES', 'Ronmell'
			
	FROM    PositionParent AS PP INNER JOIN
	        Position AS P ON PP.PositionParentId = P.PositionParentId INNER JOIN
	        _MappingJan19 AS M ON P.PositionNo = M.FromNovaPositionNo	
	WHERE   NovaOrgUnit is not NULL 
	AND     FromNovaPositionNo is not NULL	
	AND        M.loadType IN ('4JAN19L3')
						  
</cfquery>	

<!--- load position outside  --->

<cfquery name="PositionParent" 
	datasource="AppsEmployee">	
	
	INSERT INTO PositionParent (
			Mission,MandateNo, 
			OrgUnitOperational, 
			FunctionNo, FunctionDescription, PostGrade, PostType, 
			SourcePostNumber, DateEffective, DateExpiration, 
			
			OfficerUserId, OfficerLastName,OfficerFirstName )
		
	SELECT   M.Mission, 
			CASE WHEN M.Mission ='OICT' THEN 'P003'
				WHEN M.Mission IN('DPPA-DPO','DOS','HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY') THEN 'P001'
				WHEN M.Mission IN('CAAC','OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA') THEN 'P002'
				ELSE
				'P001' 
				END AS MandateNo,
	         M.NovaOrgUnit,
			 
			 (CASE WHEN         
	           (SELECT   TOP 1 FunctionNo
	            FROM     Applicant.dbo.FunctionTitleGrade
	            WHERE    Reference = W.JobCode) is not NULL THEN 
				
				 (SELECT   TOP 1 FunctionNo
	            FROM     Applicant.dbo.FunctionTitleGrade
	            WHERE    Reference = W.JobCode) 
				
				ELSE '0001' END) AS FunctionNo,
					 
			  W.FunctionTitle,		
			  MT.NovaPostGrade,
		  	  MT.NovaPostType,
			  W.PositionId, '01/01/2019', ISNULL(m.ExpDate,'2050-12-31'),
			  'rfuentes','FUENTES','Ronmell'	 	          		
								
	 FROM      NYVM1618.EnterpriseHub.dbo.WhsPositionCurrent AS W INNER JOIN
               NYVM1618.EnterpriseHub.dbo._NovaMappingType AS MT ON W.PostType = MT.PositionType AND W.PostGrade = MT.PositionGrade INNER JOIN
               NYVM1618.EnterpriseHub.dbo.Ref_Job AS J ON W.JobCode = J.JobCode INNER JOIN
               _MappingJan19 M ON W.PositionId = M.SourcePostNumber
    WHERE      M.FromNovaPositionNo IS NULL 
	AND        M.NovaOrgUnit IS NOT NULL
	AND        M.loadType IN ('4JAN19L3')
			  
</cfquery>

<cfquery name="Position" 
	datasource="AppsEmployee">	

		INSERT INTO Position (
	
	         PositionParentId, 
	         Mission, MandateNo, 
			 MissionOperational, 
			 OrgUnitOperational, 
			 LocationCode, 
             FunctionNo, FunctionDescription, PostGrade, PostType, PostClass, PostAuthorised, 
			 VacancyActionClass, Source, 
			 SourcePostNumber, DateEffective, DateExpiration, 
             PositionStatus, 			 
			 Remarks, 
			 OfficerUserId, OfficerLastName, OfficerFirstName
	
			)
			
		SELECT  
		
		    (SELECT PositionParentId 
	         FROM   PositionParent 
			 WHERE  Mission = M.Mission 
			 AND    SourcePostNumber = W.PositionId
			 AND    MandateNo = CASE WHEN M.Mission ='OICT' THEN 'P003'
									WHEN M.Mission IN('DPPA-DPO','DOS','HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY') THEN 'P001'
									WHEN M.Mission IN('CAAC','OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA') THEN 'P002'
									ELSE
										'P001' 
									END 
			 ) as PositionParentId,
		
		        M.Mission,
				CASE WHEN M.Mission ='OICT' THEN 'P003'
						WHEN M.Mission IN('DPPA-DPO','DOS','HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY') THEN 'P001'
						WHEN M.Mission IN('CAAC','OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA') THEN 'P002'
					ELSE
						'P001' 
					END AS MandateNo,
				M.Mission,
	            M.NovaOrgUnit,
				'DFS002',
			         
	          	 (CASE WHEN         
	           (SELECT   TOP 1 FunctionNo
	            FROM     Applicant.dbo.FunctionTitleGrade
	            WHERE    Reference = W.JobCode) is not NULL THEN 
				
				 (SELECT   TOP 1 FunctionNo
	            FROM     Applicant.dbo.FunctionTitleGrade
	            WHERE    Reference = W.JobCode) 
				
				ELSE '0001' END) AS FunctionNo,
					 
			  LEFT(W.FunctionTitle,100),		
			  MT.NovaPostGrade,
		  	  MT.NovaPostType,
			  MT.NovaPostClass,
			  '1',
			  'Active', 'Umoja',
			  W.PositionId, 
			  '01/01/2019', 
			  ISNULL(m.ExpDate,'2050-12-31'),
			  '0',
			  'Loaded from Umoja for new entity',
			  'rfuentes','FUENTES','Ronmell'	          		
								
	 FROM      NYVM1618.EnterpriseHub.dbo.WhsPositionCurrent AS W INNER JOIN
               NYVM1618.EnterpriseHub.dbo._NovaMappingType AS MT ON W.PostType = MT.PositionType AND W.PostGrade = MT.PositionGrade INNER JOIN
               NYVM1618.EnterpriseHub.dbo.Ref_Job AS J ON W.JobCode = J.JobCode INNER JOIN
               _MappingJan19 M ON W.PositionId = M.SourcePostNumber
    WHERE      M.FromNovaPositionNo IS NULL 
	AND        M.NovaOrgUnit IS NOT NULL
	AND        M.loadType IN ('4JAN19L3')
	
</cfquery>		

<!--- load person (only temp measure for DOS --->

<!--- we obtain from Nova the positions that were created for DOS for the position listed in the table
and combine with the person no --->


<!---- we need to reset the previously loaded Assignments for Alex. 
<!-------AVOID
AVOID
AVOID This one, use the one in LoadPostsPendingAssignment used for GUDRUN SCBD 
------>
<cfquery name="Assignment" 
	datasource="AppsEmployee">	
	
	INSERT INTO PersonAssignment
	
	      (PersonNo, 
		  PositionNo, 
		  DateEffective, DateExpiration, 
		  OrgUnit, 
		  LocationCode, 
		  FunctionNo, FunctionDescription, 
		  AssignmentStatus, 
		  AssignmentClass, 
		  Incumbency, 
		  Source, 
		  Remarks, 
		  OfficerLastName, OfficerFirstName, OfficerUserId)
	
	
	SELECT     M.NovaPersonNo, 
	           P.PositionNo, 
			   '01/01/2019' AS Expr1, 
			   '12/31/2019' AS Expr2, 
			   P.OrgUnitOperational, 
			   P.LocationCode, 
			   P.FunctionNo, 
			   ISNULL(P.FunctionDescription,'Undefined'), 
	           '0', 
			   'Regular', 
			   '100', 
			   'Umoja', 
			   'Loaded for Alexander SOKOL',
			   'rfuentes',
			   'FUENTES',
			   'Ronmell'
	FROM       Position AS P INNER JOIN
	                      _MappingJan19 AS M ON P.SourcePostNumber = M.SourcePostNumber
							AND MandateNo = CASE WHEN M.Mission IN ('DOS','DPPA-DPO') THEN 'P001' WHEN M.Mission = 'OICT' THEN 'P003' ELSE 'P001' END 
	WHERE     P.Mission IN ('DOS','DPPA-DPO','OICT')
	AND       M.Mission IN ('DOS','DPPA-DPO','OICT') 
	AND       M.NovaPersonNo IS NOT NULL
	AND EXISTS (
		SELECT 'X' FROM Employee.dbo.Person WHERE PersonNo = M.NovaPersonNo
   )
   AND        M.loadType IN ( '4JAN19L1')

</cfquery>
 
 
 ---->