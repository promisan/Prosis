
<cfquery name="Delete" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		 DELETE FROM Ref_LeaveTypeClass
		 WHERE Code      = '#URL.Code#'
		 AND   LeaveType = '#URL.ID1#'
		 
</cfquery>

<cfinclude template="RecordListingDetail.cfm">
