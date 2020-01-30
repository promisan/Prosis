
<!--- set checkbox --->

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
