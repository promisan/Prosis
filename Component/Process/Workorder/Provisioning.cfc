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

<!--- ------------------------------------------------------------------------------------------ --->
<!--- Component to serve requests that relate to the provisioing of a service based workorder -- ---> 
<!--- ------------------------------------------------------------------------------------------ --->

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="getRate"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="yes"
        displayname="getRate">
		
			<cfargument name="Mission"       type="string" required="true">
			<cfargument name="OrgUnitOwner"  type="string" required="false" default="">
			<cfargument name="ServiceItem"   type="string" required="true"  default="">
			<cfargument name="Unit"          type="string" required="true"  default="">
			<cfargument name="SelectionDate" type="string" required="true"  default=""> 
			
		    <cfset dateValue = "">
			<CF_DateConvert Value="#SelectionDate#">
			<cfset DTE = dateValue>		
			
			<!--- check step one for owner --->
			
			<cfquery name="OrgUnit"
				datasource="AppsWorkOrder">
				SELECT *
				FROM   Organization.dbo.Organization
				<cfif orgunitOwner eq "">
				WHERE 1=0
				<cfelse>
				WHERE  OrgUnit = '#OrgUnitOwner#'				
				</cfif>
			</cfquery>
			
			<cfif OrgUnit.recordcount eq "0">			
			
				<cfset continue = "1">				
			
			<cfelse>
			
				<cfquery name="getRate"
					datasource="AppsWorkOrder">
					SELECT  TOP 1 *, F.Description as FrequencyDescription
					FROM    ServiceItemUnitMission R, Ref_Frequency F
					WHERE   ServiceItem      = '#ServiceItem#' 
					AND     R.Frequency      = F.Code				
					AND     ServiceItemUnit  = '#Unit#' 
					AND     Mission          = '#Mission#' 
					AND     BillingMode     != 'Supply'
					AND     DateEffective   <= #DTE#
					AND     (DateExpiration >= #DTE# or DateExpiration is NULL)												
					AND     CostId IN
	                          (SELECT     CostId
	                            FROM      ServiceItemUnitMissionOrgUnit
	                            WHERE     CostId = R.CostId 
								AND       OrgUnitOwner IN
	                                           (SELECT  OrgUnit
	                                            FROM    Organization.dbo.Organization
	                                            WHERE   MissionOrgUnitId = '#orgUnit.MissionOrgUnitId#'))
				   	ORDER BY DateEffective DESC							
				</cfquery>
				
				
				<cfif getRate.recordcount eq "0">
					<cfset continue = "1">
				<cfelse>
					<cfset continue = "0">	
				</cfif>
			
			</cfif>
			
			<cfif continue eq "1">
			
				<cfquery name="getRate"
					datasource="AppsWorkOrder">
					SELECT  TOP 1 *, F.Description as FrequencyDescription
					FROM    ServiceItemUnitMission R, Ref_Frequency F
					WHERE   ServiceItem      = '#ServiceItem#' 
					AND     R.Frequency      = F.Code
					AND     ServiceItemUnit  = '#Unit#' 
					AND     Mission          = '#Mission#' 
					AND     BillingMode     != 'Supply'
					AND     DateEffective   <= #DTE#
					AND     (DateExpiration >= #DTE# or DateExpiration is NULL)	
					
					<!--- rate is intended as a global rate --->
					
					AND     CostId NOT IN (SELECT    CostId
					                       FROM      ServiceItemUnitMissionOrgUnit
				                           WHERE     CostId = R.CostId )					
					
					ORDER BY DateEffective DESC						
				</cfquery>
				
				<cfif getRate.recordcount eq "0">
				
					<!--- we try to find any rate that somehow matches --->
				
					<cfquery name="getRate"
						datasource="AppsWorkOrder">
						SELECT   TOP 1 *, F.Description as FrequencyDescription
					    FROM     ServiceItemUnitMission R, Ref_Frequency F
					    WHERE    ServiceItem      = '#ServiceItem#' 
					    AND      R.Frequency      = F.Code
						AND      ServiceItemUnit = '#Unit#' 
						AND      BillingMode     != 'Supply'
						AND      Mission         = '#Mission#' 		
						AND      DateEffective   <= #DTE#			
						ORDER BY DateEffective DESC						
					</cfquery>		
				
						
					
				</cfif>
			
			</cfif>		
			
			<cfreturn getRate>						
						
	</cffunction>		
	
	<cffunction name="getProvisioning"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="getProvisioing">
		
			<cfargument name="WorkOrderId"        type="string" required="false">
			<cfargument name="WorkOrderLine"      type="string" required="true" default="">
			<cfargument name="date" type="string" required="true" default=""> 
			
			<cfif date eq "">
			
				<!--- get the last --->
				
				<cfquery name="getlast"
				datasource="AppsWorkOrder">
				
				SELECT    TOP 1 *
				FROM      WorkOrderLineBilling 
				WHERE     WorkorderId = '#workorderid#'
				AND       WorkOrderLine = '#workorderline#'
				ORDER BY BillingEffective DESC
				</cfquery>
				
				<cfif getLast.recordcount eq "1">
				
					<cfset dateValue = "">
					<CF_DateConvert Value="#dateFormat(getlast.BillingEffective,CLIENT.DateFormatShow)#">
					<cfset DTE = dateValue>	
					
				<cfelse>
				
					<cfset dateValue = "">
					<CF_DateConvert Value="#dateFormat(now(),CLIENT.DateFormatShow)#">
					<cfset DTE = dateValue>	
								
				</cfif>	
			
			
			<cfelse>
			
				<cfset dateValue = "">
				<CF_DateConvert Value="#date#">
				<cfset DTE = dateValue>
			
			</cfif>					   
		
			<cfquery name="get"
				datasource="AppsWorkOrder">
				
					SELECT  TOP 200 B.WorkOrderId, 
					          B.WorkOrderLine, 
							  W.BillingEffective, 
							  S.UnitDescription, 
							  B.Frequency, 
							  B.Quantity, 
							  B.Currency, 
							  B.Rate, 
						   	  B.Amount
					FROM      WorkOrderLineBilling AS W INNER JOIN
		                      WorkOrderLineBillingDetail AS B ON W.WorkOrderId = B.WorkOrderId AND W.WorkOrderLine = B.WorkOrderLine AND 
		                      W.BillingEffective = B.BillingEffective INNER JOIN
			                  ServiceItemUnit AS S ON B.ServiceItem = S.ServiceItem AND B.ServiceItemUnit = S.Unit
					WHERE     W.WorkorderId = '#workorderid#'
					AND       W.WorkorderLine = '#workorderline#'
					AND       W.BillingEffective = #dte#
			</cfquery>		  
				
			<cfreturn get>	
					
	</cffunction>
		
</cfcomponent>	