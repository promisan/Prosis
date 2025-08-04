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

<!--- create an initial table for final product recordings --->


<cftry>

	<cfquery name="Test"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   FinalProduct_#SESSION.acc#
	</cfquery>
	
	<cfcatch>
	
		<CF_DropTable dbName="AppsTransaction" 
		              tblName="FinalProduct_#SESSION.acc#"> 
		
		<cfquery name="CreateTable"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE TABLE dbo.FinalProduct_#SESSION.acc# (
		[WorkOrderId] [uniqueidentifier] NOT NULL,
		[WorkOrderLine] [int] NOT NULL,
		[Warehouse] [varchar] (20) NULL ,
		[TransactionLot] [varchar] (20) NULL ,
		[Category] [varchar] (20) NULL ,
		[ItemNo]   [varchar] (20) NULL ,
		[UoM]      [varchar] (10) NULL ,
		[WorkorderItemId] [uniqueidentifier] ROWGUIDCOL  NOT NULL CONSTRAINT [DF_FinalProduct_#SESSION.acc#] DEFAULT (newid()),
		[asDefault] [bit],
		<cfloop index="itm" from="1" to="6">
		[Class#itm#]          [varchar] (20) NULL ,
		[Class#itm#ListCode]  [varchar] (30) NULL ,
		[Class#itm#ListValue] [varchar] (50) NULL ,
		</cfloop>		
		[ItemUoMIdFinalProduct] [uniqueidentifier] NULL ,
		[Quantity] [float] NULL ,
		[Memo] [varchar] (200) NULL ,
		[Currency] [varchar] (4) NULL ,
		[Price] [float] NULL, 
		[Created] [datetime] DEFAULT (getdate()))	
		</cfquery>
		
	</cfcatch>

</cftry>
