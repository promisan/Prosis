<!--
    Copyright © 2025 Promisan

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

<!--- we check if the scale has component defined --->

<cf_systemscript>

<cfinvoke component = "Service.Process.Payroll.Scale"  
   method           = "setScaleComponent" 
   ScaleNo          = "#url.ScaleNo#" 
   Force            = "Yes">	
      
<cfquery name="get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   SalaryScale
	WHERE  ScaleNo = '#URL.ScaleNo#'
</cfquery>

<cfset url.schedule  = get.SalarySchedule>
<cfset url.mission   = get.Mission>
<cfset url.location  = get.ServiceLocation>
<cfset url.effective = get.SalaryEffective>

<cfoutput>
<script>
 ptoken.open('RateEdit.cfm?schedule=#get.SalarySchedule#&mission=#get.Mission#&location=#get.ServiceLocation#&effective=#get.SalaryEffective#&mode=#url.mode#&operational=#get.operational#','right')
</script>
</cfoutput>
