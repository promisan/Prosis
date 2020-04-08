<!--- 2019 transition --->

<!---since positionParent does a cascade delete over position, we reset the assignments in case there are --->


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
				'DPPA-DPO','DOS','HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY'
			)
			AND MandateNo = 'P001'
		)
			
	)
	AND AssignmentStatus !='9'
</cfquery>

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
				'CAAC','OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA'
			)
			AND MandateNo = 'P002'
		)
			
	)
	AND AssignmentStatus !='9'
</cfquery>

<cfquery name="reset001" 
	datasource="AppsEmployee">	
	DELETE FROM PositionParent
	WHERE Mission IN (
		'DPPA-DPO','DOS','HSU','OAJ','OMS','UNCCD_NY','UNCCD-NY','UNETHICS','UNGCO','UNOP','UNODC_NY','UNODC-NY'
	)
	AND MandateNo = 'P001'
</cfquery>	


<cfquery name="reset002" 
	datasource="AppsEmployee">	
	DELETE FROM PositionParent
	WHERE Mission IN (
		'CAAC','OSESGH','OSRSG-SVC','OSRSG-VAC', 'SC_SEA','VRA'
	)
	AND MandateNo = 'P002'
</cfquery>	

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
			M.SourcePostNumber, '01/01/2019', '12/31/2050', 
			M.FromNovaPositionNo, 
			PP.ApprovalDate, PP.ApprovalReference, PP.ApprovalPostGrade, PP.ApprovalLocationCode, 
			PP.Fund, 'fodnyhv1', 'Van Pelt', 'Hanno'
	FROM    PositionParent AS PP INNER JOIN
	        Position AS P ON PP.PositionParentId = P.PositionParentId INNER JOIN
	        _Mapping2019 AS M ON P.PositionNo = M.FromNovaPositionNo	
	WHERE   NovaOrgUnit is not NULL 
	AND     FromNovaPositionNo is not NULL	
				
						  
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
			M.SourcePostNumber, '01/01/2019', '12/31/2050', 
			'0',
			M.FromNovaPositionNo, 
			P.DisableLoan,
			P.Remarks,
			'fodnyhv1', 'Van Pelt', 'Hanno'
			
	FROM    PositionParent AS PP INNER JOIN
	        Position AS P ON PP.PositionParentId = P.PositionParentId INNER JOIN
	        _Mapping2019 AS M ON P.PositionNo = M.FromNovaPositionNo	
	WHERE   NovaOrgUnit is not NULL 
	AND     FromNovaPositionNo is not NULL			
						  
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
			  W.PositionId, '01/01/2019', '12/31/2050',
			  'fodnyhv1','Van Pelt','Johannes'	 	          		
								
	 FROM      NYVM1618.EnterpriseHub.dbo.WhsPositionCurrent AS W INNER JOIN
               NYVM1618.EnterpriseHub.dbo._NovaMappingType AS MT ON W.PostType = MT.PositionType AND W.PostGrade = MT.PositionGrade INNER JOIN
               NYVM1618.EnterpriseHub.dbo.Ref_Job AS J ON W.JobCode = J.JobCode INNER JOIN
               _Mapping2019 M ON W.PositionId = M.SourcePostNumber
    WHERE      M.FromNovaPositionNo IS NULL 
	AND        M.NovaOrgUnit IS NOT NULL
			  
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
			  '12/31/2050',
			  '0',
			  'Loaded from Umoja for new entity',
			  'fodnyhv1','Van Pelt','Johannes'	          		
								
	 FROM      NYVM1618.EnterpriseHub.dbo.WhsPositionCurrent AS W INNER JOIN
               NYVM1618.EnterpriseHub.dbo._NovaMappingType AS MT ON W.PostType = MT.PositionType AND W.PostGrade = MT.PositionGrade INNER JOIN
               NYVM1618.EnterpriseHub.dbo.Ref_Job AS J ON W.JobCode = J.JobCode INNER JOIN
               _Mapping2019 M ON W.PositionId = M.SourcePostNumber
    WHERE      M.FromNovaPositionNo IS NULL 
	AND        M.NovaOrgUnit IS NOT NULL	
	
</cfquery>		

<!--- load person (only temp measure for DOS --->

<!--- we obtain from Nova the positions that were created for DOS for the position listed in the table
and combine with the person no --->


<!---- we need to reset the previously loaded Assignments for Alex. ---->

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
			   'Loaded for Alex',
			   'fodnyhv1',
			   'Van Pelt',
			   'Hanno'
	FROM       Position AS P INNER JOIN
	                      _Mapping2019 AS M ON P.SourcePostNumber = M.SourcePostNumber
	WHERE     P.Mission IN ('DOS','DPPA-DPO')
	AND       M.Mission IN ('DOS','DPPA-DPO') 
	AND       M.NovaPersonNo IS NOT NULL
	AND EXISTS (
		SELECT 'X' FROM Employee.dbo.Person WHERE PersonNo = M.NovaPersonNo
   )

</cfquery>
 