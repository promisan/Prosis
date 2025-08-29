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
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.SalaryEffective#">
	<cfset eff = #dateValue#>

	<cfquery name="Delete"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE   FROM SalaryScale
	WHERE    SalarySchedule  = '#URL.Schedule#'
	   AND   Mission         = '#URL.Mission#'
	   AND   ServiceLocation = '#URL.Location#'
	    AND  SalaryEffective   = #eff#  
	</cfquery>

	<cfquery name="Check"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM SalaryScale
	WHERE    SalarySchedule  = '#URL.Schedule#'
	   AND   Mission         = '#URL.Mission#'
	   AND   ServiceLocation = '#URL.Location#'
	   AND   Operational = 1	  
	</cfquery>

	<cfoutput>
	<script language="JavaScript">
	    parent.ColdFusion.navigate('RateViewTree.cfm?mission=#url.mission#&schedule=#url.schedule#&location=#url.location#','treebox') 
    	window.location = "RateEdit.cfm?Effective=#DateFormat(check.SalaryEffective, client.DateSQL)#&Schedule=#URL.Schedule#&Mission=#URL.Mission#&Location=#URL.Location#&mode=Grade&operational=1"
	</script>
	</cfoutput>
