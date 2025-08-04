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
	
<cftry>
		
		<cfquery name="Test"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
			SELECT TOP 1 * FROM Transfer#URL.Warehouse#_#SESSION.acc#  
			WHERE TransferQuantity > 0
		</cfquery>
		
		<cfif Test.recordcount gte "1">
	
			<cfset found = "Yes">
		
		<cfelse>
		
			<cfset found = "No">
		
		</cfif>
			
	<cfcatch>
	
		<cfset found = "No">		
	
	</cfcatch>
	
</cftry>

<!--- enforce recreation in case not found or stock order context --->

<cfif url.stockorderid neq "" or found eq "No">
			
		<CF_DropTable dbName="AppsTransaction"  tblName="Transfer#URL.Warehouse#_#SESSION.acc#"> 
				
		<cfquery name="Create"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			CREATE TABLE dbo.Transfer#URL.Warehouse#_#SESSION.acc# (
				[TransactionId] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_Transfer#URL.Warehouse#_#SESSION.acc#] DEFAULT (newid()),
				[TransactionIdOrigin] [uniqueidentifier] NULL ,			
				[Mission] [varchar] (30) NULL,
				[Warehouse] [varchar] (20) NULL,
				[TransactionLot] [varchar] (20) NULL DEFAULT 0 ,
				[TransactionReference] [varchar] (20) NULL,
				[Location] [varchar] (20) NULL,	
				[Category] [varchar] (20) NULL,
				[ItemNo] [varchar] (20) NULL,
				[ItemNoExternal] [varchar] (200) NULL,
				[ItemDescription] [varchar] (200) NULL,
				[ItemPrecision] [integer] NULL,
				[StockControlMode] [varchar] (20) NULL,
				[ReceiptId] uniqueidentifier NULL ,
				[ValuationCode] [varchar] (20) NULL,
				[UnitOfMeasure] [varchar] (10) NULL,
				[ItemBarcode] [varchar] (20) NULL,
				[UoMDescription] [varchar] (50) NULL,	
				[StandardCost] [float] NULL,
				[TransactionDate] [datetime] NULL,
				[Quantity] [float] NULL,
				[Amount] [float] NULL,
				[Detail] [varchar] (1) NULL,
				[TransferMemo] [varchar] (100) NULL,
				[TransferWarehouse] [varchar] (20) NULL,
				[TransferLocation] [varchar] (20) NULL,
				[MeterName] [varchar] (30) NULL,
				[MeterInitial] [float] NULL,
				[MeterFinal] [float] NULL,
				[TransferQuantity] [float] NULL, 
				[TransferItemNo] [varchar] (20) NULL,
				[TransferUoM] [varchar] (10) NULL )
		
		</cfquery>		
		
		<cfquery name="CreateTableIndexes"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

			ALTER TABLE [dbo].[Transfer#URL.Warehouse#_#SESSION.acc#] ADD CONSTRAINT [PK_Transfer#URL.Warehouse#_#SESSION.acc#] PRIMARY KEY CLUSTERED 
			( TransactionId ASC ) ON [PRIMARY];

			CREATE NONCLUSTERED INDEX [_dta_Location_Detail] ON [dbo].[Transfer#URL.Warehouse#_#SESSION.acc#]
			( [Location] ASC, [Detail] ASC ) ON [PRIMARY];

			CREATE NONCLUSTERED INDEX [_dta_search] ON [dbo].[Transfer#URL.Warehouse#_#SESSION.acc#]
			(
				[TransactionReference] ASC,
				[ItemNo] ASC,
				[ItemBarcode] ASC,
				[TransactionLot] ASC,
				[ItemDescription] ASC
			) ON [PRIMARY];

		</cfquery>				

</cfif>		

<cfquery name="getContent"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT * 
		FROM  Transfer#URL.Warehouse#_#SESSION.acc#  
</cfquery>

<cfoutput>

	<cfsavecontent variable="getSourceStock">
	
		    SELECT    newid() as NewTransactionId,
					  NULL as TransactionIdOrigin,
	          		  T.Mission, 
			          T.Warehouse, 
					  T.TransactionLot,
					  I.Category,
					  I.ItemNo, 
					  I.ItemNoExternal,
					  I.ItemDescription, 
					  I.ItemPrecision,
					  T.TransactionUoM, 
					  U.ItemBarCode,
					  U.UoMDescription,
					  U.StandardCost, 
					  I.ValuationCode,			 
					  T.Location,		
					  C.StockControlMode,	 
					  SUM(T.TransactionQuantity) as Quantity, 
					  SUM(T.TransactionValue)    as Amount,			 
					  '0' as Detail
					  
			FROM      ItemTransaction T 
					  INNER JOIN Item I               ON T.ItemNo = I.ItemNo 
					  INNER JOIN ItemUoM U            ON T.ItemNo = U.ItemNo and T.TransactionUoM = U.UoM
					  INNER JOIN WarehouseLocation WL ON WL.Warehouse = T.Warehouse and WL.Location = T.Location
					  INNER JOIN Ref_Category C       ON I.Category = C.Category 
		    
			WHERE     T.Mission      = '#URL.Mission#' 	
			AND       T.Warehouse    = '#URL.Warehouse#'
			<!--- free stock only --->
			AND       T.workorderid is NULL
			AND       WL.Operational = 1
			AND       T.ActionStatus !='9'
			
			<!--- exclude in case the mode is not stock for individual items --->
			AND       C.StockControlMode = 'Stock'
															
			<cfif url.loc neq "" and url.stockorderid eq "">
				
			AND      T.Location = '#selloc#' 
			
			<cfelseif url.stockorderid neq "">
			
			<!--- tank truck --->
			
			AND      T.Location <> (SELECT Location FROM TaskOrder WHERE StockOrderId = '#url.stockorderid#')
			
			<!--- we only show here items as defined in the request to be transferred --->
			AND      T.ItemNo IN (
			                     SELECT    R.ItemNo
								 FROM      RequestTask TA INNER JOIN Request R ON TA.RequestId = R.RequestId
								 WHERE     TA.StockOrderId = '#url.stockorderid#'
								 AND       R.UoM           = T.TransactionUoM
								 )
					
			</cfif>
				
			<!--- added condition for receipt --->	
			AND      I.ItemClass = 'Supply'			
			
			GROUP BY  T.Mission, 
			          T.Warehouse, 
					  T.TransactionLot,
					  T.Location,
					   
					  I.Category,
					  I.ItemNo, 
					  U.ItemBarCode,
					  I.ItemDescription,
					  I.ItemNoExternal,
					  T.TransactionUoMMultiplier, 
					  C.StockControlMode,
					  
					  U.UoMDescription, 
					  
					  T.TransactionUoM, 
					  U.StandardCost, 
					  I.ItemPrecision, 
					  I.ValuationCode
						  
			HAVING SUM(T.TransactionQuantity) <> 0				
										
		</cfsavecontent>
		
		<cfsavecontent variable="getSourceIndividual">
		
		<!--- stock individual --->
		
		SELECT        newid() as NewTransactionId,
		              T.TransactionId as TransactionIdOrigin,
	          		  T.Mission, 
			          T.Warehouse, 
					  T.TransactionLot,
					  T.TransactionReference,
					  I.Category,
					  I.ItemNo, 
					  I.ItemNoExternal,
					  I.ItemDescription, 
					  I.ItemPrecision,
					  T.TransactionUoM, 
					  U.ItemBarCode,
					  U.UoMDescription,
					  U.StandardCost, 
					  I.ValuationCode,			 
					  T.Location,	
					  C.StockControlMode,	
					  (T.TransactionQuantity + (SELECT   ISNULL(SUM(TransactionQuantity), 0)
					                            FROM     ItemTransaction
	                			                WHERE    TransactionIdOrigin = T.TransactionId and ActionStatus !='9')) AS Quantity, 		
																						 
					  T.TransactionValue as Amount,			 
					  '0' as Detail
					  
			FROM      ItemTransaction T 
					  INNER JOIN Item I               ON T.ItemNo     = I.ItemNo 
					  INNER JOIN ItemUoM U            ON T.ItemNo     = U.ItemNo and T.TransactionUoM = U.UoM
					  INNER JOIN WarehouseLocation WL ON WL.Warehouse = T.Warehouse and WL.Location = T.Location
					  INNER JOIN Ref_Category C       ON I.Category   = C.Category 
		    
			WHERE     T.Mission       = '#URL.Mission#' 	
			AND       T.Warehouse     = '#URL.Warehouse#'
			AND       WL.Operational  = 1
			AND       T.ActionStatus != '9'
			
			<!--- exclude in case the mode is not stock for individual items --->
			AND       C.StockControlMode = 'Individual'			
									
			<cfif url.loc neq "" and url.stockorderid eq "">
				
			AND      T.Location = '#selloc#' 
			
			<cfelseif url.stockorderid neq "">
			
			<!--- tank truck --->
			
			AND      T.Location <> (SELECT Location FROM TaskOrder WHERE StockOrderId = '#url.stockorderid#')
			
			<!--- we only show here items as defined in the request to be transferred --->
			AND      T.ItemNo IN (
			                     SELECT    R.ItemNo
								 FROM      RequestTask TA INNER JOIN Request R ON TA.RequestId = R.RequestId
								 WHERE     TA.StockOrderId = '#url.stockorderid#'
								 AND       R.UoM = T.TransactionUoM
								 )
					
			</cfif>
				
			<!--- added condition for receipt --->	
			AND      I.ItemClass = 'Supply'	
								
			<!--- free stock does not have to apply here 
			AND      T.workorderid is NULL
			--->
								
			AND      T.TransactionIdOrigin is NULL		
									  
			AND     (T.TransactionQuantity + (SELECT   ISNULL(SUM(TransactionQuantity), 0)
					                           FROM     ItemTransaction
	                		                   WHERE    TransactionIdOrigin = T.TransactionId and ActionStatus !='9'))  > 0.02
											   											   			
			<cfif url.mission eq "Hicosa">
			
			<!--- --------------------------- Special ------------------------------------- --->
			<!--- --- added provision for Hicosa where they used for a while an old mode -- --->
			<!--- ------------------------------------------------------------------------- --->
			 
			 AND T.TransactionReference NOT IN ( 
			 
                              SELECT    ST.TransactionReference
                               FROM     ItemTransaction AS ST INNER JOIN
                                        Ref_Category AS SR ON ST.ItemCategory = SR.Category
                               WHERE    SR.StockControlMode = 'Individual' 
							   AND      ST.Mission          = '#url.Mission#'
                               GROUP BY ST.TransactionReference
                               HAVING   ABS(SUM(ST.TransactionQuantity)) < 0.02
							   )							  
					
							   
			</cfif>				   
							   
			<!--- ------------------------------------------------------------------------ --->													   										
				
	</cfsavecontent>
	
</cfoutput>

<cfif getContent.recordcount eq "0">
	
		<!--- main records --->
		
		<cfquery name="SearchResult"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#	(
		         TransactionId,				
				 Mission,
				 Warehouse,
				 TransactionLot,
				 Category,
				 ItemNo,
				 ItemNoExternal,
				 ItemDescription,
				 ItemPrecision,
				 UnitOfMeasure,
				 ItemBarcode,
				 StockControlMode,
				 UoMDescription,
				 StandardCost,
				 ValuationCode,			 
				 Location,				 
				 Quantity,
				 Amount,
				 Detail)
				 
			SELECT   S.newTransactionId,		         
		          S.Mission,
		          S.Warehouse, 
				  S.TransactionLot,
				  S.Category,
				  S.ItemNo, 
				  S.ItemNoExternal,
				  S.ItemDescription, 
				  S.ItemPrecision,
				  S.TransactionUoM, 
				  S.ItemBarCode,
				  S.StockControlMode,
				  S.UoMDescription,
				  S.StandardCost, 
				  S.ValuationCode, 
				  S.Location,
				  S.Quantity, 
				  S.Amount,
				  S.Detail		 
				 
			FROM    ( #preservesinglequotes(getSourceStock)# ) S
		  
		</cfquery>
		
				
		<cfquery name="SearchResult"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#	(
		         TransactionId,
				 TransactionidOrigin,
				 Mission,
				 Warehouse,
				 TransactionLot,
				 TransactionReference,
				 Category,
				 ItemNo,
				 ItemNoExternal,
				 ItemDescription,
				 ItemPrecision,
				 UnitOfMeasure,
				 ItemBarcode,
				 StockControlMode,
				 UoMDescription,
				 StandardCost,
				 ValuationCode,			 
				 Location,					
				 Quantity,
				 Amount,
				 Detail)
				 
				 SELECT   S.newTransactionId,
		          S.TransactionIdOrigin,
		          S.Mission,
		          S.Warehouse, 
				  S.TransactionLot,
				  S.TransactionReference,
				  S.Category,
				  S.ItemNo, 
				  S.ItemNoExternal,
				  S.ItemDescription, 
				  S.ItemPrecision,
				  S.TransactionUoM, 
				  S.ItemBarCode,
				  S.StockControlMode,
				  S.UoMDescription,
				  S.StandardCost, 
				  S.ValuationCode, 
				  S.Location,
				  S.Quantity, 
				  S.Amount,
				  S.Detail		 
				 
			FROM  ( #preservesinglequotes(getSourceIndividual)# ) S
					  
		</cfquery>		
			
	<!--- grouping records --->
	
	<cfswitch expression = "#URL.Group#">
		
     <cfcase value = "Location">
	 
	   <cf_assignid>
	   
		<cfquery name="Grouping"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#
			         (Location,Detail)
					 
			SELECT   DISTINCT T.Location,'1'
			FROM     ItemTransaction T INNER JOIN Item I ON T.ItemNo = I.ItemNo
		    WHERE    T.Mission     = '#URL.Mission#' 
			AND      T.Warehouse   = '#URL.Warehouse#'
			
			<cfif URL.Loc neq "" and url.stockorderid eq "">
			AND      T.Location = '#URL.Loc#'
			<cfelseif url.stockorderid neq "">
			AND      T.Location <> (SELECT Location FROM TaskOrder WHERE StockOrderId = '#url.stockorderid#')
			</cfif>
			
		</cfquery>			
			
	 </cfcase>	
					
	</cfswitch>	
	
<cfelse>
		
	<!--- update the list with the current values of the free stock --->
		
	<cfquery name="updateStock"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 UPDATE userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#
		 
		 SET    Quantity         = S.Quantity, 
		        Amount           = S.Amount
				
		 FROM   userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc# T,
		        ( #preservesinglequotes(getSourceStock)# ) as S
				
		 WHERE  T.Warehouse        = S.Warehouse
		 AND    T.Location         = S.Location
		 AND    T.ItemNo           = S.ItemNo
		 AND    T.UnitOfMeasure    = S.TransactionUoM
		 AND    T.TransactionLot   = S.TransactionLot
				 
		 AND    S.StockControlMode = 'Stock'	
		 	 
	</cfquery>		
	
	<!---
	<cfoutput>1. #cfquery.executiontime#</cfoutput>
	--->
	
	<cfquery name="updateIndividual"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 UPDATE userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#
		 SET    Quantity         = S.Quantity, 
		        Amount           = S.Amount
				
		 FROM   userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc# T,
		        ( #preservesinglequotes(getSourceIndividual)# ) as S
				
		 WHERE  T.TransactionIdOrigin = S.TransactionIdOrigin
		 		 		 
		 AND    S.StockControlMode = 'Individual'			
	</cfquery>		
	
	<!---
	<cfoutput>2. #cfquery.executiontime#</cfoutput>
	--->
	
	<!--- clean overcomplete --->
	
	<cfquery name="removeStock"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 DELETE userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#
		 WHERE  TransactionId NOT IN (SELECT T.TransactionId
		 							  FROM  userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc# T 
									  INNER JOIN ( #preservesinglequotes(getSourceStock)# ) as S 
									  ON    T.Warehouse      = S.Warehouse		
									     AND   T.Location       = S.Location
									     AND   T.ItemNo         = S.ItemNo
									     AND   T.UnitOfMeasure  = S.TransactionUoM
									     AND   T.TransactionLot = S.TransactionLot
									 	)
		 AND   StockControlMode = 'Stock'								
	</cfquery>	

	<!---	
	<cfoutput>3. #cfquery.executiontime#</cfoutput>	
	--->
	
	<!--- clean overcomplete --->
	
	<cfquery name="removeIndividual"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 DELETE userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#
		 WHERE  TransactionId NOT IN (SELECT T.TransactionId
		 							  FROM   userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc# T,
									         ( #preservesinglequotes(getSourceIndividual)# ) as S
									  WHERE  T.TransactionIdOrigin  = S.TransactionIdOrigin  )
		 AND    StockControlMode = 'Individual'								  
	</cfquery>	
	
	<!---
	<cfoutput>4. #cfquery.executiontime#</cfoutput>	
	--->
	
	<cfquery name="addbaseStock"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		

		 INSERT INTO userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#	
		 
		 		(TransactionId,				 
				 Mission,
				 Warehouse,
				 TransactionLot,
				 Category,
				 ItemNo,
				 ItemDescription,
				 ItemPrecision,
				 UnitOfMeasure,
				 ItemBarcode,
				 StockControlMode,
				 UoMDescription,
				 StandardCost,
				 ValuationCode,			 
				 Location,			
				 Quantity,
				 Amount,
				 Detail)
		
		 SELECT   S.newTransactionId,		         
		          S.Mission,
		          S.Warehouse, 
				  S.TransactionLot,
				  S.Category,
				  S.ItemNo, 
				  S.ItemDescription, 
				  S.ItemPrecision,
				  S.TransactionUoM, 
				  S.ItemBarCode,
				  S.StockControlMode,
				  S.UoMDescription,
				  S.StandardCost, 
				  S.ValuationCode, 
				  S.Location,
				  S.Quantity, 
				  S.Amount,
				  S.Detail	
				  
		 FROM  ( #preservesinglequotes(getSourceIndividual)# ) S
		 
		 WHERE    1=1 
		 AND      NOT EXISTS (SELECT 'X'
		                      FROM   userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc# T
							  WHERE   T.Warehouse      = S.Warehouse
							  AND     T.Location       = S.Location
							  AND     T.ItemNo         = S.ItemNo
							  AND     T.UnitOfMeasure  = S.TransactionUoM	
							  AND     T.TransactionLot = S.TransactionLot )		  				  
			  				 					 
	</cfquery>	
	
	<!---
	<cfoutput>5. #cfquery.executiontime#</cfoutput>	
	--->
		
	<cfquery name="addbaseIndividual"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		

		 INSERT INTO userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#	(
				 TransactionId,
				 TransactionIdOrigin,
				 Mission,
				 Warehouse,
				 TransactionLot,
				 TransactionReference,
				 Category,
				 ItemNo,
				 ItemDescription,
				 ItemPrecision,
				 UnitOfMeasure,
				 ItemBarcode,
				 StockControlMode,
				 UoMDescription,
				 StandardCost,
				 ValuationCode,			 
				 Location,			
				 Quantity,
				 Amount,
				 Detail)
		
		 SELECT   S.newTransactionId,
		          S.TransactionIdOrigin,
		          S.Mission,
		          S.Warehouse, 
				  S.TransactionLot,
				  S.TransactionReference,
				  S.Category,
				  S.ItemNo, 
				  S.ItemDescription, 
				  S.ItemPrecision,
				  S.TransactionUoM, 
				  S.ItemBarCode,
				  S.StockControlMode,
				  S.UoMDescription,
				  S.StandardCost, 
				  S.ValuationCode, 
				  S.Location,
				  S.Quantity, 
				  S.Amount,
				  S.Detail	
				  
		 FROM  ( #preservesinglequotes(getSourceIndividual)# ) S
		 
		 WHERE    NOT EXISTS (SELECT 'X'
		                      FROM   userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc# 
							  WHERE  TransactionIdOrigin  = S.TransactionidOrigin)		  				  
			  				 					 
	</cfquery>		
	
	<!---
	<cfoutput>6. #cfquery.executiontime#</cfoutput>
	--->
		
	<!--- grouping records --->
	
	<cfswitch expression = "#URL.Group#">
		
     <cfcase value = "Location">	 
	 	   
		<cfquery name="Grouping"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc#
			          (Location,Detail)
			SELECT   DISTINCT T.Location,'1'
			FROM     ItemTransaction T INNER JOIN
             		 Item I ON T.ItemNo = I.ItemNo
		    WHERE    T.Mission   = '#URL.Mission#' 
			AND      T.Warehouse = '#URL.Warehouse#'
			
			AND      T.Location NOT IN (SELECT Location 
			                            FROM   userTransaction.dbo.Transfer#URL.Warehouse#_#SESSION.acc# 
									    WHERE  Detail = '1')			
										
			<cfif URL.Loc neq "" and url.stockorderid eq "">
			AND      T.Location = '#URL.Loc#'
			<cfelseif url.stockorderid neq "">
			AND      T.Location NOT IN  (SELECT Location 
			                             FROM   TaskOrder 
						   		         WHERE  StockOrderId = '#url.stockorderid#')
			</cfif>
			
		 </cfquery>			
		 			
	 </cfcase>	
					
	</cfswitch>	
		
</cfif>			

