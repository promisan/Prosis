
<cf_wfPending entityCode = "VacDocument" entityCode2  ="VacCandidate" 
	 mailfields          = "No" 
	 includeCompleted    = "No" 	 
	 Mission             = "#url.mission#"
	 Mode                = "subquery">
	 
	 
<!--- this will return the active step of the workflow, however the workflow is
likely to be split over 2 entities as each workflow has one or more
selected candidates which each have a track potentially assigned --->
		 
<!--- retrieve pending tracks --->

<!--- 14/3/2014
  added a provision to cleanse wf flow tracks that do not relate to a record in the database anymore --->
			
<cfsavecontent variable="SelectTracks">

	<!--- this can have several units accross mandates --->
	<cfquery name="getmandate"
		datasource="AppsOrganization"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization.dbo.Organization
		WHERE    Mission = '#url.mission#'
		AND      OrgUnitCode = '#url.hierarchyRootUnit#'
	</cfquery>	
		
	<cfoutput>

    <!--- ---------------------------------------------------------------------- --->
	<!--- we get the tracks with the current status, if a track a one or more
	selected candidate tracks the track will be duplicated for each wf stage which is
	found for the tracks in the workflow objects --->
	<!--- ---------------------------------------------------------------------- --->

	SELECT   D.*, T.*,
	
			 (SELECT ActionDescription 
			  FROM   Organization.dbo.Ref_EntityActionPublish EA, 
			         Organization.dbo.OrganizationObject OO 
			  WHERE  OO.ObjectId = T.ObjectId 
			  AND    EA.ActionPublishNo = OO.ActionPublishNo
			  AND    EA.ActionCode = T.ActionCode) as ActionDescription,
			  
			 (SELECT O.OrgUnitNameShort
			  FROM   Organization.dbo.Organization O, Employee.dbo.Position P
			  WHERE  P.OrgUnitOperational = O.OrgUnit
			  AND    P.PositionNo = D.PositionNo) as OrgUnitNameShort 
			  
			  <!--- add also the fund --->			  
		
	FROM     Vacancy.dbo.Document D 
	         <!--- if the track does not have a workflow it will render the tracks here as outer join --->
	         LEFT OUTER JOIN  (#preserveSingleQuotes(WorkFlowSteps)#) as T ON D.DocumentNo = T.ObjectKeyValue1
			
	WHERE    D.Mission = '#URL.Mission#'		
										 		
	 <!--- has a workflow track defined, no longer needed in my views 									  
	 
	 AND     D.DocumentNo IN (SELECT ObjectKeyValue1 
	                          FROM   Organization.dbo.OrganizationObject 
							  WHERE EntityCode = 'VacDocument')								  
	 --->					  					  	
	 
	 <!--- has at least one position associated to it --->
	 AND     D.DocumentNo IN (SELECT DocumentNo 
	                          FROM   Vacancy.dbo.DocumentPost DP
							  WHERE  DP.DocumentNo = D.DocumentNo
							  AND    DP.PositionNo IN (SELECT PositionNo 
							                           FROM   Employee.dbo.Position P
													   WHERE  PositionNo = DP.PositionNo
													   
													   <!--- filter by parent org unit --->	
													   
													   <cfif URL.HierarchyRootUnit neq "">
														
															AND P.OrgUnitOperational IN (
																														        																	
																	SELECT   OrgUnit
																	FROM     Organization.dbo.Organization
																	WHERE    Mission           = '#url.Mission#'
																	<cfloop query="getMandate">
																	AND      MandateNo         = '#MandateNo#'
																	AND      HierarchyCode LIKE '#HierarchyCode#%'
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


