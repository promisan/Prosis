
<cfquery name="Clear" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE PersonSearch WHERE SearchId = '#URL.ID1#'
     </cfquery>
	 
	 <script language="JavaScript">
	 
	 parent.left.location = "SearchTree.cfm?ID=0"
	 
	 </script>