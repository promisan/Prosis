
<cfparam name="Object.ObjectKeyValue4"  default="">

<!--- set url.id values based on the context --->
<cfif Object.ObjectKeyValue4 neq "">

	<cfset url.drillid = Object.ObjectKeyValue4>	
    <cfset url.workflow = "1">
		
	<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM  Ref_ParameterMission
		WHERE Mission = '#Object.Mission#'
	</cfquery>
	
<cfelse>

	<cfset url.workflow  ="0">
    <cfparam name="URL.ID1" default="">
	
</cfif>

<cfquery name="RequestLines" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT L.*
	FROM   Materials.dbo.RequestHeader H,
	       Materials.dbo.Request L 		 	 
	WHERE      H.Mission         = L.Mission
	AND        H.Reference       = L.Reference
	AND        H.RequestHeaderId = '#url.drillid#' 	

</cfquery>

<cfoutput>
<cfif RequestLines.recordcount eq "1">
	<iframe src="../../Warehouse/Application/StockOrder/Task/Tasking/TaskView.cfm?requestid=#requestlines.requestid#&mode=embed" width="100%" height="100%" frameborder="0"></iframe>
<cfelse>
	<cfinclude template="DocumentLines.cfm">
</cfif>
</cfoutput>