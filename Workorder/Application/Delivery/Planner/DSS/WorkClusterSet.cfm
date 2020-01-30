<cfparam name="URL.action" default="next">

<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfif URL.id neq "">
	<cftransaction>
		<cfquery name="get"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				WHERE  RouteId='#URL.Id#'
		</cfquery>
	
		<cfquery name="getDetails"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				WHERE  RouteId='#URL.Id#'
		</cfquery>
		
		<cfloop query="getDetails">
			
			<cfif StructKeyExists(Form,"select_#getDetails.Node#")>
				<cfset sOrder = Form["select_#getDetails.Node#"]>
				 
				<cfif sOrder neq "">
					<cfquery name="qTimeSlotUpdate"
						datasource="AppsTransaction" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
							SET PlanOrder = '#sOrder#'
							WHERE  RouteId = '#getDetails.RouteId#'
							AND    Date    = '#getDetails.Date#'
							AND    Node    = '#getDetails.Node#'
					</cfquery>		
				</cfif>
			</cfif>			
			
			<cfif StructKeyExists(Form,"order_#getDetails.Node#")>
				<cfset lOrder = Form["order_#getDetails.Node#"]>
				 
				<cfif lOrder neq "">
					<cfquery name="qLOUpdate"
						datasource="AppsTransaction" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
							SET ListingOrder = '#lOrder#'
							WHERE  RouteId = '#getDetails.RouteId#'
							AND    Date    = '#getDetails.Date#'
							AND    Node    = '#getDetails.Node#'
					</cfquery>		
				</cfif>
			
			</cfif>	
			
		</cfloop>	
		
				
		
		<cfset debug = 0>
		
		<cfquery name="qSetFlow"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				SET    ActionStatus = '1'
				WHERE  RouteId='#URL.Id#'
				AND ActionStatus!='9'
		</cfquery>			
		
		<cfquery name="qSetFlowDetails"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				SET    ActionStatus = '1'
				WHERE  RouteId='#URL.Id#'	
				AND    ActionStatus != '9'	
		</cfquery>		
		
		<cfquery name="qSetFlowNodes"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				SET    ActionStatus = '1'
				FROM   stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N INNER JOIN stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# D	ON N.Node = D.Node AND N.Date = D.Date
				WHERE  D.RouteId='#URL.Id#'		
				AND    D.ActionStatus != '9'
		</cfquery>
	
		<cfquery name="getNext"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 * 
				FROM   stWorkPlanSelection_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				WHERE  Date = #dts#
				AND    Step = '#URL.step#'
				ORDER BY Created DESC
		</cfquery>		
	</cftransaction>
	<cfif getNext.RouteId neq #URL.Id# or getNext.recordcount eq 0>
		<!--- It did not exist, we have to recalculate --->
		<cfset SESSION.count = 1>
		<cfset URL.mode = "Upload">
		<cfinclude template="WorkClusterInit.cfm">
	</cfif>	
	
<cfelse>
	<cfset SESSION.count = 1>
	<cfset URL.mode = "Upload">
	<cfset URL.step = "">
	<cfinclude template="WorkClusterInit.cfm">
</cfif>

	

	
