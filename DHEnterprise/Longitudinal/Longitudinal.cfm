

<!--- batch to prepare dataset for Longitudinal inquiry through Nova for post incumbency and contract
which is positioned in 1617 

The basis is a file with dates to be constructed

	The process will generate content for each selection date
	The process will aspply various corrections for easy inquiry
	
	next selection date

--->

<!----always keep last 5 months ---->
<cfquery name="UPDPeriod" 
	datasource="MartStaffing">		 
		UPDATE Period
		SET Status = '5'
		WHERE Datamart = 'Gender'
		AND SelectionDate IN (
			SELECT TOP 5 SelectionDate FROM Period WHERE DataMart = 'Gender' AND Status !='0' ORDER  BY SelectionDate DESC
		)
</cfquery>


<!---- 
31-Oct-2019 >>halloween threat<<
changed based on the request:
Gender Team: data Static for 1 month, every 1st day of the month must be refreshed.
EO Team: deta dynamic, every day must be refreshed.

we add field: periodicity so.
every day in execution check:
	IF first Day of the month, THEN
		Truncate all data, refresh fully the content.
	ELSE
		Truncate Data WHERE periodicity = 'month'
	END

Proceed with Loading contents
	Load normal DAILY
	IF first Day of the Month, THEN
		Load copy of Daily with Flag='month', this will incorporate new changes, and be kept for the current month, until next execution
	END

**Properly ADD Periodicity as part of the filters in Dashboard **	

---->

<cfquery name="getSpecialP" 
	datasource="MartStaffing">		 
		SELECT TOP 1 *
		FROM Period
		WHERE Datamart = 'Gender'
		AND	  Status = '0'
		AND   Filter = '''DPPA-DPO'''
		ORDER BY SelectionDate DESC
</cfquery>

<cfif getSpecialP.recordCount lte 0>
	<!--- no record, create as the validation will be later ---->
	
	<cfquery name="getSpecialP" 
	datasource="MartStaffing">		 
		INSERT INTO Period(DataMart, SelectionDate, Status, Filter)
		VALUES ('Gender',GETDATE()-1,'0','''DPPA-DPO''')
	</cfquery>
	
	<cfelse>
	
		<cfquery name="updateYesterday" 
		datasource="MartStaffing">		 
			UPDATE Period
			SET SelectionDate = GETDATE()-1
			WHERE DataMart = 'Gender'
			AND   Status  = '0'
			AND   Filter = '''DPPA-DPO'''
		</cfquery>
</cfif>

<cfquery name="getSP" 
datasource="MartStaffing">		 
		SELECT ABS( DATEDIFF(Day, SelectionDate, (DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, getDAte()) + 1, 0))))) as DayDiff
		FROM            Period
		WHERE        (Status = '0') 
		AND	 Filter =	'''DPPA-DPO'''
</cfquery>
		
<cfif getSP.DayDiff lte 1 >
	<!---remove this record as it might be 1 day before or after the end of the month, no need to update as it was done before --->
	<cfquery name="getSP" 
	datasource="MartStaffing">		 
		DELETE FROM Period
		WHERE        (Status = '0') 
		AND 		Filter = '''DPPA-DPO'''
	</cfquery>
</cfif>

<cfquery name="isFirstDay" 
datasource="MartStaffing">		 
		SELECT DAY(GetDATE()) AS DayOfTheMonth
</cfquery>

<cfset thisFirstDay	="No">

<cfif isFirstDay.DayOfTheMonth eq "1">
	<cfset thisFirstDay	= 	"yes">
</cfif>



<cfquery name="getPeriod" 
	datasource="MartStaffing">		 
		SELECT *
		FROM Period
		WHERE Datamart = 'Gender'
		ORDER BY SelectionDate DESC
</cfquery>

<!--- ------------------------------------------------ --->
<!--- special measures to be embedded in the Hub later --->
<!--- ------------------------------------------------ --->


<cfquery name="applyPeriod" 
	datasource="hubEnterprise">	

UPDATE    MissionOrganization
SET       PresentationLevel1 = M.Presentationlevel1
FROM      Mapping_PresentationLevel M INNER JOIN
          MissionOrganization AS MO ON M.Mission = MO.Mission AND M.OrgUnitId = MO.OrgUnitId
WHERE     MO.Mission IN ('UN-DFS-EO','UN-DPKO-EO','DPPA-DPO','DOS','SCBD')

</cfquery>

<cfquery name="applyPeriod" 
	datasource="hubEnterprise">	

UPDATE    MissionOrganization
SET       PresentationLevel1 = 'OCT'
WHERE     Mission IN ('OCT')

UPDATE    MissionOrganization
SET       PresentationLevel1 = 'UNOV'
WHERE     Mission IN ('UNOV')

UPDATE    MissionOrganization
SET       PresentationLevel1 = 'OICT'
WHERE     Mission IN ('OICT')

</cfquery>

<!--- ------------------------------------------------ --->
<!--- ------------------------------------------------ --->
<!--- ------------------------------------------------ --->

<!--- generate data mart --->

<cfset hub = "NYVM1618.EnterpriseHub.dbo.">

<!--- special temp case to tag on-secondment positions --->
<!------
0 - day
1 - Month

for the sake of the 'tranquility' of all involved, we generate a report as logFile for the records that changed. criteria are:
* changed tag
* new posts.
* deleted posts.
* PostGrade, WorkingGrade, ContractGrade changes.

----->

