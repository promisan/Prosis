
<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    AssetItem A, Item I
	 WHERE   A.ItemNo  = I.ItemNo
	 AND     A.AssetId = '#url.assetid#'		
</cfquery>


<cfquery name="Consumption" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">   
	SELECT  S.*, 
	        I.ItemDescription AS ItemDescription, 
			U.UoMDescription AS UoMDescription,
			I.Category
    FROM    AssetItemSupply S INNER JOIN
            Item    I ON S.SupplyItemNo = I.ItemNo INNER JOIN
            ItemUoM U ON S.SupplyItemNo = U.ItemNo AND S.SupplyItemUoM = U.UoM	
	WHERE   S.AssetId  = '#url.Assetid#' 
</cfquery>


<cfif Consumption.recordcount eq "0">

	<cfquery name="Consumption" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">   
		SELECT  '#url.Assetid#' as AssetId,
				S.*, 
		        I.ItemDescription AS ItemDescription, 
				U.UoMDescription AS UoMDescription,
				I.Category
	    FROM    ItemSupply S INNER JOIN
	            Item    I ON S.SupplyItemNo = I.ItemNo INNER JOIN
	            ItemUoM U ON S.SupplyItemNo = U.ItemNo AND S.SupplyItemUoM = U.UoM	
		WHERE   S.ItemNo  = '#get.itemNo#' 
	</cfquery>

</cfif>
