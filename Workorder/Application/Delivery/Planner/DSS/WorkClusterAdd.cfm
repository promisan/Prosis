	
<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfquery name="qCurrentRoute"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	  SELECT *
	  FROM   stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
	  WHERE RouteId = '#URL.Id#'
	  ORDER BY ListingOrder DESC
</cfquery>

<cfset vMax = qCurrentRoute.ListingOrder>

<cfinclude template="../../getTreeData.cfm">

<cftransaction>
<cfloop list="#units#" index="vBranch">

		<cfquery name="qNodes"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT * 
			FROM stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# 
			WHERE OrgUnitOwner = '#vBranch#'
			AND Date = #dts#
			ORDER BY Branch DESC
		</cfquery>	

		<cfset vListingOrder=vMax>
		<cfloop query="qNodes">
			<cfquery name="qCheck"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * FROM stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
				WHERE RouteId = '#URL.Id#'
				AND Node = '#qNodes.Node#'	
			</cfquery>
		
		
			<cfif qCheck.recordcount eq 0>
		
				<cfset vListingOrder = vListingOrder + 1>	
				<cfquery name="qInsert"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					INSERT INTO stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
					           (RouteId,
					           Date
					           ,Node
					           ,Duration
					           ,Distance
							   ,ActionStatus
					           ,ListingOrder)
					     VALUES
					           ('#URL.Id#'
					           ,#dts#
					           ,'#qNodes.Node#'
					           ,0
					           ,0
							   ,'1a'
					           ,#vListingOrder#)
				</cfquery>		
				<cfquery name="qNodeUpdate"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					UPDATE stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
					SET ActionStatus = '1a'
					WHERE Date = #dts#
					AND Node = '#qNodes.Node#'
				</cfquery>						
			<cfelse>

				<cfquery name="qFlowUpdate"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
					SET ActionStatus = '1a'
					WHERE RouteId = '#URL.Id#'
					AND Node = '#qNodes.Node#'
				</cfquery>					
			
			
				<cfquery name="qNodeUpdate"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					UPDATE stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
					SET ActionStatus = '1a'
					WHERE Date = #dts#
					AND Node = '#qNodes.Node#'
				</cfquery>					
					   
			</cfif>
		
		</cfloop>

	
</cfloop>
</cftransaction>
