
<!--- only show if category is selected as it is driven by the category --->
<table style="width:100%">
	
	<tr class="labelmedium2"><td style="font-size:15px"><cf_tl id="Subcategory"></td></tr>
	
	<tr><td style="height:10px" id="subcategory">
	
		<cfquery name="SubCat" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	 
			 SELECT      CategoryItem, CategoryItemName
			 FROM        Ref_CategoryItem
			 WHERE       Category = '#url.category#'
			 ORDER BY    CategoryItemOrder
	    
	   </cfquery>

	   <cf_UISelect name   = "filterSubCat"
		     class          = "regularxxl"
		     queryposition  = "below"
		     query          = "#SubCat#"
		     value          = "CategoryItem"
		     onchange       = "search()"		     
		     required       = "No"
		     display        = "CategoryItemName"
		     selected       = ""
			 separator      = "|"
		     multiple       = "yes"/>						
	
	</td></tr> 
	
	<!--- this is driven by the procurement class --->
	
	<tr class="labelmedium2 line"><td style="font-size:15px"><cf_tl id="Other classification"></td></tr>		
	
</table>