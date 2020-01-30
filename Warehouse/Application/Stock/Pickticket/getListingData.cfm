	
<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT *
	
	FROM (

		SELECT    DISTINCT 
		          R.RequestId,
	              R.Reference, 
	              R.RequestDate, 
				  Org.OrgUnit, 
				  Org.OrgUnitName, 			  
				  R.Warehouse, 
				  R.ShipToWarehouse,
				  (SELECT WarehouseName 
				   FROM   Warehouse
				   WHERE  Warehouse = R.ShipToWarehouse) as ShipToWarehouseName,
				  R.ItemNo, 
	              R.RequestedQuantity, 
					(SELECT ISNULL(SUM(TransactionQuantity*-1),0) 
					 FROM   ItemTransaction E
					 WHERE  E.RequestId = R.RequestId
					 AND    TransactionQuantity < 0) as Fullfilled, 
				 R.UoM AS UnitOfMeasure, 
	             I.ItemPrecision, 
				 R.StandardCost, 
				 R.RequestedAmount, 
				 R.Currency,
				 R.ItemPrice,
				 R.ItemAmount,
				 R.SalesPrice,
				 R.SalesAmount,
				 R.Status, 
				 H.ActionStatus,
				 I.ItemDescription, 				 
				 H.Contact, 
	             H.eMailAddress, 
				 H.DateDue,
				 H.Remarks, 
				 R.UoMMultiplier, 
				 U.UoMDescription
						
		FROM     Request R INNER JOIN
		         Item I ON R.ItemNo = I.ItemNo INNER JOIN
		         Organization.dbo.Organization Org ON R.OrgUnit = Org.OrgUnit INNER JOIN
		         RequestHeader H ON R.Reference = H.Reference INNER JOIN
		         ItemUoM U ON I.ItemNo = U.ItemNo and R.UoM = U.UoM
		WHERE    R.Status = '#URL.IDStatus#' <!--- status = 2 or 2b backordered --->		
		
		AND      ( 
		               ( 
					    H.RequestHeaderId IN (SELECT ObjectKeyValue4 
					                         FROM   Organization.dbo.OrganizationObject
											 WHERE  EntityCode = 'WhsRequest'
		                                     AND    ObjectKeyValue4 = H.RequestHeaderId) 
											 
					     AND H.ActionStatus IN ('2','2a','3')
						 
						)
					   
				     OR  (
					    
						 H.RequestHeaderId NOT IN (SELECT ObjectKeyValue4 
					                              FROM   Organization.dbo.OrganizationObject
												  WHERE  EntityCode = 'WhsRequest'
				                                  AND    ObjectKeyValue4 = H.RequestHeaderId) 
					 
					     AND H.ActionStatus != '9'	
					 
					    )
					
				  )   
		
								
		AND       R.ItemClass   = '#URL.ItemClass#'  
		
		AND       R.RequestType IN ('Pickticket','Warehouse')  <!--- warehouse = transfer --->
		AND       R.Warehouse   = '#URL.Warehouse#'
		
		
	
	) as X
	
	WHERE RequestedQuantity > Fullfilled
	
	<cfif trim(url.fnd) neq "">
		AND		  (
						Reference like '%#trim(url.fnd)#%'
						OR
						Contact like '%#trim(url.fnd)#%'
						OR
						ShipToWarehouseName like '%#trim(url.fnd)#%'
						OR
						ItemNo like '%#trim(url.fnd)#%'
						OR
						ItemDescription like '%#trim(url.fnd)#%'
						OR
						UoMDescription like '%#trim(url.fnd)#%'
				  )
		</cfif> 	
				
	ORDER BY  X.Reference, X.ItemNo 
	
</cfquery>



