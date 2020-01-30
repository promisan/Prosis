<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfquery name="qDriver"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
		SET PersonNo='#URL.psno#'
		WHERE   Date = #dts#
		AND     Step = '#URL.step#'
</cfquery>		
