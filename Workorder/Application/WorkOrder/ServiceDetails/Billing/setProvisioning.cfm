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
<cfoutput>

	<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT    *							  
			FROM      WorkOrder
			WHERE     WorkOrderId = '#url.workorderid#'
																							
	</cfquery>		
	
	<cfparam name="form.workactionid" default="">
	
	<cfset act = "">
	<cfloop index="itm" list="#Form.WorkActionId#">
	  <cfif act neq "">
		  <cfset act = "#act#,'#itm#'">
	  <cfelse>
	      <cfset act = "'#itm#'">
	  </cfif>
	</cfloop>
	
	<cfquery name="Actions" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT    *							  
			FROM      WorkOrderLineAction 
			<cfif act neq "">
			WHERE     WorkActionId  IN (#preserveSingleQuotes(act)#) 
			<cfelse>
			WHERE   1=0
			</cfif>																				
	</cfquery>		
	
	<cfquery name="DefaultClasses" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT SIU.UnitClass
		FROM     ServiceItemUnitMission SIUM INNER JOIN
                 ServiceItemUnit SIU ON SIUM.ServiceItemUnit = SIU.Unit AND SIUM.ServiceItem = SIU.ServiceItem
        WHERE    SIUM.Mission = '#get.mission#' 
        AND      SIUM.EnableSetDefault = '1'
	</cfquery>
	
	<cfloop query="defaultclasses">
	
		<script>
		    try {
			document.getElementById('#UnitClass#_unitquantity_0').value = '#Actions.recordcount#'
			calc('#unitclass#','0','#Actions.recordcount#',document.getElementById('#UnitClass#_standardcost_0').value)
			} catch(e) {}			
		</script>
	
	</cfloop>	
	
	<!--- wildcard : or take the first regular entry to be increased with the check box --->
	<script>
	       
			try {
			document.getElementById('Regular_UnitQuantity_1').value = '#Actions.recordcount#'			
			calc('Regular','1','#Actions.recordcount#',document.getElementById('Regular_StandardCost_1').value)
			} catch(e) {}	
	</script>
	
</cfoutput>