<cfif thisFirstDay eq "yes">

	<cfquery name="TagChanges" 
	datasource="MartStaffing">
		SELECT  DISTINCT
			G1.PositionId, REPLACE(G1.Mission,'- ','') as newPillar,
			REPLACE(G2.Mission,'- ','') as oldPillar
		FROM MartStaffing.dbo.Gender as G1
				INNER JOIN MartStaffing.dbo.Gender as G2
					ON G2.PositionId		= G1.PositionId
					AND G2.SelectionDate	= G1.SelectionDate
					AND G2.TransactionType 	= '1'
					AND G2.AppointmentType	= G1.AppointmentType
					AND G2.ContractTerm		= G1.ContractTerm
					AND EXISTS (
							SELECT 'X' 
							FROM MartStaffing.dbo.Period as P
							WHERE P.Status = '5'
							AND P.SelectionDate  = G2.SelectionDate
					)
					AND G2.Mission			!= G1.Mission
					AND G2.MissionLabel		= G1.MissionLabel
					AND G2.Mission			!='DPPA-DPO'
		WHERE 1=1
			AND EXISTS (
					SELECT 'X' 
					FROM MartStaffing.dbo.Period as P
					WHERE P.Status IN ( '5','0')
					AND P.SelectionDate  = G1.SelectionDate
						)
			AND G1.TransactionType 		= '0'
			AND G1.MissionLabel 		= 'DPPA-DPO'
			AND G1.Mission 				!='DPPA-DPO'
			AND G1.Incumbency 			='100'
	</cfquery>
	
	<cfquery name="newPosts" 
	datasource="MartStaffing">
		SELECT  DISTINCT
				G1.PositionId, REPLACE(G1.Mission,'- ','') as newPillar
		FROM MartStaffing.dbo.Gender as G1
		WHERE 1=1
			AND EXISTS (
					SELECT 'X' 
					FROM MartStaffing.dbo.Period as P
					WHERE P.Status IN ( '5','0')
					AND P.SelectionDate  = G1.SelectionDate
				)
		AND G1.TransactionType	= '0'
		AND G1.MissionLabel		= 'DPPA-DPO'
		AND G1.Mission			!='DPPA-DPO'
		AND G1.Incumbency		='100'
		AND NOT EXISTS (
				SELECT 'X' 
					FROM MartStaffing.dbo.Gender as G2
					WHERE G2.TransactionType = '1'
					AND EXISTS (
						SELECT 'X' 
							FROM MartStaffing.dbo.Period as P
							WHERE P.Status = '5'
							AND P.SelectionDate  = G2.SelectionDate
						)
					AND G2.PositionId		= G1.PositionId
					AND G2.MissionLabel		= G1.MissionLabel
		) 
	</cfquery>
	
	<cfquery name="deletedPosts" 
	datasource="MartStaffing">
		SELECT  DISTINCT
			G1.PositionId, REPLACE(G1.Mission,'- ','') as newPillar
		FROM MartStaffing.dbo.Gender as G1
		WHERE 1=1
			AND EXISTS (
				SELECT 'X' 
					FROM MartStaffing.dbo.Period as P
				WHERE P.Status IN ( '5')
				AND P.SelectionDate  = G1.SelectionDate
				)
			AND G1.TransactionType = '1'
			AND G1.MissionLabel = 'DPPA-DPO'
			AND G1.Mission !='DPPA-DPO'
			AND G1.Incumbency ='100'
			AND NOT EXISTS (
					SELECT 'X' 
					FROM MartStaffing.dbo.Gender as G2
					WHERE G2.TransactionType = '0'
					AND EXISTS (
							SELECT 'X' 
							FROM MartStaffing.dbo.Period as P
							WHERE P.Status IN ( '5','0')
							AND P.SelectionDate  = G2.SelectionDate
					)
					AND G2.PositionId		= G1.PositionId
					AND G2.MissionLabel		= G1.MissionLabel
			) 
	</cfquery>
	
	<cfquery name="changedData" 
	datasource="MartStaffing">
		SELECT  
				G1.PositionId, 
				G1.PositionGrade as oldPostGrade,
				G2.PositionGrade as newPostGrade,
				G1.GradeContract as oldGradeContract,
				G2.GradeContract as newGradeContract,
				G1.GradeWorking  as oldGradeWorking,
				G2.GradeWorking  as newGradeWorking
		FROM MartStaffing.dbo.Gender as G1
			INNER JOIN MartStaffing.dbo.Gender as G2
				ON G2.PositionId		=	G1.PositionId
				AND G2.MissionLabel		=	G1.MissionLabel
				AND G2.PositionGrade	!=	G1.PositionGrade
				AND G2.GradeContract	!=	G1.GradeContract
				AND G2.GradeWorking		!=	G1.GradeWorking
				AND G2.TransactionType	=	'1'
		WHERE 1=1
			AND EXISTS (
					SELECT 'X' 
					FROM MartStaffing.dbo.Period as P
					WHERE P.Status IN ( '5','0')
					AND P.SelectionDate  = G1.SelectionDate
				)
		AND G1.TransactionType	= '0'
		AND G1.MissionLabel		= 'DPPA-DPO'
		AND G1.Mission			!='DPPA-DPO'
		AND G1.Incumbency		='100'
	</cfquery>

</cfif>


<cfquery name="clean" 
	datasource="MartStaffing">
		<cfif thisFirstDay	eq "yes">
			TRUNCATE Table MartStaffing.dbo.Gender	
		<cfelse>
			DELETE FROM MartStaffing.dbo.Gender WHERE TransactionType	=	'0'
		</cfif>
</cfquery>

<cfquery name="cleanSpecCBD" 
	datasource="MartStaffing">
		DELETE FROM MartStaffing.dbo.Gender WHERE Mission = 'SCBD' <!---regardless of transtype, later we update to 1 for all records ---->
</cfquery>

<cfquery name="clean" 
	datasource="MartStaffing">		 
		TRUNCATE Table MartStaffing.dbo.Position		
</cfquery>

