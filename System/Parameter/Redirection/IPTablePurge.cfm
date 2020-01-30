
<cfquery name="Delete" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM stRedirection
		 WHERE IPRangeID = '#URL.ID#'
</cfquery>

<script>
	 <cfoutput>
	 window.location = "IPTable.cfm"
	 </cfoutput> 
</script>	