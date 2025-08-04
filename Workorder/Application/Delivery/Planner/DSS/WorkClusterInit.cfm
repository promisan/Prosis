<!--
    Copyright © 2025 Promisan

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
<cfparam name="URL.date" default="06/01/2015">
<cfparam name="URL.mode" default="Load">
<cfparam name="URL.step" default="1">
<cfset debug      = 0>
<cfset max_lookup = 1>

<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfif url.step eq "">
	
		<cftry>
			<cfquery name="qCheck"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
					SELECT   *
				    FROM     stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N
				   	WHERE    Date = #dts#
				   	<cfif URL.step neq "">
					   	AND      EXISTS
						(
							SELECT 'X'
							FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# D INNER JOIN stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# P
								ON D.RouteId = P.RouteId
							WHERE   N.Node = D.Node
								AND N.Date = D.Date
								AND P.Step = '#URL.Step#'
						)
				   	</cfif>
					ORDER BY Node ASC	
			</cfquery>
			<cfset vExists = True>
			
			<cfcatch>
				<cfset vExists = False>
				<cfset qCheck.recordcount  = 0>
			</cfcatch>
		</cftry>	
			
		<cfif qCheck.recordcount eq 0 OR url.Step eq  0 OR NOT vExists>
		
				<cfset objMatrix = CreateObject("component","service.process.workorder.routing")/>
				
				<cfif URL.mode eq "Load">
					<cfset URL.Step = 1> <!--- Reseting all --->
					<cfset objResponse = objMatrix.loadDeliveries(
									date = "#URL.date#",
									start_latitude  = 52.0319556,
									start_longitude = 4.369180099999994,
									start_zip       = 2497,
									depth       	= max_lookup,
									debug           = debug,
									mission         = URL.mission)
					/>
					
					<cfset objMatrix.writeDB()/>
					
				<cfelse>
				
					<cfset objResponse = objMatrix.uploadDeliveries(
									date    = "#URL.date#",
									depth   = max_lookup,
									debug   = debug,
									mission = URL.mission)
					/>
					
				</cfif>
				
				<cfif objResponse neq 0>
				
					<cfset ROUTES = CreateObject( 
				    	"java", 
					    "java.util.ArrayList" 
					    ).Init() />
						
			
					   <cfquery name="SPs"
						datasource="AppsTransaction" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
							SELECT TOP #max_lookup# PositionNo 
							FROM 
							Userquery.dbo.stWorkPlanSuggestedDrivers_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# D 
							WHERE Date = #DTS#
							AND NOT EXISTS(
								SELECT 'X'
								FROM stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
								WHERE Date = D.Date
								AND PositionNo = D.PositionNo)
							ORDER BY Total DESC	
						</cfquery>
						
						<cfloop query="SPs">
								<cfset objMatrix.setDriver(SPs.PositionNo)/>
								<cfset qBranches = objMatrix.getHistoricalBranches()/>
								<cfset ROUTES[qBranches.Node] = objMatrix.evaluateNode(Node = qBranches.Node)/>
						</cfloop>	
						
						<cfset objMatrix.writeResults(Routes = ROUTES, Step=URL.Step)>
						
				</cfif>	
		</cfif>
		
	<cfquery name="qAllUnits"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT OrgUnitOwner
	    FROM   stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N 
		WHERE  Date = #dts#
	</cfquery>
	
	<cfset SESSION.unit_scope = ValueList(qAllUnits.OrgUnitOwner)>
	
<cfelse>
	<cfset objResponse = objMatrix.uploadDeliveries(
					date    = "#URL.date#",
					depth   = max_lookup,
					debug   = debug,
					mission = URL.mission)/>

	<cfset ROUTES = CreateObject( 
		"java", 
	    "java.util.ArrayList" 
	    ).Init() />

	<cfset ROUTES[0] = objMatrix.evaluateNode(Node = qBranches.Node)/>
	<cfset objMatrix.writeResults(Routes = ROUTES, Step='')>
</cfif>


