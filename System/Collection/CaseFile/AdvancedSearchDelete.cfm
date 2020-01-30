
<cfif URL.searchid neq "">

	<cfif URL.Line neq "">
		<cfquery name="qDelete" datasource = "AppsSystem">		
			DELETE FROM CollectionLogCriteria
			WHERE  SearchId = '#URL.searchid#'
			AND    SearchLine = '#URL.line#' 
		</cfquery>
		
	<cfelse>
	
		<cfquery name="qDelete" datasource = "AppsSystem">
			DELETE FROM CollectionLogCriteria
			WHERE  SearchId = '#URL.Searchid#'
		</cfquery>
		
	</cfif>

	<cfoutput>
	
		<script>
			ColdFusion.navigate ('CaseFile/AdvancedSearchCriteria.cfm?searchid=#URL.searchid#&class=#url.class#&mode=new&ds=AppsCaseFile&db=CaseFile&Table=Ref_TopicElementClass&layout=1&where= and elementClass = |#url.class#|','dcriteria_#url.class#');
		</script>
	
	</cfoutput>		
	
</cfif>

