
<cfif workorderlineid neq "">

	<cfparam name="url.mode"      default="standard">
	<cfparam name="url.Year"      default="2010">
	<cfparam name="url.Month"     default="3">
	<cfparam name="url.Reference" default="undefined">
	
	<cfquery name="get" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT    * 
	FROM      WorkorderLine 
	WHERE     WorkorderLineId = '#url.workorderlineid#' 
	</cfquery>
	
	<cfif get.recordcount eq "1">
	
		<cfset url.workorderid   = get.workorderid>
		<cfset url.workorderline = get.workorderline>
		<cfset url.mode = "portal">
			
		<cfinclude template="../../../Application/WorkOrder/ServiceDetails/Charges/ChargesUsageDetail.cfm">
	
	<cfelse>
	
	Not found.
	
	</cfif>
	
</cfif>

<script>
   document.getElementById('calendar').className = "regular"	
</script>