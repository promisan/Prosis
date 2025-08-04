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
	SELECT TOP 1 TransactionId, WorkOrderId 
	FROM   StockInventory#URL.Warehouse#_#SESSION.acc#
	</cfquery>
			
	<cfcatch>
		
		<CF_DropTable dbName="AppsTransaction" 
		              tblName="StockInventory#URL.Warehouse#_#SESSION.acc#"> 
		
		<cfquery name="CreateTable"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			CREATE TABLE dbo.StockInventory#URL.Warehouse#_#SESSION.acc# (
				[TransactionId]        [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_StockInventory#URL.Warehouse#_#SESSION.acc#] DEFAULT (newid()),
				[TransactionIdOrigin]  [uniqueidentifier] NULL ,			
				[Warehouse]            [varchar] (20) NULL ,
				[TransactionLot]       [varchar] (20) NULL DEFAULT 0 ,
				[TransactionReference] [varchar] (20) NULL ,
				[Location]             [varchar] (20) NULL ,
				[ItemNo]               [varchar] (20) NULL ,
				[ItemNoExternal]       [varchar] (20) NULL ,
				[ReservationClass]     [varchar] (20) NULL  ,
				[WorkOrderid]          [uniqueidentifier] NULL ,	<!--- earmarking of stock by a order --->
				[WorkOrderLine]        [int] NULL ,	
				[RequirementId]        [uniqueidentifier] NULL ,	
				[ParentItemNo]         [varchar] (20) NULL ,
				[ItemDescription]      [varchar] (200) NULL ,
				[ItemPrecision]        [int] NULL ,
				[Category]             [varchar] (20) NULL ,
				[CategoryItem]         [varchar] (50) NULL ,
				[CategoryItemName]     [varchar] (80) NULL ,
				[StandardCost]         [float] NULL ,
				[Classification]       [varchar] (100) NULL ,
				[EntityClass]          [varchar] (30) NULL ,
				[UoM]                  [varchar] (20) ,
				[ItemBarCode]          [varchar] (20) ,
				[UoMDescription]       [varchar] (80) NULL ,
				[ItemLocationId]       [uniqueidentifier] NULL,
				[LocationLinked]       [int] NULL ,
				[Strapping]            [int] NULL ,
				[OnHand]               [float] NULL ,
				[Counted]              [float] NULL ,
				[Metric]               [float] NULL ,
				[ActualStock]          [float] NULL ,
				[Status]               [varchar] (2) NULL)
				
		</cfquery>
		
		<cfquery name="Index" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			CREATE UNIQUE INDEX [TransactionInd] ON dbo.StockInventory#URL.Warehouse#_#SESSION.acc#([TransactionId]) 
			 ON [PRIMARY]
		</cfquery>	
		
		<cfquery name="Index" 
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			CREATE CLUSTERED INDEX [WarehouseInd] ON dbo.StockInventory#URL.Warehouse#_#SESSION.acc#([Warehouse],[Location],[Status],[ItemNo],[UoM],[TransactionLot])
			 ON [PRIMARY]		  
		</cfquery>				
		
	</cfcatch>

</cftry>

<cfinclude template="InventoryView.cfm">