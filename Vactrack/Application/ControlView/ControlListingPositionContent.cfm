
<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission = '#mis#'
</cfquery>

<cfsavecontent variable="myquery">

<cfsavecontent variable="SelectTracks">
	
	<cfoutput>	

    <!--- ---------------------------------------------------------------------- --->
	<!--- we get the tracks with the current status, if a track a one or more
	selected candidate tracks the track will be duplicated for each wf stage which is
	found for the tracks in the workflow objects --->
	<!--- ---------------------------------------------------------------------- --->
	
	SELECT      DISTINCT S.PositionNo, S.PositionParentId, S.Mission, S.MandateNo, S.OrgunitNameShort, S.HierarchyCode, 
	            S.FunctionNo, S.FunctionDescription, S.PostType, S.PostClass, S.VacancyActionClass, 
                S.ShowVacancy, S.SourcePostNumber, S.DateExpiration, S.PostGrade, S.Remarks, 
				S.PostOrder, 
				S.Category, 
				
				  (SELECT     TOP 1 ReferenceNo
				   FROM       Applicant.dbo.FunctionOrganization
				   WHERE      DocumentNo = H.DocumentNo
				  ) as Reference, 
				   
				  (SELECT     R.Description
                   FROM       PositionParentGroup AS PPG INNER JOIN
                              Ref_PositionParentGroupList AS R ON PPG.GroupCode = R.GroupCode AND PPG.GroupListCode = R.GroupListCode
                   WHERE      PPG.GroupCode = 'Status' and PPG.PositionParentId = S.PositionParentId) AS PostStatus,
				H.DocumentNo, H.DocumentType,
				H.ActionDescription, 
				H.DueDate
				
    FROM        vwPosition AS S LEFT OUTER JOIN
                             (SELECT      D.DocumentNo
							              , P.PositionParentId 
										  , D.DocumentType
										  , D.DueDate
										
															 
										  , (SELECT ActionDescription 
						                   FROM   Organization.dbo.Ref_EntityActionPublish EA, 
			                 			          Organization.dbo.OrganizationObject OO 
			                   			   WHERE  OO.ObjectId = T.ObjectId 
						                   AND    EA.ActionPublishNo = OO.ActionPublishNo
			                   			   AND    EA.ActionCode = T.ActionCode) as ActionDescription
										  
							 
                               FROM         Vacancy.dbo.[Document] AS D INNER JOIN
                                            Vacancy.dbo.DocumentPost AS DP ON D.DocumentNo = DP.DocumentNo AND D.Status = '0' INNER JOIN
                                            Position AS P ON DP.PositionNo = P.PositionNo INNER JOIN
											userQuery.dbo.#session.acc#_#Mission.MissionPrefix#_VacancyTrack T ON D.DocumentNo = T.ObjectKeyValue1
											
											<!--- INNER JOIN 
											(#preserveSingleQuotes(WorkFlowSteps)#) as T ON D.DocumentNo = T.ObjectKeyValue1
											--->
											
                               WHERE        D.Mission = '#url.mission#' 
							   AND          D.Status = '0') AS H ON S.PositionParentId = H.PositionParentId
							   
     WHERE      S.Mission = '#url.mission#' 
	 
	 <cfif URL.HierarchyCode neq "">
	 
	       AND      HierarchyCode LIKE '#url.HierarchyCode#%'	
																		
	</cfif>				
	 
	 AND        S.DateEffective < GETDATE() 
	 AND        S.DateExpiration > GETDATE()
 
	 --condition 
	 
	 </cfoutput>	
	 									
</cfsavecontent>

<cfset itm = 0>
		
<cfset fields=ArrayNew(1)>

<cfset itm = itm + 1>					
<cfset fields[itm] = {label      = "Position", 					
					  field      = "SourcePostNumber",										
					  search     = "text"}>	
					  
<cfset itm = itm + 1>					  
<cfset fields[itm] = {label      = "Status",                  					
					  field      = "PostStatus",					
					  search     = "text",
					  filtermode = "2"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Type", 					
					  field      = "PostType",		
					  column     = "common",											
					  search     = "text", 
					  filtermode = "3"}>							  				  

<cfset itm = itm + 1>					  
<cfset fields[itm] = {label      = "Grade",                  					
					  field      = "PostGrade",		
					  fieldsort  = "PostOrder",					  			
					  search     = "text",
					  filtermode = "3"}>					  					  
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Title",                     
					  field      = "FunctionDescription", 													
					  search     = "text", 
					  filtermode = "2"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label          = "Track",                     
					  field          = "DocumentNo", 	
					  functionscript = "showdocument",										
					  search         = "text", 
					  filtermode     = "4"}>	
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Type",                     
					  field      = "DocumentType", 			
					  column     = "common",										
					  search     = "text", 
					  filtermode = "2"}>	
					  
