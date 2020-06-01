<!--- store search request --->

  <cfquery name="Update" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE PersonSearch 
	 SET    Status = '1', 
	        Description = '#Form.Description#', 
		    Access = '#form.Access#'
	 WHERE  SearchId = '#FORM.SearchId#'
     </cfquery>

  <script language="JavaScript">
  
   parent.ptoken.location('InitView.cfm');
  
  </script>	
  