	
 <cftransaction>
	
	<!--- positions --->
	
	<cfquery name="Delete" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
    	 DELETE FROM Position
    	 WHERE  PositionParentId = '#url.PositionParentId#'
	</cfquery>	

	<cfquery name="Delete" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	DELETE FROM PositionParent
			WHERE  PositionParentId  = '#url.positionparentid#'  
	 </cfquery>
    
	<!---   
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	         action      = "Delete"
			 datasource  = "AppsEmployee" 
			 contenttype = "Scalar"
			 content     = "PositionParentId : #url.positionparentid#">
			 
	 --->
   
	<!--- assignment through RI

	<cfparam name="Form.AssignmentNo" default="''">

	<cfquery name="Delete3" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   DELETE PersonAssignment
	   WHERE AssignmentNo  = '#url.positionparentid#' 
	 </cfquery>
	 
	 ---> 
	 
</cftransaction>