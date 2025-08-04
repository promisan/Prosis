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

<cfquery name="param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Ref_ParameterMission
	   WHERE     Mission = '#url.mission#'  
</cfquery>
		
<cfset diff = (100+param.taskorderdifference)/100>  

<cfoutput>

<cfsavecontent variable="access">

		AND   W.Warehouse IN (
                 SELECT DISTINCT Warehouse 
                 FROM   Request R
			     WHERE  Mission = '#url.mission#' 
				 
				 <!--- AND   Distribution = 1 --->
				 
				 AND    (
				            R.OrgUnit  IN (
					                       SELECT S.OrgUnit <!--- all possible orgunits based on the linkage --->
					                       FROM   Organization.dbo.OrganizationAuthorization A, 
										          Organization.dbo.Organization O, 
												  Organization.dbo.Organization S
										   WHERE  A.OrgUnit = O.OrgUnit
										   AND    O.MissionOrgUnitId = S.MissionOrgUnitId
										   AND    A.UserAccount = '#SESSION.acc#'
										   AND    A.Role = 'WhsRequester'											   
									   )
						    OR 
							R.Mission  IN (
								           SELECT Mission 
					                       FROM   Organization.dbo.OrganizationAuthorization 
										   WHERE  UserAccount = '#SESSION.acc#'
										   AND    Role        = 'WhsRequester'		
										   AND    Mission     = '#url.mission#'				   
										   AND    (OrgUnit is NULL or OrgUnit = 0)
				        )   
			   )
			   
	)		   


</cfsavecontent>

</cfoutput>

<!--- initial queries --->

<cfquery name="WarehouseList" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   R.ListingOrder, R.City, W.Warehouse, W.WarehouseName,		
		 
			 (SELECT COUNT(DISTINCT H.Reference)  
	          FROM   Request L, RequestHeader H
			  WHERE  H.Mission = '#url.mission#'
			  AND    H.Mission   = L.Mission
			  AND    H.Reference = L.Reference
			  AND    L.Warehouse = W.Warehouse
			  AND    H.ActionStatus < '5') AS counted
				 
    FROM     Warehouse W, Ref_WarehouseCity R
	WHERE    W.Mission = R.Mission
	AND      W.City = R.City
    AND      W.Mission = '#url.mission#'	
	AND      Distribution = 1

	<!--- only warehouses to which this person has access --->
	
	<cfif getAdministrator(url.mission) eq "1">	
	    #preservesinglequotes(access)#
	<cfelse>
	     AND Warehouse IN (SELECT Warehouse
		                   FROM   Request 
						   WHERE  Warehouse = W.Warehouse)
	</cfif>
	ORDER BY R.ListingOrder
								   
</cfquery>

<!--- status list to be shown --->

 <cfquery name="Status" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  
	    SELECT   E.Status, 
		         E.Description, 
				 E.ListingOrder,
				 E.ListingGroup							 									
					 
	    FROM     Status E
	    WHERE    E.Class = 'Header'	
		AND      E.Status != '0'
		
		AND      (
		         E.Show = 1 OR Status IN (SELECT ActionStatus 
				                           FROM   RequestHeader 
								           WHERE  Mission = '#url.mission#' 
								           AND    ActionStatus = E.Status)
										   
			     )	    
		ORDER BY E.ListingOrder, E.Status, E.Description
		
 </cfquery>
 
 <!--- status content --->

 <cfquery name="StatusList" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  
 	  SELECT    R.Warehouse,
			    H.ActionStatus,
			    count(DISTINCT H.Reference) as Total
      FROM      RequestHeader H, Request R
	  WHERE     H.Reference = R.Reference
	  AND       H.Mission   = R.Mission
	  AND       H.Mission   = '#url.mission#'			 
	  GROUP BY  R.Warehouse,
			    H.ActionStatus		 
		
</cfquery> 
 
<cfquery name="StatusTaskList" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT     R.Warehouse, 
	           R.Reference,
	           RT.RequestId, 
			   RT.TaskSerialNo, 			  
			   RT.StockOrderId, 
			   RT.ShipToMode, 
			   RT.TaskType, 
			   RT.SourceWarehouse,
			   C.Category,
			   C.Description as ItemCategory,
			   '3' as ActionStatus,
			   
			   (CASE WHEN RT.SourceRequisitionNo is not NULL THEN 'Procurement'
                    
				  ELSE  (
						SELECT    RC.Description
						FROM      Ref_WarehouseClass RC INNER JOIN
						          Warehouse RW ON RC.Code = RW.WarehouseClass
						WHERE     RW.Warehouse = RT.SourceWarehouse) END)  as Source,	  
			   		   						   
			   R.Status, 
			   RT.TaskQuantity,
			   
	           (SELECT    ISNULL(SUM(TransactionQuantity), 0) * #diff#
	                FROM      ItemTransaction S
	                WHERE     RequestId = RT.RequestId AND TaskSerialNo = RT.TaskSerialNo AND TransactionQuantity > 0 AND ActionStatus != '9') AS Shipped,
					
	           (SELECT    ISNULL(SUM(TransactionQuantity), 0)
	                FROM      ItemTransaction S
	                WHERE     RequestId = RT.RequestId AND TaskSerialNo = RT.TaskSerialNo AND TransactionQuantity > 0 AND ActionStatus = '0') AS ShippedNoConfirmation
					
	FROM      RequestTask RT 
	          INNER JOIN Request R ON RT.RequestId = R.RequestId 
			  INNER JOIN Item I ON R.ItemNo = I.ItemNo
			  INNER JOIN Ref_Category C ON I.Category = C.Category
	WHERE     R.Mission = '#URL.Mission#' 
	<!--- delivery not manually closed --->
	AND       RT.RecordStatus <> '3' 
	<!--- requisition line is pending --->
	AND       R.Status = '2' 
	AND       R.Reference IN (SELECT Reference
	                          FROM   RequestHeader 
							  WHERE  Mission      = '#url.mission#' 
							  AND    ActionStatus = '3' 
							  AND    Reference    = R.Reference)
</cfquery>

