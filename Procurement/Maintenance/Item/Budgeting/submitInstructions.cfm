<cfset vInstruction = trim(evaluate("Form.BudgetEntryInstruction_#url.code#"))>

<cfquery name="update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	ItemMasterObject
		SET		BudgetEntryInstruction = '#vInstruction#'
		WHERE 	ItemMaster = '#url.itemmaster#'
		AND		ObjectCode = '#url.code#'	
</cfquery>

<cf_tl id="Saved!">