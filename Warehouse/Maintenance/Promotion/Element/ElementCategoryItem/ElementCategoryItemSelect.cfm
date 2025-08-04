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
