
<!--- This batch template servers to the following purposes --->

<!--- 1. It populates tables used for a Data Analysis on Consolidated Item Transaction---> 
<!--- 2. It populates tables used for a Data Analysis on Sales Item Transaction --->
<!--- 3. Monthly Asset Consumption analyisis --->
<!--- 3a. Updates the average usage --->
<!--- 4. Populates the Daily Balance Transaction table (skItemTransactionDay) used in Monthly Fuel Stock Balance report---->


<cfquery name="getMission" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *  
	FROM Ref_ParameterMission	
	WHERE Mission IN (SELECT Mission 
	                  FROM   Organization.dbo.Ref_MissionModule
					  WHERE  SystemModule = 'Warehouse')
</cfquery>	


<cfloop query="getMission">
	
	<cfset url.mission = mission>
	
	<!--- generate the skItemTransactionTable --->
	
	<cfquery name="clearMission" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			DELETE FROM skItemTransaction
			WHERE Mission = '#mission#'	
	</cfquery>	
	
	<!--- aggregated transaction source --->
	
	<cfquery name="addRecords" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO skItemTransaction (
	
				Mission, 
				Warehouse, 
				WarehouseName, 
				WarehouseClass, 
				WarehouseClassName, 
				WarehouseCity, 
				TransactionType, 
				TransactionTypeName, 
				TransactionClass,
				TransactionReference,
				TransactionYear, 
	            TransactionMonth, 
				
				ItemNo, 
				ItemDescription, 
				ItemCategory, 
				ItemCategoryName, 
				Location, 
				LocationName, 
				LocationClass, 
				LocationClassName, 
				BillingMode, 
				ItemUoM,
				ItemUoMName, 
				RequestReference,
				AssetCategory,
				AssetCategoryName,
	            AssetItemNo, 
				AssetItemName, 
				Make, 
				MakeName, 
				ProgramCode, 
				ProgramClass, 
				ProgramName, 
				OrgUnit, 
				OrgUnitCode, 
				OrgUnitName, 
				BranchCode,
				BranchName,
				Records, 
				TransactionQuantity, 
	            TransactionValue	)
	
	SELECT     T.Mission, 
	
	           T.Warehouse, W.WarehouseName, 			   
			   W.WarehouseClass, WC.Description AS WarehouseClassName, 			   
			   W.City AS WarehouseCity, 
			   
			   T.TransactionType, TT.Description AS TransactionTypeName, 
			   
			   ISNULL(LEFT(WB.BatchDescription,40), ' n/a')  AS TransactionClass, 			   
			   ISNULL(LEFT(WB.BatchReference,20), ' n/a')    AS TransactionReference, 
			   
			   YEAR(T.TransactionDate) AS TransactionYear, 
			   MONTH(T.TransactionDate) AS TransactionMonth, 
			   			   		   
			   T.ItemNo, T.ItemDescription, 
			   
			   T.ItemCategory, C.Description AS ItemCategoryName, 
			   
			   T.Location, WL.Description AS LocationName, 
			   
			   WL.LocationClass, WLC.Description AS LocationClassName, 
			   
			   T.BillingMode, 
			   
			   T.TransactionUoM as ItemUoM, UoM.UoMDescription AS ItemUoMName, 
			   
			   ISNULL(R.Reference, ' n/a')         AS RequestReference, 
			   
			   ISNULL(AC.Category, ' n/a')         AS AssetCategory, 
               ISNULL(AC.Description, ' n/a')      AS AssetCategoryName, 
			   
			   ISNULL(AII.ItemNo, ' n/a')          AS AssetItemNo, 
               ISNULL(AII.ItemDescription, ' n/a') AS AssetItemName, 
			   
			   ISNULL(M.Code, ' n/a')      AS Make, 
			   ISNULL(M.Description, ' n/a') AS MakeName, 
			   
			   ISNULL(PR.ProgramCode, ' n/a')  AS ProgramCode, 
			   ISNULL(PR.ProgramClass, ' n/a') AS ProgramClass, 
			   ISNULL(PR.ProgramName, ' n/a')  AS ProgramName, 
			   
			   ISNULL(T.OrgUnit, '0')   AS OrgUnit, 
               ISNULL(T.OrgUnitCode, ' n/a')  AS OrgUnitCode, 
			   ISNULL(T.OrgUnitName, ' n/a')  AS OrgUnitName, 
			   
			   ISNULL(ORT.OrgUnitCode,' n/a') AS BranchCode, 
			   ISNULL(ORT.OrgUnitName,' n/a') AS BranchName,
			   
			   COUNT(*) AS Records, 
			   SUM(T.TransactionQuantity) AS TransactionQuantity, 
			   SUM(T.TransactionValue) AS TransactionValue
			   
		FROM    ItemTransaction T INNER JOIN
                Warehouse W ON T.Warehouse = W.Warehouse INNER JOIN
                Ref_WarehouseClass WC ON W.WarehouseClass = WC.Code INNER JOIN
                Ref_TransactionType TT ON T.TransactionType = TT.TransactionType INNER JOIN
                Ref_Category C ON T.ItemCategory = C.Category INNER JOIN
                WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location INNER JOIN
                Ref_WarehouseLocationClass WLC ON WL.LocationClass = WLC.Code INNER JOIN
                ItemUoM UoM ON T.ItemNo = UoM.ItemNo AND T.TransactionUoM = UoM.UoM LEFT OUTER JOIN
                Organization.dbo.Organization O INNER JOIN
                Organization.dbo.Organization ORT ON O.Mission = ORT.Mission AND O.MandateNo = ORT.MandateNo AND O.HierarchyRootUnit = ORT.OrgUnitCode ON 
                T.OrgUnit = O.OrgUnit LEFT OUTER JOIN
                Program.dbo.Program PR ON T.ProgramCode = PR.ProgramCode LEFT OUTER JOIN
                Ref_Make M INNER JOIN
                Item AII INNER JOIN AssetItem AI ON AII.ItemNo = AI.ItemNo ON M.Code = AI.Make ON T.AssetId = AI.AssetId LEFT OUTER JOIN 
				Ref_Category AC ON AII.Category = AC.Category LEFT OUTER JOIN
				Request R ON T.RequestId = R.RequestId LEFT OUTER JOIN
				WarehouseBatch WB ON T.TransactionBatchNo = WB.BatchNo 
				

		   					  
		WHERE   T.Mission = '#mission#'	AND T.ItemNo IN (SELECT ItemNo FROM Item WHERE ItemNo = T.ItemNo AND ItemClass = 'Supply')		  

		GROUP BY T.Mission, 
		         T.Warehouse, 
				 W.WarehouseName, 
				 W.WarehouseClass, 
				 WC.Description, 
				 T.TransactionType, 
				 WB.BatchDescription,
				 WB.BatchReference,
				 TT.Description, 
				 YEAR(T.TransactionDate), 
                 MONTH(T.TransactionDate), 
				 T.ItemNo, 
				 T.ItemDescription, 
				 T.TransactionUoM,
				 T.ItemCategory, 
				 C.Description, 
				 T.Location, 
				 WL.Description, 
				 WL.LocationClass, 
				 WLC.Description, 
                 T.BillingMode, 
				 UoM.UoMDescription, 
				 W.City, 				 
				 AII.ItemNo, 
				 AII.ItemDescription, 	
				 AC.Category,
				 AC.Description,			 
				 R.Reference,
				 PR.ProgramCode, 
				 PR.ProgramClass, 
				 PR.ProgramName, 				 
				 T.OrgUnit, 
				 T.OrgUnitCode, 
                 T.OrgUnitName, 
				 M.Description, 
				 M.Code,
				 ORT.OrgUnitCode, 
				 ORT.OrgUnitName

		ORDER BY T.Mission, T.Warehouse
	
	</cfquery>
	
	<cf_ScheduleLogInsert   
       ScheduleRunId  = "#schedulelogid#"
	   Description    = "Complete skItemTransaction for #mission#"
	   StepStatus="1">	 
	
	<cfquery name="clearMission" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			DELETE FROM skItemTransactionShipping
			WHERE Mission = '#mission#'	
	</cfquery>	
	
	<cfquery name="addRecords" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		<!--- invoice dataset --->
		INSERT INTO skItemTransactionShipping (
		
		            TransactionId,
					Mission, 
					Warehouse, WarehouseName, 
					WarehouseClass, WarehouseClassName, 					
					WarehouseCity, 
					TransactionType, TransactionTypeName, 
					
					TransactionYear, 
		            TransactionMonth, 
					
					<!--- added 16/6 --->
					TransactionReference,
					RequestReference,
					
					ItemNo, ItemDescription, 

					ItemCategory, ItemCategoryName, 

					Location, LocationName, 
					LocationClass, LocationClassName, 
					
					GeoLocation, GeoLocationName,
					
					BillingMode, 
					
					ItemUoM, ItemUoMName, 

					AssetCategory, AssetCategoryName,
		            AssetItemNo, AssetItemName, 
					
					<!--- added 16/6 --->
					AssetBarCode, AssetDecalNo,
										
					Make, MakeName, 
					
					ProgramCode, ProgramClass, ProgramName, 
					
					OrgUnit, OrgUnitCode, OrgUnitName, 
					
					BranchCode,	BranchName,			
					
					TransactionBatchNo,	TransactionDate, TransactionDocument,

					PersonNo, LastName,	FirstName, IndexNo,	PersonId,	
					
					TransactionQuantity, 
		            TransactionValue,
					
					InvoiceNo,
					InvoiceDate,
					SalesCurrency, 
					SalesPriceVariable, SalesPriceFixed, SalesPrice, 
					SalesAmount, SalesTax, SalesTotal				
				
					)
		
		<!--- take category from the asset item --->
		
		SELECT     T.TransactionId,
		           T.Mission, 
		           T.Warehouse, W.WarehouseName, 
				   
				   W.WarehouseClass, WC.Description AS WarehouseClassName, 
				   W.City AS WarehouseCity, 
				   
				   T.TransactionType, TT.Description AS TransactionTypeName, 
				   
				   YEAR(T.TransactionDate) AS TransactionYear, 
				   MONTH(T.TransactionDate) AS TransactionMonth, 
				   
				   <!--- added 16/6 --->
				   T.TransactionReference,				   
				   ISNULL(Req.Reference, ' n/a') AS RequestReference, 
				   
				   T.ItemNo, T.ItemDescription, 
				   
				   T.ItemCategory, C.Description AS ItemCategoryName, 
				   
				   T.Location, WL.Description AS LocationName,
				   
				   WL.LocationClass, WLC.Description AS LocationClassName, 
				   
				   L.Location, L.LocationName,
				   
				   T.BillingMode, 
				   
				   T.TransactionUoM AS ItemUoM, UoM.UoMDescription AS ItemUoMName, 
				   
				   ISNULL(AC.Category, ' n/a') AS AssetCategory, ISNULL(AC.Description, ' n/a') AS AssetCategoryName, 
				   
				   ISNULL(AII.ItemNo, ' n/a') AS AssetItemNo,
				   ISNULL(AII.ItemDescription, ' n/a') AS AssetItemName, 
				   
				   <!--- added 16/6 --->
				   ISNULL(AI.AssetBarCode, ' n/a') AS AssetBarcode, 
				   ISNULL(AI.AssetDecalNo, ' n/a') AS AssetDecalNo, 
				   
				   ISNULL(M.Code, ' n/a') AS Make, ISNULL(M.Description, ' n/a') AS MakeName, 
				   ISNULL(PR.ProgramCode, ' n/a') AS ProgramCode, ISNULL(PR.ProgramClass, ' n/a') AS ProgramClass, ISNULL(PR.ProgramName, ' n/a') AS ProgramName, 
				   
				   ISNULL(T.OrgUnit, '0') AS OrgUnit, ISNULL(T.OrgUnitCode,' n/a') AS OrgUnitCode, ISNULL(T.OrgUnitName, ' n/a') AS OrgUnitName, 
				   ISNULL(ORT.OrgUnitCode, ' n/a') AS BranchCode, ISNULL(ORT.OrgUnitName, ' n/a') AS BranchName, 
				   
				   T.TransactionBatchNo,
				   T.TransactionDate,
				   T.TransactionReference AS TransactionDocument, 
				   T.PersonNo, E.LastName, E.FirstName, E.IndexNo, E.Reference AS PersonID, 
	               T.TransactionQuantity*-1 as TransactionQuantity,
				   T.TransactionValue*-1 as TransactionValue,
				   
	               (SELECT     InvoiceNo
	                FROM          Purchase.dbo.Invoice
	                WHERE      Invoiceid = TS.InvoiceId) AS InvoiceNo,
					
	               (SELECT     DocumentDate
	                FROM          Purchase.dbo.Invoice
	                WHERE      Invoiceid = TS.InvoiceId) AS InvoiceDate, 
					
					TS.SalesCurrency, 
					TS.SalesPriceVariable, TS.SalesPriceFixed, TS.SalesPrice, 
					TS.SalesAmount, TS.SalesTax, TS.SalesTotal
	
	   FROM         ItemTransaction T 
	                INNER JOIN  WarehouseBatch B ON T.TransactionBatchNo = B.BatchNo 
					INNER JOIN  Warehouse W ON T.Warehouse = W.Warehouse 
					INNER JOIN  Ref_WarehouseClass WC ON W.WarehouseClass = WC.Code 
					INNER JOIN  Ref_TransactionType TT ON T.TransactionType = TT.TransactionType 
					INNER JOIN  Ref_Category C ON T.ItemCategory = C.Category 
					INNER JOIN  WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 
					INNER JOIN  Ref_WarehouseLocationClass WLC ON WL.LocationClass = WLC.Code 
					INNER JOIN  ItemUoM UoM ON T.ItemNo = UoM.ItemNo AND T.TransactionUoM = UoM.UoM 
					INNER JOIN  ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId 
					LEFT OUTER JOIN  Employee.dbo.Person E ON T.PersonNo = E.PersonNo 
					LEFT OUTER JOIN  Request Req ON Req.RequestId = T.RequestId 
					<!--- added --->
					INNER JOIN  Location L ON L.Location = T.TransactionLocationId 				
					
					LEFT OUTER JOIN  Organization.dbo.Organization O 
					INNER JOIN  Organization.dbo.Organization ORT ON O.Mission = ORT.Mission AND O.MandateNo = ORT.MandateNo AND O.HierarchyRootUnit = ORT.OrgUnitCode ON T.OrgUnit = O.OrgUnit 
					LEFT OUTER JOIN Program.dbo.Program PR ON T.ProgramCode = PR.ProgramCode 
					
					LEFT OUTER JOIN Ref_Make M 
					INNER JOIN Item AII 
					INNER JOIN AssetItem AI ON AII.ItemNo = AI.ItemNo ON M.Code = AI.Make ON T.AssetId = AI.AssetId 
					LEFT OUTER JOIN Ref_Category AC ON AII.Category = AC.Category

		WHERE       T.Mission = '#mission#'	AND T.ItemNo IN (SELECT ItemNo FROM Item WHERE ItemNo = T.ItemNo AND ItemClass = 'Supply')		 	
		
		<cfif OperationMode eq "Internal">
		    <!--- only billable transactions are shown here --->
			AND     T.BillingMode = 'External'
		<cfelse>
			<!--- all transactions are shown here --->
		</cfif>
		AND         T.TransactionQuantity < 0 and B.TransactionType = '2'
		
		UNION
		
		<!--- take category from the batch --->
		
		SELECT     T.TransactionId,
		           T.Mission, 
		           T.Warehouse, W.WarehouseName, 
				   
				   W.WarehouseClass, WC.Description AS WarehouseClassName, 
				   W.City AS WarehouseCity, 
				   
				   T.TransactionType, TT.Description AS TransactionTypeName, 
				   
				   YEAR(T.TransactionDate) AS TransactionYear, 
				   MONTH(T.TransactionDate) AS TransactionMonth, 
				   
				   <!--- added 16/6 --->
				   T.TransactionReference,				   
				   ISNULL(Req.Reference, ' n/a') AS RequestReference, 
				   
				   T.ItemNo, T.ItemDescription, 
				   
				   T.ItemCategory, C.Description AS ItemCategoryName, 
				   
				   T.Location, WL.Description AS LocationName,
				   
				   WL.LocationClass, WLC.Description AS LocationClassName, 
				   
				   L.Location, L.LocationName,
				   
				   T.BillingMode, 
				   
				   T.TransactionUoM AS ItemUoM, UoM.UoMDescription AS ItemUoMName, 
				   
				   ISNULL(BC.Category, ' n/a') AS AssetCategory, ISNULL(BC.Description, ' n/a') AS AssetCategoryName, 
				   
				   <!--- the below is usually not relevant for transfers --->
				   ISNULL(AII.ItemNo, ' n/a') AS AssetItemNo, ISNULL(AII.ItemDescription, ' n/a') AS AssetItemName, 
				   
				   <!--- added 16/6 --->
				   ISNULL(AI.AssetBarCode, ' n/a') AS AssetBarcode, 
				   ISNULL(AI.AssetDecalNo, ' n/a') AS AssetDecalNo, 
				   
				   ISNULL(M.Code, ' n/a') AS Make, ISNULL(M.Description, ' n/a') AS MakeName, 
				   ISNULL(PR.ProgramCode, ' n/a') AS ProgramCode, ISNULL(PR.ProgramClass, ' n/a') AS ProgramClass, ISNULL(PR.ProgramName, ' n/a') AS ProgramName, 
				   
				   ISNULL(T.OrgUnit, '0') AS OrgUnit, ISNULL(T.OrgUnitCode,' n/a') AS OrgUnitCode, ISNULL(T.OrgUnitName, ' n/a') AS OrgUnitName, 
				   ISNULL(ORT.OrgUnitCode, ' n/a') AS BranchCode, ISNULL(ORT.OrgUnitName, ' n/a') AS BranchName, 
				   
				   T.TransactionBatchNo,
				   T.TransactionDate,
				   T.TransactionReference AS TransactionDocument, 
				   T.PersonNo, E.LastName, E.FirstName, E.IndexNo, E.Reference AS PersonID, 
	               T.TransactionQuantity*-1 as TransactionQuantity,
				   T.TransactionValue*-1 as TransactionValue,
				   
	               (SELECT     InvoiceNo
	                FROM          Purchase.dbo.Invoice
	                WHERE      Invoiceid = TS.InvoiceId) AS InvoiceNo,
					
	               (SELECT     DocumentDate
	                FROM          Purchase.dbo.Invoice
	                WHERE      Invoiceid = TS.InvoiceId) AS InvoiceDate, 
					
					TS.SalesCurrency, 
					TS.SalesPriceVariable, TS.SalesPriceFixed, TS.SalesPrice, 
					TS.SalesAmount, TS.SalesTax, TS.SalesTotal
	
	   FROM         ItemTransaction T 
	                INNER JOIN WarehouseBatch B               ON T.TransactionBatchNo = B.BatchNo 
					LEFT OUTER JOIN Ref_Category BC           ON B.Category = BC.Category 
					INNER JOIN Warehouse W                    ON T.Warehouse = W.Warehouse 
					INNER JOIN Ref_WarehouseClass WC          ON W.WarehouseClass = WC.Code 
					INNER JOIN Ref_TransactionType TT         ON T.TransactionType = TT.TransactionType 
					INNER JOIN Ref_Category C                 ON T.ItemCategory = C.Category 
					INNER JOIN WarehouseLocation WL           ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location 
					INNER JOIN Ref_WarehouseLocationClass WLC ON WL.LocationClass = WLC.Code 
					INNER JOIN ItemUoM UoM                    ON T.ItemNo = UoM.ItemNo AND T.TransactionUoM = UoM.UoM 
					INNER JOIN ItemTransactionShipping TS     ON T.TransactionId = TS.TransactionId 
					LEFT OUTER JOIN Employee.dbo.Person E     ON T.PersonNo = E.PersonNo 
					LEFT OUTER JOIN  Request Req ON Req.RequestId = T.RequestId 
					
					<!--- added --->
					INNER JOIN  Location L ON L.Location = T.TransactionLocationId 		
					
					LEFT OUTER JOIN Organization.dbo.Organization O 					
					INNER JOIN  Organization.dbo.Organization ORT ON O.Mission = ORT.Mission AND O.MandateNo = ORT.MandateNo AND O.HierarchyRootUnit = ORT.OrgUnitCode ON 
                    T.OrgUnit = O.OrgUnit 
					
					LEFT OUTER JOIN Program.dbo.Program PR ON T.ProgramCode = PR.ProgramCode 
					
					LEFT OUTER JOIN Ref_Make M INNER JOIN Item AII INNER JOIN AssetItem AI ON AII.ItemNo = AI.ItemNo ON M.Code = AI.Make ON T.AssetId = AI.AssetId 

		WHERE       T.Mission = '#mission#'	AND T.ItemNo IN (SELECT ItemNo FROM Item WHERE ItemNo = T.ItemNo AND ItemClass = 'Supply')		 	
		
		<cfif OperationMode eq "Internal">
		    <!--- only billable transactions are shown here --->
			AND    	    T.BillingMode = 'External'
		<cfelse>
			<!--- all transactions are shown here --->
		</cfif>
		AND         T.TransactionQuantity < 0 and B.TransactionType = '8'
				
		ORDER BY    T.Mission, T.Warehouse
		
	</cfquery>	
	
	<cf_ScheduleLogInsert   
       ScheduleRunId  = "#schedulelogid#"
	   Description    = "Complete skItemTransactionShipping for #mission#"
	   StepStatus="1">	 
	
