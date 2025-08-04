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
