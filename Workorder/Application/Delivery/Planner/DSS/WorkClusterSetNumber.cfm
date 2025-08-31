<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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