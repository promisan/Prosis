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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="AssetList"
             access="public"
             returntype="any"
             displayname="Budget Table">
		
		<cfargument name="Mission"      type="string"  required="false"  default="">
		<cfargument name="Children"     type="string"  required="true"   default="0">
		<cfargument name="Disposal"     type="string"  required="true"   default="">
		<cfargument name="AssetEnabled" type="string"  required="true"   default="1">		
		<cfargument name="AssetId"      type="string"  required="true"   default="">
		<cfargument name="Role"         type="string"  required="true"   default="">
		<cfargument name="Content"      type="string"  required="true"   default="Sum">
		<cfargument name="Mode"         type="string"  required="true"   default="Table">
		<cfargument name="Table"        type="string"  required="false"  default="#SESSION.acc#Asset">
		
		<CF_DropTable dbName="AppsQuery"  tblName="#table#">		
				
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#AssetOrganization">	
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#AssetLocation">			
						
		<cf_verifyOperational module="Procurement" Warning="No">
					
		<cfquery name="Param" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_ParameterMission
			WHERE  Mission = '#Mission#'
		</cfquery>	
		
		<!--- retrieve the current location --->
		
		<cfquery name="CurrentOrganization" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  A.AssetId, 
			        MAX(DateEffective) AS DateEffective
			INTO    userQuery.dbo.#SESSION.acc#AssetOrganization
			FROM    AssetItemOrganization A
			WHERE   A.ActionStatus != '9'	
			
			<cfif assetid neq "">
			
			AND (  
			
				AssetId IN  (#PreserveSingleQuotes(AssetId)#)
			
				<cfif children eq "1">
					OR   AssetId IN
				           (SELECT AssetId
				            FROM   AssetItem
				            WHERE  ParentAssetId IN (#PreserveSingleQuotes(AssetId)#)
						   )
				
				</cfif>
			
			   )					
			
			</cfif>
		
			<cfif mission neq "">					
			AND   AssetId IN
			           (SELECT AssetId
			            FROM   AssetItem
			            WHERE  Mission = '#mission#'
					    AND    AssetId = A.AssetId)
			</cfif>			
							 
			GROUP BY AssetId
		</cfquery>		
		
		<!--- retrieve the current organization --->
				
		<cfquery name="CurrentLocation" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  A.AssetId, 
			        MAX(DateEffective) AS DateEffective
			INTO    userQuery.dbo.#SESSION.acc#AssetLocation
			FROM    AssetItemLocation A
			WHERE   A.Status != '9'		
			
			<cfif assetid neq "">
			
			AND (  
			
				AssetId IN  (#PreserveSingleQuotes(AssetId)#)
			
				<cfif children eq "1">
					OR   AssetId IN
				           (SELECT AssetId
				            FROM   AssetItem
				            WHERE  ParentAssetId IN (#PreserveSingleQuotes(AssetId)#)
						   )
				
				</cfif>
			
			   )					
			
			</cfif>
			
			<cfif mission neq "">					
			
			AND   AssetId IN
			           (SELECT AssetId
			            FROM   AssetItem
			            WHERE  Mission = '#mission#'
					    AND    AssetId = A.AssetId)
						
			</cfif>			
					
			GROUP BY AssetId
		</cfquery>
		
		<!--- merge --->
		
		<cfquery name="Base" 
		  datasource="appsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT     DISTINCT 
		             P.Category          AS AssetClass, 
		             P.ItemDescription   AS ParentDescription, 
					 P.DepreciationScale AS DepreciationScale, 
			         P.ItemNo            AS WarehouseItemNo, 
					 
				 
					 <cfif operational eq "1">
					 (SELECT PurchaseNo
					  FROM   Purchase.dbo.PurchaseLineReceipt PL, Purchase.dbo.PurchaseLine P
					  WHERE  PL.RequisitionNo = P.RequisitionNo
					  AND    ReceiptId = I.ReceiptId) as PurchaseNo,
					 <cfelse>
					 '' as PurchaseNo,
					 </cfif>					 
					 I.*, 
					 					 
					 O.OrgUnit           AS OrgUnit, 
					 O2.HierarchyCode    AS HierarchyCode,
					 O.PersonNo          AS PersonNo, 
					 O.DateEffective     AS DateEffective,					
					 O.MovementId        AS OrgMovementId,
					 
					 L.Location          AS Location, 
					 L.DateEffective     AS LocationEffective, 
					 <!---  L.Status as LocationStatus, --->
					 L.MovementId        AS LocationMovementId 
										 
		   <cfif Mode eq "Table">		  
		   INTO      userquery.dbo.#table#
		   </cfif>		 
				  
		   FROM      userQuery.dbo.#SESSION.acc#AssetLocation Last2 
		             INNER JOIN AssetItemLocation L ON Last2.AssetId = L.AssetId AND Last2.DateEffective = L.DateEffective 
					 INNER JOIN userQuery.dbo.#SESSION.acc#AssetOrganization Last 
					 INNER JOIN AssetItemOrganization O ON Last.AssetId = O.AssetId AND Last.DateEffective = O.DateEffective 
					 INNER JOIN AssetItem I ON O.AssetId = I.AssetId ON L.AssetId = I.AssetId 
					 INNER JOIN Item P ON I.ItemNo = P.ItemNo INNER JOIN 
					 Organization.dbo.Organization O2 ON O2.OrgUnit = O.OrgUnit
					 
										
		
		   WHERE   1=1 
		   
		   <cfif mission neq "">
		     AND I.Mission = '#mission#'
		   </cfif>
		   
		   <cfif assetid neq "">		   
		   			
			AND (  
			
				I.AssetId IN  (#PreserveSingleQuotes(AssetId)#)
			
				<cfif children eq "1">
					OR   I.AssetId IN
				           (SELECT AssetId
				            FROM   AssetItem
				            WHERE  ParentAssetId IN (#PreserveSingleQuotes(AssetId)#)
						   )
				
				</cfif>
			
			   )					
			
			</cfif>
			
			<!--- select only the items to units to which this person has been granted access --->
			
			<cfif role neq "" and SESSION.isAdministrator eq "No" and not findNoCase(mission,SESSION.isLocalAdministrator)>
			
			AND (
			
			    O.OrgUnit IN  (
				
							   SELECT OrgUnit 
			                   FROM   Organization.dbo.OrganizationAuthorization
							   WHERE  UserAccount = '#SESSION.acc#'
							   AND    Mission     = '#Mission#'
							   AND    ClassParameter = 'Default'
							   AND    Role IN (#preservesinglequotes(Role)#)
							   
							   UNION
							   
							   SELECT OrgUnit 
			                   FROM   Organization.dbo.OrganizationAuthorization
							   WHERE  UserAccount = '#SESSION.acc#'
							   AND    Mission     = '#Mission#'
							   AND    ClassParameter = P.Category
							   AND    Role IN (#preservesinglequotes(Role)#)
							   							   
							  ) 
							  
				OR
				
				I.Mission IN  (
							   
							   SELECT Mission 
			                   FROM   Organization.dbo.OrganizationAuthorization
							   WHERE  UserAccount = '#SESSION.acc#'
							   AND    OrgUnit is NULL
							   AND    Mission = '#Mission#'
							   AND    ClassParameter = 'Default'
							   AND    Role IN (#preservesinglequotes(Role)#)
							   
							   UNION
							   
							   SELECT Mission 
			                   FROM   Organization.dbo.OrganizationAuthorization
							   WHERE  UserAccount = '#SESSION.acc#'
							   AND    OrgUnit is NULL
							   AND    Mission = '#Mission#'
							   AND    ClassParameter = P.Category
							   AND    Role IN (#preservesinglequotes(Role)#)
														   
							  ) 
							  
				)			  		
			
			</cfif>			
			
			<cfif disposal eq "0">
			
				AND    I.AssetId NOT IN (SELECT AssetId 
				                         FROM   AssetItemDisposal 
										 WHERE  AssetId = I.AssetId)
			
			</cfif>
		    
			<cfif AssetEnabled eq "1">			
			AND I.Operational = '1'	
			</cfif>
			
		   ORDER BY ItemDescription 
		</cfquery>		
		
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#AssetOrganization">	
		<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#AssetLocation">	
						
		<cfif mode eq "view">
		
		    	<cfreturn Base>		
				
		<cfelse>
		
			<cfquery name="Index" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				CREATE  INDEX [AssetInd] ON dbo.#table#([AssetId]) ON [PRIMARY]
			</cfquery>	
					
		</cfif>		
		
	</cffunction>	

	
	<cffunction name="AssetListUser"
             access="public"
             returntype="any"
             displayname=" Return a Table containing all the assets that are granted for the user">
		
		<cfargument name="Mission"         type="string" required="false" default="">
		<cfargument name="Category"        type="string" required="false" default="No">
		<cfargument name="ActionCategory"  type="string" required="false" default="">
		<cfargument name="Warehouse"       type="string" required="true"  default="">
		<cfargument name="AssetId"         type="string" required="true"  default="">		
		
		<cfquery name="Org1" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Organization
			WHERE  MissionOrgUnitId IN
			
				(
					SELECT MissionOrgUnitId 
					FROM   Materials.dbo.Warehouse 
					WHERE  Mission = '#Mission#'
					<cfif warehouse neq "">
					AND    Warehouse = '#warehouse#'
					</cfif>
				)
			
			<cfif SESSION.isAdministrator eq "No" and not findNoCase(mission,SESSION.isLocalAdministrator)>
			
			AND OrgUnit IN
			
			  (
				SELECT DISTINCT O.OrgUnit 
				FROM   Organization.dbo.Organization O, 
		             Organization.dbo.OrganizationAuthorization OA
				      WHERE  O.Mission      = '#Mission#'
				      AND    O.OrgUnit      = OA.OrgUnit
				      AND    OA.UserAccount = '#SESSION.acc#'             
				      AND    OA.Role        = 'WhsPick'  
	 
			      UNION
      
			    SELECT DISTINCT O.OrgUnit 
			    FROM   Organization.dbo.Organization O, 
				Organization.dbo.OrganizationAuthorization OA
			      WHERE  O.Mission  = '#Mission#'
			      AND    O.Mission = OA.Mission
			      AND    OA.OrgUnit is NULL
			      AND    OA.UserAccount = '#SESSION.acc#'             
			      AND    OA.Role        = 'WhsPick'  
				) 			
				
			</cfif>	
			
		</cfquery>
				
		<cfset vOrgUnit = "''">				
		
		<cfloop query = "Org1">
		
			<!--- also retrieve org units equal or under including prior mandates --->
			
			<cfquery name="Org2" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    OrgUnit
			    FROM      Organization
			    WHERE     MissionOrgUnitId IN (						 
								   SELECT    MissionOrgUnitId
				                    FROM     Organization
				                   WHERE     Mission   = '#Org1.Mission#' 
								     AND     MandateNo = '#Org1.MandateNo#' 
									 AND     HierarchyCode LIKE '#Org1.HierarchyCode#%'
								  )	
			</cfquery>		
			
			<cfloop query = "Org2">
				<cfset vOrgUnit = ListAppend(vOrgUnit, OrgUnit)>
			</cfloop>
			
		</cfloop>	
		
		<!--- now we retrieve the assets to be show for processing --->
		
		<cfquery name="SelectedAssets" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		   SELECT  AI.AssetId
		   FROM    AssetItem AI, Item I
		   WHERE   
		   AI.Operational = '1'	
		   AND AI.ItemNo = I.ItemNo
		     
	   <cfif Mission neq "">     
		   AND   AI.Mission = '#mission#'
	   </cfif> 
   
	   <!--- ----------------------- --->
	   <!--- exclude disposed assets --->
	   <!--- ----------------------- --->
	   
	   AND    AI.AssetId NOT IN (SELECT AssetId 
	                             FROM   AssetItemDisposal 
	                             WHERE  AssetId = AI.AssetId)     
   
       <!--- filter for assets that need logging --->
	   
	   <cfif Category eq "Yes">
	   AND    I.Category IN (
					          SELECT DISTINCT Category
						      FROM   Ref_AssetActionCategory
						      WHERE  EnableTransaction = '0'
					        ) 
	   </cfif>
	   
	   <!--- is enabled for this action --->	   

	   <cfif assetid neq "">     
	        
		   AND (  
		   
			    AI.AssetId IN  (#PreserveSingleQuotes(AssetId)#)  
			    OR   
				AI.AssetId IN (
			                  SELECT AssetId
			                  FROM   AssetItem
			                  WHERE  ParentAssetId IN (#PreserveSingleQuotes(AssetId)#)
			                  )       
		      )     
	   
	   </cfif>

	   <!--- we only show parent here, as the details are shown in the portal --->	
	      	
	   AND AI.ParentAssetId IS NULL
	   
	   <!--- has access to this asset item through the warehouse --->
	   
	   <cfif SESSION.isAdministrator eq "Yes" or findNoCase(mission,SESSION.isLocalAdministrator)>
	   
	      <!--- Armin - has been assigned to a warehouse/facility, if
		  the asset is NOT fullfilled by a particular warehouse then 
		  I have to check if it has been defined for all the warehouses
		  eg. a vehicle can be filled by any warehouse so I have to check NOT EXIST
		  IN THE AssetItemSupplyWarehouse--->
	   
		     AND 
			 (
			 AI.Assetid IN (
						      SELECT AssetId
						      FROM   AssetItemSupplyWarehouse AISW 			      
						      WHERE  AISW.AssetId = AI.AssetId  
							  <cfif warehouse neq "">
							  AND    AISW.Warehouse = '#warehouse#'
							  </cfif>
							  UNION
							 SELECT   WA.ParentAssetId
						      FROM   AssetItemSupplyWarehouse AISW 				  	     
							  		 INNER JOIN AssetItem WA ON WA.Assetid = AISW.AssetId	
							         INNER JOIN Warehouse W ON W.Warehouse = AISW.Warehouse 
									 INNER JOIN Organization.dbo.Organization O ON W.MissionOrgUnitId = O.MissionOrgUnitId
								      WHERE  WA.ParentAssetId = AI.AssetId
					  
									  <cfif warehouse neq "">
									  AND    AISW.Warehouse = '#warehouse#'
									  <cfelse>			  
								      AND    O.OrgUnit in (#PreserveSingleQuotes(vOrgUnit)#)		  
								  </cfif>							  
							  
			     )
			 <cfif warehouse eq ""> 
			 OR AI.AssetId IN (
				 			SELECT AssetId 
							FROM   AssetItemAssetAction
							WHERE  AssetId        = AI.AssetId 
							AND    ActionCategory = '#ActionCategory#'
							AND    Operational    = 1
	 		   )
			 </cfif>	  	 
		   	 )
		 
	   <cfelse>
	   
	       <!--- action would need to be enabled --->
		   
		   <cfif actionCategory neq "">	   
	   
	   	   AND  AI.AssetId IN (	SELECT AssetId 
								FROM   AssetItemAssetAction
								WHERE  AssetId        = AI.AssetId 
								AND    ActionCategory = '#ActionCategory#'
								AND    Operational    = 1 )	 
					   
		   </cfif>			   
	   
		   AND (		   
		        
			    AI.Assetid IN (
			    
					  SELECT AssetId
				      FROM   AssetItemSupplyWarehouse AISW 				  	     
					         INNER JOIN Warehouse W ON W.Warehouse = AISW.Warehouse 
							 INNER JOIN Organization.dbo.Organization O ON W.MissionOrgUnitId = O.MissionOrgUnitId
						
					  <!--- if the asset or the child of an asset has been defined for this warehouse/facility --->		 
				      WHERE  AISW.AssetId = AI.AssetId
					  
					  <cfif warehouse neq "">
					  
					  AND    AISW.Warehouse = '#warehouse#' 
					  
					  <cfelse>		
					    
				      AND    O.OrgUnit in (#PreserveSingleQuotes(vOrgUnit)#)		
					    
					  </cfif>
				   					 
					  <cfif assetid neq ""> 
						
							OR	AI.AssetId IN (				
									SELECT AssetId 
									FROM   AssetItemAssetAction	
									WHERE  AssetId        = AI.AssetId 				 		
									AND    ActionCategory = '#ActionCategory#'
									AND    Operational    = 1 )
									
					  </cfif>
												
					UNION
					
					 SELECT   WA.ParentAssetId
				      FROM   AssetItemSupplyWarehouse AISW 				  	     
					  		 INNER JOIN AssetItem WA ON WA.Assetid = AISW.AssetId	
					         INNER JOIN Warehouse W ON W.Warehouse = AISW.Warehouse 
							 INNER JOIN Organization.dbo.Organization O ON W.MissionOrgUnitId = O.MissionOrgUnitId
						
					  <!--- if the asset or the child of an asset has been defined for this warehouse/facility --->		 
				      WHERE  WA.ParentAssetId = AI.AssetId
					  
					  <cfif warehouse neq "">
					  AND    AISW.Warehouse = '#warehouse#'
					  <cfelse>			  
				      AND    O.OrgUnit in (#PreserveSingleQuotes(vOrgUnit)#)		  
					  </cfif>
				   					 
					  <cfif assetid neq ""> 
						
							OR	AI.AssetId IN (				
									SELECT AssetId 
									FROM   AssetItemAssetAction	
									WHERE  AssetId        = AI.AssetId 				 		
									AND    ActionCategory = '#ActionCategory#'
									AND    Operational    = 1 )
									
					  </cfif>
				
					 )
				 
		   	   )
		   
	   </cfif>
	   
	   </cfquery>
		
	   <cfset vListAssets = QuotedValueList(SelectedAssets.AssetId)>

		
	   <cfreturn vListAssets>
		
	</cffunction>		

		
</cfcomponent>