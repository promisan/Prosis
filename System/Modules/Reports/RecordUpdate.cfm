
<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ReportControl
	SET Operational = '#URL.Operational#'
	WHERE ControlId = '#URL.ControlId#'	
 </cfquery>