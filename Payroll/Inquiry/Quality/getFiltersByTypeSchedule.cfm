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

<cfset vTopN = 12>
<cfset vSelectedMonths = 3>

<cfif url.salarySchedule neq "">
	
	<cfif url.type eq "0">

		<cfquery name="getPayrollItems" 
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *, left(Source,1)+':'+left(PayrollItemName, 200) as PayrollItemNameS
			 FROM     Ref_PayrollItem PI
			 WHERE    PayrollItem IN (SELECT PayrollItem 
			                         FROM   EmployeeSettlementLine ESL
									 WHERE  ESL.Mission        = '#url.mission#'
									 AND    ESL.SalarySchedule = '#url.SalarySchedule#'
									 AND    ESL.PaymentDate >= getDate()-500)			 		
			 AND 	  PI.Settlement      = '1'
			 AND 	  PI.PrintGroup != 'Contributions'
			 
			 AND      PayrollItem IN (SELECT PayrollItem
			                          FROM   SalarySchedulePayrollItem
									  WHERE  Mission = '#url.mission#'
									  AND    SalarySchedule = '#url.SalarySchedule#') 
			 
			 ORDER BY PI.PrintOrder, PI.PayrollItemName
		</cfquery>	

		<cfquery name="getDates" 
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   DISTINCT TOP #vTopN# PaymentDate
			 FROM     EmployeeSettlementLine
			 WHERE 	  Mission = '#url.mission#'
			 AND 	  SalarySchedule = '#url.salarySchedule#'
			 ORDER BY PaymentDate DESC
		</cfquery>
		
	<cfelse>

		<cfquery name="getPayrollItems" 
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		    SELECT   *, left(Source,1)+':'+left(PayrollItemName, 200) as PayrollItemNameS
			 FROM     Ref_PayrollItem PI
			 WHERE    PayrollItem IN (SELECT PayrollItem 
			                          FROM   EmployeeSalary ES INNER JOIN 
									         EmployeeSalaryLine ESL ON  ES.SalarySchedule = ESL.SalarySchedule	
										 AND ES.PayrollStart  = ESL.PayrollStart
										 AND ES.PersonNo      = ESL.PersonNo
										 AND ES.PayrollCalcNo = ESL.PayrollCalcNo
									  WHERE  ES.Mission       = '#url.mission#'
									  AND    ES.SalarySchedule = '#url.SalarySchedule#'
									  AND    ES.PayrollStart>= getDate()-500)			 		
			 AND 	  PI.Settlement      = '1'
			 AND 	  PI.PrintGroup != 'Contributions'
			 
			 AND      PayrollItem IN (SELECT PayrollItem
			                          FROM   SalarySchedulePayrollItem
									  WHERE  Mission = '#url.mission#'
									  AND    SalarySchedule = '#url.SalarySchedule#') 
			 
			 ORDER BY PI.PrintOrder, PI.PayrollItemName
		 
		</cfquery>
				
		<cfquery name="getDates" 
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT DISTINCT TOP #vTopN# PayrollEnd as PaymentDate
			 FROM   EmployeeSalary
			 WHERE 	Mission = '#url.mission#'
			 AND 	SalarySchedule = '#url.salarySchedule#'
			 ORDER BY PayrollEnd DESC
		</cfquery>
		
	</cfif>
	
	<cfquery name="getPostGrades" 
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   DISTINCT PG.PostGrade, PG.PostOrder
			 FROM     EmployeeSalary ESL INNER JOIN Employee.dbo.Ref_PostGrade PG ON ESL.ContractLevel = PG.PostGrade
			 WHERE 	  ESL.Mission        = '#url.mission#'
			 AND      ESL.SalarySchedule = '#url.SalarySchedule#'			 
			 ORDER BY PG.PostOrder ASC
	</cfquery>
		

	<cfquery name="getLocations" 
	 datasource="AppsPayroll" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT DISTINCT 
		 		L.LocationCode,
				L.Description as LocationDescription
		 FROM   EmployeeSalary ES 
		 		INNER JOIN EmployeeSalaryLine ESL
					ON ES.SalarySchedule = ESL.SalarySchedule
					AND ES.PayrollStart = ESL.PayrollStart
					AND ES.PersonNo = ESL.PersonNo
					AND ES.PayrollCalcNo = ESL.PayrollCalcNo
		 		INNER JOIN Ref_PayrollLocation L 
					ON ES.ServiceLocation = L.LocationCode
		 WHERE 	ES.Mission = '#url.mission#'
		 AND    ESL.SalarySchedule = '#url.SalarySchedule#'
	</cfquery>

	<table width="100%">		
		<tr>
			<td class="labelmedium2" colspan="2"><cf_tl id="Payroll Item">:</td>
		</tr>
		<tr>
			<td class="labellarge" colspan="2" style="padding:5px">
							 
				 <cf_UIselect name = "PayrollItem"					
					size           = "1"
					class          = "regularXXL"
					id             = "PayrollItem"		
					multiple       = "Yes"													
					style          = "width:100%"											
					query          = "#getPayrollItems#"
					queryPosition  = "below"
					value          = "PayrollItem"
					display        = "PayrollItemNameS"/>
					
				<!---	
				
				 <cfset ht = getPayrollItems.recordcount*24>
				 <cfif ht gt 300>
				 	<cfset ht = "300">
				 </cfif>	
				 			 
				<select name="PayrollItem" id="PayrollItem" class="regularxxl" style="background-color:f4f4f4;padding:4px;border:0px;height:<cfoutput>#ht#</cfoutput>px; width:100%;" multiple="multiple">
					<cfoutput query="getPayrollItems">
						<option value="#PayrollItem#"> #left(Source,1)#: #left("#PayrollItemName# (#PayrollItem#)", 200)#
					</cfoutput>
				</select>
				
				--->
			</td>
		</tr>

		<tr>
			<td width="50%" valign="top" style="padding-right:4px">
				<table width="100%">
					<tr>
						<td class="labelmedium2"><cf_tl id="Contract grade">:</td>
					</tr>
					
					   <cfset ht = getPostGrades.recordcount*21>
					   <cfif ht gt 400>
				 	     <cfset ht = "400">
					   </cfif>	
					<tr>
						<td class="labellarge">
							<select name="PostGrade" id="PostGrade" class="regularxl" style="background-color:f4f4f4;border-left:0px;border-right:0px;height:<cfoutput>#ht#</cfoutput>px; width:100%;" multiple="multiple">
								<cfoutput query="getPostGrades">
									<option value="#PostGrade#"> #left("#PostGrade#", 250)#
								</cfoutput>
							</select>
						</td>
					</tr>
				</table>
			</td>
			<td valign="top" style="border-left:1px solid gray">
				<table width="100%">
					<tr>
						<td class="labelmedium2" style="padding-left:4px"><cf_tl id="Location">:</td>
					</tr>
					<tr>
						<td class="labellarge">
							<select name="Location" id="Location" class="regularxl" style="background-color:f4f4f4;border-left:0px;border-right:0px;height:<cfoutput>#ht#</cfoutput>px; width:100%;" multiple="multiple">
								<cfoutput query="getLocations">
									<option value="#LocationCode#">#LocationDescription#
								</cfoutput>
							</select>
						</td>
					</tr>	
				</table>
			</td>
		</tr>		
		
		<tr class="line">
			<td class="labelmedium2" colspan="2">
			<table style="width:100%">
			<tr class="labelmedium2"><td><cf_tl id="Compare Months"></td>
			<cfif url.type eq "0">
			<td style="padding-left:20px"><cf_tl id="Include retro-active payment"></td>			
			<td style="padding-left:5px"><input type="checkbox" class="radiol" name="filtermode" value="1" checked></td>
			<cfelse>
			<td style="padding-left:20px"><cf_tl id="Show SPA only"></td>			
			<td style="padding-left:5px"><input type="checkbox" class="radiol" name="filtermode" value="1"></td>
			
			</cfif>
			</tr></table>
			</td>
		</tr>	
		<tr class="line">
			<td class="labelmedium2" colspan="2">
				
				<cfset vCols = 3>
				<table width="100%">
				
					<tr class="fixlengthlist">
						<cfset vCnt = 0>
						<cfoutput query="getDates">
							
							<cfset vThisDate = dateAdd("s", 0, PaymentDate)>

							<td>
								<cfset vThisValue = dateFormat(vThisDate, "YYYY") & dateFormat(vThisDate, "M")>
								<input type="checkbox" <cfif currentrow lte vSelectedMonths>checked="checked"</cfif> class="regularxl clsMonth" name="month" id="month_#currentrow#" style="height:18px; width:18px;" value="#vThisValue#">
							</td>
							<td class="labelmedium" style="font-size:90%;">
								<cfset vThisMonth = dateFormat(vThisDate, "MMM")>
								<cf_tl id="#vThisMonth#" var="1">
								<label for="month_#currentrow#">#lt_text#-#dateFormat(vThisDate, "YY")#</label>
							</td>

							<cfset vCnt = vCnt + 1>
							<cfif vCnt eq vCols>
								<cfset vCnt = 0>
								</tr>
								<tr class="fixlengthlist">
							</cfif>

						</cfoutput>
					</tr>
				</table>
				
			</td>
		</tr>
				
		<tr class="line">
				<td colspan="2">	
				<table width="100%">
					<tr>
						<td class="fixlength labelmedium2"><cf_tl id="Sort/Filter"></td>
						<td class="labellarge">
							<input type="radio" name="order" value="0" id="order0" checked="checked" style="height:15px; width:15px;"> <label for="order0"><cf_tl id="Index"></label>
						</td>
						<td class="labellarge" style="padding-left:5px;">
							<input type="radio" name="order" id="order1" value="1" style="height:15px; width:15px;"> <label for="order1"><cf_tl id="Name"></label>
						</td>
						<td class="labellarge" align="right" style="padding-left:10px;">
							<input type="text" style="width:100px;border:0px;border-left:1px solid silver;background-color:f1f1f1" class="regularxxl" name="FilterPerson" id="FilterPerson">
						</td>
					</tr>
				</table>
				
			</td>	
			
		</tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td colspan="2" align="center">
				<cf_tl id="Apply" var="1">
				<cfoutput>
					<input type="button" id="btnApply" class="button10g" value="#lt_text#" style="height:35px; width:200px; font-size:125%;" onclick="doFilter();">
				</cfoutput>
			</td>
		</tr>
	</table>
	

</cfif>