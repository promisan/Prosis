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
<!--- 1. First check if stCache exists
	  2. If exists then nothing
	  3. if does not then build it
 --->
 
 <cfset vCreate = false>
 
 <cftry>
		<cfquery name="qCheck" 
	 	datasource="AppsTransaction" 
	 	username="#SESSION.login#" 
	 	password="#SESSION.dbpw#">
	 		SELECT TOP 1 * FROM stCache
	 	</cfquery>
	<cfcatch>
		<cfset vCreate = true>
	</cfcatch>	 	 		
 </cftry>
 
 <cfif vCreate>
 	
		<cfquery name="qDrop_stCache" 
	 	datasource="AppsTransaction" 
	 	username="#SESSION.login#" 
	 	password="#SESSION.dbpw#">
	 		IF OBJECT_ID(N'stCacheFilter', N'U') IS NOT NULL 
	 			DROP TABLE stCacheFilter;
	 		
	 		IF OBJECT_ID(N'stCacheStaffingView', N'U') IS NOT NULL
	 			DROP TABLE stCacheStaffingView;
		</cfquery>
 	
		<cfquery name="qCreate_stCache" 
	 	datasource="AppsTransaction" 
	 	username="#SESSION.login#" 
	 	password="#SESSION.dbpw#">
			CREATE TABLE stCache(
				DocumentId uniqueidentifier ROWGUIDCOL  NOT NULL,
				CacheURL varchar(400) NULL,
				Created datetime NOT NULL,
				CONSTRAINT PK_stCache PRIMARY KEY CLUSTERED 
				(DocumentId ASC),
			 	CONSTRAINT IX_stCache UNIQUE NONCLUSTERED 
				(CacheURL ASC)
			);
			
			ALTER TABLE stCache ADD  CONSTRAINT [DF_stCache_DocumentId]  DEFAULT (newid()) FOR DocumentId;
			ALTER TABLE stCache ADD  CONSTRAINT [DF_stCache_Created]  DEFAULT (getdate()) FOR Created;
			
			
			CREATE TABLE stCacheFilter(
				DocumentId uniqueidentifier NOT NULL,
				FilterField varchar(50) NOT NULL,
				FilterValue varchar(300) NOT NULL,
		 	CONSTRAINT PK_stCacheFilter PRIMARY KEY CLUSTERED 
			(	DocumentId ASC,
				FilterField ASC,
				FilterValue ASC
			)
			); 
			
			ALTER TABLE stCacheFilter WITH NOCHECK ADD  CONSTRAINT FK_stCacheFilter_stCache FOREIGN KEY(DocumentId)
			REFERENCES stCache (DocumentId)
			ON UPDATE CASCADE
			ON DELETE CASCADE;

			ALTER TABLE stCacheFilter CHECK CONSTRAINT FK_stCacheFilter_stCache;
			ALTER TABLE stCacheFilter ADD  CONSTRAINT DF_stCacheFilter_DocumentId  DEFAULT (newid()) FOR DocumentId;			
			
			CREATE TABLE stCacheStaffingView(
				DocumentId uniqueidentifier NOT NULL,
				OrgUnit int NOT NULL,
				Mission varchar(30) NULL,
				OrgUnitName varchar(80) NULL,
				OrgUnitClass varchar(20) NULL,
				HierarchyCode varchar(20) NULL,
				OrgUnitCode varchar(20) NULL,
				SelectionDate datetime NULL,
				OrgExpiration datetime NULL,
				Class varchar(10) NOT NULL,
				ListOrder int NULL,
				PostGradeBudget varchar(10) NOT NULL,
				PostOrderBudget int NULL,
				ViewOrder int NOT NULL,
				Code varchar(20) NULL,
				Total int NULL,
				TotalCum int NULL,
				Created datetime NOT NULL,
			 CONSTRAINT PK_stCacheStaffingView PRIMARY KEY CLUSTERED 
			 (  DocumentId ASC,
				OrgUnit ASC,
				Class ASC,
				PostGradeBudget ASC,
				ViewOrder ASC)
			 );
			
			ALTER TABLE stCacheStaffingView  WITH NOCHECK ADD  CONSTRAINT FK_stCacheStaffingView_stCache FOREIGN KEY(DocumentId)
			REFERENCES stCache (DocumentId)
			ON UPDATE CASCADE
			ON DELETE CASCADE;			
			
			ALTER TABLE stCacheStaffingView CHECK CONSTRAINT FK_stCacheStaffingView_stCache;
			ALTER TABLE stCacheStaffingView ADD  CONSTRAINT DF_stCacheStaffingView_Created  DEFAULT (getdate()) FOR Created;
		</cfquery> 	
 </cfif> 	 	
