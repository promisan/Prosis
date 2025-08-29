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
<cfparam name="components" default="'FirstLangAllow','SecLangAllow'">
<cfparam name="correction" default="PostAd">

<!--- annual leave conmutation correction --->

<cfif processmodality eq "PersonalForce">
	
	<cfquery name="Leave" 
		 datasource="AppsPayroll"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT     *
			 FROM       PersonMiscellaneous
			 WHERE      PersonNo = '#Form.PersonNo#' 
			 AND        PayrollItem = 'A55' 
			 AND        Source = 'Final'
			 AND        SourceId is not NULL
	</cfquery>	
	
	<cfloop query="Leave">
				
		<cfquery name="get" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM   EmployeeSettlement	
		    WHERE  SettlementId = '#Leave.SourceId#'	
		</cfquery>	
		
		<cfif get.Recordcount eq "1">
		
		<cfquery name="getPeriod" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    TOP 1 *
			FROM      Employee.dbo.PersonContract
			WHERE     PersonNo          = '#get.PersonNo#' 
			AND       SalarySchedule    = '#get.SalarySchedule#' 
			AND       Mission           = '#get.Mission#' 
			AND       ActionStatus      IN ('0','1') <!--- hanno 5/2/2019 added 0 to be included based on davies 9289 who did not have his last leg closed --->
			AND       HistoricContract != '1'			        
			ORDER BY  DateEffective DESC		
		</cfquery>
		
		<cfif getPeriod.recordcount neq "0">
			<cfset max = getPeriod.DateExpiration>
		<cfelse>
			<cfset max = get.PaymentDate>
		</cfif>
		
		
		<cfquery name="getContract" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    TOP 1 *
				FROM      PersonContract
				WHERE     ContractId = '#getPeriod.ContractId#'		   					
		</cfquery>
						
		<cfquery name="getScale" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    TOP 1 *
				FROM      SalaryScale
				WHERE     SalarySchedule   = '#get.SalarySchedule#' 
				AND       ServiceLocation  = '#getContract.ServiceLocation#' 
				AND       Mission          = '#get.Mission#' 
				AND       SalaryEffective <= '#get.PaymentDate#'
				AND       Operational = 1
				ORDER BY SalaryEffective DESC
		</cfquery>
					
		<cfif getScale.recordcount eq "1">
		
				<cfquery name="Schedule" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   SalarySchedule	
				    WHERE  SalarySchedule = '#get.SalarySchedule#'	
				</cfquery>	
			
				<cfquery name="getRate" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      SalaryScaleLine SL INNER JOIN
			                     SalaryScaleComponent SSC ON SL.ScaleNo = SSC.ScaleNo AND SL.ComponentName = SSC.ComponentName
				    WHERE     SL.ScaleNo      = #getScale.ScaleNo# 
					AND       SL.ServiceLevel = '#getContract.ContractLevel#' 
					AND       SL.ServiceStep  = '#getContract.ContractStep#' 
					AND       SSC.PayrollItem = '#schedule.SalaryBasePayrollItem#' 
					
				</cfquery>		
			
				<cfset cur = getRate.currency>
				<cfset amt = getRate.Amount>
				
				<!--- obtain percentage post adjustment --->
				
				<cfquery name="getAdjustment" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     SalaryScalePercentage
					WHERE    ScaleNo       = #getScale.ScaleNo#
					AND      ComponentName = '#correction#'
				</cfquery>
				
				<cfquery name="getAdjustmentDetail" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     SalaryScalePercentageDetail
					WHERE    ScaleNo       = #getScale.ScaleNo# 
					AND      ComponentName = '#correction#' 
					AND      DetailValue   = '#month(max)#'		
				</cfquery>	
				
				<cfif getAdjustmentDetail.recordcount eq "1">
				   <cfset  adjust = getAdjustmentDetail.percentage>
				<cfelseif getAdjustment.recordcount eq "1">
					<cfset adjust = getAdjustment.percentage>
				<cfelse>
					<cfset adjust = 0>
				</cfif>		
				
				<cfset amtD        = amt/(12*21.75)> 
				<cfset dayrate = amtD + (amtD*adjust/100)>
			
				<!--- --->
			
				<cfquery name="Set" 
					 datasource="AppsPayroll"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 UPDATE     PersonMiscellaneous
					 SET        Rate     = round(#dayrate#,2),
					            Amount   = round(#dayrate*Quantity#,2),
								Remarks  = 'Revised Rate'
					 WHERE      PersonNo = '#Form.PersonNo#'
					 AND        CostId   = '#CostId#'		
				</cfquery>	
				
		</cfif> 	
		
		</cfif>
		
	</cfloop>

</cfif>