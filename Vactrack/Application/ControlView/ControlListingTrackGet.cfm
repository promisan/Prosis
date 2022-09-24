
<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Ref_Mission
     	WHERE  Mission = '#url.mission#'
</cfquery>

<cf_wfPending 
	     EntityCode           = "VacDocument" 
		 EntityCodeIgnoreLast = "0"	
		 entityCode2          = "VacCandidate" 
		 mailfields           = "No" 
		 includeCompleted     = "No" 	 
		 Mission              = "#url.mission#"
		 Mode                 = "table"
		 table                = "#session.acc#_#mission.missionprefix#_VacancyTrack">		

<!--- this will return the active step of the workflow, however the workflow is
likely to be split over 2 entities as each workflow has one or more
selected candidates which each have a track potentially assigned --->
		 
<!--- retrieve pending tracks --->

<!--- 14/3/2014
  added a provision to cleanse wf flow tracks that do not relate to a record in the database anymore --->
  
<!--- this can have several units accross mandates --->
	<cfquery name="getmandate"
		datasource="AppsOrganization"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT   DISTINCT MandateNo
		FROM     Organization.dbo.Organization
		WHERE    Mission = '#url.mission#'
		AND      OrgUnitCode = '#url.hierarchyRootUnit#' 
	</cfquery>	
			
<cfsavecontent variable="session.SelectTracks">
	
	<cfoutput>	

    <!--- ---------------------------------------------------------------------- --->
	<!--- we get the tracks with the current status, if a track a one or more
	selected candidate tracks the track will be duplicated for each wf stage which is
	found for the tracks in the workflow objects --->
	<!--- ---------------------------------------------------------------------- --->

	SELECT   D.*, T.*,
	
	         (SELECT TOP 1 DateVacant 
			  FROM   Vacancy.dbo.DocumentPost
			  WHERE  DocumentNo = D.DocumentNo
			  ORDER BY DateVacant DESC) as DateVacant,
	
	         (SELECT Description 
			  FROM   Vacancy.dbo.Ref_DocumentType
			  WHERE  Code = D.DocumentType)      as TypeDescription,
			  
			 (SELECT LEFT(ReferenceNo,16)
			  FROM   Applicant.dbo.FunctionOrganization
			  WHERE  FunctionId = D.FunctionId)  as ReferenceNoExternal,
			  
			 (SELECT count(*)
			  FROM   Applicant.dbo.ApplicantFunction
			  WHERE  FunctionId = D.FunctionId
			  AND    Status IN ('1','1s','2','2f','3'))  as CandidateCount,
			  			  			  
			 (SELECT DateEffective
			  FROM   Applicant.dbo.FunctionOrganization
			  WHERE  FunctionId = D.FunctionId)  as DatePosted, 
	
			 (SELECT ActionDescription 
			  FROM   Organization.dbo.Ref_EntityActionPublish EA, 
			         Organization.dbo.OrganizationObject OO 
			  WHERE  OO.ObjectId = T.ObjectId 
			  AND    EA.ActionPublishNo = OO.ActionPublishNo
			  AND    EA.ActionCode = T.ActionCode) as ActionDescriptionStep,
			  
			 (SELECT TOP 1 EA.Description 
			  FROM   Organization.dbo.Ref_EntityActionParent EA, 
			         Organization.dbo.OrganizationObject OO 
			  WHERE  OO.ObjectId = T.ObjectId 
			  AND    OO.EntityCode = EA.EntityCode
			  AND    EA.Code     = T.ParentCode
			  AND    EA.Owner    = OO.Owner) as ActionDescription, 
			  
			 (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = D.PositionNo) as OrgUnitNameShort,
			  
			 (SELECT O.HierarchyCode
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = D.PositionNo) as OrgUnitHierarchy,
			  
			 (SELECT count(*)
			  FROM   Vacancy.dbo.DocumentCandidate C
			  WHERE  D.DocumentNo  = C.DocumentNo
			  AND    Status IN ('2s','3')) as Candidates
			  
			  <!--- add also the fund --->			  
		
	FROM     Vacancy.dbo.Document D 
	         <cfif url.status eq "0">
	         <!--- if the track does not have a workflow it will render the tracks here as outer join --->
	         INNER JOIN userQuery.dbo.#session.acc#_#mission.missionprefix#_VacancyTrack as T ON D.DocumentNo = T.ObjectKeyValue1
			 <cfelse>
			 LEFT OUTER JOIN userQuery.dbo.#session.acc#_#mission.missionprefix#_VacancyTrack as T ON D.DocumentNo = T.ObjectKeyValue1
			 </cfif>
			
	WHERE    D.Mission = '#URL.Mission#'							  	
	 
	 <!--- has at least one position associated to it --->
	 AND     D.DocumentNo IN (SELECT DocumentNo 
	                          FROM   Vacancy.dbo.DocumentPost DP
							  WHERE  DP.DocumentNo = D.DocumentNo
							  AND    DP.PositionNo IN (SELECT PositionNo 
							                           FROM   Employee.dbo.Position P
													   WHERE  PositionNo = DP.PositionNo
													   
													   <!--- filter by parent org unit --->	
													   
													   <cfif url.HierarchyCode neq "">
														
															AND P.OrgUnitOperational IN (
																														        																	
																	SELECT   OrgUnit
																	FROM     Organization.dbo.Organization
																	WHERE    Mission           = '#url.Mission#'
																	<cfloop query="getMandate">
																	AND      MandateNo         = '#MandateNo#'
																	AND      HierarchyCode LIKE '#url.HierarchyCode#%'																	
																	<cfif currentrow neq recordcount>
																	UNION
																	</cfif>
																	</cfloop>
																	
																	<!---
																	<cfif URL.HierarchyCode neq "">																	
																	AND      HierarchyCode LIKE '#URL.HierarchyCode#%' 
																	</cfif>	
																	--->
																)
															
														</cfif>
													   
													   
													   ))		
													   	
	 <!--- overruling status set by the user or workflow --->	
	 AND      D.Status  = '#URL.Status#' 			
	 	
	 <cfif URL.Parent neq "All">
	 <!--- filter by parent track classification --->
	 AND     T.ParentCode = '#URL.Parent#'
	 </cfif> 
	 
	 </cfoutput>
	 		
</cfsavecontent>

