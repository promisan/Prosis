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
		
			<cfquery name="due"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			    SELECT        Pe.ActionStatus, COUNT(*) AS Counted
				FROM          PersonEvent AS Pe LEFT OUTER JOIN
				              Organization.dbo.Organization AS O ON Pe.OrgUnit = O.OrgUnit
				WHERE         Pe.Mission = '#url.mission#' 
				AND           Pe.ActionStatus IN ('0','1','2','3') 
				AND           Pe.DateEventDue = '#dateformat(url.calendardate,client.dateSQL)#'
				<cfif url.HierarchyCode neq "">
				AND           Pe.OrgUnit IN (	SELECT   OrgUnit
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
				</cfif>							
				GROUP BY Pe.ActionStatus
			
			</cfquery>
			
			<tr class="labelmedium2 fixlengthlist linedotted" style="height:18px">	
			
			<td><cf_tl id="Due"></td>
			
			<cfoutput>
			
			<cfloop index="itm" list="0,1,3">
			
				<cfswitch expression="#itm#">
								
					<cfcase value="0">
					    <cfset cl = "FFFF00">
					</cfcase>
					<cfcase value="1">
					    <cfset cl = "C0C0C0">
					</cfcase>
					<cfcase value="2">
					    <cfset cl = "00FF00">
					</cfcase>
					<cfcase value="3">
					    <cfset cl = "00FF00">
					</cfcase>		
				
				</cfswitch>
							
				<cfquery name="get" dbtype="query">
					SELECT   *
					FROM     Due
					WHERE    ActionStatus = '#itm#'				
			    </cfquery>
				
				<td align="center" style="width:50px;border:1px solid silver" bgcolor="<cfif get.counted gte '1'>#cl#</cfif>">#get.counted#</td>
					
			</cfloop>		
			
			</cfoutput>		
		
		</table>			
	
	<cfcatch>
	
	      <table><tr><td><font color="FF0000">problem</font></td></tr></table>
	
	</cfcatch>
	
</cftry>
