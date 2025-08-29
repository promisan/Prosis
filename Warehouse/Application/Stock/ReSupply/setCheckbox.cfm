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
<cfoutput>

	<cfquery name="get"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE StockResupply#URL.Warehouse#_#SESSION.acc#
		SET   Selected = <cfif url.action eq "all">1<cfelse>0</cfif>	
		<cfif url.sort eq "Category">	
		WHERE  CategoryItem IN (
							SELECT CategoryItem FROM StockResupply#URL.Warehouse#_#SESSION.acc#		
							WHERE  [LineNo] = '#URL.LineNo#' 	
							)		
		</cfif>
	</cfquery>
	
	<script>
	
	    <cfif url.action eq "all">
		
		  	$('.checkbox_#url.section#').prop( 'checked', true );		
			$('.enter_#url.section#').prop( 'disabled', false );	
			$('.enter_#url.section#').css( 'background-color', 'C6F2E2' );
							
		<cfelse>
		
			$('.checkbox_#url.section#').prop( 'checked', false );	
			$('.enter_#url.section#').prop( 'disabled', true );			
			$('.enter_#url.section#').css( 'background-color', 'ffffff' );	
			// $('.enter_#url.section#').prop( 'class', 'hide' );
			
		</cfif>
		
		ptoken.navigate('../Resupply/getTotal.cfm?warehouse=#url.warehouse#&lineno=#url.lineno#&section=#url.section#&sort=#url.sort#','section#url.section#')	
			
	</script>
	
</cfoutput>
