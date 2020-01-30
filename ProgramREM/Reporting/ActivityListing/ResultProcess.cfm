
<cfquery name="Clear" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE ProgramSearch WHERE SearchId = '#URL.ID1#'
     </cfquery>
	 
	 <script language="JavaScript">
	 
	 parent.left.location = "SearchTree.cfm?ID=0"
	 
	 </script>