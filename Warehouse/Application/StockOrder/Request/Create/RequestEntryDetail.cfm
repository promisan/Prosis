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
<cfparam name="url.mode"  default="request">
<cfparam name="url.scope" default="backoffice">

<!--- show the cart lines for which this person is allwed to submit --->
					
<cfquery name="Cart" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WarehouseCart C, Item I, ItemUoM U
    WHERE  C.ItemNo = I.ItemNo 
	AND    C.UoM    = U.UoM
	AND    I.ItemNo = U.ItemNo
	<!--- selected warehouse --->
	AND    C.Warehouse = '#url.warehouse#'
		
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->

	<cfelse>
	
	AND    (

    	     (C.UserAccount = '#SESSION.acc#' AND ShipToWarehouse is NULL)
	                OR 
			 ShipToWarehouse IN (SELECT Warehouse 
			                     FROM   Warehouse 
								 WHERE  Mission = '#url.mission#'
								 AND    MissionOrgUnitid IN 			 
	
							           (
									   
						                  SELECT DISTINCT O.MissionOrgUnitId 
						                  FROM   Organization.dbo.Organization O, 
										         Organization.dbo.OrganizationAuthorization OA
										  WHERE  O.Mission      = '#url.Mission#'
										  AND    O.OrgUnit      = OA.OrgUnit
										  AND    OA.UserAccount = '#SESSION.acc#'											  
										  AND    OA.Role        = 'WhsPick'  
						
										  UNION
										  
										  SELECT DISTINCT O.MissionOrgUnitId 
						                  FROM   Organization.dbo.Organization O, 
										         Organization.dbo.OrganizationAuthorization OA
										  WHERE  O.Mission  = '#url.Mission#'
										  AND    O.Mission = OA.Mission
										  AND    OA.OrgUnit is NULL
										  AND    OA.UserAccount = '#SESSION.acc#'											  
										  AND    OA.Role        = 'WhsPick'  
																							  
									   )	
									   
								)
								
			)		
			
	</cfif>			
	ORDER BY ShipToWarehouse DESC, ShipToLocation							
</cfquery>

<cfif cart.recordcount eq "0">

	<script>
		 document.getElementById('submitbutton').className = "hide"		
	</script>
	
<cfelse>

	<script>
		 document.getElementById('submitbutton').className = "button10s"
	</script>
	
	
</cfif>

<cfinclude template="../../../../Portal/Requester/CartDetail.cfm">	
