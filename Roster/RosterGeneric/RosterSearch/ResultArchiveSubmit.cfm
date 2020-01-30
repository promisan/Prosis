<!--- store search request --->

<cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE RosterSearch 
	 SET    Status      = '1', 
	        Description = '#Form.Description#', 
		    Access      = '#form.Access#'
	 WHERE  SearchId = '#FORM.SearchId#'
</cfquery>
	 
<cfquery name="Search" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearch
		WHERE SearchId = '#Form.SearchId#'
</cfquery>  

<cfoutput>

  <script language="JavaScript">
	
  	   parent.window.location = "Search1.cfm?Status=#url.status#&DocNo=#url.docno#&Owner=#Search.Owner#&mode=#url.mode#";
    
  </script>	
</cfoutput>  


  