
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_ReportControlLayout
		 WHERE ControlId = '#URL.ID#' and LayoutName = '#URL.ID1#'
</cfquery>

<script>
     outputrefresh()	
</script>	