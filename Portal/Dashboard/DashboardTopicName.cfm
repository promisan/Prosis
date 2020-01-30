
<cfparam name="attributes.frm" default="1">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM UserDashboard
WHERE Account = '#SESSION.acc#'
AND DashBoardFrame = '#attributes.frm#'
</cfquery>

<cfif get.reportId neq "">

	<cfquery name="SearchResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   FunctionName as Name 
		FROM     Ref_ModuleControl 
		WHERE    SystemFunctionId = '#Get.ReportId#'
		UNION
		SELECT   DistributionName as Name
		FROM     UserReport U
		WHERE    ReportId = '#Get.ReportId#'
	</cfquery>

	<cfset caller.name = searchresult.name>

<cfelse>

	<cfset caller.name = "">

</cfif>


