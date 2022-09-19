	
<!--- shows the information for the date as to how many are pending for that date --->

<cfparam name="url.hierarchyCode" default="">

	<cfquery name="getmandate"
		datasource="AppsOrganization"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT   DISTINCT MandateNo
		FROM     Organization.dbo.Organization
		WHERE    Mission = '#url.mission#'		
	</cfquery>	
	
<cftry>
		
		<table width="98%" align="center">
		
			<cfquery name="get"
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			    SELECT *
				
				FROM (
			
					SELECT    Status, DocumentNo,
					          (SELECT ReferenceNo FROM Applicant.dbo.FunctionOrganization WHERE FunctionId = D.FunctionId) as ReferenceNo, 
							  OfficerUserLastName as Officer, OfficerUserLastName as Owner 
					FROM      Document D
					WHERE     Mission = '#url.mission#'
					AND       CAST(Created AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'	
					
					UNION
					
					SELECT    Status, DocumentNo, 
							  (SELECT ReferenceNo FROM Applicant.dbo.FunctionOrganization WHERE FunctionId = D.FunctionId) as ReferenceNo,
							  StatusofficerLastName as Officer, OfficerUserLastName as Owner
					FROM      Document D
					WHERE     Mission = '#url.mission#'
					AND       CAST(StatusDate AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'
					
					UNION
					
					SELECT     DISTINCT '0a' as Status, OO.ObjectKeyValue1 as DocumentNo, 
          					   (SELECT ReferenceNo FROM Applicant.dbo.FunctionOrganization WHERE FunctionId = D.FunctionId) as ReferenceNo,
					           OOA.OfficerLastName, OO.OfficerLastName as Owner
					FROM       Organization.dbo.OrganizationObjectAction AS OOA INNER JOIN
			                   Organization.dbo.OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId INNER JOIN
							   Document D ON D.DocumentNo = OO.ObjectKeyValue1
					WHERE      OO.Mission = '#url.mission#'
					AND        OO.EntityCode IN ('VacDocument', 'VacCandidate')         
					AND        CAST(OfficerDate AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'	
					AND        OOA.OfficerLastName != 'Agent'		
				
				) as D
				
				<cfif url.HierarchyCode neq "">
				
				WHERE    DocumentNo IN (SELECT DocumentNo 
				                        FROM   Vacancy.dbo.DocumentPost DP
							            WHERE  DP.DocumentNo = D.DocumentNo
							            AND    DP.PositionNo IN (SELECT PositionNo 
							                                     FROM   Employee.dbo.Position P
													             WHERE  PositionNo = DP.PositionNo
													   
																 <!--- filter by parent org unit --->
																   														
																	AND    P.OrgUnitOperational IN (
																																	        																	
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
																			)	
																														   
													           )
											   )	
											   
					</cfif>						   				
													
			</cfquery>
			
			
			
			<cfquery name="list" dbtype="query">
				SELECT   *
				FROM     Get
				ORDER BY DocumentNo DESC, Status 
			</cfquery>
					
			<cfoutput query="list" group="DocumentNo">
			
				<tr class="labelit fixlengthlist linedotted" style="height:18px">	
						
				<td style="height:10px;padding-left:2px"><a href="javascript:showdocument('#DocumentNo#')">
				<cfif ReferenceNo neq "">#left(ReferenceNo,6)#<cfelse>#DocumentNo#</cfif></a></td>			
				<td align="right" style="height:10px;padding-left:2px;padding-right:4px;">
				<cfif officer eq "Agent">#Owner#<cfelse>#Officer#</cfif>
				</td>
						
				<td style="min-width:20px;max-width:20px;border:0px solid silver;cursor:pointer">
					
					<cf_UITooltip
						id         = "detail#documentno#"
						ContentURL = "ScheduleCalendarList.cfm?documentno=#documentno#"
						CallOut    = "true"
						Position   = "left"
						Width      = "430"
						ShowOn     = "click"
						Height     = "270"
						Duration   = "40">
					
						<table style="width:100%"><tr>
						
							<cfoutput>
							
							<cfswitch expression="#Status#">
							
								<cfcase value="0">
								    <cfset cl = "yellow">
								</cfcase>
								<cfcase value="0a">
								    <cfset cl = "silver">
								</cfcase>
								<cfcase value="1">
								    <cfset cl = "green">
								</cfcase>
								<cfcase value="9">
								    <cfset cl = "red">
								</cfcase>
							
							</cfswitch>
							
							<td style="width:50%;background-color:#cl#">&nbsp;</td>
							
							</cfoutput>
						
							</tr>
							
						</table>
					
					</cf_UItooltip>	
					
				</td>	
														
								
				</tr>	
						
			</cfoutput>		
			
			<!---	
			
			<cfquery name="get"
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      Document
				WHERE     Mission = '#url.mission#'
				AND       CAST(StatusDate AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'							
			</cfquery>
			
			<cfoutput query="get">
				<tr class="labelit fixlengthlist linedotted" style="height:18px">	
				    <cfif status eq "9">	
				    <td style="min-width:5px;max-width:5px;background-color:red"></td>	
					<cfelse>
					<td style="min-width:5px;max-width:5px;background-color:green"></td>	
					</cfif>
					<td style="height:10px;padding-left:2px">					
					<a href="javascript:showdocument('#DocumentNo#')">#DocumentNo#:</a>
					</td>			
					<td align="right" style="height:10px;padding-left:2px;padding-right:4px;">#StatusofficerLastName#</td>
				</tr>			
			</cfoutput>
			
			<cfquery name="get"
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     DISTINCT OO.ObjectKeyValue1, OOA.OfficerLastName 
				FROM       Organization.dbo.OrganizationObjectAction AS OOA INNER JOIN
		                   Organization.dbo.OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId
				WHERE      OO.Mission = '#url.mission#'
				AND        OO.EntityCode IN ('VacDocument', 'VacCandidate')         
				AND        CAST(OfficerDate AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'										
			</cfquery>
			
			<cfoutput query="get">
				<tr class="labelit fixlengthlist linedotted" style="height:18px">					    
				    <td style="min-width:5px;max-width:5px;background-color:gray"></td>						
					<td style="height:10px;padding-left:2px">					
					<a href="javascript:showdocument('#ObjectKeyValue1#')">#ObjectKeyValue1#:</a>
					</td>			
					<td align="right" style="height:10px;padding-left:2px;padding-right:4px;">#OfficerLastName#</td>
				</tr>			
			</cfoutput>
			
			--->
			
		
		</table>			
	
	<cfcatch>
	
	      <table><tr><td><font color="FF0000">problem</font></td></tr></table>
	
	</cfcatch>
	
</cftry>
