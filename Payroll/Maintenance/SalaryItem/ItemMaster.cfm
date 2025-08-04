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
<cf_compression>

<cfquery name="ItemMaster" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ItemMaster
	WHERE Code IN (SELECT ItemMaster FROM ItemMasterObject WHERE ObjectCode = '#url.object#')
	AND Operational = 1				
</cfquery>

<cfquery name="Check"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM SalarySchedulePayrollItem
	WHERE Mission       = '#url.mission#'
	AND  SalarySchedule = '#url.schedule#'
	AND PayrollItem     = '#url.item#'
</cfquery>			

<select name="<cfoutput>itemmaster_#url.row#</cfoutput>" id="<cfoutput>itemmaster_#url.row#</cfoutput>" class="regularxl" style="width:220">
      <option value=""></option>
	      <cfoutput query="ItemMaster">
			     <option value="#Code#" <cfif Check.ItemMaster eq Code> SELECTED</cfif>>
					 #Code# #Description#</option>
		   </cfoutput>
</select>