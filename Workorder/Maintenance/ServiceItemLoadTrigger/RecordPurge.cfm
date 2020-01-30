
<cfset dateValue = "">
<cf_DateConvert Value="#url.start#">
<cfset vStart = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#url.end#">
<cfset vEnd = dateValue>

<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	ServiceItemLoadTrigger
		WHERE	ServiceItem = '#url.serviceitem#'
		AND		SelectionDateStart = #vStart#
		AND		SelectionDateEnd = #vEnd#
		AND		LoadScope = '#url.loadscope#'
</cfquery>

<cfinclude template="RecordListingDetail.cfm">