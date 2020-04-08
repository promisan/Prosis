
<cfparam name="url.pcategory" default="">

<cfquery name="getPromo" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  *
        FROM    Promotion
		WHERE	PromotionId = '#url.promotionId#'
</cfquery>

<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  *,
				(SELECT Description FROM Ref_Category WHERE Category = C.Category) as CategoryDescription,
				(SELECT CategoryItemName FROM Ref_CategoryItem WHERE Category = C.Category AND CategoryItem = C.CategoryItem) as CategoryItemName
        FROM    PromotionElementItem C
		WHERE	PromotionId = '#url.promotionId#'
		AND		ElementSerialNo = '#url.serial#'
		AND		Category = '#url.category#'
		AND		CategoryItem = '#url.categoryItem#'
</cfquery>
			  
<cfquery name="CatItem" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
        FROM    Ref_Category C
		WHERE	C.Category IN (SELECT DISTINCT Category FROM Item WHERE ItemNo IN (SELECT ItemNo FROM ItemUoMMission WHERE Mission = '#getPromo.mission#'))
		ORDER BY C.Category
</cfquery>

<cfajaximport tags="cfform">
			  
<cfform name="frmElementCategoryItem" 
	method="POST" 
	action="ElementCategoryItem/ElementCategoryItemSubmit.cfm?idmenu=#url.idmenu#&serial=#url.serial#&promotionid=#url.promotionid#&category=#url.category#&categoryitem=#categoryitem#">
			
<table width="100%" align="center">
	<cfoutput>
	<tr><td height="8"></td></tr>
	<tr>
		<td class="labelit" style="min-width:120px" height="23"><cf_tl id="Category">:</td>
		<td>
			<cfset vCat = get.Category>
			<cfif url.pcategory neq "">
				<cfset vCat = url.pcategory>
			</cfif>
			<cfselect 
					name="category" 
					query="CatItem" 
					value="Category" 
					display="Description" 
					selected="#vCat#" 
					required="yes" 
					class="regularxl"
					message="Please, select a valid category" 
					onchange="document.getElementById('processCategoryItemSelect').innerText = '';">
			</cfselect>
		</td>
	</tr>
	<tr><td height="8"></td></tr>
	<tr>
		<td colspan="2">
			<cfdiv 
				id="divCatItem" 
				bind="url:ElementCategoryItem/ElementCategoryItemSelect.cfm?idmenu=#url.idmenu#&serial=#url.serial#&promotionid=#url.promotionid#&category=#url.category#&categoryitem=#categoryitem#&pcategory={category}">
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td colspan="2" align="center" id="processCategoryItemSelect"></td></tr>
	<!--- <tr><td height="5"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2" align="center"><input type="Submit" name="save" id="save" class="button10g" value="  Save  "></td>
	</tr> --->
	</cfoutput>
</table>

</cfform>