
<!---- to be defined --->

 <cfquery name="Update" 
     datasource="AppsWorkOrder" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 UPDATE Workorder
	 SET    OrderMemo       = '#Form.Ordermemo#', Reference = '#Form.Reference#'			
     WHERE  WorkorderId = '#URL.WorkOrderid#' 
  </cfquery>
	
	