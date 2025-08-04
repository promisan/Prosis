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

<cfparam name="URL.ID4" default="default">
<cfset Mission = "#Attributes.Mission#">

<cfquery name="CurrentMandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT   TOP 1 *
      FROM     Ref_Mandate
   	  WHERE    Mission = '#Mission#' 
	  ORDER BY MandateDefault DESC
</cfquery>

<!--- General correct by Hanno on 23/07/2012 as warehouse granted access is not mandate sensitive
and is driven by the role we adjust the entries in OrganizationAuthorization to reflect the OrgUnit of the current mandate 
which is derrived through the missionorgunitid --->

<cfinvoke component="Service.Access.AccessLog"  
		  method       = "SyncWarehouseAccess"
		  Mission      = "#Mission#"
		  Role         = "#URL.ID4#">	 
		  
<cf_UItree id="root"
	title="<span style='font-size:16px;padding-bottom:3px'>Warehouse</span>"		
	Root="no"
	expand="Yes">		  
		
		<cfoutput>
		
		<cf_UItreeitem value="#Mission#"
	        display="<span style='font-size:15px;padding-top:1px;;padding-bottom:1px' class='labelit'>#CurrentMandate.Description#</span>"				
			target="right"
			parent="root"
			href="OrganizationListing.cfm?Mission=#Mission#&ID4=#URL.ID4#">	
				  				
			<cfquery name="City" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT DISTINCT City
				  FROM   Materials.dbo.Warehouse W
				  WHERE  Mission = '#Mission#'      
			</cfquery>
			
			<cfloop query="City">
			
				<cf_UItreeitem value="#mission#_#currentrow#"
			        display="<span style='font-size:15px' class='labelit'>#City#</span>" parent="#mission#">	
				
				  <cfquery name="Warehouse" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
				      SELECT   DISTINCT O.TreeOrder, O.OrgUnitName, O.OrgUnit, O.OrgUnitCode, W.WarehouseName 
				      FROM     #Client.LanPrefix#Organization O, Materials.dbo.Warehouse W
				   	  WHERE    O.MissionOrgUnitId = W.MissionOrgUnitId
					  AND      W.Mission          = '#Mission#'
					  AND      O.MandateNo        = '#CurrentMandate.MandateNo#'
					  AND      W.City             = '#City#'
					  ORDER BY TreeOrder, OrgUnitName 
				  </cfquery>
				  
				  <cfset parent = "#mission#_#currentrow#">
				  
				  <cfloop query="Warehouse">
				  
				  	<cf_UItreeitem value="#mission#_#WarehouseName#"
				        display="<span style='font-size:13px' class='labelit'>#WarehouseName#</span>"
						parent="#parent#"						
						target="right"
						href="OrganizationListing.cfm?ID0=#OrgUnit#&ID1=#OrgUnit#&Mission=#Mission#&ID3=#CurrentMandate.MandateNo#&ID4=#URL.ID4#">	
				  					    
				  </cfloop>						  
			  
			  </cfloop>
			      
		</cfoutput>
		
</cf_UItree>


