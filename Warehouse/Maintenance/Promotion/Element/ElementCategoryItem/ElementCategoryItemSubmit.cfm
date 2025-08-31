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
<cf_screentop html="no">

<cfquery name="CatItemS" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  C.*,
				(SELECT Description FROM Ref_Category WHERE Category = C.Category) as CategoryDescription,
				(SELECT CategoryItem FROM PromotionElementItem WHERE ElementSerialno = '#url.serial#' AND PromotionId = '#url.PromotionId#' AND Category = C.Category AND CategoryItem = C.CategoryItem) as Selected
        FROM    Ref_CategoryItem C
		WHERE	C.Category = '#form.category#'
</cfquery>

<cftransaction>

	<cfquery name="clear" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			DELETE
			FROM 	PromotionElementItem
			WHERE 	ElementSerialNo = '#url.serial#'
			AND		PromotionId = '#url.promotionid#'
			AND		Category = '#form.category#'
	</cfquery>

	<cfloop query="CatItemS">
	
		<cfset vCategoryItem = replace(categoryItem, ' ', '_', 'ALL')>
		
		<cfif isDefined('Form.ci_#vCategoryItem#')>
			
			<cfquery name="Insert" 
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					INSERT INTO PromotionElementItem (
							ElementSerialNo,
							PromotionId,
							Category,
							CategoryItem,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES ('#url.serial#',
							'#url.promotionId#',
							'#form.category#',
							'#CategoryItem#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#' )
			</cfquery>
		
		</cfif>

	</cfloop>

</cftransaction>

<cf_ModuleControlLog 
         systemfunctionid="#url.idmenu#" 
		 action="Insert" 
		 content="#form#">
								 
<cfoutput>
	<script>
		ColdFusion.navigate('ElementCategoryItem/ElementCategoryItemEdit.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#url.serial#&category=&categoryItem=&pcategory=#form.category#','divElementCategoryItemListing');
	</script>
</cfoutput>	
