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
<cfparam name="url.incrementalName" 		default="ItemTransactionDay">
<cfparam name="url.incrementalGroupName"	default="Warehouse">
<cfparam name="url.selectiveName" 			default="SelectiveItemTransactionDay">
<cfparam name="url.selectiveGroupName"		default="Warehouse">
<cfparam name="url.pauseIncremental"		default="1">

<!--- kherrera [2014-04-29]: Provision made to calculate only FUEL items for performance matters --->
<cfset vItemCategoryRestriction = "'FUEL'">

<!--- Dev comment for diaz 01/12/2012 ----------------------------- --->
<!--- this portion we take from the table Ref_CategoryClassification 
for class=Consumption to prevent we have to change this as hardcoding --->
<!--- --------------------------------------------------------------- --->

<cfset vLogReportCount = 300>

<!--- kherrera [2013-02-05]: Provision made to avoid issues with the updates --->

<cfif lcase(CGI.HTTP_HOST) eq "dev01" 
	or lcase(CGI.HTTP_HOST) eq "www.promisan.net">

	<cfset vCategoryVehicles   = "Vehicles">
	<cfset vCategoryGenerators = "Generators">
	<cfset vCategoryAircraft   = "AIR">
	<cfset vCategoryBoats      = "BOA">
	<cfset vCategoryCookers    = "CCR">
	
	<cfset extendedIndexClauses = 0>

<cfelse>
	
	<!--- UN instances --->
	<cfset vCategoryVehicles       = "VEH">
	<cfset vCategoryGenerators     = "GEN">
	<cfset vCategoryAircraft       = "AIR">
	<cfset vCategoryBoats          = "BOA">
	<cfset vCategoryCookers        = "CCR">
	
	<!--- This should be set to 1 if the db version is 2005 or greater --->
	<cfset extendedIndexClauses = 1>
	
</cfif>

<cfset snapshotItemTransaction = "_snapshotItemTransaction_skItemTransactionDay">
<cf_dropTable dbName="AppsQuery" tblName="#snapshotItemTransaction#">
<cfset Answer1 = "_Answer1_skItemTransactionDay">
<cf_dropTable dbName="AppsQuery" tblName="#Answer1#">
<cfset Answer2 = "_Answer2_skItemTransactionDay">
<cf_dropTable dbName="AppsQuery" tblName="#Answer2#">
<cfset Answer3 = "_Answer3_skItemTransactionDay">
<cf_dropTable dbName="AppsQuery" tblName="#Answer3#">
<cfset Answer4 = "_Answer4_skItemTransactionDay">
<cf_dropTable dbName="AppsQuery" tblName="#Answer4#">
<cfset Answer5 = "_Answer5_skItemTransactionDay">
<cf_dropTable dbName="AppsQuery" tblName="#Answer5#">
<cfset Answer6 = "_Answer6_skItemTransactionDay">
<cf_dropTable dbName="AppsQuery" tblName="#Answer6#">

<cfif url.isFullLoad eq 1>
	
	<!--- Pause incremental and selective processes to avoid overlapping --->
	<cfif url.pauseIncremental eq 1>
		<cfschedule action = "pause"
					task   = "#url.incrementalName#"
					group  = "#url.incrementalGroupName#">
					
		<cfschedule action = "pause"
					task   = "#url.selectiveName#"
					group  = "#url.selectiveGroupName#">
					
		<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Incremental and Selective Process On Pause"
			StepStatus     = "1">
	</cfif>
				
	<!--- Clear sk and st tables --->
	
	<cfquery name="deleteSKItemTransactionDay"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			DELETE FROM skItemTransactionDay		
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "SkItemTransactionDay Cleaned"
		StepStatus     = "1">
	
	<cfquery name="deleteSTItemTransactionDay"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			DELETE FROM stItemTransactionDay		
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "StItemTransactionDay Cleaned"
		StepStatus     = "1">

</cfif>

<cfif url.isFullLoad eq 2>

	<!--- Pause incremental process to avoid overlapping --->
	<cfif url.pauseIncremental eq 1>
		<cfschedule action = "pause"
					task   = "#url.incrementalName#" 
					group  = "#url.incrementalGroupName#">
					
		<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Incremental Process On Pause"
			StepStatus     = "1">
	</cfif>
	<!--- Selectively Clear st table --->
	
	<cfquery name="selectivelyDeleteSTItemTransactionDay"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			DELETE 
			FROM 	stItemTransactionDay
			WHERE	EXISTS
					(
						SELECT	'X'
						FROM
								(
									SELECT	Mission,
											Warehouse,
											Location,
											Item,
											UoM,
											ClosingStock
									FROM	skItemTransactionDay
									WHERE	Year = YEAR(GETDATE())
									AND		Month = MONTH(GETDATE())
									AND		Day = DAY(GETDATE())
								) AS S
								INNER JOIN
								(
									SELECT	T.Mission,
											T.Warehouse,
											T.Location,
											T.ItemNo,
											T.TransactionUoM,
											SUM(T.TransactionQuantity) as Stock
									FROM	ItemTransaction T
											INNER JOIN WarehouseLocation WL
												ON T.Warehouse = WL.Warehouse
												AND T.Location = WL.Location
									WHERE	(
												T.TransactionBatchNo NOT IN
																	  (
																			SELECT		Tx.TransactionBatchNo
																			FROM		ItemTransaction Tx
																						INNER JOIN WarehouseLocation WLx
																							ON Tx.Warehouse = WLx.Warehouse
																							AND Tx.Location = WLx.Location
																			WHERE      Tx.Mission            = T.Mission 
																			AND        Tx.Warehouse          = T.Warehouse 
																			AND        Tx.ItemNo             = T.ItemNo 
																			AND        Tx.TransactionUoM     = T.TransactionUoM
																			AND		   WLx.LocationId		 = WL.LocationId
																			AND        Tx.TransactionBatchNo = T.TransactionBatchNo
																			AND	       Tx.TransactionType    = '8'
																			GROUP BY   Tx.TransactionBatchNo
																			HAVING     SUM(Tx.TransactionQuantity) = 0
																		)
												OR T.TransactionType = '2'
											)
									GROUP BY T.Mission,
											T.Warehouse,
											T.Location,
											T.ItemNo,
											T.TransactionUoM
								) AS T
								ON	S.Mission = T.Mission
								AND	S.Warehouse = T.Warehouse
								AND S.Location = T.Location
								AND S.Item = T.ItemNo
								AND S.UoM = T.TransactionUoM
						WHERE	S.ClosingStock != T.Stock
						AND		S.Mission = stItemTransactionDay.Mission
						AND		S.Warehouse = stItemTransactionDay.Warehouse
						AND 	S.Location = stItemTransactionDay.Location
						AND 	S.Item = stItemTransactionDay.ItemNo
						AND 	S.UoM = stItemTransactionDay.UoM
					)
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "StItemTransactionDay Selectively Cleaned"
		StepStatus     = "1">

