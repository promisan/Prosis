
<!---
<cfoutput>#url.class#</cfoutput>
--->

<cfparam name="url.find"   default="">
<cfparam name="url.prefix" default="">
<cfparam name="url.class"  default="Supply">

<cfquery name="Item" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     IM.Description AS ItemMaster, 
		           C.Description, 
				   R.CategoryItemName,
				   I.ItemNo, 
				   I.ItemDescription, 
				   I.Classification, 
				   I.Classification+' '+I.ItemDescription as ItemName, IM.Code
		FROM       Item I INNER JOIN 
		           Purchase.dbo.ItemMaster IM ON I.ItemMaster = IM.Code INNER JOIN 
				   Ref_Category C ON I.Category = C.Category INNER JOIN 
				   Ref_CategoryItem R ON I.Category = R.Category AND I.CategoryItem = R.CategoryItem
				
		<cfif url.class eq "Supply">
				
		WHERE      I.ItemClass IN ('Supply','Service')
		<!--- exclude final product items as it would not make sense these would be BOM items which has been disabled 26/2/2016 
		AND        I.Category IN (SELECT Category FROM Ref_Category WHERE FinishedProduct = '0')		
		--->
		<cfelse>	
		<!--- obtain items that have a bom to be inherited --->	
		WHERE      I.ItemClass IN ('Service','Supply')
		AND        I.ItemNo IN (SELECT ItemNo FROM ItemBOM WHERE ItemNo = I.ItemNo and Mission = '#url.mission#')
		AND        I.ItemNo != '#url.itemno#'
		</cfif>
				
		<!--- enabled for the mission --->		
		AND        ItemNo IN (SELECT ItemNo FROM ItemUoMMission WHERE ItemNo = I.ItemNo and Mission = '#url.mission#')
		
		AND        (
		            I.Classification LIKE '%#url.find#%' OR 
		            I.ItemDescription LIKE '%#url.find#%' OR 
					I.ItemNo IN (SELECT ItemNo FROM ItemUoM WHERE ItemNo = I.ItemNo AND ItemBarCode LIKE '%#url.find#%')		 
				   )				 
		ORDER BY   C.Description, R.CategoryItemOrder, R.CategoryItemName, I.ItemMaster, I.ItemNo, I.ItemDescription
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
	<cfif Item.recordcount eq "0">
		<tr><td class="labelmedium" align="center" height="70"><font color="gray"><cf_tl id="No items found"></font></td></tr>	
	</cfif>
	
	<cfoutput query="Item" group="Description">
		<tr><td class="labellarge"><b>#Description#</td></tr>		
		<cfoutput group="CategoryItemName"> <tr><td style="padding-left:5px" class="labelmedium"><b>#CategoryItemName#</td></tr>
		<cfoutput>
		<tr class="navigation_row"><td width="100%" style="padding-left:10px" class="navigation_action labelit" onclick="selectresourceitem('#itemno#','#URL.prefix#','')">#ItemName#</td></tr>
		</cfoutput>		
		</cfoutput> 
	</cfoutput>									
	
</table>

<cfset AjaxOnLoad("doHighlight")>	