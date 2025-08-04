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

<cfparam name="url.direction" default="down">
<cfparam name="form.WorkPlanDetailId" default="">

<cfif form.WorkPlanDetailId neq "">

	<!--- we check of the workplanDetailId is a branch and then we need move
	also the underlying deliveries if the dorection is down for internal integrity --->
		
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.dts#">
	<cfset DTS = dateValue>
	
	<cfquery name="getPlan"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT WorkPlanId 
		FROM   WorkPlan W
		WHERE  DateEffective  <= #dts# 
		AND    DateExpiration >= #dts# 
		AND    W.Mission      = '#url.mission#'
	    AND    W.PositionNo   = '#url.PositionNo#'	
	</cfquery>	
	
	<cfset detailid = form.WorkPlanDetailId>
			
	<cfif url.direction eq "down">
	
		<!--- determine the next delivery if this is of the same branch if so we move it as well --->
		
		<cfquery name="getBranch"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT * 
			FROM   WorkPlanDetail
			WHERE  WorkPlanDetailId IN (#preservesingleQuotes(DetailId)#) 
			AND    WorkActionId is NULL
		</cfquery>	
	
		<cfloop query="getBranch">
								
			<cfset next = planorder+1>
			
			<cfquery name="getUnit"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT * 
				FROM   WorkPlanDetail D
				WHERE  WorkPlanId   = '#workplanid#'
				AND    Planorder = #next#
				AND    EXISTS (SELECT  'X'
								FROM    WorkOrderLineAction AS WA INNER JOIN
						                WorkOrder AS W ON WA.WorkOrderId = W.WorkOrderId 
								WHERE   WA.WorkActionId = D.WorkActionId
								AND     W.OrgUnitOwner = '#getBranch.OrgUnitOwner#')				
			</cfquery>	
			
			<cfloop condition="#getUnit.recordcount# eq '1'">
										
				<cfif getUnit.recordcount eq "1">						
					<cfset detailid = "#detailid#,'#getUnit.WorkPlanDetailId#'">			
				</cfif>
				
				<cfset next = next + 1>
				
				<cfquery name="getUnit"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					SELECT * 
					FROM   WorkPlanDetail D
					WHERE  WorkPlanId   = '#workplanid#'
					AND    Planorder = #next#
					AND    EXISTS (SELECT  'X'
									FROM    WorkOrderLineAction AS WA INNER JOIN
							                WorkOrder AS W ON WA.WorkOrderId = W.WorkOrderId 
									WHERE   WA.WorkActionId = D.WorkActionId
									AND     W.OrgUnitOwner = '#getBranch.OrgUnitOwner#')				
				</cfquery>	
			
			</cfloop>
					
		</cfloop>
		
	<cfelse>
	
		<!--- determine if a branch is just above it, if so we move it up as well together with the delivery --->
				
		<cfquery name="getBranch"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT * 
			FROM   WorkPlanDetail
			WHERE  WorkPlanDetailId IN (#preservesingleQuotes(DetailId)#) 
			AND    WorkActionId is NULL
		</cfquery>	
	
		<cfloop query="getBranch">
		
			<cfset prior = planorder-1>
		
			<cfquery name="getUnit"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT * 
				FROM   WorkPlanDetail D
				WHERE  WorkPlanId   = '#workplanid#'
				AND    Planorder = #prior#
				AND    EXISTS (SELECT  'X'
								FROM    WorkOrderLineAction AS WA INNER JOIN
						                WorkOrder AS W ON WA.WorkOrderId = W.WorkOrderId 
								WHERE   WA.WorkActionId = D.WorkActionId
								AND     W.OrgUnitOwner = '#getBranch.OrgUnitOwner#')				
			</cfquery>	
			
			<cfloop condition="#getUnit.recordcount# eq '1'">
										
				<cfif getUnit.recordcount eq "1">						
					<cfset detailid = "#detailid#,'#getUnit.WorkPlanDetailId#'">			
				</cfif>
				
				<cfset prior = prior - 1>
				
				<cfquery name="getUnit"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					SELECT * 
					FROM   WorkPlanDetail D
					WHERE  WorkPlanId   = '#workplanid#'
					AND    Planorder = #prior#
					AND    EXISTS (SELECT  'X'
									FROM    WorkOrderLineAction AS WA INNER JOIN
							                WorkOrder AS W ON WA.WorkOrderId = W.WorkOrderId 
									WHERE   WA.WorkActionId = D.WorkActionId
									AND     W.OrgUnitOwner = '#getBranch.OrgUnitOwner#')				
				</cfquery>	
			
			</cfloop>
			
		</cfloop>				
	
	</cfif>
			
	<cfif url.direction eq "down">
		<cfset val = "+1">
		<cfset pro = "-1">
	<cfelse>
		<cfset val = "-1">
		<cfset pro = "+1">
	</cfif>
	
	<cfloop query="getPlan">	
		
		<cfquery name="update"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			UPDATE WorkPlanDetail 
			SET    PlanOrder    = PlanOrder#val#, 
			       Created      = getDate()
			WHERE  WorkPlanId   = '#workplanid#'
			AND    WorkPlanDetailId IN (#preservesingleQuotes(DetailId)#)			
		</cfquery>	
		
		<cfset planid = workplanid>
		
		<!--- now we need to correct planorders which are double --->
		
		<cfquery name="obtain"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT   PlanOrder,count(*) 
				FROM     WorkPlanDetail 		
				WHERE    WorkPlanId   = '#planid#'
				GROUP BY PlanOrder	
				HAVING   count(*) > 1
		</cfquery>	
				
		<cfloop condition="#obtain.recordcount# gte 1">
						
			<cfloop query="Obtain">
			
				<cfquery name="set"
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					UPDATE  WorkPlanDetail 
					SET     PlanOrder    = PlanOrder#pro#, 
					        Created      = getDate()
					WHERE   WorkPlanId   = '#planid#'
					AND     PlanOrder    = '#PlanOrder#'
					AND     WorkPlanDetailId NOT IN (#preservesingleQuotes(DetailId)#) 
				</cfquery>	
					
			</cfloop>
			
			<cfquery name="obtain"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				SELECT   PlanOrder,count(*) 
				FROM     WorkPlanDetail 		
				WHERE    WorkPlanId   = '#planid#'
				AND      PlanOrder > 0
				AND      PlanOrder < 30
				GROUP BY PlanOrder	
				HAVING   count(*) > 1
			</cfquery>	
				
		</cfloop>	
			
		<!--- we define the schedule --->
		
		<cfquery name="getPlan"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT *
			FROM   WorkPlanDetail
			WHERE  WorkPlanId = '#workplanid#'	
			ORDER BY PlanOrder	
		</cfquery>	
		
		<cfquery name="getOrder"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT * FROM Ref_PlanOrder		
			ORDER BY ListingOrder
		</cfquery>	
		
		<cfloop query="getOrder">
				    
			<cfset ar[currentrow][1] = listingorder>
			<cfset ar[currentrow][2] = code>
			
		</cfloop>
								
		<cfloop query="getPlan">	
					
			<cfset row = ceiling(currentrow/2)>
			
			<cftry>			
				<cfset cde = ar[row][2]>
			<cfcatch>
			
			</cfcatch>
			</cftry>
			
			<cfif PlanorderCode neq cde>
						
				<cfquery name="update"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
						UPDATE WorkPlanDetail 
						SET    PlanOrderCode = '#cde#'
						WHERE  WorkPlanDetailId = '#workplandetailid#'	
					</cfquery>					
			</cfif>	
			
			
		</cfloop>
						
						
		<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
			   method           = "setWorkPlanOrder" 
			   WorkPlanId       = "#workplanid#">   			
				
	</cfloop>

</cfif>

<cfset url.mode = "embed">
<cfinclude template="WorkPlanActorDetail.cfm">
	