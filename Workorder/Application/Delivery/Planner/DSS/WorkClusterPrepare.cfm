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
<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfset URL.ID = "">

<cfif URL.step neq "final">
	<cftry>
		<cfquery name="qSelected"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 * 
				FROM     stWorkPlanSelection_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				WHERE    Date = #dts#
				AND      Step = '#URL.step#'
				ORDER BY Created DESC
		</cfquery>
		
		<cfset max_lookup = 5>
		
		<cfquery name="qCheck"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *  
				FROM stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				WHERE   Date 		= #dts#
				AND     Step 		= '#URL.step#'
				AND PersonNo IS NOT NULL
		</cfquery>		
		
		<cfif qCheck.recordcount eq 0> 
			<cfquery name="qMaster"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  PO.PositionNo, PO.FunctionDescription, P.PersonNo, F.*,
					        (SELECT SUM(Duration) FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# D WHERE F.RouteId = D.RouteId AND F.Date = D.Date) as Duration,
							(SELECT COUNT(1) 
								FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# D 
									INNER JOIN stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N ON N.Node = D.node AND N.Date = D.Date 
									WHERE F.RouteId = D.RouteId AND F.Date = D.Date AND Branch=0
							 		AND D.ActionStatus != '9'
							 ) 
									as Deliveries				         
							FROM    stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# F 
									INNER JOIN Employee.dbo.Position PO ON PO.PositionNo = F.PositionNo 
									LEFT OUTER JOIN Employee.dbo.PersonAssignment PA ON PA.PositionNo = F.PositionNo
									LEFT OUTER JOIN Employee.dbo.Person P ON PA.PersonNo = P.PersonNo  
							WHERE   F.Date 		= #dts#
							AND     F.Step 		= '#URL.step#'
							AND     PA.DateEffective <= #dts#
							AND     PA.DateExpiration > = #dts#
							AND     PA.AssignmentStatus  IN ('0','1')
					ORDER BY Duration DESC
			</cfquery>
			
			<!--- We have to update the workplan table with this ---->
			<cfif qMaster.PersonNo neq "">
					<cfquery name="qUpdate"
							datasource="AppsTransaction" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							UPDATE stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
							SET 	PersonNo    = '#qMaster.PersonNo#'
							WHERE   Date 		= #dts#
							AND     Step 		= '#URL.step#' 
							AND PersonNo IS NULL
					</cfquery>				
			</cfif>	
			
			
			
		<cfelse>
			<cfquery name="qMaster"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  PO.PositionNo, PO.FunctionDescription, F.PersonNo, F.*,
					        (SELECT SUM(Duration) FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# D WHERE F.RouteId = D.RouteId AND F.Date = D.Date) as Duration,
							(SELECT COUNT(1) 
								FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# D 
									INNER JOIN stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N ON N.Node = D.node AND N.Date = D.Date 
									WHERE F.RouteId = D.RouteId AND F.Date = D.Date AND Branch=0
							 		AND D.ActionStatus != '9'
							 ) 
									as Deliveries				         
							FROM    stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# F 
									INNER JOIN Employee.dbo.Position PO ON PO.PositionNo = F.PositionNo 
							WHERE   F.Date 		= #dts#
							AND     F.Step 		= '#URL.step#'
					ORDER BY Duration DESC
			</cfquery>		
		</cfif>			
		
		<cfif qSelected.RouteId neq "">
			<cfset URL.Id = qSelected.RouteId>
		<cfelse>
			<cfset URL.Id = qMaster.Routeid>			
		</cfif>
		
		<cfif qMaster.recordcount eq 0>
			<cfset vInit=TRUE>
		</cfif>	
		
	<cfcatch>
		<cfset vInit=TRUE>	
	</cfcatch>		
	</cftry>	
 
</cfif>	
