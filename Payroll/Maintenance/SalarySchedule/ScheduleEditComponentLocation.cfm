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
<cfquery name="Location"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_PayrollLocation
	WHERE     LocationCode IN
                   (SELECT     LocationCode
                    FROM       Ref_PayrollLocationMission LM INNER JOIN
                               SalaryScheduleMission M ON LM.Mission = M.Mission
                    WHERE      M.SalarySchedule = '#url.schedule#')
</cfquery>		

<cfoutput>
<input type="hidden" name="locationvisible_#id#" value="1">					
</cfoutput>

<table width="100%">

<cfquery name="check"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      SalaryScheduleComponent
		WHERE     SalarySchedule = '#url.schedule#'
		AND       ComponentName = '#url.component#'
</cfquery>	

<cfif check.period eq "DAY" or check.period eq "HOUR">
	
	<tr><td colspan="4">
	
			<cfquery name="get"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    SalarySchedule, ComponentName, RateComponentName, CAST(RatePercentage as DECIMAL(12,8)) RatePercentage /*to support the Scientific notation*/
				FROM      SalaryScheduleComponentRate
				WHERE     SalarySchedule = '#url.schedule#'
				AND       ComponentName = '#url.component#'
			</cfquery>	
	
			<table>
			
			<cfoutput>
			
				<tr class="labelmedium">
				<td style="padding-left:10px"><cf_tl id="Auto generate rate">:</td>
				<td style="padding-left:20px">
				
					<cfquery name="parent"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_CalculationBase
						WHERE    Code IN  (SELECT I.Code
										   FROM   Ref_CalculationBaseItem I INNER JOIN
		                                          Ref_PayrollComponent R ON I.PayrollItem = R.PayrollItem
										   WHERE  R.Period IN ('MONTH', 'YEAR')
										   AND    I.Code IN (SELECT Code 
										                     FROM   Ref_CalculationBaseItem 
														     WHERE  SalarySchedule = '#url.schedule#'))
					</cfquery>		   
										
					<select name="ratecomponent_#id#" class="regularxxl" style="width:250px">
					    <option value="">n/a</option>
						<cfloop query="parent">
							<option value="#Code#" <cfif get.ratecomponentname eq code>selected</cfif>>#Description#</option>
						</cfloop>
					</select>
				
				</td>
				<td style="padding-left:10px"><cf_tl id="Percentage">:</td>	
				<td style="padding-left:10px">
				    <input class="regularxxl" value="#get.ratepercentage#" style="text-align:right;width:90px" name="ratepercentage_#id#">
				</td>		
				<td style="padding-left:2px">%</td>
				</tr>
				
			</table>
			
			</cfoutput>
	
	</td></tr>

</cfif>

<cfset cnt = 0>

<cfoutput query="Location">
	
	<cfquery name="check"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      SalaryScheduleComponentLocation
		WHERE     SalarySchedule = '#url.schedule#'
		AND       ComponentName = '#url.component#'
		AND       LocationCode  = '#locationCode#'	
	</cfquery>	
	
	<cfset cnt = cnt + 1>
	
	<cfif cnt eq "1">
	<tr class="labelmedium2" style="height:20px">
	</cfif>
	
		<td style="width:70;padding-left:7px"><input class="radiol" type="checkbox" name="location_#id#" value="#LocationCode#" <cfif check.recordcount gte "1">checked</cfif>></td>
		<td style="width:45% padding-right:20px">#Description#</td>
		
	<cfif cnt eq "2"></tr></cfif>	

</cfoutput>


</table>