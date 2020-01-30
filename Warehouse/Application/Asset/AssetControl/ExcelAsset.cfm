
<cfquery name="Drop"
	datasource="AppsQuery">
     if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwListing#SESSION.acc#]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwListing#SESSION.acc#]
</cfquery>

<cfset table1   = "vwListing#SESSION.acc#">	

<cfset condition = replaceNoCase(filter,"|","'","ALL")> 
 			             
<cfquery name="FactTable" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   CREATE VIEW dbo.vwListing#SESSION.acc# AS
   SELECT   P.OrgUnitCode AS BranchCode, 
		    L.LocationName as LocationName,			        
			O.OrgUnitCode AS OrgUnitCode, 
			O.OrgUnitName as OrgUnitName,		
			P.OrgUnitName as BranchName, 
            (SELECT   TOP 1 ActionCategoryList
				 FROM     Materials.dbo.AssetItemAction I 
	             WHERE    I.AssetId = B.AssetId
				 AND      I.ActionCategory = 'Condition'
				 ORDER BY I.Created DESC
				) as Condition,											
			I.Category as Category,				
			I.CategoryItem as MainItem,			
			I.ItemDescription as Item,
			B.*
	FROM    #SESSION.acc#AssetBase#url.id# B,
	        Organization.dbo.Organization O,
			Organization.dbo.Organization P,
			Materials.dbo.Location L,
			Materials.dbo.Item I			
	WHERE   B.OrgUnit           = O.OrgUnit	
	AND     L.Location          = B.Location	
	AND     O.Mission           = P.Mission
	AND     O.MandateNo         = P.MandateNo
	AND     O.HierarchyRootUnit = P.OrgUnitCode
	AND     I.ItemNo = B.ItemNo
	#preservesingleQuotes(condition)# 	
</cfquery>

<cfset table1   = "vwListing#SESSION.acc#">	

