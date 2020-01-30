<cfquery name="CurrencyList" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT  DISTINCT Currency
	FROM    WarehouseCategoryPriceSchedule
	WHERE   Warehouse= '#url.Warehouse#'
	<cfif url.category neq "">
	AND		Category = '#url.category#'
	</cfif>
	AND		Operational = 1
</cfquery>

<select name="currency" 
	id="currency" class="regularxl">
	<cfoutput query="CurrencyList">
		<option value="#Currency#">#Currency#</option>
	</cfoutput>
</select>



