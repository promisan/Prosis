
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
					INSERT INTO PromotionElementItem
						(
							ElementSerialNo,
							PromotionId,
							Category,
							CategoryItem,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#url.serial#',
							'#url.promotionId#',
							'#form.category#',
							'#CategoryItem#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
		
		</cfif>

	</cfloop>

</cftransaction>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
			                     action="Insert" 
								 content="#form#">
								 

<cfoutput>
	<script>
		ColdFusion.navigate('ElementCategoryItem/ElementCategoryItemEdit.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#url.serial#&category=&categoryItem=&pcategory=#form.category#','divElementCategoryItemListing');
	</script>
</cfoutput>	
