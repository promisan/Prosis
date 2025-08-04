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
<cfparam name="URL.id" 		default = "">
<cfparam name="URL.type" 	default = "0">
<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfquery name="qSelectedNode"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
	WHERE 
	<cfif URL.id neq "">
	RouteId = '#URL.Id#'
	AND
	</cfif>   
	Node    = '#URL.Node#' 
</cfquery>

<cfif qSelectedNode.recordcount neq 0>
	
	<cftransaction>
		<!--- Marked for deletion ----->
		<cfif URL.id eq "">
			<cfquery name="qDeleteSelected"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				DELETE FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				WHERE 
				Node    = '#URL.Node#'  
			</cfquery>
		<cfelse>
			<cfquery name="qDeleteSelected"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				SET ActionStatus = '9'
				WHERE 
				<cfif URL.id neq "">
				RouteId = '#URL.Id#'
				AND
				</cfif>   
				Node    = '#URL.Node#'  
			</cfquery>		
		</cfif>

		<cfquery name="qDeleteSelected"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			UPDATE stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
			SET ActionStatus = '0'
			WHERE Date = #DTS#
			AND   Node = '#URL.Node#'  
		</cfquery>		
		
		<!---- Looking for the associated branch ----->
		<cfquery name="qNodeDetails"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  * 
			FROM    stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
			WHERE 	Date    = #DTS#
			AND     Node    = '#URL.Node#'  
		</cfquery>	
	
		<cfif qNodeDetails.Branch eq '1' and URL.type eq 1>
		
				<cfquery name="qSibling"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
					WHERE Node        != '#URL.Node#' 
					AND   Date         = #DTS#
					AND   OrgUnitOwner = '#qNodeDetails.OrgUnitOwner#'
					AND   Branch       = 0
				</cfquery>	
				
				<cfloop query="qSibling">
		
					<cfquery name="qSiblingUpdate"
						datasource="AppsTransaction" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
							SET   ActionStatus = '9'
							WHERE 
							<cfif URL.id neq "">
							RouteId = '#URL.Id#'
							AND
							</cfif>   
							AND   Node    = '#qSibling.Node#'
					</cfquery>	
					
					<cfquery name="qDeleteSelected"
						datasource="AppsTransaction" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							UPDATE stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
							SET    ActionStatus = '0'
							WHERE  Date = #DTS#
							AND    Node = '#qSibling.Node#' 
					</cfquery>		
					
				</cfloop>
		
		</cfif>
			 	
	</cftransaction>
	
</cfif>	
