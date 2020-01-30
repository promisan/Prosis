<cfquery name="qSelectedNode"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
	WHERE RouteId      = '#URL.Id#'
	AND   Node    	   = '#URL.Node#'
	AND   ActionStatus = '9'  
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfif qSelectedNode.recordcount neq 0>
	
	<cftransaction>
		<!--- Marked for deletion ----->
		<cfquery name="qDeleteSelected"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
			SET ActionStatus = '0'
			WHERE RouteId = '#URL.Id#'
			AND   Node    = '#URL.Node#'  
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
		
		<cfif qSibling.recordcount eq 0>
			<cfquery name="qBranch"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * FROM stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				WHERE Date         = #DTS#
				AND   OrgUnitOwner = '#qNodeDetails.OrgUnitOwner#'
				AND   Branch       = 1
			</cfquery>	
			
			<!--- There are no siblings thus, we need to also inactivate the branch ---->
			<cfquery name="qSiblingUpdate"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
					SET   ActionStatus = '1'
					WHERE RouteId = '#URL.Id#'
					AND   Node    = '#qBranch.Node#'
			</cfquery>	
		</cfif>
			 	
	</cftransaction>
	
</cfif>	