<cfloop query="getPeriod">

	<cfset dte = selectiondate>
	
    <cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(dte,CLIENT.DateFormatShow)#">
	<cfset seldate = dateValue>
		
	<cfsavecontent variable="MissionOrg">
	<cfoutput>
	  SELECT     MO.*
	  FROM       #Hub#MissionOrganization AS MO INNER JOIN
                     (SELECT     Mission, MAX(DateEffective) AS DateEffective
                      FROM       #Hub#MissionOrganization
                      WHERE      DateEffective <= #seldate#
                      GROUP BY   Mission) AS ML ON MO.Mission = ML.Mission AND MO.DateEffective = ML.DateEffective	
	</cfoutput>				  
	</cfsavecontent>
			
	<cfquery name="applyPeriodGender" 
		datasource="MartStaffing">		
		
		INSERT INTO MartStaffing.dbo.Gender
		
				 (SelectionDate, 
				  Mission,
				  MissionLabel,
				  MissionParent,
				  MissionParentOrder,
				  
				  OrgUnitId, 
				  OrgUnitName, 
				  OrgUnitNameShort, 
				  OrgHierarchy, 
				  
				  PositionId, 
				  PositionGrade, 
				  PositionSeconded, 
				  PositionType,	
				  PositionTypeName,
				 
				  Location, 
				  JobCode, 
				  JobCodeName,
				  
				  AssignmentType, 
				  AssignmentTypeName,
				  
			      AppointmentType, 
				  AppointmentTypeName,
				  
				  ContractTerm, 
				  ContractTermName,
				  
				  Fund,
				  Incumbency, 	   
				  IndexNo, LastName, MiddleName, FirstName, Gender, 
				  NationalityCode, Country, LocationCountry,
				  DOB, MaritalStatus, 
			      EmailAddress, EODUN, 
				  GradeContract, 
				  GradeWorking, 
				  Source)
		
		SELECT     '#dte#', 
		           
		           M.MissionLabel,
				   M.MissionLabel as Mission,
				   MO.PresentationLevel1,		
				   (SELECT PresentationOrder
				   FROM   #hub#MissionPresentation
				   WHERE  Mission = M.Mission
				   AND    PresentationLevel = MO.PresentationLevel1) as Sorting,
		
				   PA.OrgUnitId, 
				   MO.OrgUnitName, 
	               MO.OrgUnitNameShort,
				   MO.OrgHierarchy,    		   
				  
				   PA.PositionId, 
				   PO.PositionGrade,
				   0 AS PositionSeconded,
				   PO.PositionType,
				   
				   (SELECT    PostTypeName
				    FROM      #hub#Ref_PostType
					WHERE     PostType = PO.PositionType),			   
				
				   PA.Location, 
				   P.JobCode, 
				   
				   (SELECT    JobDescription
				    FROM      #hub#Ref_Job
					WHERE     JobCode = P.JobCode),		
				   
				   PA.AssignmentType,			   
				   
				   
			       (SELECT    AssignmentTypeName
				    FROM      #hub#Ref_AssignmentType
					WHERE     AssignmentType = PA.AssignmentType),						   
				   
				   (SELECT    TOP (1) AppointmentType
	                FROM      #hub#PersonAppointment AS PAPP
	                WHERE     TransactionStatus = '1' 
	                AND       DateEffective    <= '#dte#'
	                AND       IndexNo           = PA.IndexNo 
	                AND       TransactionLevel  = '2'
	                ORDER BY  DateEffective DESC) AS AppointmentType,      
					
				   (SELECT    TOP (1) R.AppointmentTypeName
	                FROM      #hub#PersonAppointment AS PAPP INNER JOIN NYVM1618.EnterpriseHub.dbo.Ref_ContractType R ON PAPP.AppointmentType = R.AppointmentType
	                WHERE     TransactionStatus = '1' 
	                AND       DateEffective    <= '#dte#'
	                AND       IndexNo           = PA.IndexNo 
	                AND       TransactionLevel  = '2'
	                ORDER BY  DateEffective DESC) AS AppointmentTypeName,   
					
					  (SELECT    TOP (1) ContractTerm
	                FROM      #hub#PersonAppointment AS PAPP
	                WHERE     TransactionStatus = '1' 
	                AND       DateEffective    <= '#dte#'
	                AND       IndexNo           = PA.IndexNo 
	                AND       TransactionLevel  = '2'
	                ORDER BY  DateEffective DESC) AS ContractTerm,      
					
				   (SELECT    TOP (1) R.ContractTermDescription
	                FROM      #hub#PersonAppointment AS PAPP INNER JOIN NYVM1618.EnterpriseHub.dbo.Ref_ContractTerm R ON PAPP.ContractTerm = R.ContractTerm
	                WHERE     TransactionStatus = '1' 
	                AND       DateEffective    <= '#dte#'
	                AND       IndexNo           = PA.IndexNo 
	                AND       TransactionLevel  = '2'
	                ORDER BY  DateEffective DESC) AS ContractTermName,
	                
	               (SELECT    TOP (1) CBFund 
					FROM      #hub#PositionFunding
					WHERE     TransactionStatus = '1'
					AND       DateEffective    <= '#dte#'
					AND       PositionId        = PO.PositionId
					ORDER BY  DateEffective DESC) as Fund,   
															
				   PA.Incumbency,                
				  			   			
				   PA.IndexNo,    
				   PER.LastName, 
				   PER.MiddleName, 
				   PER.FirstName, 
				   PER.Gender, 
				   PER.NationalityCode, 
				   (SELECT Country
				    FROM   #hub#Ref_Country
					WHERE  Code = PER.NationalityCode) as Country,
				   (SELECT PresentationLevel1
				    FROM   #hub#Ref_Country
					WHERE  Code = PER.NationalityCode) as PresentationLevel1,
				   PER.DOB, 
				   PER.MaritalStatus, 
				   
				   PER.EmailAddress, 
	               PER.EODUN, 		  
	               
	                ISNULL((SELECT   TOP (1) Grade
	                 FROM     #hub#PersonGrade AS G
	                 WHERE    IndexNo       = PA.IndexNo 
	                 AND      GradeClass    != 'SPA' 
	                 AND      DateEffective <= '#dte#' 
	                 AND      TransactionStatus = '1' 
	                 AND      Source        = 'Umoja'
	                 ORDER BY DateEffective DESC),'Undefined') AS PersonGrade, 	 
	                            
	                (SELECT    TOP (1) Grade
	                  FROM     #hub#PersonGrade AS G
	                  WHERE    IndexNo = PA.IndexNo 
	                  AND      GradeClass     = 'SPA' 
	                  AND      (DateEffective <= '#dte#') and DateExpiration >= '#dte#'
	                  AND      TransactionStatus = '1' 
	                  AND      Source         = 'Umoja'
	                  ORDER BY DateEffective DESC) AS PersonSPAGrade,                      
	                 
					  PA.Source 	
					  
			FROM      #hub#PositionOrganization            AS P INNER JOIN
                      #hub#PersonAssignment                AS PA ON P.PositionId = PA.PositionId INNER JOIN
                      #hub#Position                        AS PO ON PO.PositionId = PA.PositionId INNER JOIN
                      #hub#Person                          AS PER ON PER.IndexNo = PA.IndexNo INNER JOIN
                      #hub#Mission                         AS M INNER JOIN
                      (#preserveSingleQuotes(MissionOrg)#) AS MO ON M.Mission = MO.Mission ON P.OrgUnit = MO.OrgUnitId		  	  
	       					  
			WHERE     PA.AssignmentType    <> 'ZA'
			AND       PA.TransactionStatus = '1' 
			AND       PA.Source            = 'Umoja' 
			AND       PA.DateEffective <= '#dte#' AND PA.DateExpiration >= '#dte#'
			
			AND       P.TransactionStatus  = '1' 
			AND       P.DateEffective <= '#dte#'  AND P.DateExpiration  >= '#dte#'
			
			AND       M.MissionLabel IN (#preserveSingleQuotes(filter)#) 
						
			AND       MO.Relationship = 'Operational'
			AND       MO.PresentationLevel1 is not NULL		
				
		</cfquery>	
		
		<cfsavecontent variable="whsPositionDate">

		<cfoutput>		
				
			SELECT Org.PositionId,   
			       MO.Mission,  
			       P.DateEffective,
			       P.DateExpirationFund,
			       P.DateExpiration,
			       Org.CenterOwner,		
			       Org.OrgUnit,
			       MO.OrgUnitName,
			       MO.OrgUnitNameShort,
			       MO.OrgHierarchy,
			       Org.DutyStation,				
			       Org.JobCode,	
				   (SELECT TOP (1) F.FunctionDescription
				    FROM NYVM1617.Applicant.dbo.FunctionTitle AS F
				         INNER JOIN NYVM1617.Applicant.dbo.FunctionTitleGrade AS G ON F.FunctionNo = G.FunctionNo
				    WHERE F.FunctionClass = 'Umoja'
			        AND   G.Reference = Org.JobCode
     				) AS FunctionTitle,
					
		     	   (SELECT TOP (1) O.Description
				     FROM  NYVM1617.Applicant.dbo.FunctionTitle AS F
				           INNER JOIN NYVM1617.Applicant.dbo.FunctionTitleGrade AS G ON F.FunctionNo = G.FunctionNo
				           INNER JOIN NYVM1617.Applicant.dbo.OccGroup AS O ON F.OccupationalGroup = O.OccupationalGroup
				     WHERE F.FunctionClass = 'Umoja'
			         AND   G.Reference = Org.JobCode
				    ) AS FunctionFamily,
					
				   (SELECT TOP (1) PG.Description
				     FROM  NYVM1617.Applicant.dbo.FunctionTitle AS F
				           INNER JOIN NYVM1617.Applicant.dbo.FunctionTitleGrade AS G ON F.FunctionNo = G.FunctionNo
				           INNER JOIN NYVM1617.Applicant.dbo.OccGroup AS O ON F.OccupationalGroup = O.OccupationalGroup
				           INNER JOIN NYVM1617.Applicant.dbo.OccGroup AS PG ON PG.OccupationalGroup = O.ParentGroup						  
				     WHERE F.FunctionClass = 'Umoja'
			         AND   G.Reference = Org.JobCode ) AS FunctionNetwork,
					 
				    Org.JobId,
				    Mod.PostGrade,
				    Gr.ListingOrder AS PostOrder, 
				
				    Mod.EmployeeGroup,
				    Mod.EmployeeSubGroup,
				    Mod.PostType,
				    Mod.PostNature,
				    Fnd.BudgetPeriod,
				    Fnd.CBFund,
				    Fnd.CBCostCenter,
				    Fnd.CBFunctionalArea,
				    Fnd.CBWBse,
				    Fnd.CBLines
		 
			FROM #hub#Ref_PostGrade AS Gr INNER JOIN	(
			
			    SELECT  PositionId,
			            PostGrade,
			            EmployeeGroup,
			            EmployeeSubGroup,
			            PostType,
			            PostNature
			    FROM    #hub#PositionModality AS M
			    WHERE   DateEffective <= '#dte#' 
			     AND    DateExpiration >= '#dte#'
			     AND    TransactionStatus = '1') AS Mod ON Gr.PostGrade = Mod.PostGrade
			 
			 RIGHT OUTER JOIN (
			 
			      SELECT PositionId,
			             CenterOwner, 
			             OrgUnit,
     	                 DutyStation,  
			             JobCode,
			             JobId
		  	      FROM   #hub#PositionOrganization AS O
			      WHERE  DateEffective  <= '#dte#'
			       AND   DateExpiration >= '#dte#'
			       AND   TransactionStatus = '1') AS Org 
				 
			 INNER JOIN #hub#Position AS P ON Org.PositionId = P.PositionId
			 
		     INNER JOIN (
			 
				  SELECT PositionId,
				         BudgetPeriod,
				         CBFund,
				         CBCostCenter,
				         CBFunctionalArea,
				         MAX(CBWBse) AS CBWBse,
				         COUNT(*) AS CBLines
				  FROM   #hub#PositionFunding
				  WHERE  DateEffective  <= '#dte#'
				   AND   DateExpiration >= '#dte#'
				   AND   TransactionStatus = '1'	 
				  GROUP BY PositionId,
				           BudgetPeriod,
				           CBFund,
				           CBCostCenter,
				           CBFunctionalArea ) AS Fnd ON Org.PositionId = Fnd.PositionId
				           
			INNER JOIN (#preserveSingleQuotes(MissionOrg)#) AS MO ON Org.OrgUnit = MO.OrgUnitId	 ON Mod.PositionId = Org.PositionId         
			
			WHERE MO.Mission IN ('UNEP','SCBD','DOS','OICT')
					 
			GROUP BY Org.PositionId,
			         Mo.Mission,
			         Org.OrgUnit,
			         Org.DutyStation,
			         Org.JobCode,
			         Org.JobId,
			         Org.CenterOwner,
			         Mod.PostGrade,
			         Mod.EmployeeGroup,
			         Mod.EmployeeSubGroup,
			         Mod.PostType,
			         Mod.PostNature,
			         Fnd.BudgetPeriod,
			         Fnd.CBFund,
			         Fnd.CBCostCenter,
			         Fnd.CBFunctionalArea,
			         Fnd.CBWBse,
			         Fnd.CBLines,
			         P.DateEffective,
			         P.DateExpirationFund,
			         P.DateExpiration,
			         MO.OrgUnitName,
			         MO.OrgUnitNameShort,
			         MO.OrgHierarchy,
			         Gr.ListingOrder
		
		
				
			</cfoutput>		
			  
	</cfsavecontent>	
	
	
	
	<cfset pst = "WhsPositionCurrent">
	
	<cfquery name="applyPeriodPosition" 
		datasource="MartStaffing">		
		
		INSERT INTO MartStaffing.dbo.Position (
			
			  SelectionDate, 
			  Mission, 			  
			  PositionId, IndexNo, LastName, FirstName, Nationality, DOB, EODUN, EODSecretariat, Gender, EmailAddress, 
              ContractExpiry, ContractLevel, ContractStep, 
			  DateEffective, DateExpiration, 
			  Incumbency, Location, AssignmentType, IncumbencyStatus, JobCodeBudget, JobCode, 
              FunctionTitle, FunctionFamily, FunctionNetwork, PostType, PostTypeName, PostGrade, PostOrder, OrgUnitBudget, OrgUnitNameBudget, OrgUnitNameShortBudget, 
              HierarchyCodeBudget, OrgUnit, OrgUnitName, OrgUnitNameShort, 
			  HierarchyCode, CBFund, CBFunctionalArea, CBCostCenter, CBCostCenterName, CBWBSe, 
              PostEffective, PostExpiration,
			  FundingUmojaEffective, FundingUmojaExpiration		
			  		
			)					
						
			SELECT 		DISTINCT
			            '#dte#',	
			            P.Mission,		
						P.PositionId, 		
										
						A.IndexNo, 
						A.LastName, 
						
						A.FirstName, 
						A.Nationality, 
						A.DOB, 
						A.EODUN,
						A.EODSecretariat,	
						A.Gender,	
						A.EmailAddress,
						
						(SELECT   TOP 1 DateExpiration 
						FROM      #hub#PersonAppointment C 
						WHERE     C.IndexNo = A.IndexNo
						AND       C.TransactionStatus = '1'
						AND       C.TransactionLevel  = '1'
						AND       C.DateEffective    <= '#dte#'
						ORDER BY  C.DateExpiration DESC) as ContractExpiry,
						
						(SELECT   TOP 1 Grade 
						FROM      #hub#PersonGrade C 						
						WHERE     C.IndexNo           = A.IndexNo
						AND       C.TransactionStatus = '1'
						AND       C.DateEffective    <= '#dte#'
						ORDER BY  DateEffective DESC) as ContractLevel,		
						
						(SELECT   TOP (1) Step
                         FROM     #hub#PersonGrade AS C
                         WHERE    C.IndexNo           = A.IndexNo
						 AND      C.TransactionStatus = '1'
						 AND      C.DateEffective    <= '#dte#'
                         ORDER BY C.DateEffective DESC) as ContractStep,				
												
						A.DateEffective, 
						A.DateExpiration, 
						A.Incumbency,
						(SELECT DutyStationName 
						 FROM   #hub#Ref_Location 
						 WHERE  DutyStation = A.Location) as Location,						
	                    A.AssignmentType,
						'Incumbered' as IncumbencyStatus, 					
															
					( SELECT PositionJobcode
					  FROM   #Hub#Position
					  WHERE  PositionId = P.PositionId) as JobCodeBudget,
					
					P.JobCode,
					P.FunctionTitle,
					P.FunctionFamily,
					P.FunctionNetwork,													
					 
					P.PostType, 
					
					(SELECT   PostTypeName 
					 FROM     #Hub#Ref_PostType
					 WHERE    PostType = P.PostType) as PostTypeName,
					
					P.PostGrade, 
					P.PostOrder,
							
																	
				    P.OrgUnit          as OrgUnitBudget,
					P.OrgUnitName      as OrgUnitNameBudget, 
					P.OrgUnitNameShort as OrgUnitNameShortBudget, 
					P.OrgHierarchy     as HierarchyCodeBudget,
					
					(SELECT TOP 1 OrgUnit
					 FROM  #Hub##pst#Operational
					 WHERE PositionId = P.PositionId) as OrgUnit,
					
					(SELECT TOP 1 OrgUnitName
					 FROM  #Hub##pst#Operational
					 WHERE PositionId = P.PositionId) as OrgUnitName,
															 
					(SELECT TOP 1 OrgUnitNameShort
					 FROM  #Hub##pst#Operational
					 WHERE PositionId = P.PositionId) as OrgUnitNameShort,
					 
					(SELECT TOP 1 OrgHierarchy
					 FROM  #Hub##pst#Operational
					 WHERE PositionId = P.PositionId) as HierarchyCode, 
															
					P.CBFund, 
					P.CBFunctionalArea, 									
					P.CBCostCenter, 
					
					(SELECT CostCenterName
					 FROM   #hub#Ref_CostCenter
					 WHERE  CostCenter = P.CBCostCenter) as CBCostCenterName,	
					 				
					P.CBWBSe,
					
					<!---  P.CBWBSeName, --->
					P.DateEffective    as PostEffective,
					P.DateExpiration   as PostExpiration,
					
					(SELECT MIN(DateEffective)
					FROM  #hub#PositionFunding
					WHERE PositionId = P.PositionId
					AND   TransactionStatus = '1') as FundingUmojaEffective,
					
					(SELECT MAX(DateExpiration)
					FROM  #hub#PositionFunding
					WHERE PositionId = P.PositionId
					AND   TransactionStatus = '1') as FundingUmojaExpiration							
		
		FROM   		(#preserveSingleQuotes(whsPositionDate)#) AS P LEFT OUTER JOIN (		
		
					SELECT  SPA.PositionId,
					        SPA.Incumbency,
							SPA.Location,						
							SPA.AssignmentType,
							SPA.IndexNo, 
							SP.LastName, 
							SP.FirstName, 
							SP.Gender, 			
							SP.EmailAddress,			
							SP.Nationality, 
							SP.DOB, 				
							SP.EODUN,
							SP.EODSecretariat,		 
							SPA.DateEffective, 
							SPA.DateExpiration						
							
					FROM    #hub#PersonAssignment AS SPA INNER JOIN 
					        #hub#Person AS SP ON SPA.IndexNo = SP.IndexNo						
							
				    WHERE     SPA.DateEffective <= '#dte#' 
				
	                      AND      SPA.DateExpiration >= '#dte#'
						  AND      SPA.TransactionStatus != '9' 
						  AND      SPA.AssignmentType NOT IN ('SE','SL') 
												  				
					) as A ON P.PositionId = A.PositionId 	
															
		WHERE P.Mission IN ('UNEP','SCBD','DOS','OICT')	<!--- UNEP --->
		
		
						
	</cfquery>		
			
 
		
	<!--- create a copy of DPPA and DPO based on the different context of the post  --->
	
	<cfloop index="itm" list="01,02,03">
	
		<cfquery name="applyDPPA" 
		datasource="MartStaffing">	
		
			INSERT INTO Gender
			
			( SelectionDate, Mission, MissionLabel, MissionParent, MissionParentOrder, OrgUnitId, OrgUnitName, OrgUnitNameShort, OrgHierarchy, PositionId, 
			                      PositionGrade, PositionGradeOrder, PositionGradeParent, PositionType, PositionTypeName, PositionSeconded, Location, JobCode, JobCodeName, AssignmentType, 
			                      AssignmentTypeName, AppointmentType, AppointmentTypeName, ContractTerm, ContractTermName, Incumbency, IndexNo, GradeContract, GradeContractOrder, 
			                      GradeContractParent, GradeWorking, GradeWorkingOrder, GradeWorkingParent, LastName, MiddleName, FirstName, Gender,NationalityCode,Country,LocationCountry, DOB, 
			                      Age, AgeCluster, MaritalStatus, EmailAddress, EODUN, DateRetirement, Source, Fund, Created)
		
			SELECT     SelectionDate, <cfif itm eq "01">'- DPPA'<cfelseif itm eq "02">'- DPO'<cfelse>'- SS'</cfif>, MissionLabel, MissionParent, MissionParentOrder, OrgUnitId, OrgUnitName, OrgUnitNameShort, OrgHierarchy, PositionId, 
			                      PositionGrade, PositionGradeOrder, PositionGradeParent, PositionType, PositionTypeName, PositionSeconded, Location, JobCode, JobCodeName, AssignmentType, 
			                      AssignmentTypeName, AppointmentType, AppointmentTypeName, ContractTerm, ContractTermName, Incumbency, IndexNo, GradeContract, GradeContractOrder, 
			                      GradeContractParent, GradeWorking, GradeWorkingOrder, GradeWorkingParent, LastName, MiddleName, FirstName, Gender,NationalityCode, Country, LocationCountry, DOB, 
			                      Age, AgeCluster, MaritalStatus, EmailAddress, EODUN, DateRetirement, Source, Fund, Created
		
			FROM     Gender
			WHERE    Mission = 'DPPA-DPO'	
			AND      CONVERT(VARCHAR(20),PositionId) IN (
			
						SELECT    RTRIM(LTRIM(P.SourcePostNumber))
						FROM      NYVM1613.Employee.dbo.PositionParentGroup AS PPG INNER JOIN
				                  NYVM1613.Employee.dbo.PositionParent AS PP ON PPG.PositionParentId = PP.PositionParentId INNER JOIN
				                  NYVM1613.Employee.dbo.Position AS P ON PP.PositionParentId = P.PositionParentId
						WHERE     PPG.GroupCode = 'Usage' AND (PPG.GroupListCode = '#itm#')
						)
						
			AND  	SelectionDate = '#dte#'	
			AND TransactionType = '0'
		</cfquery>	
	
	</cfloop>
			
		
	<cfquery name="applyGradeWorking" 
	datasource="MartStaffing">	
		UPDATE  MartStaffing.dbo.Gender
		SET     GradeWorking = GradeContract
		WHERE   SelectionDate = '#dte#'
		AND     GradeWorking is NULL
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
		
    </cfquery>	
	
	<cfquery name="applyAge" 
	datasource="MartStaffing">	
		UPDATE  MartStaffing.dbo.Gender
		SET     Age = DATEDIFF(MONTH,dob,#seldate#)/12
		WHERE   SelectionDate = '#dte#'
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
    </cfquery>
 
 	<cfquery name="applyRetirement" 
	datasource="MartStaffing">	
		UPDATE  MartStaffing.dbo.Gender
		SET     DateRetirement = DATEADD(yyyy,65,DOB)
		WHERE   SelectionDate = '#dte#'
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
    </cfquery>
	
	<cfset prior = 18>
	
	<cfloop index="itm" list="29,39,49,59,69,79,89">
		
		<cfquery name="applyAge" 
		datasource="MartStaffing">	
			UPDATE  MartStaffing.dbo.Gender
			SET     AgeCluster = '#prior#-#itm#'
			WHERE   Age <= #itm#
			AND     SelectionDate = '#dte#'
			AND     AgeCluster is NULL
			<cfif thisFirstDay neq "yes">
				AND TransactionType = '0'
			</cfif>
	    </cfquery>
		
		<cfset prior = itm+1>
	
	</cfloop>
	
	<cfquery name="applyGradeOrderPosition" 
	datasource="MartStaffing">	
		UPDATE  MartStaffing.dbo.Gender
		SET     PositionGradeOrder = R.ListingOrder,
		        PositionGradeParent = R.GradeCategory
		FROM    MartStaffing.dbo.Gender F INNER JOIN #hub#Ref_PostGrade R ON F.PositionGrade = R.PostGrade		
		WHERE   SelectionDate = '#dte#'
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
    </cfquery>
	
	<cfquery name="applyGradeOrderContract" 
	datasource="MartStaffing">	
		UPDATE  MartStaffing.dbo.Gender
		SET     GradeContractOrder = R.ListingOrder,
		        GradeContractParent = R.GradeCategory
		FROM    MartStaffing.dbo.Gender F INNER JOIN #hub#Ref_PostGrade R ON F.GradeContract = R.PostGrade		
		WHERE   SelectionDate = '#dte#'
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
    </cfquery>
	
	<cfquery name="applyGradeOrderContract" 
	datasource="MartStaffing">	
		UPDATE  MartStaffing.dbo.Gender
		SET     GradeWorkingOrder = R.ListingOrder,
		        GradeWorkingParent = R.GradeCategory
		FROM    MartStaffing.dbo.Gender F INNER JOIN #hub#Ref_PostGrade R ON F.GradeWorking = R.PostGrade	
		WHERE   SelectionDate = '#dte#'	
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
    </cfquery>
	    		
</cfloop>

<!--- ------------------------------------------------ --->
<!--- special measures to be embedded in the Hub later --->
<!--- ------------------------------------------------ --->

<cfquery name="Seconded" 
datasource="MartStaffing">
	UPDATE Gender 
	SET    PositionSeconded = 1
	FROM   Gender G
	<!---- modified by rfuentes 26-June-2019, as for now, table: PositionSeconded is empty
	WHERE  PositionId IN (SELECT PositionId 
	                      FROM NYVM1618.Nova.dbo.PositionSeconded
						  WHERE Mission = G.Mission)
	------->
	
	WHERE  PositionId IN (
							SELECT LTRIM(RTRIM(SourcePostNumber)) as SourcePostNumber
							FROM	NYVM1613.Employee.dbo.Position
							WHERE 	1=1
							--AND 	Mission = G.Mission
							AND		PostType = 'Seconded'
							AND		Mission = 'DPPA-DPO'
							AND     VacancyActionClass = 'Active'
							)
		<!----apply for DPPA and children for now ----->
	AND Mission IN  ('DPPA-DPO','- SS', '- DPPA', '- DPO')
	
	<cfif thisFirstDay neq "yes">
		AND TransactionType = '0'
	</cfif>
	
</cfquery>


<!--- ------------------------------------------------ --->
<!--- ------------------------------------------------ --->


<!--- ------------------------------------------------ --->
<!--- ----------------Recruitment--------------------- --->

<cfquery name="clean" 
	datasource="MartStaffing">		 
		TRUNCATE Table MartStaffing.dbo.Recruitment
</cfquery>

<!--- attention this query excludes interns no grades --->

<cfquery name="applyPeriod" 
		datasource="MartStaffing">	
			
		INSERT INTO MartStaffing.dbo.Recruitment
		
			(	
			RecordId, 
			JobOpeningId, JobOpeningPosted, JobOpeningClose, JobOpeningClass, 
			Mission, 
			PostGrade, PostGradeOrder,
			<!---
			MissionParent, MissionParentOrder, 
			--->
			JobCode, 
			JobCodeName, JobFamily, 
						 
			DateApplication, 
						
			RecruitmentStage, 
			PersonNo, ApplicantNo, LastName, FirstName, Gender, DOB,  
			IndexNo, EMailAddress, 
			BirthNationalityCode,BirthNationality, 
			NationalityCode, Nationality
			)

	SELECT  VC.RecordId,
	        V.Job_Opening_ID,V.Posting_Date,V.End_Date,V.CategoryName,
		   
	        CASE SUBSTRING(V.UN_Department,1,CHARINDEX(' ',V.UN_Department))
	              WHEN '' THEN V.UN_Department
	                      ELSE SUBSTRING(V.UN_Department,1,CHARINDEX(' ',V.UN_Department))
	        END,   
			PG.PostGrade,
		    PG.ListingOrder,	
		    V.JOB_CODE,
			
		    V.Job_Title,
	        V.Occupation_Group,	           
	        VC.AppliedDate,		
						
		    VC.Disposition,
		    A.PersonNo,
		    A.ApplicantNo,
		    A.Last_name,
		    A.First_Name,
		    A.Gender,
		    
		    A.DOB,
		    A.IndexNo,
		    A.eMail,		
			A.BirthNationality,
			(SELECT TOP 1 iso2 FROM [NYVM1618].EnterpriseHub.dbo.Ref_country WHERE undp = A.BirthNationality) as Birth,			
			A.Nationality,
			(SELECT TOP 1 iso2 FROM [NYVM1618].EnterpriseHub.dbo.Ref_country WHERE undp = A.Nationality) as Nation
			
	FROM   [NYVM1618].inspiraJO.dbo.IMP_ISPVacancy V
	       INNER JOIN [NYVM1618].inspiraJO.dbo.IMP_ISPVacancyCandidate VC ON V.Job_Opening_ID = VC.JobOpeningID
	       INNER JOIN [NYVM1618].inspiraJO.dbo.IMP_ISPApplicant A 
		           ON  VC.Applicant_Num = A.Applicant_Num 
				   AND VC.ApplicantNo = A.ApplicantNo
				   AND VC.PersonNo = A.PersonNo
	       INNER JOIN [NYVM1618].EnterpriseHub.dbo.Ref_PostGrade PG ON REPLACE(PG.PostGrade,'-','')=V.Grade
		   
	WHERE     (Disposition <> '110 Reject')	  
	
	</cfquery>
	
	<cfquery name="clean" 
	datasource="MartStaffing">		 
		TRUNCATE Table MartStaffing.dbo.RecruitmentStage
	</cfquery>
	
	<cfquery name="applyStage" 
		datasource="MartStaffing">		
		INSERT INTO RecruitmentStage
		       (RecordId,PresentationLevel)
	    SELECT     RecordId, PresentationLevel
	    FROM       [NYVM1618].inspiraJO.dbo.IMP_ISPVacancyCandidate I INNER JOIN [NYVM1618].EnterpriseHub.dbo.Ref_RecruitmentStage R ON I.Disposition = R.Code
	    WHERE      RecordId IN (SELECT Recordid FROM Recruitment)
		AND        Disposition <> '110 Reject'	  
	</cfquery>
		
	<cfquery name="Nation"
	datasource="MartStaffing">
		UPDATE Recruitment 
		SET    BirthNationality = (SELECT TOP 1 iso2 FROM [NYVM1618].EnterpriseHub.dbo.Ref_country WHERE iso3 = A.BirthNationality)
		FROM   Recruitment A
		WHERE  BirthNationality is NULL	
    </cfquery>

	<cfquery name="Nation"
	datasource="MartStaffing">
	UPDATE Recruitment 
	SET    Nationality = (SELECT TOP 1 iso2 FROM [NYVM1618].EnterpriseHub.dbo.Ref_country WHERE iso3 = A.Nationality)
	FROM   Recruitment A
	WHERE  Nationality is NULL	
    </cfquery>
   
   <cfquery name="applyAge" 
	datasource="MartStaffing">	
		UPDATE  Recruitment 
		SET     Age = DATEDIFF(year,dob,getdate())		
   </cfquery>
   
   <!--- -- WHERE   SelectionDate = '#dte#' --->
    
 	
  <cfset prior = 18>
	
  <cfloop index="itm" list="29,39,49,59,69,79">
		
		<cfquery name="applyAge" 
		datasource="MartStaffing">	
			UPDATE  Recruitment 
			SET     AgeCluster = '#prior#-#itm#'
			WHERE   Age <= #itm#
			-- AND     SelectionDate = '#dte#'
			AND     AgeCluster is NULL
	    </cfquery>
		
		<cfset prior = itm+1>
	
  </cfloop>

  <cfquery name="applyJO" 
	datasource="MartStaffing">	
	UPDATE Recruitment
	SET JobOpeningClass='Job Opening'
	WHERE JobOpeningClass='Standard Requisition'
  </cfquery>


<!--- special adjustment to DPPA-DPO to avoid undef in grades for posts rfuentes 25-June-2019 ---->


<cfquery name="applyGradePatch" 
	datasource="MartStaffing">	
	
		UPDATE Gender
		SET PositionGrade= GradeContract
		, PositionGradeOrder  = GradeContractOrder
		WHERE 1=1
		AND Mission in ('- DPO', '- DPPA', '- SS', 'DPPA-DPO')
		AND AssignmentType IN ('TA', 'PM')
		AND PositionGrade = 'Undef'
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
	
  </cfquery>
  
  
  <cfquery name="applyApptPatch" 
	datasource="MartStaffing">	
	
		UPDATE Gender
		SET AppointmentType= '99'
		, AppointmentTypeName  = 'Undef'
		WHERE 1=1
		AND Mission in ('- DPO', '- DPPA', '- SS', 'DPPA-DPO')
		AND AssignmentType IN ('TA', 'PM')
		AND AppointmentType IS NULL
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
	
  </cfquery>
  
	<cfquery name="applyApptPatch" 
	datasource="MartStaffing">	
		<!----applies for DPPA-DPO only, as stakeholders don't want to see for retirement --->
		UPDATE Gender
		SET AgeCluster= '60+'
		WHERE 1=1
		AND Mission IN ('- DPO', '- DPPA', '- SS', 'DPPA-DPO')
		AND AgeCluster IN ('60-69','70-79','80-89')
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
	
  </cfquery>
  
  <cfquery name="removeBillingPosts" 
	datasource="MartStaffing">	
	
		DELETE FROM Gender
		WHERE 1=1
		AND Mission in ('- DPO', '- DPPA', '- SS', 'DPPA-DPO')
		AND Positiontype = '33'	/** this relates to billing position, we don't count them **/
		<cfif thisFirstDay neq "yes">
			AND TransactionType = '0'
		</cfif>
	
  </cfquery>
  
  <cfif thisFirstDay eq "yes">
		<!----double content for DPPA-DPO and its units, but with flag: Month ----->
		
		<cfquery name="applyDPPAMonthly" 
			datasource="MartStaffing">	
			
			INSERT INTO Gender
			
			( SelectionDate, Mission, MissionLabel, MissionParent, MissionParentOrder, OrgUnitId, OrgUnitName, OrgUnitNameShort, OrgHierarchy, PositionId, 
			                      PositionGrade, PositionGradeOrder, PositionGradeParent, PositionType, PositionTypeName, PositionSeconded, Location, JobCode, JobCodeName, AssignmentType, 
			                      AssignmentTypeName, AppointmentType, AppointmentTypeName, ContractTerm, ContractTermName, Incumbency, IndexNo, GradeContract, GradeContractOrder, 
			                      GradeContractParent, GradeWorking, GradeWorkingOrder, GradeWorkingParent, LastName, MiddleName, FirstName, Gender,NationalityCode,Country,LocationCountry, DOB, 
			                      Age, AgeCluster, MaritalStatus, EmailAddress, EODUN, DateRetirement, Source, Fund, TransactionType, Created)
		
			SELECT     SelectionDate, Mission, MissionLabel, MissionParent, MissionParentOrder, OrgUnitId, OrgUnitName, OrgUnitNameShort, OrgHierarchy, PositionId, 
			                      PositionGrade, PositionGradeOrder, PositionGradeParent, PositionType, PositionTypeName, PositionSeconded, Location, JobCode, JobCodeName, AssignmentType, 
			                      AssignmentTypeName, AppointmentType, AppointmentTypeName, ContractTerm, ContractTermName, Incumbency, IndexNo, GradeContract, GradeContractOrder, 
			                      GradeContractParent, GradeWorking, GradeWorkingOrder, GradeWorkingParent, LastName, MiddleName, FirstName, Gender,NationalityCode, Country, LocationCountry, DOB, 
			                      Age, AgeCluster, MaritalStatus, EmailAddress, EODUN, DateRetirement, Source, Fund,'1' TransactionType, Created
		
			FROM     Gender
			WHERE    Mission IN ('DPPA-DPO','- DPPA','- DPO','- SS')
			AND 	TransactionType = '0'
		</cfquery>	
	</cfif>
	
	
  <!---- if there is an issue pending with numbers, please check enterprisehub.dbo.[MissionPresentation] for null presentationLevel1 values ----->
  
  
  <!--- FINISHES special adjustment to DPPA-DPO  rfuentes 25-June-2019 ---->


	<cfquery name="cleanSpecCBD" 
	datasource="MartStaffing">
		UPDATE MartStaffing.dbo.Gender 
			SET TransactionType = '1' 
		WHERE Mission = 'SCBD' <!---we update to 1 for all records as this is supposed to be monthly---->
	</cfquery>






