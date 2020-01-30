
<cfquery name="Clear" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE RosterSearch 
	 WHERE  SearchId = '#URL.ID1#'
     </cfquery>
	 
	 <script language="JavaScript">
	 
	 parent.left.location = "SearchTree.cfm?ID=0"
	 
	 </script>
	 
</cfif>
