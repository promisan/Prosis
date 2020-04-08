<cfquery name="CatItemS" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  C.*,
				(SELECT Description FROM Ref_Category WHERE Category = C.Category) as CategoryDescription,
				(SELECT CategoryItem FROM PromotionElementItem WHERE ElementSerialNo = '#url.serial#' AND PromotionId = '#url.PromotionId#' AND Category = C.Category AND CategoryItem = C.CategoryItem) as Selected
        FROM    Ref_CategoryItem C
		WHERE	C.Category = '#url.pcategory#'
		ORDER BY C.Category, C.CategoryItemName
</cfquery>

<!-- <cfform name="frmCategoryItem" method="POST" action="CategoryItemSubmit.cfm?idmenu=#url.idmenu#&serial=#url.serial#&promotionid=#url.promotionid#&category=#url.category#&categoryitem=#categoryitem#"> -->

<table width="100%" align="center" cellspacing="0" class="formpadding">
	<cfset cols = 3>
	<cfset cnt = 0>
	<tr>
		<cfoutput query="CatItemS">
			<cfset cnt = cnt + 1>
			<cfset vCategoryItem = replace(categoryItem, ' ', '_', 'ALL')>
			<td onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="" width="#100/cols#%" 
			  style="border:1px dotted ##C0C0C0;" id="td1_#vCategoryItem#" <cfif selected neq "">style="background-color:'FFFFCF';"</cfif>>
				<table width="100%">
					<tr>
						<td class="labelit">
							<label>
							<input type="Checkbox" 
								name="ci_#vCategoryItem#" 
								id="ci_#vCategoryItem#" 
								<cfif selected neq "">checked</cfif> 
								onclick="javascript: saveCI(this,'#vCategoryItem#','#url.promotionId#','#url.serial#','#Category#','#CategoryItem#');">
							&nbsp;#CategoryItemName#
							</label>
						</td>
					</tr>
				</table>
			</td>
			<cfif cnt eq cols>
				</tr>
				<tr>
				<cfset cnt = 0>
			</cfif>
		</cfoutput>
	</tr>
</table>

<!-- </cfform> -->
