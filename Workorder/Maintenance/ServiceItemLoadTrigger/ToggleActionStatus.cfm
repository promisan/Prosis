
<cf_compression>

<cfset dateValue = "">
<cf_DateConvert Value="#url.start#">
<cfset vStart = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#url.end#">
<cfset vEnd = dateValue>

<cfif url.status eq "0">
	<cfset vActionStatus = "1">
<cfelseif url.status eq "1">
	<cfset vActionStatus = "0">
</cfif>

<cfquery name="Update" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE	ServiceItemLoadTrigger
		SET		ActionStatus = '#vActionStatus#'
		WHERE	ServiceItem = '#url.serviceitem#'
		AND		SelectionDateStart = #vStart#
		AND		SelectionDateEnd = #vEnd#
		AND		LoadScope = '#url.loadscope#'
</cfquery>

<cfset vId = "#url.ServiceItem##url.start##url.end##url.loadscope#">
<cfset vId = replace(vId," ", "_", "ALL")>
<cfset vId = replace(vId,"/", "_", "ALL")>

<cfoutput>
	<script>
		ColdFusion.navigate('RecordListingActionStatus.cfm?serviceitem=#url.serviceItem#&start=#url.start#&end=#url.end#&loadscope=#url.loadscope#&status=#vActionStatus#','divStatus_#vId#');
	</script>
</cfoutput>