</cfif>

<cftry>

	<!--- Get ItemTransaction snapshot to be taken in a temp table --->
	
	<cfquery name="itemTransactionSnapShot"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT 	T.*,
					WL.LocationId as WLLocationId
			INTO	UserQuery.dbo.#snapshotItemTransaction#
			FROM	ItemTransaction T INNER JOIN WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location
		
	</cfquery>
	
	<cfquery name="itemTransactionSnapShotIndexes"
		Datasource="AppsQuery"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		CREATE NONCLUSTERED INDEX [_dta_index__snapshotItemTransaction_1] ON [dbo].[_snapshotItemTransaction_skItemTransactionDay] 
		(
			[Warehouse] ASC,
			[TransactionUoM] ASC,
			[Mission] ASC,
			[Location] ASC,
			[ItemNo] ASC,
			[TransactionBatchNo] ASC,
			[TransactionDate] ASC,
			[TransactionType] ASC
		)
		<!--- Include clause does not work in SQLServer 2000 --->
		<cfif extendedIndexClauses eq 1>
			INCLUDE ( [Created]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		;
	
		CREATE NONCLUSTERED INDEX [_dta_index__snapshotItemTransaction_2] ON [dbo].[_snapshotItemTransaction_skItemTransactionDay] 
		(
			[ItemNo] ASC,
			[TransactionUoM] ASC,
			[Created] ASC,
			[Warehouse] ASC,
			[Location] ASC,
			[Mission] ASC
		)
		<cfif extendedIndexClauses eq 1>
			WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		;
		
		CREATE NONCLUSTERED INDEX [_dta_index__snapshotItemTransaction_3] ON [dbo].[_snapshotItemTransaction_skItemTransactionDay] 
		(
			[Mission] ASC,
			[Warehouse] ASC,
			[Location] ASC,
			[ItemNo] ASC,
			[TransactionUoM] ASC,
			[Created] ASC
		)
		<cfif extendedIndexClauses eq 1>
			WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		;
		
		CREATE NONCLUSTERED INDEX [_dta_index__snapshotItemTransaction_4] ON [dbo].[_snapshotItemTransaction_skItemTransactionDay] 
		(
			[Mission] ASC,
			[Warehouse] ASC,
			[Location] ASC,
			[ItemNo] ASC,
			[TransactionUoM] ASC
		)
		<cfif extendedIndexClauses eq 1>
			INCLUDE ( [TransactionDate]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		;
		
		CREATE NONCLUSTERED INDEX [_dta_index__snapshotItemTransaction_5] ON [dbo].[_snapshotItemTransaction_skItemTransactionDay] 
		(
			[Warehouse] ASC,
			[Location] ASC,
			[TransactionUoM] ASC,
			[ItemNo] ASC,
			[Mission] ASC,
			[Created] ASC
		)
		<cfif extendedIndexClauses eq 1>
			INCLUDE ( [TransactionDate]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		;
		
		CREATE NONCLUSTERED INDEX [_dta_index__snapshotItemTransaction_6] ON [dbo].[_snapshotItemTransaction_skItemTransactionDay] 
		(
			[TransactionBatchNo] ASC,
			[TransactionType] ASC
		)
		
		<cfif extendedIndexClauses eq 1>
			INCLUDE ( [Mission],
			[Warehouse],
			[TransactionDate],
			[ItemNo],
			[Location],
			[TransactionQuantity],
			[TransactionUoM],
			[Created]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		;
		
		CREATE NONCLUSTERED INDEX [_dta_index__snapshotItemTransaction_7] ON [dbo].[_snapshotItemTransaction_skItemTransactionDay] 
		(
			[TransactionType] ASC,
			[TransactionBatchNo] ASC
		)
		<cfif extendedIndexClauses eq 1>
			INCLUDE ( [Mission],
			[Warehouse],
			[ItemNo],
			[TransactionQuantity],
			[TransactionUoM]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		;
		
		CREATE NONCLUSTERED INDEX [_dta_index__snapshotItemTransaction_8] ON [dbo].[_snapshotItemTransaction_skItemTransactionDay] 
		(
			[TransactionType] ASC,
			[TransactionBatchNo] ASC,
			[AssetId] ASC
		)
		<cfif extendedIndexClauses eq 1>
			INCLUDE ( [Mission],
			[Warehouse],
			[TransactionDate],
			[ItemNo],
			[Location],
			[TransactionQuantity],
			[TransactionUoM],
			[Created]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		;
		
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed ItemTransaction Snapshot Gathering"
		StepStatus     = "1">
	
	<!--- Get initial valid data --->
	
	<cfquery name="qApplicableWarehouseItems"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT DISTINCT 	
					Mission,
					Warehouse,
					WarehouseName,
					Location,
					ItemNo,
					ItemDescription,
					TransactionUoM,
					UoMDescription,
					ItemPrecision,
					convert(datetime, convert(varchar(10),MIN(MinDate),112)) AS MinDate,
					MAX(MaxCreatedDate) AS MaxCreatedDate
			
			INTO	userQuery.dbo.#Answer2#
			
			FROM	(				
					SELECT DISTINCT	
							T.Mission, 
							T.Warehouse, 
							W.WarehouseName,
							WL.Location,
							T.ItemNo, 
							I.ItemDescription,
							T.TransactionUoM, 
							U.UoMDescription,
							I.ItemPrecision,
							ISNULL((
							
								SELECT 	MIN(TransactionDate) AS MinDate
								FROM	UserQuery.dbo.#snapshotItemTransaction# T2
								WHERE	T2.Mission = T.Mission
								AND		T2.Warehouse = T.Warehouse
								AND		T2.Location = T.Location
								AND		T2.ItemNo = T.ItemNo
								AND		T2.TransactionUoM = T.TransactionUoM
								AND		T2.Created >=
										(
											SELECT	CreatedDateLastLoaded
											FROM	stItemTransactionDay
											WHERE	Mission   = T.Mission
											AND		Warehouse = T.Warehouse
											AND		Location  = T.Location
											AND		ItemNo    = T.ItemNo
											AND		UoM       = T.TransactionUoM
										)							
							), 
								(
									SELECT 	MIN(TransactionDate) AS MinDate
									FROM	UserQuery.dbo.#snapshotItemTransaction# T2
									WHERE	T2.Mission = T.Mission
									AND		T2.Warehouse = T.Warehouse
									AND		T2.Location = T.Location
									AND		T2.ItemNo = T.ItemNo
									AND		T2.TransactionUoM = T.TransactionUoM
								)
							) as MinDate,
							
							(
								SELECT 	MAX(Created) as Created
								FROM	UserQuery.dbo.#snapshotItemTransaction# T3
								WHERE	T3.Mission = T.Mission
								AND		T3.Warehouse = T.Warehouse
								AND		T3.Location = T.Location
								AND		T3.ItemNo = T.ItemNo
								AND		T3.TransactionUoM = T.TransactionUoM
							) as MaxCreatedDate
							
					FROM	UserQuery.dbo.#snapshotItemTransaction# T
							INNER JOIN Warehouse W	        ON T.Warehouse = W.Warehouse
							INNER JOIN WarehouseLocation WL	ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location
							INNER JOIN Item I				ON T.ItemNo    = I.ItemNo
							INNER JOIN ItemUoM U			ON T.ItemNo    = U.ItemNo AND T.TransactionUoM = U.UoM
							
					WHERE  	I.ItemClass = 'Supply'
					<cfif vItemCategoryRestriction neq "">
					AND		I.Category IN (#preserveSingleQuotes(vItemCategoryRestriction)#)
					</cfif>
					AND		T.Created >
							(
								ISNULL((
									SELECT	CreatedDateLastLoaded
									FROM	stItemTransactionDay
									WHERE	Mission   = T.Mission
									AND		Warehouse = T.Warehouse
									AND		Location  = T.Location
									AND		ItemNo    = T.ItemNo
									AND		UoM       = T.TransactionUoM
								), '19000101')
							)
							
					UNION
					
					SELECT DISTINCT	
							T.Mission, 
							T.Warehouse, 
							W.WarehouseName,
							WL.Location,
							T.ItemNo, 
							I.ItemDescription,
							T.TransactionUoM, 
							U.UoMDescription,
							I.ItemPrecision,
							ISNULL((
							
								SELECT 	MIN(TransactionDate) AS MinDate
								FROM	ItemTransactionDeny T2
								WHERE	T2.Mission        = T.Mission
								AND		T2.Warehouse      = T.Warehouse
								AND		T2.Location       = T.Location
								AND		T2.ItemNo         = T.ItemNo
								AND		T2.TransactionUoM = T.TransactionUoM
								AND		T2.Created >=
										(
											SELECT	CreatedDateLastLoaded
											FROM	stItemTransactionDay
											WHERE	Mission    = T.Mission
											AND		Warehouse  = T.Warehouse
											AND		Location   = T.Location
											AND		ItemNo     = T.ItemNo
											AND		UoM        = T.TransactionUoM
										)								
							), 
								(
									SELECT 	MIN(TransactionDate) AS MinDate
									FROM	ItemTransactionDeny T2
									WHERE	T2.Mission        = T.Mission
									AND		T2.Warehouse      = T.Warehouse
									AND		T2.Location       = T.Location
									AND		T2.ItemNo         = T.ItemNo
									AND		T2.TransactionUoM = T.TransactionUoM
								)
							) as MinDate,
							
							(
								SELECT 	MAX(Created) as Created
								FROM	ItemTransactionDeny T3
								WHERE	T3.Mission          = T.Mission
								AND		T3.Warehouse        = T.Warehouse
								AND		T3.Location         = T.Location
								AND		T3.ItemNo           = T.ItemNo
								AND		T3.TransactionUoM   = T.TransactionUoM
							) as MaxCreatedDate
							
					FROM	ItemTransactionDeny T
							INNER JOIN Warehouse W ON T.Warehouse = W.Warehouse
							INNER JOIN WarehouseLocation WL	ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location
							INNER JOIN Item I      ON T.ItemNo = I.ItemNo
							INNER JOIN ItemUoM U   ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM
					WHERE  	I.ItemClass = 'Supply'
					<cfif vItemCategoryRestriction neq "">
					AND		I.Category IN (#preserveSingleQuotes(vItemCategoryRestriction)#)
					</cfif>
					AND		T.Created >
							(
								ISNULL((
									SELECT	CreatedDateLastLoaded
									FROM	stItemTransactionDay
									WHERE	Mission   = T.Mission
									AND		Warehouse = T.Warehouse
									AND		Location  = T.Location
									AND		ItemNo    = T.ItemNo
									AND		UoM       = T.TransactionUoM
								), '19000101')
							)
				
				) AS Data
				
				GROUP BY 
						Mission,
						Warehouse,
						WarehouseName,
						Location,
						ItemNo,
						ItemDescription,
						TransactionUoM,
						UoMDescription,
						ItemPrecision
				
	</cfquery>
	
	<cfquery name="answer2Index"
		Datasource="AppsQuery"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		CREATE NONCLUSTERED INDEX [_dta_index__Answer2_1] ON [dbo].[_Answer2_skItemTransactionDay] (
			[Warehouse] ASC,
			[ItemNo] ASC,
			[TransactionUoM] ASC,
			[Mission] ASC,
			[Location] ASC,
			[MaxCreatedDate] ASC		)
		<!--- Include clause does not work in SQLServer 2000 --->
		<cfif extendedIndexClauses eq 1>
			INCLUDE ( [MinDate]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		
	</cfquery>
	
	<cfquery name="applicableWarehouseItems"
		Datasource="AppsQuery"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT	*
			FROM	#Answer2#			
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Valid Data Gathering"
		StepStatus     = "1">	
		
	<cfquery name="quantityResume"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
					
		SELECT 	T.Mission,
				T.Warehouse,
				T.Location,
				T.ItemNo,
				T.TransactionType,
				T.TransactionUoM,
				T.TransactionBatchNo,
				T.Created,
				convert(varchar(10),T.TransactionDate,112) as TransactionDate,
				T.TransactionQuantity
		
		INTO	UserQuery.dbo.#Answer4#
		
		FROM	UserQuery.dbo.#snapshotItemTransaction# T
		
		<!--- internal transfer within geo location --->
		WHERE	(T.TransactionBatchNo NOT IN
				  (SELECT      TransactionBatchNo
					FROM       UserQuery.dbo.#snapshotItemTransaction#
					WHERE      Mission            = T.Mission 
					AND        Warehouse          = T.Warehouse 
					AND        ItemNo             = T.ItemNo 
					AND        TransactionUoM     = T.TransactionUoM
					AND		   WLLocationId       = T.WLLocationId
					AND        TransactionBatchNo = T.TransactionBatchNo
					AND	       TransactionType    = '8'
					GROUP BY   TransactionBatchNo
					HAVING     SUM(TransactionQuantity) = 0)
				OR T.TransactionType = '2'
				)			
	</cfquery>
	
	<cfquery name="answer4Index"
		Datasource="AppsQuery"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		CREATE NONCLUSTERED INDEX [_dta_index__Answer4_1] ON [dbo].[_Answer4_skItemTransactionDay] (
				[Mission] ASC,
				[Warehouse] ASC,
				[Location] ASC,
				[ItemNo] ASC,
				[TransactionUoM] ASC,
				[TransactionDate] ASC,
				[TransactionQuantity] ASC,
				[Created] ASC,
				[TransactionType] ASC
			)
		<cfif extendedIndexClauses eq 1>
			WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Transactions Resume"
		StepStatus     = "1">	
	
	<cfquery name="quantityAssetResume"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
					
			SELECT 	T.Mission,
				    T.Warehouse,
				    T.Location,
				    T.ItemNo,
				    T.TransactionType,
				    T.TransactionUoM,
				    T.TransactionBatchNo,
				    T.Created,
				    I.Category,
				    T.AssetId,
				    AI.ParentAssetId,
				    Convert(varchar(10),T.TransactionDate,112) as TransactionDate,
				    T.TransactionQuantity
			INTO	UserQuery.dbo.#Answer5#
			FROM	UserQuery.dbo.#snapshotItemTransaction# T
					INNER JOIN AssetItem AI	ON T.AssetId = AI.AssetId
					INNER JOIN Item I		ON AI.ItemNo = I.ItemNo
			WHERE	(T.TransactionBatchNo NOT IN
					  (SELECT      TransactionBatchNo
						FROM       UserQuery.dbo.#snapshotItemTransaction#
						WHERE      Mission            = T.Mission 
						AND        Warehouse          = T.Warehouse 
						AND        ItemNo             = T.ItemNo 
						AND        TransactionUoM     = T.TransactionUoM
						AND		   WLLocationId       = T.WLLocationId
						AND        TransactionBatchNo = T.TransactionBatchNo
						AND	       TransactionType    = '8'
						GROUP BY   TransactionBatchNo
						HAVING     SUM(TransactionQuantity) = 0)
					OR T.TransactionType = '2'
					)
			AND		T.TransactionType in (SELECT TransactionType 
			                              FROM   Ref_TransactionType 
										  WHERE  TransactionClass = 'Distribution')
			
	</cfquery>
	
	<cfquery name="answer5Index"
		Datasource="AppsQuery"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		CREATE NONCLUSTERED INDEX [_dta_index__Answer5_1] ON [dbo].[_Answer5_skItemTransactionDay] (
			[Mission] ASC,
			[Warehouse] ASC,
			[Location] ASC,
			[ItemNo] ASC,
			[TransactionUoM] ASC,
			[TransactionDate] ASC,
			[Category] ASC,
			[Created] ASC,
			[ParentAssetId] ASC
		)
		<!--- Include clause does not work in SQLServer 2000 --->
		<cfif extendedIndexClauses eq 1>
			INCLUDE ( [TransactionQuantity]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		</cfif>
		
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Asset Transactions Resume"
		StepStatus     = "1">	
	
	<cfquery name="parentAssetResume"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT 	AI.AssetId,
					I.Category
			INTO	UserQuery.dbo.#Answer6#
			FROM    AssetItem AI INNER JOIN Item I ON AI.ItemNo = I.ItemNo
			WHERE	AI.ParentAssetId IS NULL
			
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Parent Assets Resume"
		StepStatus     = "1">
		
	
	<!--- Get initial valid data detail --->
	<cfquery name="transactions"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT DISTINCT	
					T.Mission,
					W.Warehouse,
					W.WarehouseName,
					T.Location,
					I.ItemNo,
					U.UoM,
					I.ItemDescription,
					U.UoMDescription as ItemUoM,
					I.ItemPrecision,
					day(T.TransactionDate) as Day,
					month(T.TransactionDate) as Month,
					year(T.TransactionDate) as Year,
					ISNULL((
						SELECT	ISNULL(SUM(TransactionQuantity), 0)
						FROM	UserQuery.dbo.#Answer4# T2
						WHERE	T2.Mission = T.Mission
						AND		T2.Warehouse = T.Warehouse
						AND		T2.Location = T.Location
						AND		T2.ItemNo = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		T2.TransactionDate <= convert(varchar(10),T.TransactionDate,112)
						AND		T2.Created <= VT.MaxCreatedDate
					), 0)as OpeningStock,
					
					ISNULL((
						SELECT  ISNULL(SUM(TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer4# T2
						WHERE	T2.Mission = T.Mission
						AND		T2.Warehouse = T.Warehouse
						AND		T2.Location = T.Location
						AND		T2.ItemNo = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		T2.TransactionType in (SELECT TransactionType FROM Ref_TransactionType WHERE TransactionClass IN ('Receipt', 'Transfer'))
						AND		T2.TransactionQuantity > 0
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as Received,
					
					ISNULL((
						SELECT  ISNULL(SUM(-TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer5# T2
						WHERE	T2.Mission = T.Mission
						AND		T2.Warehouse = T.Warehouse
						AND		T2.Location = T.Location
						AND		T2.ItemNo = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		(
									T2.Category  = '#vCategoryVehicles#'
									OR 
									(
										T2.ParentAssetId IN
										(
											SELECT 	AssetId
											FROM    UserQuery.dbo.#Answer6#
											WHERE	Category  = '#vCategoryVehicles#'
										)
									)
								)
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as IssuedVehicles,
					
					ISNULL((
						SELECT  ISNULL(SUM(-TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer5# T2
						WHERE	T2.Mission = T.Mission
						AND		T2.Warehouse = T.Warehouse
						AND		T2.Location = T.Location
						AND		T2.ItemNo = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		(
									T2.Category  = '#vCategoryGenerators#'
									OR 
									(
										T2.ParentAssetId IN
										(
											SELECT 	AssetId
											FROM    UserQuery.dbo.#Answer6#
											WHERE	Category  = '#vCategoryGenerators#'
										)
									)
								)
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as IssuedGenerators,
					
					ISNULL((
						SELECT  ISNULL(SUM(-TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer5# T2
						WHERE	T2.Mission = T.Mission
						AND		T2.Warehouse = T.Warehouse
						AND		T2.Location = T.Location
						AND		T2.ItemNo = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		(
									T2.Category  = '#vCategoryAircraft#'
									OR 
									(
										T2.ParentAssetId IN
										(
											SELECT 	AssetId
											FROM    UserQuery.dbo.#Answer6#
											WHERE	Category  = '#vCategoryAircraft#'
										)
									)
								)
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as IssuedAircraft,
					
					ISNULL((
						SELECT  ISNULL(SUM(-TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer5# T2
						WHERE	T2.Mission = T.Mission
						AND		T2.Warehouse = T.Warehouse
						AND		T2.Location = T.Location
						AND		T2.ItemNo = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		(
									T2.Category  = '#vCategoryBoats#'
									OR 
									(
										T2.ParentAssetId IN
										(
											SELECT 	AssetId
											FROM    UserQuery.dbo.#Answer6#
											WHERE	Category  = '#vCategoryBoats#'
										)
									)
								)
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as IssuedBoats,
					
					ISNULL((
						SELECT  ISNULL(SUM(-TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer5# T2
						WHERE	T2.Mission = T.Mission
						AND		T2.Warehouse = T.Warehouse
						AND		T2.Location = T.Location
						AND		T2.ItemNo = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		(
									T2.Category  = '#vCategoryCookers#'
									OR 
									(
										T2.ParentAssetId IN
										(
											SELECT 	AssetId
											FROM    UserQuery.dbo.#Answer6#
											WHERE	Category  = '#vCategoryCookers#'
										)
									)
								)
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as IssuedCookers,
										
					ISNULL((
						SELECT  ISNULL(SUM(-TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer4# T2
						WHERE	T2.Mission        = T.Mission
						AND		T2.Warehouse      = T.Warehouse
						AND		T2.Location       = T.Location
						AND		T2.ItemNo         = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		T2.TransactionType in (SELECT TransactionType FROM Ref_TransactionType WHERE TransactionClass = 'Distribution')
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as Issued,
					
					ISNULL((
						SELECT  ISNULL(SUM(-TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer4# T2
						WHERE	T2.Mission        = T.Mission
						AND		T2.Warehouse      = T.Warehouse
						AND		T2.Location       = T.Location
						AND		T2.ItemNo         = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		T2.TransactionType in (SELECT TransactionType FROM Ref_TransactionType WHERE TransactionClass = 'Transfer')
						AND		T2.TransactionQuantity <= 0
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as Transfer,
					
					ISNULL((
						SELECT  ISNULL(SUM(TransactionQuantity),0)
						FROM    UserQuery.dbo.#Answer4# T2
						WHERE	T2.Mission         = T.Mission
						AND		T2.Warehouse       = T.Warehouse
						AND		T2.Location        = T.Location
						AND		T2.ItemNo          = T.ItemNo
						AND		T2.TransactionUoM  = T.TransactionUoM
						AND		convert(varchar(10),T2.TransactionDate,112) = convert(varchar(10),T.TransactionDate,112)
						AND		T2.TransactionType in (SELECT TransactionType FROM Ref_TransactionType WHERE TransactionClass = 'Variance')
						AND		T2.Created <= VT.MaxCreatedDate
					), 0) as Variance,
					
					ISNULL((
						SELECT	ISNULL(SUM(TransactionQuantity), 0)
						FROM	UserQuery.dbo.#Answer4# T2
						WHERE	T2.Mission        = T.Mission
						AND		T2.Warehouse      = T.Warehouse
						AND		T2.Location       = T.Location
						AND		T2.ItemNo         = T.ItemNo
						AND		T2.TransactionUoM = T.TransactionUoM
						AND		T2.TransactionDate < convert(varchar(10),dateAdd(day,1,T.TransactionDate),112)
						AND		T2.Created <= VT.MaxCreatedDate
					), 0)as ClosingStock
					
			INTO	UserQuery.dbo.#Answer1#
			FROM	UserQuery.dbo.#snapshotItemTransaction# T
					INNER JOIN Warehouse W ON T.Warehouse = W.Warehouse
					INNER JOIN Item I ON T.ItemNo = I.ItemNo
					INNER JOIN ItemUoM U ON T.ItemNo = U.ItemNo	AND T.TransactionUoM = U.UoM
					INNER JOIN UserQuery.dbo.#Answer2# VT ON VT.Mission = T.Mission
									AND		VT.Warehouse = T.Warehouse
									AND		VT.Location = T.Location
									AND		VT.ItemNo = T.ItemNo
									AND		VT.TransactionUoM = T.TransactionUoM
			WHERE	(
						T.TransactionBatchNo NOT IN
						(
							SELECT     TransactionBatchNo
							FROM          UserQuery.dbo.#snapshotItemTransaction#
							WHERE       Mission        = T.Mission 
							AND         Warehouse      = T.Warehouse 
							AND         ItemNo         = T.ItemNo 
							AND         TransactionUoM = T.TransactionUoM
							AND		    WLLocationId = T.WLLocationId
							AND         TransactionBatchNo = T.TransactionBatchNo	
							AND		    TransactionType = '8'
							GROUP BY    TransactionBatchNo
							HAVING      SUM(TransactionQuantity) = 0
						)
						OR T.TransactionType = '2'
					)
					
			AND 	I.ItemClass = 'Supply'
			<cfif vItemCategoryRestriction neq "">
			AND		I.Category IN (#preserveSingleQuotes(vItemCategoryRestriction)#)
			</cfif>
			AND		T.TransactionDate >= convert(varchar(10),VT.MinDate,112)
			AND		T.Created         <= VT.MaxCreatedDate
		
	</cfquery>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Valid Data Detail Gathering"
		StepStatus     = "1">	
		
	<!--- Fill temporary table --->
	<cfquery name="createTempStructureWith0Values"
		Datasource="AppsQuery"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT 	convert(varchar(30),'') as Mission,
					convert(varchar(20),'') as Warehouse,
					convert(varchar(60),'') as WarehouseName,		
					convert(varchar(20),'') as Location,																								
					convert(varchar(20),'') as Item,
					convert(varchar(10),'') as UoM,
					convert(varchar(200),'') as ItemDescription,
					convert(varchar(50),'') as ItemUoM,
					convert(varchar(10),'') as ItemPrecision,
					0 as Day,
					0 as Month,
					0 as Year,
					0.0 as OpeningStock,
					0.0 as Received,
						0.0 as issuedVehicles,
						0.0 as issuedGenerators,
						0.0 as issuedAircraft,
						0.0 as issuedBoats,
						0.0 as issuedCookers,
						0.0 as issuedOthers,
					0.0 as Issued,
					0.0 as Transfer,
					0.0 as Variance,
					0.0 as ClosingStock
			INTO 	#Answer3#				
		
	</cfquery>
	
	<!--- Clear temporary table --->
	<cfquery name="clearTempStructureWith0Values"
		Datasource="AppsQuery"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		DELETE FROM #Answer3#
			
	</cfquery>
	
	<cfset cnt = 0>
	
	<cfloop query="applicableWarehouseItems">
	
		<cfset vmonth = month(MinDate)>
		<cfset vyear = year(MinDate)>
		<cfset vCurrentDate = createDate(vyear,vmonth,1)>
	
		<cfloop condition="#vCurrentDate# lte createDate(year(now()),month(now()),1)">
		
			<cfset firstDayMonth = createDate(vyear, vmonth, 1)>
			<cfset lastDayMonth = dateAdd("s",-1,dateAdd("m",1,firstDayMonth))>
			<cfset firstDay = 1>
			<cfset lastDay = datePart("d",lastDayMonth)>
			
			<!--- Populate whole month with 0's --->
			<cfloop index="vday" from="#firstDay#" to="#lastDay#">
				
				<cfquery name="populateTempStructureWith0Values"
					Datasource="AppsQuery"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					INSERT INTO #Answer3#
							(Mission,
							Warehouse,
							WarehouseName,		
							Location,																								
							Item,
							UoM,
							ItemDescription,
							ItemUoM,
							ItemPrecision,
							Day,
							Month,
							Year,
							OpeningStock,
							Received,
								issuedVehicles,
								issuedGenerators,
								issuedAircraft,
								issuedBoats,
								issuedCookers,
								issuedOthers,
							Issued,
							Transfer,
							Variance,
							ClosingStock)
					VALUES 
							('#mission#',
							'#warehouse#',
							'#warehouseName#',	
							'#location#',
							'#itemNo#',
							'#transactionUoM#',
							'#ItemDescription#',
							'#UoMDescription#',
							#ItemPrecision#,
							#vday#,
							#vmonth#,
							#vYear#,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0,
							0)
				
				</cfquery>
			
			</cfloop>
			
			<cfset vCurrentDate = dateAdd("m",1,vCurrentDate)>
			<cfset vmonth = month(vCurrentDate)>
			<cfset vyear = year(vCurrentDate)>
			
			<cfset cnt = cnt +1>
		
			<cfif cnt eq vLogReportCount or applicableWarehouseItems.currentrow eq applicableWarehouseItems.recordcount>
			
				<cf_ScheduleLogInsert
			   	ScheduleRunId  = "#schedulelogid#"
				Description    = "  ------- Temporary Table Progress: #NumberFormat(((applicableWarehouseItems.currentrow*100)/applicableWarehouseItems.recordcount),',.__')# % [Month: #vmonth#/#vyear# - Records: #NumberFormat(applicableWarehouseItems.currentrow,',')# of #NumberFormat(applicableWarehouseItems.recordcount,',')#]"
				StepStatus     = "1">	
		
				<cfset cnt = 0>
	
			</cfif>
		
		</cfloop>
		
	</cfloop>

	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Valid Data Insertion To Temporary Table"
		StepStatus     = "1">
	
	
	<!--- Fill skItemTransactionDay --->
	<cfquery name="populateStructureWith0Values"
		Datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		INSERT INTO skItemTransactionDay
				(Mission,
				Warehouse,
				WarehouseName,		
				Location,																								
				Item,
				UoM,
				ItemDescription,
				ItemUoM,
				ItemPrecision,
				Day,
				Month,
				Year,
				OpeningStock,
				Received,
					issuedVehicles,
					issuedGenerators,
					issuedAircraft,
					issuedBoats,
					issuedCookers,
					issuedOthers,
				Issued,
				Transfer,
				Variance,
				ClosingStock)
		
		SELECT	Mission,
				Warehouse,
				WarehouseName,		
				Location,																								
				Item,
				UoM,
				ItemDescription,
				ItemUoM,
				ItemPrecision,
				Day,
				Month,
				Year,
				OpeningStock,
				Received,
					issuedVehicles,
					issuedGenerators,
					issuedAircraft,
					issuedBoats,
					issuedCookers,
					issuedOthers,
				Issued,
				Transfer,
				Variance,
				ClosingStock
		FROM	UserQuery.dbo.#Answer3# P
		WHERE	NOT EXISTS
				(
					SELECT	'X'
					FROM	skItemTransactionDay
					WHERE	Mission = P.mission
					AND		Warehouse = P.warehouse
					AND		Location = P.location
					AND		Item = P.item
					AND		UoM = P.UoM
					AND		year = P.year
					AND		month = P.month
					AND		day = P.day
				)
	
	</cfquery>
	
	<cfset cnt = 0>
	
	<cfloop query="applicableWarehouseItems">
	
		<cfset vmonth = month(MinDate)>
		<cfset vyear = year(MinDate)>
		<cfset vCurrentDate = createDate(vyear,vmonth,1)>
	
		<cfloop condition="#vCurrentDate# lte createDate(year(now()),month(now()),1)">
		
			<cfset firstDayMonth = createDate(vyear, vmonth, 1)>
			<cfset lastDayMonth = dateAdd("s",-1,dateAdd("m",1,firstDayMonth))>
			<cfset firstDay = 1>
			<cfset lastDay = datePart("d",lastDayMonth)>
			
			<!--- Populate days with values --->		
			<cfloop index="vday" from="#firstDay#" to="#lastDay#">
			
				<cfquery name="qTransactions"
					Datasource="AppsQuery"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT	*
						FROM	#Answer1#
						WHERE	Mission = '#mission#'
						AND		Warehouse = '#warehouse#'
						AND		Location = '#location#'
						AND		ItemNo = '#itemNo#'
						AND		UoM = '#transactionUoM#'
						AND		year = #vyear#
						AND		month = #vmonth#
						AND		day = #vday#
				</cfquery>
				
				<cfset vOpeningStock = 0>
				<cfset vClosingStock = 0>
				
				<!--- Get previous day values --->
				<cfset vLastDate = dateAdd("d",-1,createDate(vyear,vmonth,vday))>
			
				<cfquery name="qLastDayTransactions"
					Datasource="AppsMaterials"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT	*
						FROM	skItemTransactionDay
						WHERE	Mission = '#mission#'
						AND		Warehouse = '#warehouse#'
						AND		Location = '#location#'
						AND		Item = '#itemNo#'
						AND		UoM = '#transactionUoM#'
						AND		year = #year(vLastDate)#
						AND		month = #month(vLastDate)#
						AND		day = #day(vLastDate)#
				</cfquery>
				
				<cfif qLastDayTransactions.recordCount gt 0>
					<cfset vOpeningStock = qLastDayTransactions.closingStock>
					<cfset vClosingStock = qLastDayTransactions.closingStock>
				</cfif>
				
				<cfif qTransactions.recordCount gt 0>
				
					<!--- Initialiaze Values --->
					<cfset vReceived = 0>
					<cfset vIssuedVehicles = 0>
					<cfset vIssuedGenerators = 0>
					<cfset vIssuedAircraft = 0>
					<cfset vIssuedBoats = 0>
					<cfset vIssuedCookers = 0>
					<cfset vIssuedOthers = 0>
					<cfset vIssued = 0>
					<cfset vTransfer = 0>
					<cfset vVariance = 0>
					
					<!--- Set this day values --->
					<cfset vReceived = qTransactions.Received>
					<cfset vIssuedVehicles = qTransactions.IssuedVehicles>
					<cfset vIssuedGenerators = qTransactions.IssuedGenerators>
					<cfset vIssuedAircraft = qTransactions.IssuedAircraft>
					<cfset vIssuedBoats = qTransactions.IssuedBoats>
					<cfset vIssuedCookers = qTransactions.IssuedCookers>
					<cfset vIssued = qTransactions.Issued>
					
					<cfset vIssuedOthers = vIssued - (vIssuedVehicles + vIssuedGenerators + vIssuedAircraft + vIssuedBoats + vIssuedCookers)>
					
					<cfset vTransfer = qTransactions.Transfer>
					<cfset vVariance = qTransactions.Variance>
					
					<cfset vClosingStock = qTransactions.ClosingStock>		
					
					<!--- Update values in skItemTransactionDay --->
					<cfquery name="updateStructure"
						Datasource="AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						UPDATE 	skItemTransactionDay
						SET		OpeningStock = #vOpeningStock#,
								Received = #vReceived#,
									issuedVehicles = #vIssuedVehicles#,
									issuedGenerators = #vIssuedGenerators#,
									issuedAircraft = #vIssuedAircraft#,
									issuedBoats = #vIssuedBoats#,
									issuedCookers = #vIssuedCookers#,
									issuedOthers = #vIssuedOthers#,
								Issued = #vIssued#,
								Transfer = #vTransfer#,
								Variance = #vVariance#,
								ClosingStock = #vClosingStock#
						WHERE	Mission = '#mission#'
						AND		Warehouse = '#warehouse#'
						AND		Location = '#location#'																							
						AND		Item = '#itemNo#'
						AND		UoM = '#transactionUoM#'
						AND		Day = #vday#
						AND		Month = #vmonth#
						AND		Year = #vyear#
					
					</cfquery>
					
				<cfelse>
				
					<!--- Update values in skItemTransactionDay --->
					<cfquery name="updateStructure"
						Datasource="AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						UPDATE 	skItemTransactionDay
						SET		OpeningStock = #vOpeningStock#,
								ClosingStock = (#vOpeningStock# + D.Received - D.Issued - D.Transfer + D.Variance)
						FROM	skItemTransactionDay D
						WHERE	D.Mission = '#mission#'
						AND		D.Warehouse = '#warehouse#'
						AND		D.Location = '#location#'																							
						AND		D.Item = '#itemNo#'
						AND		D.UoM = '#transactionUoM#'
						AND		D.Day = #vday#
						AND		D.Month = #vmonth#
						AND		D.Year = #vyear#
					
					</cfquery>
				
				</cfif>
			
			</cfloop>
			
			<cfset vCurrentDate = dateAdd("m",1,vCurrentDate)>
			<cfset vmonth = month(vCurrentDate)>
			<cfset vyear = year(vCurrentDate)>
			
			<cfset cnt = cnt +1>
		
			<cfif cnt eq vLogReportCount or applicableWarehouseItems.currentrow eq applicableWarehouseItems.recordcount>
			
				<cf_ScheduleLogInsert
			   	ScheduleRunId  = "#schedulelogid#"
				Description    = "  ------- Main Table Progress: #NumberFormat(((applicableWarehouseItems.currentrow*100)/applicableWarehouseItems.recordcount),',.__')# % [Month: #vmonth#/#vyear# - Records: #NumberFormat(applicableWarehouseItems.currentrow,',')# of #NumberFormat(applicableWarehouseItems.recordcount,',')#]"
				StepStatus     = "1">	
		
				<cfset cnt = 0>
	
			</cfif>
		
		</cfloop>
		
	</cfloop>
	
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Valid Data Insertion"
		StepStatus     = "1">	
		
		
	<!--- Fill/Update stItemTransactionDay --->
	<cfquery name="qTransactionsPerformed"
		Datasource="AppsQuery"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	*
			FROM	#Answer2#
	</cfquery>
	
	<cfloop query="qTransactionsPerformed">
	
		<cftry>
			
			<cfquery name="InsertIncrementalLog"
				Datasource="AppsMaterials"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					INSERT INTO stItemTransactionDay (
							Mission,
							Warehouse,
							Location,
							ItemNo,
							UoM,
							CreatedDateLastLoaded )
					VALUES (
							'#Mission#',
							'#Warehouse#',
							'#Location#',
							'#ItemNo#',
							'#TransactionUoM#',
							'#MaxCreatedDate#' ) 	
				
			</cfquery>
		
			<cfcatch>
			
				<cfquery name="UpdateIncrementalLog"
					Datasource="AppsMaterials"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						UPDATE 	stItemTransactionDay
						SET		CreatedDateLastLoaded = '#MaxCreatedDate#'
						WHERE	Mission   = '#Mission#'
						AND		Warehouse = '#Warehouse#'
						AND		Location  = '#Location#'
						AND		ItemNo    = '#ItemNo#'
						AND		UoM       = '#TransactionUoM#'
					
				</cfquery>
				
			</cfcatch>
		</cftry>
	
	</cfloop>
			
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed Incremental Log Update"
		StepStatus     = "1">


	<cfcatch>
	
		<cfif url.isFullLoad eq 1>
		
			<cfif url.pauseIncremental eq 1>
				<!--- Resume incremental process --->
				<cfschedule action = "resume"
							task   = "#url.incrementalName#"
							group  = "#url.incrementalGroupName#">
							
				<!--- Resume selective process --->
				<cfschedule action = "resume"
							task   = "#url.selectiveName#"
							group  = "#url.selectiveGroupName#">
			</cfif>
						
		</cfif>
		
		<cfif url.isFullLoad eq 2>
		
			<cfif url.pauseIncremental eq 1>
				<!--- Resume incremental process --->
				<cfschedule action = "resume"
							task   = "#url.incrementalName#"
							group  = "#url.incrementalGroupName#">
			</cfif>
						
		</cfif>
					
		<!--- Retrhow the error --->
		<cfrethrow>
		
	</cfcatch>
</cftry>


<cf_dropTable dbName="AppsQuery" tblName="#snapshotItemTransaction#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer1#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer2#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer3#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer4#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer5#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer6#">

<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Temporary Tables Cleaned"
		StepStatus     = "1">

<cfif url.isFullLoad eq 1>

	<!--- Resume incremental and selective process --->
	<cfif url.pauseIncremental eq 1>
		<cfschedule action = "resume"
					task   = "#url.incrementalName#"
					group  = "#url.incrementalGroupName#">
				
		<cfschedule action = "resume"
					task   = "#url.selectiveName#"
					group  = "#url.selectiveGroupName#">
							
		<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Incremental and Selective Process Reinstated"
			StepStatus     = "1">
	</cfif>
		
</cfif>

<cfif url.isFullLoad eq 2>

	<!--- Resume incremental process --->
	<cfif url.pauseIncremental eq 1>
		<cfschedule action = "resume"
					task   = "#url.incrementalName#"
					group  = "#url.incrementalGroupName#">
					
		<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Incremental Process Reinstated"
			StepStatus     = "1">
	</cfif>
		
</cfif>
	
Finished!