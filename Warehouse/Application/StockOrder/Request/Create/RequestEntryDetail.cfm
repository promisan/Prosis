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
