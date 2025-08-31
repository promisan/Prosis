<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
					
					SELECT    '0a', D.DocumentNo,FO.ReferenceNo, 
							  OfficerUserLastName as Officer, OfficerUserLastName as Owner 
					FROM      Document D INNER JOIN Applicant.dbo.FunctionOrganization FO ON FO.FunctionId = D.FunctionId 
					WHERE     D.Mission = '#url.mission#'
					AND       D.Status != '9'
					AND       CAST(FO.DateEffective AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'	
					
					UNION
					
					SELECT    '0b', D.DocumentNo,FO.ReferenceNo, 
							  OfficerUserLastName as Officer, OfficerUserLastName as Owner 
					FROM      Document D INNER JOIN Applicant.dbo.FunctionOrganization FO ON FO.FunctionId = D.FunctionId 
					WHERE     D.Mission = '#url.mission#'
					AND       D.Status != '9'
					AND       CAST(FO.DateExpiration AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'	
					
					UNION
					
					SELECT    Status, DocumentNo, 
							  (SELECT ReferenceNo FROM Applicant.dbo.FunctionOrganization WHERE FunctionId = D.FunctionId) as ReferenceNo,
							  StatusofficerLastName as Officer, OfficerUserLastName as Owner
					FROM      Document D
					WHERE     Mission = '#url.mission#'					
					AND       CAST(StatusDate AS Date) = '#dateformat(url.calendardate,client.dateSQL)#'
					
					UNION
					
					SELECT     DISTINCT '0d' as Status, OO.ObjectKeyValue1 as DocumentNo, 
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
			
			<style>
			
			.container {
			  width: 100%;
			  height: 30px;
			  position: relative;
			}
			
			.box {
			  width: 100%;
			  height: 30px;			  
			  position: absolute;
			}
			
			.overlay {
			  z-index: 900;		
			  position: absolute;	  			 			 
			  width: 100%;
			  height: 14px;		
			}
			
			</style>
					
					
			<cfoutput query="list" group="DocumentNo">
			
				<tr class="labelit fixlengthlist">								
										
				<td style="min-width:120px;max-width:120px;border:0px solid silver;cursor:pointer">
									
					
						
						<div class="container">
						
						  <cf_UITooltip
						id         = "detail#documentno#"
						ContentURL = "Recruitment/ScheduleCalendarList.cfm?documentno=#documentno#"
						CallOut    = "true"
						Position   = "left"
						Width      = "430"
						ShowOn     = "click"
						Height     = "270"
						Duration   = "40">
						
                           <div class="box">
					
							<table style="width:100%"><tr style="height:26px">
							
								<cfset cur = 0>
							
								<cfoutput>												
								
								<cfset cur = cur + 1>
								
								<cfswitch expression="#Status#">
								
									<cfcase value="0">
									    <cfset ti = "New">
									    <cfset cl = "yellow">
									</cfcase>								
									<cfcase value="0a">
									    <cfset ti = "Posting start">
									    <cfset cl = "00FFFF">
									</cfcase>
									<cfcase value="0b">
									     <cfset ti = "Posting end">
									    <cfset cl = "lime">
									</cfcase>
									<cfcase value="0d">
									     <cfset ti = "Action">
									    <cfset cl = "silver">
									</cfcase>
									<cfcase value="1">
									     <cfset ti = "Completed">
									    <cfset cl = "green">
									</cfcase>
									<cfcase value="9">
								     <cfset ti = "Cancelled">
									    <cfset cl = "red">
									</cfcase>
								
								</cfswitch>													
								
								<cfif cur eq "1">
								
								<td title="#ti#" style="border-top-left-radius:10px;border-bottom-left-radius:10px;background-color:#cl#">&nbsp;</td>
															
								<cfelseif cur eq recordcount>
								
								<td title="#ti#" style="border-top-right-radius:10px;border-bottom-right-radius:10px;background-color:#cl#">&nbsp;</td>
								
								<cfelse>
								
								<td title="#ti#" style="background-color:#cl#">&nbsp;</td>
								
								</cfif>
								
								</cfoutput>
							
								</tr>
								
							</table>
						
						</div>
						
						 </cf_UItooltip>	
						 
						  <div class="overlay"> 
						  <table style="width:100%"><tr><td style="padding-left:7px;color:black;font-size:10px;background-color:##ffffff80">
						  <a style="color:black" href="javascript:showdocument('#DocumentNo#')">												  
						    <cfif ReferenceNo neq "">#left(ReferenceNo,6)#<cfelse>#DocumentNo#</cfif></a>
							</td><td align="right" style="padding-right;4px;font-size:10px;background-color:##ffffff80"">
						    <cfif officer eq "Agent">#left(Owner,8)#<cfelse>#left(Officer,8)#</cfif>
							</td></tr></table>
						  	</div>
						</div>
					
					
					
				</td>															
								
				</tr>	
						
			</cfoutput>						
		
		</table>			
	
	<cfcatch>
	
	      <table><tr><td><font color="FF0000">problem</font></td></tr></table>
	
	</cfcatch>
	
</cftry>