<cfset itm = itm+1>	
<cf_tl id="Reference" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "#lt_text#",
					field         = "Reference",	
					display       = "1",								
					rowlevel      = "1",
					Colspan       = "1",																																													
					search        = "text"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Expected" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "Expected onboarding",
					field         = "DueDate",	
					display       = "1",													
					formatted     = "dateformat(Duedate,'#CLIENT.DateFormatShow#')",																																												
					search        = "date"}>							
	 
					  
<cfset itm = itm+1>	
<cf_tl id="Remarks" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "#lt_text#",
					field         = "Remarks",	
					display       = "1",	
					rowlevel      = "2",
					Colspan       = "5",																																																		
					search        = "text"}>	
					

<cfset itm = itm+1>	
<cf_tl id="Action" var = "1">		
<cfset fields[itm] = {label       = "#lt_text#",                    
     				labelfilter   = "#lt_text#",
					field         = "ActionDescription",	
					align         = "right",
					display       = "1",	
					rowlevel      = "2",
					Colspan       = "4",																																																							
					search        = "text"}>	
										
					
					
					
					
									  					  						  					  
					  
<!---					  
		  	
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "F", 	
                    LabelFilter   = "Funding",				
					field         = "Funding",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green"}>							  	  
					  
		
<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Class", 					
					  field      = "PostClass",		
					  column     = "common",											
					  search     = "text", 
					  filtermode = "3"}>																

								
<cfset itm = itm + 1>	
<cfset fields[itm] = {label      = "Location",					
					  field      = "LocationCode",	
					  column     = "common",
					  search     = "text",
					  filtermode = "2"}>							

<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Unit", 					
					  field      = "OrgUnitName",
					  fieldsort  = "HierarchyCode",
					  search     = "text",
					  filtermode = "3"}>	

<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Last Incumbent", 					
					  field      = "Incumbent",										
					  search     = "text"}>																					
		
<cfset itm = itm + 1>				
<cfset fields[itm] = {label      = "PositionParentId",    					
					  field      = "PositionParentId",
					  Display    = "False"}>		
	
					  
--->					  

<!--- embed|window|dialogajax|dialog|standard --->
			
<cf_listing header  = "PositionTrackDetail"
    box             = "position_#url.mission#"
	link            = "#SESSION.root#/Vactrack/Application/ControlView/ControlListingPositionContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&hierarchycode=#url.hierarchyCode#"
    html            = "No"		
	datasource      = "AppsEmployee"
	listquery       = "#selecttracks#"
	listorder       = "SourcePostNumber"
	listorderalias  = ""
	listorderdir    = "DESC"
	headercolor     = "ffffff"				
	tablewidth      = "100%"
	listlayout      = "#fields#"
	FilterShow      = "Yes"
	ExcelShow       = "Yes"
	drillmode       = "tab" 
	drillargument   = "980;1100;true"	
	drilltemplate   = "Staffing/Application/Position/PositionParent/PositionView.cfm?drillid="
	drillkey        = "PositionNo">	

<cfset ajaxonload("doCalendar")>	


	