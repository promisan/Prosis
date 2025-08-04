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

<cfparam     name= "Object.ObjectKeyValue1"        default="">
<cfparam     name= "Object.ObjectKeyValue4"        default="">

<cfquery name="Last" 
	datasource="appsPayroll">
	SELECT   TOP 1 *
	FROM     CalculationLog	
	ORDER BY Created DESC
</cfquery>

<cfquery name="get"
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT     *
      FROM       Payroll.dbo.EmployeeSettlement ES
	  WHERE      SettlementId = '#Object.ObjectKeyValue4#'	           
</cfquery> 

<cfif last.recordcount eq "0">
   <cfset nextprocess = 1>
<cfelse>
   <cfset nextprocess = last.ProcessNo + 1>   
</cfif>

<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	    Method          = "getEOD"
	    PersonNo        = "#get.PersonNo#"
		Mission         = "#get.Mission#"	
		SelDate         = "#dateformat(get.PaymentDate,client.dateformatshow)#"	
	    ReturnVariable  = "EOD">   <!--- this obtains the most likely EOD for this person to apply to this FP workflow --->	
		
<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	    Method          = "getEOD"
	    PersonNo        = "#get.PersonNo#"
		Mission         = "#get.Mission#"		
	    ReturnVariable  = "EODNext">  <!--- this obtains the last known EOD for this person to apply to this FP workflow --->				
	
<cfquery name="Employee" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 * 
		FROM     PersonContract
		WHERE    PersonNo       = '#get.PersonNo#'	
		AND      Mission        = '#get.mission#'
		AND      SalarySchedule = '#get.SalarySchedule#'	
		<cfif EODNext gt EOD>
		<!--- obtain the prior EOD --->
		AND      DateEffective < '#eodnext#'
		</cfif>
		AND      ActionStatus IN ('1') 
		ORDER BY DateEffective DESC				
</cfquery>	

<cfif Employee.actionCode neq "3006">

	<table align="center">
		<tr class="labelmedium"><td style="padding-top:20px;height:50px">The last contract record does not appear to be a separation action. Please contact your administrator</td></tr>
	</table>
	<script>Prosis.busy('no')</script>
	<cfabort>
	
<cfelse>
				
	<cfset url.mode = "0">
	<cfset url.processNo      = nextProcess>
	<cfset url.mission        = get.mission>
	<cfset url.salaryschedule = get.SalarySchedule>	
	<cfset url.personNo       = get.PersonNo>
	<!--- setting to pick this up as a final payment date --->	
	<cfset wffinal            = get.PaymentDate>
	<cfset url.dateEff        = dateformat(EOD,client.dateformatshow)>
			
	<cfif employee.recordcount gte "1">		
		<cfinclude template="CalculationProcess.cfm">	
	</cfif>
	
</cfif>	
	