<cfset dateValue = "">
<CF_DateConvert Value="#URL.date#">
<cfset DTS = dateValue>		

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfif URL.step eq 0>
	<cfset SESSION.count = 1>
	<cfset URL.Mode = "Load">
	<cfinclude template="WorkClusterInit.cfm">
<cfelse>

	<cfquery name="qReset"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE stWorkPlan_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
			SET    ActionStatus = '0'
			WHERE  Date = #dts#
	</cfquery>		

	<cfquery name="qResetDetails"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE stWorkPlanDetails_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
			SET    ActionStatus = '0'
			WHERE  Date = #dts#
	</cfquery>		

	<cfquery name="qResetNodes"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
			SET    ActionStatus = '0'
			WHERE  Date = #dts#
	</cfquery>	
</cfif>	

