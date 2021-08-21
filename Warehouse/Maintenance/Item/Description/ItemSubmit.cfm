
<cfquery name="UPDATE" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  Item
	SET     ItemDescription = N'#Form.ItemDescription#'
	WHERE   ItemNo = '#url.itemno#'
</cfquery>						 

<cf_LanguageInput
	TableCode    = "Item" 
	Mode         = "Save"
	DataSource   = "AppsMaterials"
	Key1Value    = "#url.itemno#"
	Name1        = "ItemDescription">	

<!---
<cfoutput>#url.context#-#url.id#</cfoutput>
--->

<cfif url.context eq "purchase">
	
	<cfquery name="UPDATE" 
		datasource="appsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  PurchaseLine
		SET     OrderItem  = N'#Form.ItemDescription#'
		WHERE   RequisitionNo = '#url.id#' 
	</cfquery>
		
</cfif>

<cfoutput>
	#Form.ItemDescription#
</cfoutput>

<script>
	ProsisUI.closeWindow('setitem')		
</script>


