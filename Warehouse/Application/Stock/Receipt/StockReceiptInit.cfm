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
		SELECT * FROM Receipt#URL.Warehouse#_#SESSION.acc#
	</cfquery>
	

	<cfcatch>
	
	<cf_DropTable dbName="AppsTransaction"  tblName="Receipt#URL.Warehouse#_#SESSION.acc#"> 
		
	<cfquery name="Create"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		CREATE TABLE dbo.Receipt#URL.Warehouse#_#SESSION.acc# (
			[TransactionId] [int] IDENTITY (1, 1) NOT NULL,
			[Mission] [varchar] (30) NULL,
			[Warehouse] [varchar] (20) NULL,
			[TransactionLot] [varchar] (10) NULL DEFAULT 0 ,			
			[Location] [varchar] (20) NULL,
			[LocationDescription] [varchar] (100) NULL,
			[Category] [varchar] (20) NULL,
			[CategoryDescription] [varchar] (100) NULL,
			[ItemNo] [varchar] (20) NULL,
			[ItemDescription] [varchar] (200) NULL,
			[ItemPrecision] [integer] NULL,
			[ReceiptId] uniqueidentifier NULL ,
			[ReceiptNo] [varchar] (20) NULL,
			[ReceiptDeliveryDateEnd] [datetime] NULL ,
			[ValuationCode] [varchar] (20) NULL,
			[UoM] [varchar] (10) NULL,
			[UoMDescription] [varchar] (50) NULL,	
			[ItemBarcode] [varchar] (20) NULL,
			[StandardCost] [float] NULL,
			[Quantity] [float] NULL,
			[Amount] [float] NULL,
			[Selected] [varchar] (1) NULL,			
			[TransferWarehouse] [varchar] (20) NULL,
			[TransferLocation] [varchar] (20) NULL,			
			[TransferQuantity] [float] NULL, 
			[TransferItemNo] [varchar] (20) NULL,
			[TransferUoM] [varchar] (10) NULL ,
			[TransferMemo] [varchar] (40) NULL )
	
	</cfquery>
	
	</cfcatch>
	
</cftry>	