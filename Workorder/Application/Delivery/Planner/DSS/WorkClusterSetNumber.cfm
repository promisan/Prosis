<cfparam name="URL.date" 		default = "06/01/2015">

<cfset dateValue = "">
<cf_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfparam name="url.value" default="0">
<cfparam name="url.increment" default="1">

<cfset val = url.value + url.increment>

<cfoutput>

	<cfquery name="qHistoryDrivers"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
	    FROM     stWorkPlanSummaryDrivers_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
		WHERE    Date = #dts#
		ORDER BY TotalUsedPercentage DESC
	</cfquery>

	<cfif val gt qHistoryDrivers.TotalDrivers*0.60>
		<cfquery name="qUpdate"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE stWorkPlanSettings_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
			SET TotalDriversManual = '#val#'
			WHERE  Date = #dts#
		</cfquery>			
			
		<script>
		 	document.getElementById('#url.name#').value = '#val#'
		</script>
	</cfif>	
	
</cfoutput>