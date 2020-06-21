
<!--- Pending

0. Control prepare is used by the control tree as per Armin assesment 4/16/2011

1.  Define first step with status 0 or 1 (hold) for either candidate or document,      
2.	Identify the actioncode and parentcode for the last action 
3.	Filter on mission and status and selected step
4.  Now combine header and candidates and create a summary	  
5.	Summarize both table by Mission, ParentCode, ListingOrder, Number
    -> graph by parent showing total
	-> listing for expand (parent -> actioncode - temp table
	-> graph by age of the vactrack >90, 60-90, 30-60, 0-30	
6.	Create detail/lookup tables	
--->	
	
	<!--- pending : limit on select mission, status document --->
	
<cfparam name="SelectTracks" default="">	
	
<cfif URL.Parent eq "All">	<!--- show by stage --->	

	<cfif vCondition eq "">	
	
		<cfset SelectedTracks = SelectTracks>
			
		<!--- no change and thus need to filter more --->
	
	<cfelse>
		
		<cfsavecontent variable="SelectedTracks">
		
			<cfoutput>		
			    SELECT  *		
				FROM    (#preservesingleQuotes(SelectTracks)#) as T				
				<!--- added to make sure that some workflow were completed and might not be in the subtable --->									
				WHERE   1=1 #PreserveSingleQuotes(vCondition)#						
			</cfoutput>	
		
		</cfsavecontent>
						
	</cfif>
		
	<!--- ---------------------- --->		
	<!--- Summary Workflow stage --->
	<!--- ---------------------- --->
	
	<cfquery name="Summary"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	   SELECT EntityCode,
	          Code,
			  Description, 
			  ListingOrder,
			  SUM(counted) as Counted   
	   
	   FROM   (	  
	
				SELECT    T.EntityCode              as EntityCode, 
						  ISNULL(T.ParentCode,0)    as Code, 
						  ISNULL(R.Description,'PARENT NOT SET')  as Description, 
						  ISNULL(R.ListingOrder,0) as ListingOrder,
						  COUNT(T.DocumentNo)  as Counted 				
				
				FROM      (#preservesingleQuotes(SelectedTracks)#) T LEFT OUTER JOIN Organization.dbo.Ref_EntityActionParent R 
							  ON   T.EntityCode = R.EntityCode 
							  AND  T.ParentCode = R.Code
							  AND  R.EntityCode IN ('VacDocument','VacCandidate') 
							  AND  T.Owner = R.Owner		
    
				GROUP BY  T.EntityCode, 
				          T.ParentCode, 						  						 
						  R.Description, 
						  R.ListingOrder ) as Embed
						  
		GROUP BY  EntityCode, Code, Description, ListingOrder 				  
		
		ORDER BY  ListingOrder 
		
	</cfquery>	
	
	<!--- ---------------------- --->	
	<!--- -----Total documents-- --->
	<!--- ---------------------- --->
	
	<cfquery name="Count"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     COUNT(DISTINCT DocumentNo) as Total
		FROM       (#preservesingleQuotes(SelectedTracks)#) as T
	</cfquery>
		
	<!--- ---------------------- --->	
	<!--- ------Total tracks---- --->
	<!--- ---------------------- --->
						
	<cfquery name="Sum" dbtype="query">
		SELECT     SUM(counted) as Total
		FROM       Summary
	</cfquery>		
			
<cfelse> 
	
	<!--- --------------------------------- --->
	<!--- show for a selected step by grade --->
	<!--- --------------------------------- --->

	 <cfsavecontent variable="SelectedTracks">
  
     	<cfoutput>	
	
		SELECT   T.*, 			
				 P.PostGradeBudget, 
				 P.PostOrderBudget	
		FROM     (#preservesingleQuotes(SelectTracks)#) as T, 
				 Employee.dbo.Ref_PostGrade P	
		WHERE    T.PostGrade       = P.PostGrade 		
		<cfif vCondition neq "">
			#PreserveSingleQuotes(vCondition)#
		</cfif>	
				
		</cfoutput>
		
	 </cfsavecontent>	
		
		<!---
	
		SELECT  T.*, '' as PersonNo, P.PostGradeBudget, P.PostOrderBudget 
		INTO    dbo.#SESSION.acc#Doc3b_#CLIENT.FileNo#
		FROM    dbo.#SESSION.acc#Doc3a_#CLIENT.FileNo# T,
				Employee.dbo.Ref_PostGrade P, 
				Employee.dbo.Ref_PostGradeParentMission PM
		WHERE   T.EntityCode = 'VacDocument'
		<!--- AND     P.PostGradeVactrack = '1'  --->
		AND     T.PostGrade = P.PostGrade
		AND     P.PostGradeParent = PM.PostGradeParent
		AND     PM.Mission = T.Mission		
		<cfif vCondition neq "">
			#PreserveSingleQuotes(vCondition)#
		</cfif>				
		UNION ALL
		SELECT  T.*, C.PersonNo, P.PostGradeBudget, P.PostOrderBudget 
		FROM    dbo.#SESSION.acc#Doc3a_#CLIENT.FileNo# T, 
		        Vacancy.dbo.DocumentCandidate C,
				Employee.dbo.Ref_PostGrade P, 
				Employee.dbo.Ref_PostGradeParentMission PM
		WHERE   EntityCode = 'VacCandidate'
		AND     ObjectKeyValue1 = C.DocumentNo
		AND     ObjectKeyValue2 = C.PersonNo
		<!--- AND     P.PostGradeVactrack = '1'  --->
		AND     C.Status = '2s'
		AND     T.PostGrade = P.PostGrade
		AND     P.PostGradeParent = PM.PostGradeParent
		AND     PM.Mission = '#URL.Mission#'	
		<cfif vCondition neq "">
			#PreserveSingleQuotes(vCondition)#
		</cfif>				
		ORDER BY P.PostOrderBudget
		
		--->
			
	<!---
	
	<cfquery name="check"
		datasource="AppsQuery"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT * FROM dbo.#SESSION.acc#Doc3b_#CLIENT.FileNo#
	</cfquery>	
	
	<cfif check.recordcount eq "0">
	
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Doc3b_#CLIENT.FileNo#">		
	
		<cfquery name="step3b"
		datasource="AppsQuery"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		
			SELECT  T.*, '' as PersonNo, P.PostGradeBudget, P.PostOrderBudget 
			INTO    dbo.#SESSION.acc#Doc3b_#CLIENT.FileNo#
			FROM    dbo.#SESSION.acc#Doc3a_#CLIENT.FileNo# T,
					Employee.dbo.Ref_PostGrade P
			WHERE   T.EntityCode = 'VacDocument'
			<!--- AND     P.PostGradeVactrack = '1'  --->
			AND     T.PostGrade = P.PostGrade		
			<cfif vCondition neq "">
				#PreserveSingleQuotes(vCondition)#
			</cfif>		
					
			UNION ALL
			
			SELECT  T.*, C.PersonNo, P.PostGradeBudget, P.PostOrderBudget 
			FROM    dbo.#SESSION.acc#Doc3a_#CLIENT.FileNo# T, 
			        Vacancy.dbo.DocumentCandidate C,
					Employee.dbo.Ref_PostGrade P
			WHERE   EntityCode = 'VacCandidate'
			AND     ObjectKeyValue1 = C.DocumentNo
			AND     ObjectKeyValue2 = C.PersonNo
			<!--- AND     P.PostGradeVactrack = '1'  --->
			AND     C.Status = '2s'
			AND     T.PostGrade = P.PostGrade		
			<cfif vCondition neq "">
				#PreserveSingleQuotes(vCondition)#
			</cfif>				
			ORDER BY P.PostOrderBudget
						
		</cfquery>		
	
	</cfif>
	
	--->
	
	<!--- summary by grade --->
	
	<cfquery name="Summary"
		datasource="AppsQuery"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT    PostGradeBudget, 
				  PostOrderBudget,
				  COUNT(T.documentNo) AS counted  		
		FROM      (#preserveSingleQuotes(SelectedTracks)#) as T 
		WHERE     1=1 <!--- P.PostGradeVactrack = '1' --->
		GROUP BY  PostGradeBudget, PostOrderBudget
		ORDER BY  PostOrderBudget 
	</cfquery>		
	
	<cfquery name="Count"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     COUNT(DISTINCT DocumentNo) as Total
		FROM       (#preservesingleQuotes(SelectedTracks)#) as T
	</cfquery>
	
	<cfquery name="Sum" dbtype="query">
		SELECT     SUM(counted) as Total
		FROM       Summary
	</cfquery>
		
		
</cfif>

<cfif URL.Mode neq "Portal" and URL.Mode neq "Dashboard"> 

	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Subset_#CLIENT.FileNo#">
	
	<cfquery name="subset"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT  *		
		INTO UserQuery.dbo.#SESSION.acc#Subset_#CLIENT.FileNo#
		FROM    (#preservesingleQuotes(SelectedTracks)#) as T	
	</cfquery>	
	
	<cfquery name="aging"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     stAging
		ORDER BY ListingOrder
	</cfquery>
	
	<cfquery name="Aging"
		datasource="AppsQuery"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM (		
										
			<cfloop query="Aging">
				SELECT  '#Aging.Description#'   as Description, 
						'#Aging.ListingOrder#' as ListingOrder,
						 COUNT(ObjectKeyValue1) AS counted 
				FROM    UserQuery.dbo.#SESSION.acc#Subset_#CLIENT.FileNo# as T
				WHERE   #Condition#
				<cfif recordcount neq currentrow>
				UNION
				</cfif>
			</cfloop>
			  ) as D
			  
		ORDER BY ListingOrder	
				
	</cfquery>	
				
</cfif>	

<!--- ------------------------ --->	
<!--- detail views for vacancy --->
<!--- ------------------------ --->
	
<cfif URL.Parent eq "All">	
	
	<cfquery name="DetailsDocument"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    D.*, 
	          T.ParentCode,
			  T.EntityClassName ,
 			  T.ActionCode,
 			  T.ActionDescription,
			  F.ReferenceNo as VAReferenceNo,
			  
			  (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = D.PositionNo) as OrgUnitNameShort 
		
	FROM      Vacancy.dbo.Document D 
	          INNER JOIN (#preservesingleQuotes(SelectedTracks)#) as T  ON D.DocumentNo = T.ObjectKeyValue1 
			  LEFT OUTER JOIN Applicant.dbo.FunctionOrganization F ON D.FunctionId = F.FunctionId 
	WHERE 1=1
			 <cfif vCondition2 neq "">
				#PreserveSingleQuotes(vCondition2)# 
			 </cfif>
			 
	</cfquery>	
	
	<!---	
	<cfoutput>
	D : #cfquery.executiontime#
	</cfoutput>
	--->
	
	<!--- details candidate --->
	
	<cfquery name="DetailsCandidate"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    V.*, 
	          A.IndexNo, 
			  A.PersonNo, 
			  A.LastName, 
			  A.FirstName, 
			  A.Gender, 
			  A.Nationality, 			  
			  F.ReferenceNo as VAReferenceNo,
			  
			  (SELECT O.OrgUnitNameShort
			   FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			   WHERE  P.OrgUnitOperational = O.OrgUnit
			   AND    P.PositionNo = V.PositionNo) as OrgUnitNameShort 
		
	FROM      Vacancy.dbo.DocumentCandidate D INNER JOIN 
	         (#preservesingleQuotes(SelectedTracks)#) as V  ON D.DocumentNo = V.ObjectKeyValue1 AND D.PersonNo = V.ObjectKeyValue2  INNER JOIN
	          Applicant.dbo.Applicant A  ON D.PersonNo = A.PersonNo LEFT OUTER JOIN
			  Applicant.dbo.FunctionOrganization F ON V.FunctionId = F.FunctionId
	</cfquery>	
	
	<!---
	<cfoutput>
	DC : #cfquery.executiontime#		
	</cfoutput>
	--->
	
	
<cfelse>

	<!--- details --->
		
	<cfquery name="detailsDocument"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    D.*, 
	          T.EntityClassName, 
			  T.ActionCode,
			  T.PostGradeBudget, 
			  T.PostOrderBudget,
			  F.ReferenceNo as VAReferenceNo,
			  
			  (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = D.PositionNo) as OrgUnitNameShort 
			
	FROM      Vacancy.dbo.Document D 
	          INNER JOIN (#preservesingleQuotes(SelectedTracks)#) as T ON D.DocumentNo = T.DocumentNo 
			  LEFT OUTER JOIN Applicant.dbo.FunctionOrganization F ON D.FunctionId = F.FunctionId 
			<cfif vCondition2 neq "">
				#PreserveSingleQuotes(vCondition2)#
			</cfif>
	</cfquery>	
		
	<!--- details candidate --->
		
	<cfquery name="detailsCandidate"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    DISTINCT V.*, 
	          A.IndexNo, 
			  A.PersonNo, 
			  A.LastName, 
			  A.FirstName, 
			  A.Gender, 
			  A.Nationality, 
			  T.PostGradeBudget, 
			  T.PostOrderBudget, 
			  T.EntityClassName,
			  F.ReferenceNo as VAReferenceNo,
			  
			    (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = V.PositionNo) as OrgUnitNameShort 			  
	
	FROM      Vacancy.dbo.DocumentCandidate D INNER JOIN  
	          Vacancy.dbo.Document V ON D.DocumentNo = V.DocumentNo         INNER JOIN 
	          (#preservesingleQuotes(SelectedTracks)#) as T  ON T.DocumentNo = V.DocumentNo INNER JOIN
	          Applicant.dbo.Applicant A ON A.PersonNo = D.PersonNo LEFT OUTER JOIN
			  Applicant.dbo.FunctionOrganization F ON V.FunctionId = F.FunctionId
	
	
	</cfquery>

	<!--- detail table 
	
	<cftry>

	<cfquery name="details1"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    D.*, 
			  T.EntityClassName, 
			  T.ActionCode, 
			  T.ActionDescription,
			  T.PostGradeBudget, 
			  T.PostOrderBudget, 
			  F.ReferenceNo as VAReferenceNo,
			  
			  (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = D.PositionNo) as OrgUnitNameShort 
			  
	INTO      dbo.#SESSION.acc#Doc41
	FROM      Vacancy.dbo.Document D INNER JOIN 
	          dbo.#SESSION.acc#Doc3b_#CLIENT.FileNo# T ON D.DocumentNo = T.DocumentNo LEFT OUTER JOIN 
			  Applicant.dbo.FunctionOrganization F ON D.FunctionId = F.FunctionId
	WHERE 1=1
		 <cfif vCondition2 neq "">
			#PreserveSingleQuotes(vCondition2)# 
		 </cfif>
					
	</cfquery>	
		
	<!--- details candidate --->
	
	<cfquery name="details2"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    V.*, 
			  A.IndexNo, 
			  A.PersonNo, 
			  A.LastName, 
			  A.FirstName, 
			  A.Gender, 
			  A.Nationality, 
			  T.PostGradeBudget, 
			  T.PostOrderBudget, 
			  T.EntityClassName,
			  F.ReferenceNo as VAReferenceNo,
			  
			  (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = V.PositionNo) as OrgUnitNameShort 
			  
	INTO      dbo.#SESSION.acc#Doc42
	FROM      Vacancy.dbo.DocumentCandidate D INNER JOIN 
	          Vacancy.dbo.Document V ON D.DocumentNo = V.DocumentNo INNER JOIN
	          dbo.#SESSION.acc#Doc3b_#CLIENT.FileNo# T  ON D.DocumentNo = T.ObjectKeyValue1 AND D.PersonNo   = T.ObjectKeyValue2   INNER JOIN 
	          Applicant.dbo.Applicant A  ON D.PersonNo = A.PersonNo   LEFT OUTER JOIN
			  Applicant.dbo.FunctionOrganization F ON V.FunctionId = F.FunctionId
	WHERE     D.Status = '2s' <!--- selected --->
	</cfquery>	
	
	<cfcatch>	
	
	<cfabort></cfcatch>
	
	</cftry>
	
	--->
		
</cfif>


