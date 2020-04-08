
<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT     *
	FROM       Ref_ParameterMission
	WHERE      Mission = '#url.mission#'	
</cfquery>

<cf_PortalDefaultValue 
	systemfunctionid = "#url.systemfunctionid#" 
	key       = "Warehouse" 
	ResultVar = "SelectedWarehouse">

<cfset selwhs = "">
	
<cfloop index="whs" list="#SelectedWarehouse#" delimiters=",">
   <cfif selwhs eq "">
     <cfset selwhs = "'#whs#'">
   <cfelse>
   	 <cfset selwhs = "#selwhs#,'#whs#'">
   </cfif>
</cfloop>	

<cfset diff = (100+param.taskorderdifference)/100>   

<!--- ------------------------------------------------------------------ --->
<!--- procedure to adjust request with the actual tasked if it is tasked --->

<cfquery name="ResetQuantityRequest" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	UPDATE Request
	SET    RequestedQuantity = Q.Total
	
	FROM   (
			
			SELECT     R.RequestId, 
			           R.RequestedQuantity, 
					   SUM(T.TaskQuantity) AS Total
			FROM       Request AS R INNER JOIN
			           RequestTask AS T ON R.RequestId = T.RequestId
			WHERE      (T.RecordStatus = '1') AND (R.Status IN ('2','3'))
			GROUP BY   R.RequestId, R.RequestedQuantity
			HAVING     R.RequestedQuantity <> SUM(T.TaskQuantity)
			
			) Q, Request T
	
	WHERE Q.Requestid = T.RequestId
	AND   T.Mission = '#url.mission#'
	
</cfquery>

<cfsavecontent variable="onhand">
	(
	SELECT ISNULL(SUM(TransactionQuantity),0)
    FROM     ItemTransaction
    WHERE    Warehouse      = I.Warehouse 
	AND      Location       = I.Location 
	AND      ItemNo         = I.ItemNo 
	AND      TransactionUoM = I.UoM
	)
</cfsavecontent>

<cfinvoke component = "Service.Access"  
		method           = "WarehouseAccessList" 
		mission          = "#url.mission#" 					   					 
		Role             = "'WhsPick'"
		accesslevel      = "'2'" 					  
		returnvariable   = "WhsAccess">
	
<cfif whsaccess eq "">

	<table align="center"><tr><td class="labelit" style="height:120">No access was granted to any facilities. Please contact your administrator.</td></tr></table>
	<cfabort>
</cfif>		

