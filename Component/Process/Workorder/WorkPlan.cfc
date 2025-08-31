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
<!--- ------------------------------------------------------------------------------------------ --->
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "WorkPlan Component">
	
	<cffunction name="addWorkPlan"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="addWorkPlan">
		
		<cfargument name="Mode"                    type="string" default="Add" required="yes">
		<cfargument name="Mission"                 type="string" required="true">
		<cfargument name="OrgUnit"                 type="string" required="true">
		<cfargument name="PositionNo"              type="string" required="true">
		<cfargument name="PersonNo"                type="string" required="no">
		<cfargument name="DateEffective"           type="string" required="yes">
		<cfargument name="DateExpiration"          type="string" default="#DateEffective#"  required="yes">
		
		<cfquery name="getWorkPlan"
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">								
				SELECT   WorkPlanId
				FROM     WorkPlan  
				WHERE    Mission       = '#Mission#' 
				AND      OrgUnit       = '#OrgUnit#'
				AND      PositionNo    = '#PositionNo#'      
				AND      DateEffective = '#dateformat(DateEffective,client.dateSQL)#' 	
				AND      DateEffective = '#dateformat(DateExpiration,client.dateSQL)#' 								
		</cfquery>		
									
		<cfif getWorkPlan.recordcount eq "0">
		
			<cf_assignId>
			<cfset workplanid = rowguid>
			
			<!--- create workplan --->
				
			<cfquery name="addWorkPlan"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			
				INSERT INTO WorkPlan 
					
					( WorkPlanId, 
					  Mission, 
					  OrgUnit, 
					  PositionNo, 
					  PersonNo, 
					  DateEffective, 
					  DateExpiration, 		
					  OfficerUserid, 
					  OfficerLastName, 
			          OfficerFirstName )		
				  
				 VALUES
				 
					 ( '#workplanid#',
					   '#mission#',
					   '#orgunit#',
					   '#PositionNo#',
					   '#PersonNo#',
					   '#dateformat(DateEffective,client.dateSQL)#', 
					   '#dateformat(DateExpiration,client.dateSQL)#', 
					   '#session.acc#',
					   '#session.last#',
					   '#session.first#' )  
						
			</cfquery>		
		
		<cfelse>
		
			<cfset workplanid = getWorkPlan.workplanId>		
		
		</cfif>	
				
		<cfreturn workplanid>		
		
	</cffunction>	
	
	
	<cffunction name="addWorkPlanDetail"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="Yes"
        displayname="addWorkPlanDetail">
		
		<cfargument name="Mode"                    type="string" default="Add" required="yes">
		<cfargument name="WorkPlanId"              type="string" required="true">
		<cfargument name="PlanOrder"               type="string" default = "1" required="false">
		<cfargument name="PlanOrderCode"           type="string" default = "" required="false">
		<cfargument name="OrgUnitOwner"            type="string" default = "" required="false">
		<cfargument name="WorkActionId"            type="string" default = "" required="false">
		<cfargument name="LocationId"              type="string" required="false">
		<cfargument name="WorkSchedule"            type="string" default = "" required="no">
		<cfargument name="DateTimePlanning"        type="date" required="yes">
		
		<cfquery name="checkDetail"
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">								
			    SELECT   *
				FROM     WorkPlanDetail 
				WHERE    WorkPlanId      = '#workplanid#'	
				<cfif OrgUnitOwner neq "">		
				AND      OrgUnitOwner    = '#OrgUnitOwner#'
				</cfif>
				<cfif workActionId neq "">
				AND      WorkActionid    = '#WorkActionId#'
				</cfif>							
				AND      DateTimePlanning = #DateTimePlanning#
	     </cfquery>		
		 		 		 		 	 
		  <cfif checkDetail.recordcount eq "0">		  
											   
	   		<cf_assignId>
			<cfset workplandetailid = rowguid>
	 									   
	  		 <cfquery name="addWorkPlanDetail"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
															
				INSERT INTO WorkPlanDetail (
			
					WorkPlanId, 
					WorkPlanDetailId,
					PlanOrder, 		
					<cfif planordercode neq "">												
					PlanOrderCode,
					</cfif>
					<cfif workschedule neq "">
					WorkSchedule,
					</cfif>
					<cfif OrgUnitOwner neq "">
					OrgUnitOwner,
					</cfif>
					<cfif WorkActionId neq "">
					WorkActionId,
					</cfif>
					<cfif LocationId neq "">
					LocationId,
					</cfif>
				    DateTimePlanning, 															    		    
				    OfficerUserId, 
				    OfficerLastName, 
		            OfficerFirstName
					
			      ) VALUES (
				  
				  	'#workplanid#',
					'#workplandetailid#',
					'#planorder#',	
					<cfif PlanOrderCode neq "">												
					'#PlanOrderCode#',
					</cfif>												
					<cfif Workschedule neq "">
					'#workschedule#',
					</cfif>
					<cfif OrgUnitOwner neq "">
					'#OrgUnitOwner#',
					</cfif>
					<cfif WorkActionId neq "">
					'#WorkActionId#',
					</cfif>
					<cfif LocationId neq "">
					'#LocationId#',
					</cfif>
					#datetimeplanning#,															
					'#session.acc#',
					'#session.last#',
					'#session.first#')	
							  			
		    </cfquery>		
			
			<cfquery name="checkDetail"
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">								
			    SELECT   *
				FROM     WorkPlanDetail 
				WHERE    WorkPlanDetailId      = '#workplandetailid#'					
		     </cfquery>																						   
									   
		  </cfif>
						
		<cfreturn checkdetail>		
		
	</cffunction>		
		
		
</cfcomponent>	