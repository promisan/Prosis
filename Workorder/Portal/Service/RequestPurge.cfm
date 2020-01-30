
<cfif url.line eq "0">

	<cfquery name="Remove" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   DELETE Request
	   WHERE RequestId = '#URL.ajaxID#'	  
	</cfquery>
	
	<script>
	ColdFusion.navigate('../../../../WorkOrder/Portal/Service/HistoryList.cfm?mode=history','reqmain')
	</script>
	

<cfelse>
	
	<cfquery name="Remove" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   DELETE RequestLine
	   WHERE RequestId = '#URL.ajaxID#'
	   AND RequestLine = '#url.line#'
	</cfquery>
	
	<cfinclude template="ServiceView.cfm">
	
</cfif>	

