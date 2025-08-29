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