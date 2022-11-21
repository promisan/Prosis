
<cfparam name = "URL.Criteria" default = "No">
<cfparam name = "URL.SystemfunctionId" default = "">

<!--- prepare the query --->

<cfsavecontent variable="session.SelectTracks">
	
	<cfoutput>	

    <!--- ---------------------------------------------------------------------- --->
	<!--- we get the tracks with the current status, if a track a one or more
	selected candidate tracks the track will be duplicated for each wf stage which is
	found for the tracks in the workflow objects --->
	<!--- ---------------------------------------------------------------------- --->
	
		SELECT *
		FROM (
	
			SELECT *, (CASE WHEN IncumbentOwner >= 1 THEN 'Owner' WHEN Incumbent >= 1 THEN 'Temporary' ELSE 'Vacant' END) as IncumbentStatus,
        			  (CASE WHEN DatePosted      is not NULL THEN datediff(DAY, DatePosted, getdate()) ELSE -1 END)       as TrackPostedDays,
					  (CASE WHEN TrackDateVacant is not NULL THEN TrackDateVacant ELSE NULL END)                          as DateVacant,
					  (CASE WHEN TrackDateVacant is not NULL THEN datediff(DAY, TrackDateVacant, getdate()) ELSE -1 END)  as DateVacantDays 
								
			FROM (
			
			SELECT      DISTINCT S.PositionNo, 
			            count(*) over ( partition by S.PositionNo ) as PositionCount, 
			            S.PositionParentId, S.Mission, S.MandateNo, S.OrgunitNameShort, S.HierarchyCode, 
			            S.FunctionNo,  S.FunctionDescription, S.PostType, S.PostClass, S.VacancyActionClass, 
		                S.ShowVacancy, S.SourcePostNumber, S.DateExpiration, S.PostGrade, S.Remarks, 
						S.PostOrder,   S.PostGradeBudget,  S.PostOrderBudget, S.Category as PostCategory, 
						
						  (SELECT    O.OrgUnitNameShort
						   FROM      Organization.dbo.Organization O
						   WHERE     Mission = S.Mission
						   AND       MandateNo = S.MandateNo
						   AND       HierarchyCode = left(S.HierarchyCode,2) ) as ParentUnit,
						
						  (CASE WHEN 
						  (SELECT     TOP 1 LEFT(ReferenceNo,7)
						   FROM       Applicant.dbo.FunctionOrganization
						   WHERE      FunctionId = H.FunctionId ) <> '' THEN  (SELECT TOP 1 LEFT(ReferenceNo,7)
						   FROM       Applicant.dbo.FunctionOrganization
						   WHERE      FunctionId = H.FunctionId ) ELSE CAST(H.DocumentNo as varchar) END) as Reference, 
						  					
						  (SELECT     TOP 1 DateEffective
						   FROM       Applicant.dbo.FunctionOrganization
						   WHERE      FunctionId = H.FunctionId ) as DatePosted,   						   
										   
						  (SELECT     R.Description
		                   FROM       PositionParentGroup AS PPG INNER JOIN
		                              Ref_PositionParentGroupList AS R ON PPG.GroupCode = R.GroupCode AND PPG.GroupListCode = R.GroupListCode
		                   WHERE      PPG.GroupCode = 'Status' and PPG.PositionParentId = S.PositionParentId) AS PostStatus,
						   
						  (SELECT     TOP 1 Fund
						   FROM       PositionParentFunding
						   WHERE      PositionParentId  = S.PositionParentId
						   ORDER BY   DateEffective DESC  ) as Fund, 
							
						  (SELECT     TOP 1 FunctionalArea
						    FROM      PositionParentFunding
						    WHERE     PositionParentId  = S.PositionParentId
						    ORDER BY  DateEffective DESC  ) as FunctionalArea, 	
										   
						  (SELECT     count(DISTINCT PositionNo)
						    FROM      PersonAssignment
						    WHERE     PositionNo      = S.PositionNo
						    AND       AssignmentStatus IN ('0','1')
						    AND       AssignmentType   = 'Actual'					 
						    AND       Incumbency       = 100
						    AND       DateEffective  <= CAST(GETDATE() AS Date) 
						    AND       DateExpiration >= CAST(GETDATE() AS Date)				
						    AND       DateEffective  < S.DateExpiration ) as Incumbent,
						
						  <!---	
						  ( SELECT TOP 1 DateExpiration
						    FROM   PersonAssignment
						    WHERE  PositionNo      = S.PositionNo
						    AND    AssignmentStatus IN ('0','1')
						    AND    AssignmentType   = 'Actual'					 
						    AND    Incumbency       = 100						    
						    AND    DateEffective <= CAST(GETDATE() AS Date) 
							ORDER BY DateExpiration DESC) as IncumbentDateExpiration,	
							
							--->
							
						  ( SELECT count(DISTINCT PositionNo)
						    FROM   PersonAssignment
						    WHERE  PositionNo      = S.PositionNo
						    AND    AssignmentStatus IN ('0','1')
						    AND    AssignmentType   = 'Actual'	
							AND    AssignmentClass  = 'Regular'				 
						    AND    Incumbency       = 100
						    AND    DateEffective  <= CAST(GETDATE() AS Date) 
						    AND    DateExpiration >= CAST(GETDATE() AS Date)				
						    AND    DateEffective  < S.DateExpiration ) as IncumbentOwner,	
						   
						  ( SELECT count(DISTINCT PositionNo)
						    FROM   PersonAssignment
						    WHERE  PositionNo      = S.PositionNo
						    AND    AssignmentStatus IN ('0','1')
						    AND    AssignmentType   = 'Actual'									 
						    AND    Incumbency       = 0
						    AND    DateEffective  <= CAST(GETDATE() AS Date) 
						    AND    DateExpiration >= CAST(GETDATE() AS Date)				
						    AND    DateEffective  < S.DateExpiration ) as IncumbentLien,	
														
						<!--- fields added for excel --->	 
		
		                U.PersonNo         as IncumbentUserPersonNo,
						U.IndexNo          as IncumbentUserIndexNo,
						U.LastName         as IncumbentUserLastName,
						U.FirstName        as IncumbentUserFirstName,
						U.ContractType     as IncumbentUserContractType,
						U.Nationality      as IncumbentUserNationality,
						U.NationalityName  as IncumbentUserNationalityName,
						U.CountryGroup     as IncumbentUserCountryGroup,
						U.Gender           as IncumbentUserGender,
						U.AssignmentClass  as IncumbentUserClass,
						
						U.PersonNo         as LienPersonNo,
						L.IndexNo          as LienIndexNo,
						L.LastName         as LienLastName,
						L.FirstName        as LienFirstName,
						L.ContractType     as LienContractType,
						L.Nationality      as LienNationality,
						L.NationalityName  as LienNationalityName,
						L.CountryGroup     as LienCountryGroup,
						L.Gender           as LienGender,						
									 
						H.DocumentNo, 
						H.DocumentType,
						H.ActionDescription, 						
						H.ExpectedOnboarding,
						H.DateVacant as TrackDateVacant,												
						H.TrackCreated,
						H.TrackOfficerFirstName,
						H.TrackOfficerLastName,
												
						(SELECT count(*) 
						 FROM   Vacancy.dbo.DocumentCandidate 
						 WHERE  DocumentNo = H.DocumentNo
						 AND    Status IN ('2s','3')
						 ) as TrackSelectedCandidate						
												
		    FROM        vwPosition AS S 
			
			                    LEFT OUTER JOIN
		                             (SELECT      D.DocumentNo
	            								  , D.FunctionId
									              , P.PositionParentId 
												  , D.DocumentType
												  , D.DueDate as ExpectedOnBoarding
												  , DP.DateVacant
												  , D.Created as TrackCreated
												  , D.OfficerUserFirstName as TrackOfficerFirstName
												  , D.OfficerUserLastName as trackOfficerLastName
												  
												   , (SELECT TOP 1 EA.Description 
								                   FROM   Organization.dbo.Ref_EntityActionParent EA, 
					                 			          Organization.dbo.OrganizationObject OO 
					                   			   WHERE  OO.ObjectId = T.ObjectId 
												   AND    OO.EntityCode = EA.EntityCode
								                   AND    EA.Code     = T.ParentCode
												   AND    EA.Owner    = OO.Owner) as ActionDescription
												
												<!---
																	 
												  , (SELECT ActionDescription 
								                   FROM   Organization.dbo.Ref_EntityActionPublish EA, 
					                 			          Organization.dbo.OrganizationObject OO 
					                   			   WHERE  OO.ObjectId = T.ObjectId 
								                   AND    EA.ActionPublishNo = OO.ActionPublishNo
					                   			   AND    EA.ActionCode = T.ActionCode) as ActionDescription
												   
												   --->
																					 
		                               FROM        Vacancy.dbo.[Document] AS D INNER JOIN
		                                           Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo AND D.Status = '0' INNER JOIN
		                                           Position AS P ON DP.PositionNo = P.PositionNo INNER JOIN
												   userQuery.dbo.#session.acc#_#Mission.MissionPrefix#_VacancyTrack T ON D.DocumentNo = T.ObjectKeyValue1
													
													<!--- INNER JOIN 
													(#preserveSingleQuotes(WorkFlowSteps)#) as T ON D.DocumentNo = T.ObjectKeyValue1
													--->
													
		                               WHERE       D.Mission = '#url.mission#' 
									   AND         D.Status = '0') AS H ON S.PositionParentId = H.PositionParentId
									   									   
									   LEFT OUTER JOIN vwIncumbent U ON S.PositionNo = U.PositionNo and U.Modality = 'User'
									   
									   LEFT OUTER JOIN vwIncumbent L ON S.PositionNo = L.PositionNo and L.Modality = 'Lien'
									   
		     WHERE      S.Mission = '#url.mission#' 
			 
			 <cfif URL.HierarchyCode neq "">
			 
			       AND      HierarchyCode LIKE '#url.HierarchyCode#%'	
																				
			</cfif>				
			 
			 AND        S.DateEffective < GETDATE() 
			 AND        S.DateExpiration > GETDATE()
			 
			 ) as M
		 
		 ) as S
		 
		 WHERE 1=1
     
	 
	 </cfoutput>	
	 									
</cfsavecontent>

<cfset url.item = "PostGrade">

<cfsavecontent variable="qry">
		<cfoutput>		
		SELECT  #URL.Item#, 
		        COUNT(DISTINCT PositionNo) AS countedPosition, 
				COUNT(DISTINCT IncumbentUserPersonNo) AS Occupied, 
				COUNT(DISTINCT PositionNo) - COUNT(DISTINCT IncumbentUserPersonNo) AS Vacant	
		FROM    (#preserveSingleQuotes(session.SelectTracks)#) as V
		WHERE   1=1 		
		</cfoutput>	
</cfsavecontent>	

<cfswitch expression="#URL.Item#">
			 
	 <cfcase value="PostClass">
	 	
	 	<cfquery name="Graph" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			#preserveSingleQuotes(qry)#
			GROUP BY PostClass 
			ORDER BY PostClass
		</cfquery>  
	 
	 </cfcase>
	 
	 <cfcase value="ParentNameShort">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			#preserveSingleQuotes(qry)#
			GROUP BY ParentHierarchyCode, ParentNameShort
			ORDER BY ParentHierarchyCode
		</cfquery>  
			 
	 </cfcase>
	 
	 <cfcase value="OccGroupAcronym">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			#preserveSingleQuotes(qry)#
			GROUP BY OccupationalGroup, OccGroupAcronym
			ORDER BY OccupationalGroup, OccGroupAcronym
		</cfquery>  
		
	 </cfcase>
	 
	  <cfdefaultcase>
	 
	 	<cfquery name="Graph" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			#preserveSingleQuotes(qry)#
			GROUP BY PostGrade, PostOrder
			ORDER BY PostOrder	
		</cfquery>  
	 
	 </cfdefaultcase>

</cfswitch>	


<cfoutput>
	
	<table width="98%" height="100%" border="0" align="center">
	
	<!---
	<tr><td>header</td></tr>
	--->
	
	<cfset url.format = "column">
	
	<tr><td align="center">
	
	<cf_UIchart 			
			name			= "fPostVacancy"
			chartheight     = "140"			
			showxgridlines  = "yes"
			showYGridlines  = "Yes"
			fontsize        = "12"			
			showlabel	    = "No"
			showvalue	    = "No"
			legend		    = "Yes"
			gridlines       = "12"
			seriesplacement = "stacked"
			labelformat     = "number"
			yaxistitle      = "Post / Vacancy"			
			url             = "javascript:alert('$ITEMLABEL$')">
			
			<!--- listener('$ITEMLABEL$') --->
		
			<cf_UIchartseries
					type           = "#url.format#"
					query          = "#Graph#"
					itemcolumn     = "#url.item#"
					valuecolumn    = "Occupied"
					serieslabel    = "Encumbered"					
					seriescolor    = "##5C97BF"
					paintstyle     = "raise"
					markerstyle    = "circle"/>
		
			<cf_UIchartseries
					type           = "#url.format#"
					query          = "#Graph#"
					itemcolumn     = "#url.item#"
					valuecolumn    = "Vacant"
					serieslabel    = "Vacant"					
					seriescolor    = "##EB974E"
					paintstyle     = "raise"
					markerstyle    = "circle"/>

		
	</cf_UIchart>
		
	</td></tr>
		
	</table>
	
</cfoutput>	
