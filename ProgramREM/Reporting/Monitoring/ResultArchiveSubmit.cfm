<!--- store search request --->

  <cfquery name="Update" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE ProgramSearch 
	 SET    Status = '1', 
	        Description = '#Form.Description#', 
		    Access = '#form.Access#'
	 WHERE  SearchId = '#FORM.SearchId#'
     </cfquery>

  <script language="JavaScript">
  
   parent.window.location = "InitView.cfm";
  
  </script>	
  