</cfloop>


<!--- ********************* SKASSETITEMCONSUMPTION ******************** --->

<cfparam name="url.year"    		default="#year(now())#">
<cfparam name="url.yearEnd" 		default="">
<cfparam name="url.specificMonth" 	default="">

<cfset vFuelCategory = "">
<cfset vLogReportCount = 300>

<cfif lcase(CGI.HTTP_HOST) eq "dev01" 
	or lcase(CGI.HTTP_HOST) eq "www.promisan.net">

	<cfset vFuelCategory = "POL">
	
<cfelse>
	
	<cfset vFuelCategory = "FUEL">
	
</cfif>

<cfset snapshotItemTransaction = "_snapshotItemTransaction_skAssetItemConsumption">
<cf_dropTable dbName="AppsQuery" tblName="#snapshotItemTransaction#">

<cfquery name="createTempTable" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT 	*
		INTO	UserQuery.dbo.#snapshotItemTransaction#
		FROM	ItemTransaction
	
</cfquery>

<cfquery name="createIndexes" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	ALTER TABLE dbo.#snapshotItemTransaction# ADD CONSTRAINT PK_#snapshotItemTransaction#
	PRIMARY KEY CLUSTERED (TransactionId);
	
	CREATE NONCLUSTERED INDEX [_dta_index_#snapshotItemTransaction#_22_409948032__K18_K7_K4_K6_K1_K31_K17] ON [dbo].[#snapshotItemTransaction#] 
	(
		[TransactionUoM] ASC,
		[ItemNo] ASC,
		[TransactionType] ASC,
		[TransactionDate] ASC,
		[TransactionId] ASC,
		[AssetId] ASC,
		[TransactionQuantity] ASC
	)
	
	CREATE NONCLUSTERED INDEX [_dta_index_#snapshotItemTransaction#_22_409948032__K6D_K31_K18_K7_K4_K1] ON [dbo].[#snapshotItemTransaction#] 
	(
		[TransactionDate] DESC,
		[AssetId] ASC,
		[TransactionUoM] ASC,
		[ItemNo] ASC,
		[TransactionType] ASC,
		[TransactionId] ASC
	)
	
	
	CREATE NONCLUSTERED INDEX [_dta_index_#snapshotItemTransaction#_22_409948032__K6_K31_K18_K7_K4_K1_K17] ON [dbo].[#snapshotItemTransaction#] 
	(
		[TransactionDate] ASC,
		[AssetId] ASC,
		[TransactionUoM] ASC,
		[ItemNo] ASC,
		[TransactionType] ASC,
		[TransactionId] ASC,
		[TransactionQuantity] ASC
	)
	
	CREATE NONCLUSTERED INDEX [_dta_index_#snapshotItemTransaction#_22_409948032__K7_K1_K6_K31_K18_K4_K17] ON [dbo].[#snapshotItemTransaction#] 
	(
		[ItemNo] ASC,
		[TransactionId] ASC,
		[TransactionDate] ASC,
		[AssetId] ASC,
		[TransactionUoM] ASC,
		[TransactionType] ASC,
		[TransactionQuantity] ASC
	)

</cfquery>


<cfloop query="getMission">

	<cfset url.mission = mission>
	
	<!--- generate the skConsumption table --->
	
	<!--- The idea is that we check for each asset in consequetive months the 
	
	- for the asset category enabled metrics and determined total metric value of the transaction in that month
	- for the asset item the defined supply item for the metric and its planned ratio
	- the last fuel transaction in the prior month, fuel dispatched in that month excluding the last transaction.
	
	--->
	
	<!--- 
	
	      1. loop through the mission's item 
	      2. loop through the year and then the month 
		  3. clean the year and the month
		  4. for an asset item define the metric and the supply combination (There can be several) : subloop
			  4a. determine the metric value for that month
			  4b. determine the supplied quantity for that moth (incl last prior month, and exclude last of this month)
	          4c. Write record and go to next
			  
	--->
	
	<!--- all assets which have a supply metric defined and which are parent (vehicles, generators and generator groups) --->	
	
	<cfset cYear   = url.yearEnd>
	<cfif url.yearEnd eq "">
		<cfset cYear   = year(now())>
	</cfif>
	
		<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Started Consumption Analysis (skAssetItemComsumption) for #Mission#"
			StepStatus     = "1">
	
		<cfloop index="yr" from="#url.year#" to="#cYear#">	
		
			<cfset mth = month(now()) - 1>
			
			<cfif mth lt 1>
				<cfset mth = 1>
			</cfif>
			
			<cfif yr eq cYear>
				<cfset cMonth = month(now())>
			<cfelse>
			    <cfset cMonth = 12>
			</cfif>
			
			<cfif url.specificMonth neq "">
				<cfset mth = url.specificMonth>
				<cfset cMonth = url.specificMonth>
			</cfif>
			
			<cfloop index="mt" from="#mth#" to="#cMonth#">
					
				<!--- clean --->
				
				<cfquery name="clean" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE FROM skAssetItemConsumption
					WHERE       Mission        = '#URL.Mission#'
					AND         OperationYear  = '#yr#'
					AND         OperationMonth = '#mt#'
					
					<!---
					AND         AssetId = 'b7f70e99-2655-db30-9bd7-dd3da019327b'
					--->
					
				</cfquery>	
				
				<cfset STR = createDate(yr, mt, 1)>
				<cfset END = createDate(yr, mt, daysInMonth(STR))>
				
				<!--- we populate the monthly summary table for consumption --->
					
				<cfquery name="getAssets" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
										
					INSERT INTO skAssetItemConsumption
					
								(Mission, 
								 AssetId, 
								 OperationYear, 
								 OperationMonth, 				
								 SupplyItemNo, 
								 SupplyItemUoM, 
								 Metric, 
								 AssetItemNo,
								 AssetCategory,
								 OrgUnit, 
								 <!--- move to method
								 MetricSupplyTarget, 
								 MetricQuantity, 
								 --->
					             SupplyQuantityActual)				 
											 
					SELECT    '#url.mission#',
					          A.AssetId, 
							  '#yr#',
							  '#mt#',					   
							  
							  ISNULL(M.SupplyItemNo, M.SupplyItemNo)   as SupplyItemNo,
							  ISNULL(M.SupplyItemUoM, M.SupplyItemUoM) as SupplyItemUoM,
							  ISNULL(Metric, M.Metric) as Metric,
							  
					          I.ItemNo, 
							  I.Category, 	
							  
							  (
								 SELECT   TOP 1 OrgUnit 
							     FROM     AssetItemOrganization 
							     WHERE    AssetId = A.AssetId
							     AND      DateEffective >= #str#
							     ORDER BY DateEffective DESC
							   ), 								  
							  									
							  <!--- get the total issues --->	
							  	
							  ISNULL((		  					  
								  ( 
								    SELECT    ISNULL(SUM(- TransactionQuantity),0) 
									FROM      UserQuery.dbo.#snapshotItemTransaction# 
									WHERE     (AssetId  IN ( (SELECT A.AssetId) UNION (SELECT AssetId FROM AssetItem WHERE ParentAssetId = A.AssetId)))  
									AND       TransactionType = '2' 
									AND       ItemNo          = ISNULL(M.SupplyItemNo, M.SupplyItemNo)
									AND       TransactionUoM  = ISNULL(M.SupplyItemUoM, M.SupplyItemUoM)
									<!--- all transactions of this month exclude the last one --->
									AND		  TransactionDate >= #STR# 
							        AND 	  TransactionDate <= #END# 
									 <!--- -------------------------------------- --->
									 <!--- exclude last transaction of this month --->
									 <!--- -------------------------------------- --->
									AND		  TransactionId != 
											  (
											  		SELECT   TOP 1 TransactionId
		                                            FROM     UserQuery.dbo.#snapshotItemTransaction# 
		                                            WHERE    (AssetId  IN ( (SELECT A.AssetId) UNION (SELECT AssetId FROM AssetItem WHERE ParentAssetId = A.AssetId)))
													AND      TransactionType = '2' 
													AND      ItemNo          = ISNULL(M.SupplyItemNo, M.SupplyItemNo)
													AND      TransactionUoM  = ISNULL(M.SupplyItemUoM, M.SupplyItemUoM)
													AND      TransactionDate >= #STR#  AND TransactionDate <= #END# 
		                                            ORDER BY TransactionDate DESC, Created DESC
											  )
								  ) + 
								  (
								  		<!--- ----------------------------------------------- --->
										<!--- add the last transaction of the prior month --->
										<!--- ----------------------------------------------- --->
								  		SELECT   TOP 1 ISNULL(-TransactionQuantity,0) 
										FROM     UserQuery.dbo.#snapshotItemTransaction# 
										WHERE    (AssetId  IN ( (SELECT A.AssetId) UNION (SELECT AssetId FROM AssetItem WHERE ParentAssetId = A.AssetId)))
										AND      TransactionType = '2' 
										AND      ItemNo         = ISNULL(M.SupplyItemNo, M.SupplyItemNo)
										AND      TransactionUoM = ISNULL(M.SupplyItemUoM, M.SupplyItemUoM)
										AND      TransactionDate < #STR# 
										ORDER BY TransactionDate DESC, Created DESC
								  )
							  ),0) as ActualSupply
									  
							  
					FROM      AssetItem A INNER JOIN Item I   ON A.ItemNo = I.ItemNo 
								INNER JOIN ItemSupplyMetric M ON A.ItemNo = M.ItemNo 
								INNER JOIN Ref_Metric R 	  ON R.Code   = M.Metric	
																
					WHERE     A.Mission = '#url.mission#'
					
					<!--- has one ore more measurements for this metric in this period --->
					
					AND       M.Metric IN ( 
					
					                       SELECT DISTINCT MM.Metric 
					                       FROM   AssetItemAction MA, AssetItemActionMetric MM
										   WHERE  MA.AssetId = A.AssetId 
										   AND    MA.AssetActionId = MM.AssetActionId
										   AND    MA.ActionDate >= #STR# AND MA.ActionDate <= #END#
										   
										   UNION
										   
										   SELECT DISTINCT MM.Metric 
					                       FROM   AssetItem PA, AssetItemAction MA, AssetItemActionMetric MM
										   WHERE  MA.AssetId = PA.AssetId 
										   AND    PA.ParentAssetId = A.Assetid
										   AND    MA.AssetActionId = MM.AssetActionId
										   AND    MA.ActionDate >= #STR# AND MA.ActionDate <= #END#
										   										   
										   )								
					      					
					AND       M.SupplyItemNo IN (
													SELECT 	ItemNo 
													FROM 	Item 
													WHERE 	ItemNo = M.SupplyItemNo 
													AND 	Category IN (
																			SELECT 	Category 
						                                                    FROM   	Ref_Category 
																			WHERE  	VolumeManagement = 1
																			<cfif vFuelCategory neq "">
																				AND		Category = '#vFuelCategory#'
																			</cfif>
																		)
												)
										
					<!--- asset or the children have indeed actions in this period/month for the metric --->
					
					AND       A.AssetId IN (
					                        
											SELECT AssetId 
					                        FROM   AssetItemAction
											WHERE  AssetId        = A.AssetId 											
											AND    ActionCategory = 'Operations'						  
											<!--- this period/month --->
											AND    ActionDate >= #STR# AND ActionDate <= #END#
																						
											UNION
											
											SELECT ParentAssetId 
					                        FROM   AssetItem IA,AssetItemAction AA
											WHERE  IA.AssetId       = AA.AssetId
											AND    IA.ParentAssetId = A.AssetId
											
											<!--- is for metric operations --->
											<!--- removed as otherwise we miss generators 
											AND    ActionCategory IN (SELECT ActionCategory 
											                          FROM   Ref_AssetActionCategory 
																	  WHERE  Category = I.Category
																	  AND    EnableTransaction = 1 
																	  )
											--->
											
											AND    ActionCategory = 'Operations'						  
											<!--- this period/month --->
											AND    ActionDate >= #STR# AND ActionDate <= #END#
																						
											) 
					
					<!---						
					AND    A.AssetId = 'b7f70e99-2655-db30-9bd7-dd3da019327b'						
					--->
																					
				</cfquery>	
				
			</cfloop>
		</cfloop>
				
		<!--- now we update  additional target information defined based on operation level --->
		
		<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Starting update of additional target information for #mission#"
			StepStatus     = "1">
				
		<cfset cUmth = month(now()) - 1>
			
		<cfif cUmth lt 1>
			<cfset cUmth = 1>
		</cfif>
		
		<cfquery name="getOperations" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    skAssetItemConsumption C
			WHERE   1=1						
			AND     Mission = '#url.mission#'
			AND		operationYear >= '#url.year#' 
			AND		operationYear <= '#cYear#'
			<cfif url.specificMonth eq "">
			AND		operationMonth >= '#cUmth#'
			<cfelse>
			AND		operationMonth = '#url.specificMonth#'
			</cfif> 
			
			<!---
			AND     AssetId = 'b7f70e99-2655-db30-9bd7-dd3da019327b'	
			--->
						
			ORDER BY operationYear ASC, operationMonth ASC, AssetId ASC
		</cfquery>		
				
		<cfset cnt = 0>						
		
		<cfoutput>#getOperations.recordcount#</cfoutput>											
		
		<cfoutput query="getOperations" group="operationYear">
						
			<cfoutput group="operationMonth">
						
				<cfset STR = createDate(operationYear, operationMonth, 1)>
				<cfset END = createDate(operationYear, operationMonth, daysInMonth(STR))>
				
				<cfoutput group="AssetId">				
														   
					<cfoutput>
															
					<cfinvoke component = "Service.Process.Materials.Consumption"  
					   method           = "getConsumptionTarget" 
					   assetid          = "#AssetId#" 
					   supplyItemNo     = "#SupplyItemNo#"
					   supplyItemUoM    = "#SupplyItemUoM#"
					   Metric           = "#metric#"
					   Effective        = "#dateformat(STR,CLIENT.DateFormatShow)#"	   
					   Expiration       = "#dateformat(END,CLIENT.DateFormatShow)#"	   
					   returnvariable   = "getTarget">					   
					   
					  <cfdump var="#getTarget#">
					
						<cfif getTarget.TargetRatio neq "">
												
							<cfquery name="getMore" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE  skAssetItemConsumption 
									SET     MetricSupplyTarget 		=  '#getTarget.TargetRatio#',
											MetricQuantity     		=  '#getTarget.Operations#',
											MetricQuantityOpening   =  '#getTarget.operationsopening#',
											MetricQuantityClosing   =  '#getTarget.operationsclosing#',
											AvgOperationMode		=  '#getTarget.avgOperationMode#'
									WHERE   Mission        = '#url.mission#'
									AND     AssetId        = '#AssetId#'
									AND     SupplyItemNo   = '#SupplyItemNo#'
									AND     SupplyItemUoM  = '#SupplyItemUoM#'
									AND     Metric         = '#Metric#'
									AND     OperationMonth = '#operationMonth#' 
									AND     OperationYear  = '#operationYear#'				
							</cfquery>	
						
						</cfif>
						
						<cfset cnt = cnt +1>
		
						<cfif cnt eq vLogReportCount or currentrow eq getOperations.recordcount>
						
							<cf_ScheduleLogInsert
						   	ScheduleRunId  = "#schedulelogid#"
							Description    = "  ------- Progress: #NumberFormat(((currentrow*100)/getOperations.recordcount),',.__')# % [Month: #operationMonth#/#operationYear# - Records: #NumberFormat(currentrow,',')# of #NumberFormat(getOperations.recordcount,',')#]"
							StepStatus     = "1">	
					
							<cfset cnt = 0>
				
						</cfif>
					
					</cfoutput>
				
				</cfoutput>
			
			</cfoutput>	
				
		</cfoutput>	
					
		<!--- 
		
			now we are going to adjust the target if the target as defined based on the operations for that asset / supply / metric for the period of the month is different 
			
			we loop through assets that have detailed information defined
			for each asset / supply / period record we determine the target and update it 
				
		--->										
				
		<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Completed Consumption Analysis (skAssetItemConsumption) for #mission#"
			StepStatus     = "1">

</cfloop>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Start Average Calculation"
	StepStatus     = "1">	

<!---		 
	we also update the average distribution in ItemWarehouseLocationTable
--->

<cfquery name="updateAverageDistribution" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE	ItemWarehouseLocation
		SET		DistributionAverage = ROUND(AverageData.DistributionAverage,1),
		        MinimumStock        = ROUND(AverageData.DistributionAverage * IWL.DistributionDays,1)
		FROM	ItemWarehouseLocation IWL
				INNER JOIN
				(
					SELECT	ItemLocationId,
							CASE
								WHEN AveragePeriod = 0 THEN 0
								ELSE (AverageDistribution / AveragePeriod) 
							END AS DistributionAverage
					FROM
						(
							SELECT	I.ItemLocationId, 
									I.AveragePeriod,
									(
										SELECT    ISNULL(SUM(-T.TransactionQuantity),0)
										FROM      ItemTransaction T
										WHERE     T.Warehouse        = I.Warehouse
										AND       T.Location         = I.Location  
										AND       T.ItemNo           = I.ItemNo
										AND       T.TransactionUoM   = I.UoM
										AND       T.TransactionType  = '2' <!--- Only Distributions --->
										AND       T.TransactionDate > dateAdd(day, -(I.AveragePeriod), getDate()) <!--- AveragePeriod days ago from now --->
									) as AverageDistribution
							FROM	ItemWarehouseLocation I
							WHERE	I.Operational = 1 <!--- Only operational ItemWarehouseLocations --->
						) AS Data
				) AverageData
					ON IWL.ItemLocationId = AverageData.ItemLocationId
		WHERE	IWL.Operational = 1 <!--- Only operational ItemWarehouseLocation --->

</cfquery> 

<cfquery name="updateAverageDistribution" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE	ItemWarehouseLocation
	SET     MinimumStock = MaximumStock
	WHERE   MinimumStock > MaximumStock
</cfquery>	

<!--- update pattern table --->

<cfquery name="clear" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ItemWarehousePattern
	WHERE  DateEffective = '#dateformat(now(),client.dateSQL)#'
</cfquery>

<cfquery name="updateAverageDistributionAtWarehouseLevel" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		INSERT INTO ItemWarehousePattern
			(Warehouse,
			 ItemNo,
			 UoM,
			 DateEffective,
			 DistributionAverage,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
		 
		SELECT  IW.Warehouse,
		        IW.ItemNo,
				IW.UoM, 
				'#dateformat(now(),client.dateSQL)#',
				ROUND(AverageData.DistributionAverage,1), 
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'	
				    
	    FROM	ItemWarehouse IW
				INNER JOIN
				(
					SELECT	ItemNo,
							UoM,
							Warehouse, 
							CASE
								WHEN AveragePeriod = 0 THEN 0
								ELSE (AverageDistribution / AveragePeriod) 
							END AS DistributionAverage
					FROM
						(
							SELECT	I.ItemNo,
									I.UoM,
									I.Warehouse, 
									I.AveragePeriod,
									(
										SELECT    ISNULL(SUM(-T.TransactionQuantity),0)
										FROM      ItemTransaction T
										WHERE     T.Warehouse        = I.Warehouse
										AND       T.ItemNo           = I.ItemNo
										AND       T.TransactionUoM   = I.UoM
										AND       T.TransactionType  = '2' 
										AND       T.TransactionDate > dateAdd(day, -(I.AveragePeriod), getDate()) 
									) as AverageDistribution
							FROM	ItemWarehouse I
							WHERE	I.Operational = 1
						) AS Data
				) AverageData
				ON IW.Warehouse   = AverageData.Warehouse 
					AND IW.ItemNo = AverageData.ItemNo
					AND IW.UoM    = AverageData.UoM
		WHERE	IW.Operational = 1 

</cfquery> 


<cfquery name="updateAverageDistribution" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE	ItemWarehousePattern
	SET     DistributionAverage = 0
	WHERE   DistributionAverage < 0
</cfquery>	


<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Completed Average Calculation"
	StepStatus     = "1">	

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Cleaning Temporary Tables"
	StepStatus     = "1">	
	
<cf_dropTable dbName="AppsQuery" tblName="#snapshotItemTransaction#">

