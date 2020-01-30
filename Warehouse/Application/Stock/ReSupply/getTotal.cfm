
<cfif url.sort eq "Category">
	
	<cfquery name="getLine"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   StockResupply#URL.Warehouse#_#SESSION.acc#		
			WHERE  [LineNo]     = '#URL.LineNo#' 	
	</cfquery>
	
	<cfquery name="get"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT COUNT(*) as Total 
			FROM   StockResupply#URL.Warehouse#_#SESSION.acc#
			WHERE  CategoryItem = '#getLine.CategoryItem#'	
			AND    Selected     = 1	
			AND    Operational  = 1
			AND    ToBeRequested > 0
	</cfquery>
	
	<cfoutput>
	<script>	
	document.getElementById('section#url.section#').innerHTML = "#get.total#"
	</script>	
	</cfoutput>
	
</cfif>	
	
<cfquery name="get"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT COUNT(*) as Total 
		FROM   StockResupply#URL.Warehouse#_#SESSION.acc#
		WHERE  Selected = 1	
		AND    Operational = 1
		AND    ToBeRequested > 0
</cfquery>

<cfoutput>
	<script>
		document.getElementById('section0').innerHTML = '#get.total#'
	</script>
</cfoutput>
