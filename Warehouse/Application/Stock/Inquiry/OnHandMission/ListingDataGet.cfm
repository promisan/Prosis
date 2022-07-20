
<!--- control list data content --->

<cfparam name="Form.TransactionLot"   default="">		
<cfparam name="Form.Category"         default="">		

<cfset globalmission = "granted">

<!---

<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 	  
	   anyUnit           = "No"
	   role              = "'WhsPick'"
	   parameter         = "#url.systemfunctionid#"
	   accesslevel       = "'0','1','2'"
	   returnvariable    = "globalmission">	
	   
	   
<cfif globalmission neq "Granted">	

	<!--- check access on the level of the mission --->
			
	<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccessList" 
	   role              = "'WhsPick'"
	   mission           = "#url.mission#" 	  		  
	   parameter         = "#url.systemfunctionid#"
	   accesslevel       = "'0','1','2'"
	   returnvariable    = "accesslist">	
		   
	<cfif accessList.recordcount eq "0">
	
		<table width="100%" border="0" height="100%" align="center">
			   <tr><td align="center" style="padding-top:70;" valign="top" class="labelmedium">
			    <font color="FF0000">
				<cf_tl id="You have <b>NOT</b> been granted any access to this inquiry function" class="Message">
				</font>
				</td>
			   </tr>
		</table>	
		<cfabort>
	
	</cfif>		 
		   
</cfif>		

--->

<cfquery name="PriceSchedule" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	  *
		FROM   	  Ref_PriceSchedule
		WHERE     Operational = 1
		AND       Code IN (SELECT PriceSchedule
		                   FROM   Ref_PriceScheduleMission		
						   WHERE  Mission = '#url.mission#')  	
</cfquery>		


<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	  *
		FROM   	  Warehouse W
		WHERE  	  Mission  = '#url.mission#'							
		AND       Operational = 1		
		<cfif globalmission neq "granted">				
		AND       W.MissionOrgUnitId IN (					   
	                     SELECT DISTINCT MissionOrgUnitId 
				         FROM   Organization.dbo.Organization 
						 WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 
				 )						
		</cfif>		
		
</cfquery>		

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_OnHand_#Mission#"> 

<cftransaction isolation="read_uncommitted">
				    
		<cfquery name="getDataInMemory" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 		
						
			SELECT *
						
			INTO userQuery.dbo.#SESSION.acc#_OnHand_#mission#	
						
			FROM (	
			
			SELECT        I.ItemNo, 
			              I.ItemDescription, 
						  (SELECT ProgramName FROM Program.dbo.Program WHERE ProgramCode = I.ProgramCode) as Program,
			              U.UoM, 
						  U.UoMDescription, 
						  I.ItemNoExternal, 
						  I.ItemPrecision,
			              U.ItemBarCode, 
						  I.Category, 
						  R.Description, 
						  U.ItemUoMId,		
						  
						  <!--- pricing entity --->
						  
						  <cfloop query="priceschedule">
						  
							  (SELECT    TOP 1 SalesPrice
							  FROM      skMissionItemPrice
							  WHERE     Mission       = IUM.Mission 
							  AND       ItemNo        = IUM.ItemNo 
							  AND       UoM           = IUM.UoM 
							  AND       Currency      = '#application.BaseCurrency#'
							  AND       PriceSchedule = '#code#') as Price#Acronym#,
						  					  
						  </cfloop>						  						  	
						 	
			              <cfloop query="warehouse">
						 
						    (  SELECT   ISNULL(SUM(TransactionQuantity), 0) AS Expr1
                               FROM     ItemTransaction
                               WHERE    Mission        = '#url.mission#' 
							   AND      Warehouse      = '#warehouse#' 
							   AND      ItemNo         = U.ItemNo 
							   AND      TransactionUoM = U.UoM 
							   AND      WorkOrderId IS NULL) AS #warehouse#,						  
						  
						  </cfloop>
													   
                         (SELECT  ISNULL(SUM(TransactionQuantity), 0) AS Expr1
                          FROM    ItemTransaction AS ItemTransaction_1
                          WHERE   Mission        = '#url.mission#' 
						  AND     ItemNo         = U.ItemNo 
						  AND     TransactionUoM = U.UoM 
						  AND     WorkOrderId IS NULL) AS OnHand#url.mission#,
						  
						 (SELECT  ISNULL(SUM(TransactionValue), 0) AS Expr1
                          FROM    ItemTransaction AS ItemTransaction_1
                          WHERE   Mission        = '#url.mission#' 
						  AND     ItemNo         = U.ItemNo 
						  AND     TransactionUoM = U.UoM 
						  AND     WorkOrderId IS NULL) AS OnHandValue
						  
						  <!--- 
						  ,
						  
						 (SELECT  ISNULL(SUM(TransactionValue), 0) AS Expr1
                          FROM    ItemTransaction 
                          WHERE   Mission        = '#url.mission#' 
						  AND     ItemNo         = U.ItemNo 
						  AND     TransactionUoM = U.UoM 
						  AND     WorkOrderId IS NULL) 
						  
						  /
						  
						  ( SELECT CASE WHEN OnHandCostPrice = 0 THEN 999999999 ELSE OnHandCostPrice END as Costprice
						  
						    FROM 	 (SELECT  SUM(TransactionQuantity) as OnHandCostPrice
                                      FROM    ItemTransaction 
                                      WHERE   Mission        = '#url.mission#' 
				        		      AND     ItemNo         = U.ItemNo 
						              AND     TransactionUoM = U.UoM 
						              AND     WorkOrderId IS NULL ) as D
							WHERE 1 = 1	  
						  	)	
							
							--->				  
							   
			FROM          ItemUoMMission AS IUM INNER JOIN
			              ItemUoM AS U ON IUM.ItemNo = U.ItemNo AND IUM.UoM = U.UoM INNER JOIN
			              Item AS I ON U.ItemNo = I.ItemNo INNER JOIN
			              Ref_Category R ON I.Category = R.Category 
						  
			WHERE         IUM.Mission = '#url.mission#' 
			AND           I.Operational = 1 
			AND           U.Operational = 1		
			AND           I.ItemClass = 'Supply'			
			
			 ) as B			 		 
			 			 
			 WHERE OnHand#url.mission# <> 0	
			 
			 --condition									 
		
		</cfquery>	
		
		
</cftransaction>

<cfinclude template="ListingDataContent.cfm">					
	