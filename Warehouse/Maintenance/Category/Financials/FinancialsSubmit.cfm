<cftransaction>

<cfquery name="Clear" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_CategoryGledger
		WHERE  Category = '#url.Category#' 
</cfquery>

<cfquery name="Ledger" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_AreaGledger
	ORDER BY ListingOrder
</cfquery>

<cfloop query="Ledger">

	<cfparam name="Form.#area#GLAccount" default="">

	<cfset gl = evaluate("Form.#area#GLAccount")>
	
	<cfif gl neq "">
	
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_CategoryGledger
			(Category,Area,GLAccount)
			VALUES ('#url.Category#','#area#','#gl#')
		</cfquery>		
	
	</cfif>	
		
</cfloop>

</cftransaction>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
                  action ="Insert" 
				 content="#Form#">

<cfoutput>
	<script>
		ptoken.navigate('Financials/CategoryFinancials.cfm?idmenu=#url.idmenu#&id1=#url.category#','contentbox1');
	</script>
</cfoutput>