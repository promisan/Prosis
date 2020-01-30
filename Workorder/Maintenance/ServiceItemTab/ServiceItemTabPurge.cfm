
<cfquery name="Delete" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ServiceItemTab
	WHERE 	mission = '#URL.ID1#'
	AND 	code = '#URL.ID2#'
	AND		tabName = '#URL.ID3#'
</cfquery>


<cfoutput>
<script language="JavaScript">   
	ColdFusion.navigate('#SESSION.root#/workorder/maintenance/ServiceItemTab/ServiceItemTabListing.cfm?ID1=#URL.ID2#','contentbox2')
</script> 
</cfoutput>