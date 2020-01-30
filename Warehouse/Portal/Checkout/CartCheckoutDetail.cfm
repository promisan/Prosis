
<cfparam name="url.mode" default="request">
					
<cfquery name="Cart" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (SELECT Description FROM Ref_Category WHERE Category = C.Category) as Usage
    FROM   WarehouseCart C, Item I, ItemUoM U
    WHERE  C.ItemNo = I.ItemNo 
	AND    C.UoM = U.UoM
	AND    I.ItemNo = U.ItemNo
	<!--- selected warehouse --->
	AND    C.Warehouse = '#url.warehouse#'
	
	<cfif url.mode eq "submit">
	
	AND C.ShipToWarehouse is NOT NULL
	
	<cfelse>
	
	AND C.ShipToWarehouse is NULL
	
	</cfif>
		
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

<cfinclude template="../Requester/CartDetail.cfm">	
