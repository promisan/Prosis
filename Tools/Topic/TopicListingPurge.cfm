
<cfset tbl = evaluate("url.topicscope#serialno#table")>
<cfset fld = evaluate("url.topicfield#serialno#")>

<!---
<cfquery name="Delete" 
    datasource="#url.alias#" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM #tbl#
	WHERE #fld# = '#URL.Code#' 
</cfquery>
--->

<cfquery name="Delete" 
    datasource="#url.alias#" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_Topic
	<cfif url.alias eq "appsSelection">
	WHERE Topic = '#URL.Code#'
	<cfelse>
	WHERE Code  = '#URL.Code#'
	</cfif>
</cfquery>

<script>
	 listingshow()
</script>
