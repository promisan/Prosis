<!--- filter category based on the supply warehouse defined for the selected fuel item
	so it will hide AIR if no items with jet fuel are found --->	
	
	<cfparam name="url.selected" default="">
				
	<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Warehouse
			WHERE  Warehouse = '#url.warehouse#'
	</cfquery>		  
		 
	<cfquery name="CategoryList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Category
		WHERE  Category IN (SELECT DISTINCT Category
		                    FROM   Item 
							WHERE  ItemNo IN (SELECT DISTINCT ItemNo 
		                                      FROM   AssetItem I
											  WHERE  Mission = '#get.mission#'
											  AND    Operational = 1
											  AND    I.AssetId IN (SELECT DISTINCT AssetId 
											                       FROM   AssetItemSupply P
																   WHERE  SupplyItemNo  = '#url.ItemNo#'
																   AND    SupplyItemUoM = '#url.UoM#'
																   AND    I.Assetid     = P.Assetid)
											)
							)	
	</cfquery>
	
	<cfif CategoryList.recordcount eq "0">
	
		<font face="Calibri" size="2" color="FF0000"><cf_tl id="No assets consume this item" class="message"></font>
		
		<script language="JavaScript">
		 try { document.getElementById('addbutton').className = 'hide' } catch(e) {}
		</script>
	
	<cfelse>
	 
		<select name="categoryselect" class="enterastab regularxl" id="categoryselect">
		 <cfoutput query="CategoryList">
		     <option value="#Category#" <cfif category eq url.selected>selected</cfif>>#Description#</option>
		 </cfoutput>
		</select>	
		
		<script language="JavaScript">
		  try {  document.getElementById('addbutton').className = 'regular' } catch(e) {}
		</script>
	
	</cfif>	