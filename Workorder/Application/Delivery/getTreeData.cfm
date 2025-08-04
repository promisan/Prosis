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
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<cfquery name="getCountry"
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT    *
		FROM      Ref_Mission
		WHERE     Mission = '#url.mission#'		
</cfquery>

<cfset nat = getCountry.CountryCode>

<!--- --------------------------------- --->

<cfset vInit = GetTickCount()>

<cfquery name="Branch"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		
		SELECT   DISTINCT W.OrgUnitOwner as OrgUnit
	    FROM     WorkOrder AS W INNER JOIN
                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 
	    WHERE    A.ActionClass       = 'Delivery' 	   
	    AND      A.DateTimePlanning  = #dts#
	    AND      WL.Operational      = '1'
	    AND      W.Mission           = '#url.mission#'	
	   
</cfquery>	

<cfset unitchecked   = "">
<cfset units         = "">
<cfset workactionids = "">

<cfloop query="Branch">

	<cfif StructKeyExists(Form,"select_#orgunit#")>		
		
		<cfset sel = Form["select_#orgunit#"]>				
		
		<cfif sel neq "0" and sel neq "">
		
			<cfif StructKeyExists(Form,"workaction_#orgunit#")>					
				<cfset act = Form["workaction_#orgunit#"]>								
				<cfif act eq "">				
					<cfif units eq "">
						<cfset units = orgunit>
					<cfelse>
					 	<cfset units = "#units#,#orgunit#">  
					</cfif>					
					<!--- pointer to select all within this unit --->				
				<cfelse>								
					<cfif workactionids eq "">
				  		<cfset workactionids = act>
					<cfelse>
				  		<cfset workactionids = "#workactionids#,#act#">  
					</cfif>							
				</cfif> 				
			<cfelse>						
				<cfif units eq "">
					<cfset units = orgunit>
				<cfelse>
				 	<cfset units = "#units#,#orgunit#">  
				</cfif>					
			</cfif>				
			<cfif unitchecked eq "">
		  		<cfset unitchecked = orgunit>
			<cfelse>
		  		<cfset unitchecked = "#unitchecked#,#orgunit#">  
			</cfif>						
		</cfif>	
			
	</cfif>	
	
</cfloop>	

<!--- to be revised for DSS planner --->
<cfset SESSION.units_scope = unitchecked>

<cfparam name="form.Person" default="">
<cfset person = Form.Person>