<cfquery name="WarehouseList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT <!--- TOP 800 save guard to keep the size smaller --->
			TOP 500
	       W.Warehouse, 
	       W.WarehouseName,
		   W.City,
		   WL.Location, 
		   WL.Description as LocationDescription,
		   WL.StorageCode,
		   WL.StorageId,
		   WL.LocationId,
		   
		   I.DistributionAverage,
		   
		   (
		   		SELECT 	ISNULL(DistributionAverage,0)
		   		FROM	ItemWarehousePattern
		   		WHERE	Warehouse = I.Warehouse
		   		AND		ItemNo = I.ItemNo
		   		AND		UoM = I.UoM
		   		AND		CONVERT(VARCHAR(10), DateEffective, 112) = CONVERT(VARCHAR(10), getDate(), 112)
		   ) as WarehouseDistributionAverage,
		   
		   (
				SELECT ISNULL(SUM(TransactionQuantity),0)
			    FROM     ItemTransaction
			    WHERE    Warehouse      = I.Warehouse  
				AND      ItemNo         = I.ItemNo 
				AND      TransactionUoM = I.UoM
		   ) as WarehouseOnHand,	
		   
		   (SELECT COUNT(BatchNo) 
		    FROM   WarehouseBatch B
		    WHERE  Warehouse = W.Warehouse 
			AND    BatchNo IN (SELECT BatchNo FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo)
		    AND    ActionStatus = '0') as Pending,  
		   
			   (SELECT COUNT(DISTINCT CONVERT(varchar(40),LocationId))
			    FROM   WarehouseLocation, Location 
				WHERE  Warehouse = WL.Warehouse) as LocationIdCount,
		   
			   (  SELECT LocationName
			      FROM Location 
				  WHERE Location = WL.LocationId) as StorageLocation,
			
		   I.ItemLocationId,
		   I.ItemNo, 
		   I.UoM,
		   C.Category,
		   C.Description as CategoryDescription,
		   IM.ItemPrecision,
		   I.UoM as ItemUoM,
		   IU.EnablePortal,
		   WL.LocationClass as LocationClassCode,
		   
		   <!--- cart --->

			<!---				  
		   (SELECT TOP 1 CartId
                FROM    WarehouseCart
                WHERE   ShipToWarehouse   = I.Warehouse 
			    AND     ShipToLocation    = I.Location 
			    AND     ItemNo            = I.ItemNo 
			    AND     UoM               = I.UoM) AS CartId, 
			--->
			null AS CartId,	  		  
		   
		   (SELECT      Description 
		       FROM     Ref_WarehouseLocationClass 
			   WHERE    Code = WL.LocationClass) as LocationClass,				 

			<!--- ----------------------------------------- ---> 	
			<!--- ---------------last transaction-------------->
			<!--- ----------------------------------------- ---> 		  
			
			(SELECT MAX(TransactionDate) as LastUpdated
                FROM     ItemTransaction
                WHERE    Warehouse      = I.Warehouse 
			    AND      Location       = I.Location 
			    AND      ItemNo         = I.ItemNo 
			    AND      TransactionUoM = I.UoM) AS LastUpdated, 	
				
		    <!--- ----------------------------------------- ---> 	
			<!--- ------------DRAFT REQUEST---------------- --->
			<!--- ----------------------------------------- ---> 			

			<!---			  
			(SELECT sum(Quantity) 
                FROM     WarehouseCart
                WHERE    ShipToWarehouse    = I.Warehouse 
			    AND      ShipToLocation     = I.Location 
			    AND      ItemNo             = I.ItemNo 
			    AND      UoM                = I.UoM				
				) AS onDraft, 
			--->
			0 AS onDraft,			
							
			<!--- ----------------------------------------- --->
			<!--- stock on request for the storage location --->		
			<!--- ----------------------------------------- --->  
			
			(SELECT sum(RD.RequestedQuantity) 
                FROM     Request R 
				         INNER JOIN RequestDetail RD ON R.RequestId = RD.RequestId 
						 INNER JOIN RequestHeader RH ON R.Mission = RH.Mission and RH.Reference = R.Reference
						 
                WHERE    RD.ShipToWarehouse  = I.Warehouse 
			    AND      RD.ShipToLocation   = I.Location 
			    AND      R.ItemNo            = I.ItemNo 
			    AND      R.UoM               = I.UoM	
	
				AND      RH.ActionStatus < '5'   <!--- added hanno --->
				
				<!--- total requested --->
				
				AND      R.RequestedQuantity > 
					
					    <!--- total received on this request --->
						
					    (
							(SELECT  ISNULL(SUM(TransactionQuantity),0)*#diff# 
							 FROM    ItemTransaction T
							 WHERE   RequestId  = R.RequestId
							 AND     TransactionType IN ('1','8','6')  <!--- maybe better to drop and take any positive transaction type --->
							 AND     TransactionQuantity > 0)	
						 						 
						 +
							
						   (SELECT ISNULL(SUM(TaskQuantity),0)
							FROM   RequestTask
							WHERE  RequestId = R.RequestId							
							AND    RecordStatus = '3')
						 
						)						
				
				 		
				AND      R.Status != '9'				
				
				) AS onRequest, 	
				
			<!--- ----------------------------------------- --->
			<!--- stock on request for the storage location --->		
			<!--- ----------------------------------------- --->  
			
			(SELECT SUM(RD.RequestedQuantity) 
                FROM     Request R 
						 INNER JOIN RequestDetail RD ON R.RequestId = RD.RequestId
						 INNER JOIN RequestHeader RH ON R.Mission = RH.Mission and RH.Reference = R.Reference
                WHERE    RD.ShipToWarehouse  = I.Warehouse 
			    AND      RD.ShipToLocation   = I.Location 
			    AND      R.ItemNo            = I.ItemNo 
			    AND      R.UoM               = I.UoM	
				AND      RH.ActionStatus < '5'
				AND      R.Status = '9'
				<!--- show only for 7 days --->
				AND      R.Created > getDate() - 7							
				) AS onCancel, 		
				
			<!--- ----------------------------------------- ---> 		   
		    <!--- ---- stock on hand for storage location - --->
		    <!--- ----------------------------------------- ---> 
		   
		   #onhand# AS OnHand, 					
			
			<!--- -------------------- --->
			<!--- get the usable stock --->		
			<!--- -------------------- --->
						
		   (CASE WHEN (#onhand# - I.LowestStock) < 0 THEN 0 ELSE (#onhand# - I.LowestStock) END) AS Usable,						 
			  
		   IM.ItemDescription,
		   IU.UoMDescription,
		   R.Description as LocationClassName,		   
		   I.MinimumStock,	   
		   I.MaximumStock,		
		   I.LowestStock
		   		   
	FROM   Warehouse W, 
		   Ref_WarehouseCity WC,
	       WarehouseLocation WL, 
		   <!--- detail stock location --->
		   ItemWarehouseLocation I,
		   Ref_WarehouseLocationClass R,
		   Item IM,
		   Ref_Category C,
		   ItemUoM IU
		   
	WHERE  W.Mission      = '#url.mission#' 
	AND    W.Warehouse    = WL.Warehouse
	AND    IM.Category    = C.Category
	AND    W.Mission      = WC.Mission
	AND    W.City         = WC.City
	AND    WL.Warehouse   = I.Warehouse
	AND    WL.Location    = I.Location
	AND    R.Code         = WL.LocationClass
	AND    I.ItemNo       = IM.ItemNo
	AND    I.ItemNo       = IU.ItemNo
	AND    I.UoM          = IU.UoM 	
	AND    W.Operational  = 1
	AND    WL.Operational = 1
	AND    IM.ItemClass   = 'Supply'
					
	<!--- limit access based on granted access as whs procesor which is 
	         derrived from the determined missionorgunitid --->		
			 
	AND    W.Warehouse IN  (#preservesingleQuotes(whsaccess)#)	
	
	<cfif url.init eq "0">
	
		<cfif selwhs eq "">
		
		AND   1=0
	
		<cfelse>
	
		<!--- filter based on the defaults selected --->	
		<!--- ------------------------------------ --->
		AND   W.Warehouse IN (#preservesingleQuotes(selwhs)#)	
		<!--- ------------------------------------ --->
	
		</cfif>
	
	</cfif>
	
		
	ORDER BY  WC.ListingOrder, 
			  W.City, 
			  W.WarehouseClass,
	          W.WarehouseName,
	          WL.LocationId, 
			  C.Description,
			  IM.ItemDescription, 
			  IU.UoMDescription, 
			  WL.LocationClass
		
</cfquery>

