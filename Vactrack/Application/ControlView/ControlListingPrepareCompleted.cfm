
  <!--- show by grade for complete tracks --->
    
  <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Doc4_#CLIENT.FileNo#">
  <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Doc5_#CLIENT.FileNo#">
  
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
	
	
	<cfquery name="Sum" dbtype="query">
		SELECT     SUM(counted) as Total
		FROM       Summary
	</cfquery>
		
	
	<cfquery name="Period"
		datasource="AppsVacancy"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     stPeriod
		ORDER BY ListingOrder
	</cfquery>	
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Subset_#CLIENT.FileNo#">
	
	<cfquery name="subset"
	datasource="AppsVacancy"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT  *		
		INTO UserQuery.dbo.#SESSION.acc#Subset_#CLIENT.FileNo#
		FROM    (#preservesingleQuotes(SelectedTracks)#) as T	
	</cfquery>	
	
	<cfquery name="Period"
		datasource="AppsQuery"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM (		
										
			<cfloop query="Period">
			
				SELECT  '#Description#' as Description, 
						#ListingOrder# as ListingOrder,
						COUNT(DocumentNo) AS counted 
				FROM    UserQuery.dbo.#SESSION.acc#Subset_#CLIENT.FileNo# as T
				WHERE   StatusDate >= '#DateFrom#' 
				AND     StatusDate <= '#DateUntil#' 
				<cfif recordcount neq currentrow>
				UNION
				</cfif>
				
			</cfloop>
			  ) as D
			  			  
		ORDER BY ListingOrder	
				
	</cfquery>	
		
	<cfquery name="Count"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     COUNT(DISTINCT DocumentNo) as Total
		FROM       (#preservesingleQuotes(SelectedTracks)#) as T
	</cfquery>
	
	
	<!--- details --->
		
	<cfquery name="detailsDocument"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT    D.*, 
	          T.EntityClassName, 
			  T.PostGradeBudget, 
			  T.PostOrderBudget,
			  F.ReferenceNo as VAReferenceNo,
			  
			  (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = D.PositionNo) as OrgUnitNameShort 
			
	FROM      Vacancy.dbo.Document D INNER JOIN (#preservesingleQuotes(SelectedTracks)#) as T  
			  ON D.DocumentNo = T.DocumentNo  LEFT OUTER JOIN 
			  Applicant.dbo.FunctionOrganization F ON D.FunctionId = F.FunctionId 
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
		WHERE     D.Status = '3'
		
	
	</cfquery>
	
	
