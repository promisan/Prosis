
<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfquery name="qCluster"
	datasource="Appstransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	  SELECT P.*, PE.PersonNo, PE.FirstName, PE.LastName
	  FROM   stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# P INNER JOIN Employee.dbo.Person PE ON PE.PersonNo= P.PersonNo
	  WHERE
	  	   P.ActionStatus in ('1','1a')
	  	   AND P.Date = #dts#
      ORDER BY P.Step ASC
</cfquery>

<!---- We might need to only rebuild planning for the References Ids as per below ---->
<cfquery name="qResetDetails"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	DELETE WorkPlanDetail
	WHERE DateTimePlanning= #DTS#
</cfquery>

<cfquery name="qReset"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	DELETE WorkPlan
	WHERE DateEffective= #DTS#
</cfquery>

<cfset vListingOrder = 0>

<cfloop query ="qCluster">


		<cf_assignId>
		<cfset id = rowguid>	

		<cfquery name="qInsertHeader"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			INSERT INTO WorkPlan
			           (WorkPlanId
					   ,Mission
			           ,OrgUnit
			           ,PersonNo
			           ,FirstName
			           ,LastName
			           ,DateEffective
			           ,DateExpiration
					   ,ReferenceId
			           ,OfficerUserid
			           ,OfficerLastName
			           ,OfficerFirstName)
			     VALUES
			           ('#id#'
					   ,'Kuntz'
			           ,NULL
			           ,'#qCluster.PersonNo#'
			           ,''
			           ,''
			           ,#DTS#
			           ,#DTS#
			           ,'#qCluster.RouteId#'
			           ,'#SESSION.acc#'
			           ,'#SESSION.Last#'
			           ,'#SESSION.First#')
		</cfquery>


		<cfquery name="qFlow"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			  SELECT F.ListingOrder,
				     F.Date,
			         F.Node,
			         F.ListingOrder,
			         F.Distance,
			         F.Duration,
			         F.PlanOrder,
			         N.Latitude,
			         N.Longitude,
			         N.Branch,
			         N.ZipCode,
			         N.CustomerName,
					 N.OrgUnitOwner,
			         O.OrgUnitName,
			         F.ActionStatus,
			         P.Step,
					 N.WorkOrderLineId
			  FROM   stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# F INNER JOIN stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N
					ON   F.Node = N.Node AND F.Date = N.Date 
				INNER JOIN Organization.dbo.Organization O
					ON   N.OrgUnitOwner = O.OrgUnit
				INNER JOIN stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# P ON P.RouteId = F.RouteId
			  WHERE
			  	   F.ActionStatus in ('1','1a')
			  	   AND F.Date         = #dts#
				   AND P.RouteId      = '#qCluster.RouteId#'
			  	ORDER BY P.Step ASC, F.ListingOrder ASC
		</cfquery>		
		
		<cfloop query="qFlow">
		

				<cfif qFlow.Branch eq 0>
					<cfquery name="qWorkOrderAction"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
						SELECT WA.WorkActionId
						FROM WorkOrderLine WL INNER JOIN WorkOrderLineAction WA
						ON WL.WorkOrderId = WA.WorkOrderId AND WL.WorkOrderLine = WA.WorkOrderLine
						WHERE WL.WorkOrderLineId = '#qFlow.WorkOrderLineId#'
						AND WL.ActionStatus!=9
						AND WA.ActionClass = 'Delivery'
					</cfquery>	
					
					<cfif qWorkOrderAction.recordcount neq 0>
						
						<cfquery name="qCheck"
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
							SELECT *
							FROM WorkPlanDetail
							WHERE WorkActionId = '#qWorkOrderAction.WorkActionId#'
							AND   DateTimePlanning= '#qFlow.PlanOrder#'
						</cfquery>						
						
						<cfif qCheck.recordcount eq 0>
							<cfset doIt = TRUE>
						<cfelse>
							<cfset doIt = FALSE>
						</cfif>	
						
					<cfelse>
						<cfset doIt = FALSE>
					</cfif>
				
				<cfelse>
					<cfset doIt = TRUE>
					
				</cfif>	
		
				<cfif doIt>
					
						<cfset vListingOrder = vListingOrder + 1>
						<cfquery name="qInsertDetail"
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
							INSERT INTO WorkPlanDetail
							           (WorkPlanId
							           ,PlanOrder
							           ,PlanOrderCode
							           ,PlanActionMemo
							           ,DateTimePlanning
							           ,OrgUnitOwner
							           ,WorkActionId
							           ,OfficerUserId
							           ,OfficerLastName
							           ,OfficerFirstName)
							     VALUES
							           ('#Id#'
							           ,'#vListingOrder#'
							           ,'#qFlow.PlanOrder#'
							           ,'From Prosis DSS'
							           ,#DTS#
									   <cfif qFlow.Branch eq 1>
							           ,'#qFlow.OrgUnitOwner#'
									   <cfelse>
									   ,NULL
									   </cfif> 
									   <cfif qFlow.Branch eq 0>
							           ,'#qWorkOrderAction.WorkActionId#'
									   <cfelse>
									   ,NULL
									   </cfif> 							   
							           ,'#SESSION.acc#'
							           ,'#SESSION.Last#'
							           ,'#SESSION.First#')
						</cfquery>
						
				</cfif>
		
		</cfloop>

</cfloop>

<CF_DropTable dbName="AppsTransaction" tblName="stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#">
<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#">
<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#">	
<CF_DropTable dbName="AppsTransaction" tblName="stWorkPlanSelection_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#">

<script>
	callBack_Done();
</script>