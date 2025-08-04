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

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Asset"> 

<cfset condition = replaceNoCase(filter,"|","'","ALL")> 
 			             
<cfquery name="FactTable" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   NEWID() AS FactTableId, 
            <!--- B.AssetClass AS AssetClass_dim, --->
			B.DepreciationScale AS Scale_dim, 
			    (SELECT   TOP 1 ActionCategoryList
				 FROM     Materials.dbo.AssetItemAction I 
	             WHERE    I.AssetId = B.AssetId
				 AND      I.ActionCategory = 'Condition'
				 ORDER BY I.Created DESC
				) as Condition_dim,					
			L.LocationCode AS Location_dim,    
			L.LocationName as Location_nme,			        
			O.OrgUnitCode AS OrgUnit_dim, 
			O.OrgUnitName as OrgUnit_nme,
			O.HierarchyCode AS OrgUnit_ord,
			P.OrgUnitCode AS Branch_dim, 
			P.OrgUnitName as Branch_nme,
			I.Category as Category_dim,
			B.Make AS Make_dim, 
			B.Model as Model_dim,
			I.CategoryItem AS MainItem_dim, 
			I.CategoryItem as MainItem_nme,
			I.ItemNo AS Item_dim, 
			I.ItemDescription as Item_nme,
			B.Description, 			 
			B.DepreciationBase, 
			B.DepreciationCumulative, 			
			B.ReceiptDate
	INTO    userquery.dbo.#SESSION.acc#Asset		
	FROM    #SESSION.acc#AssetBase#url.id# B,
	        Organization.dbo.Organization O,
			Organization.dbo.Organization P,
			Materials.dbo.Location L,
			Materials.dbo.Item I			
	WHERE   B.OrgUnit = O.OrgUnit	
	AND     L.Location = B.Location	
	AND     O.Mission   = P.Mission
	AND     O.MandateNo = P.MandateNo
	AND     O.HierarchyRootUnit = P.OrgUnitCode
	AND     I.ItemNo = B.ItemNo
	#preservesingleQuotes(condition)# 	
</cfquery>
	
<cfset client.table1_ds = "#SESSION.acc#Asset">
