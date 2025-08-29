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
<cfquery name="Period" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT    *
		FROM      SalarySchedulePeriod
		WHERE     CalculationId = '#URL.Id#'
</cfquery>

<cfinvoke component="Service.Access"  
   method="payrollofficer" 
   mission="#Period.Mission#"
   returnvariable="accessPayroll">	

<cfquery name="Expiration" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	SELECT   PersonNo, MAX(DateExpiration) AS Expiration
	FROM     PersonContract
	WHERE    SalarySchedule = '#Period.SalarySchedule#'
	AND      Mission        = '#Period.Mission#'  
	<!---
	AND      EnforceFinalPay = 1
	--->
	AND      PersonNo NOT IN
                          (SELECT   PersonNo
                            FROM    PersonContract
                            WHERE   (DateExpiration = '' OR DateExpiration IS NULL) 
							AND      SalarySchedule = '#Period.SalarySchedule#'
							AND      Mission        = '#Period.Mission#')
	GROUP BY PersonNo
	HAVING   MAX(DateExpiration) <= '#DateFormat(Period.PayrollEnd, client.dateSQL)#' 
	     AND MAX(DateExpiration) >= '#DateFormat(Period.PayrollStart, client.dateSQL)#'
	ORDER BY MAX(DateExpiration)  
</cfquery>

<table width="99%"
       align="center"
       border="0"
       cellspacing="0"
       cellpadding="0"
       bordercolor="C0C0C0"
       class="formpadding">
	   
	<cfoutput>   
	   
	<tr><td colspan="9" style="background: f4f4f4;">
	
	<table width="100%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	<td>#Period.Mission#</td>
	<td>#Period.SalarySchedule#</td>
	<td>#dateformat(Period.PayrollStart,CLIENT.DateFormatShow)#</td>
	<td>#dateformat(Period.PayrollEnd,CLIENT.DateFormatShow)#</td>
	<td><cfif Period.calculationStatus eq "2"><font color="FF0000">Persion has been closed</font><cfelse>Period is open</cfif></td>
	</tr>
	</table>
	</td></tr>   
	
	<tr><td height="5"></td></tr>
	
	<tr>
	    <td></td>
		<td><b>#client.IndexNoName#</a></td>
		<td><b><cf_tl id="Name"></td>
		<td><b><cf_tl id="Nat">.</td>
		<td><b><cf_tl id="Expiration"></td>
		<td><b><cf_tl id="Assignment"></td>
		<td><b><cf_tl id="Level"></td>
		<td align="right"><b><cf_tl id="Salary"></td>
		<td align="center"><b><cf_tl id="Final Pay"></td>
	</tr>
	<tr><td height="1" colspan="9" bgcolor="c0c0c0"></td></tr>
	
</cfoutput>	

<cfif expiration.recordcount eq "0">
<tr><td colspan="8" height="30" align="center"><font color="0080FF"><b><cf_tl id="No eligible employees for final payment for this period" class="Text"></td></tr>

</cfif>

<cfoutput query="Expiration">
	
	<cfquery name="Person" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT    *
			FROM      Person
			WHERE     PersonNo = '#PersonNo#'
	</cfquery>	
	
	<cfquery name="Contract" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT    TOP 1 *
			FROM      PersonContract
			WHERE     PersonNo = '#PersonNo#'
			AND       DateExpiration = '#DateFormat(Expiration,client.dateSQL)#'
			AND       SalarySchedule = '#Period.SalarySchedule#'
			AND       Mission        = '#Period.Mission#' 
	</cfquery>	
	
	<cfquery name="Assignment" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT    TOP 1 *
			FROM      PersonAssignment
			WHERE     PersonNo = '#PersonNo#'
			AND       AssignmentStatus IN ('0','1')
			AND       AssignmentClass = 'Regular'
			ORDER BY DateExpiration DESC
	</cfquery>	
	
	<tr>
	<td align="center" width="50">
		
		<img src="#SESSION.root#/Images/ct_collapsed.gif" alt="View History" 
			id="#currentrow#Exp" border="0" class="show" 
			align="absmiddle" style="cursor: pointer;" 
			onClick="slip('#currentrow#','#URLEncodedFormat(Period.PayrollEnd)#','#Period.SalarySchedule#','#Period.Mission#','#PersonNo#')">
			
		<img src="#SESSION.root#/Images/ct_expanded.gif" 
			id="#currentrow#Min" alt="Hide History" border="0" 
			align="absmiddle" class="hide" style="cursor: pointer;" 
			onClick="slip('#currentrow#','#URLEncodedFormat(Period.PayrollEnd)#','#Period.SalarySchedule#','#Period.Mission#','#PersonNo#')">				
			
	</td>
	<td height="28"><a href="javascript:EditPerson('#PersonNo#','Payroll')">#Person.IndexNo#</a></td>
	<td>#Person.FullName#</td>
	<td>#Person.Nationality#</td>
	<td>#DateFormat(Expiration,CLIENT.DateFormatShow)#</td>
	<td><cfif Expiration neq Assignment.DateExpiration>
	<font color="FF0000"><b>
	</cfif>
	
	#DateFormat(Assignment.DateExpiration,CLIENT.DateFormatShow)#</td>
	<td>#Contract.ContractLevel#-#Contract.ContractStep#</td>
	<td align="right">#numberformat(Contract.ContractSalaryAmount,"__,__.__")#</td>
	<td right="1" align="center" id="final">
	
	<cfif accessPayroll eq "EDIT" or accessPayroll eq "ALL">
	
		<cfquery name="Check" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		  	 SELECT    *
	         FROM      EmployeeSalary
			 WHERE     PersonNo       = '#PersonNo#' 
			 AND       PaymentFinal   = '1'
			 AND       Mission        = '#Period.Mission#' 
			 AND       SalarySchedule = '#Period.SalarySchedule#' 
			 AND       PayrollStart   = '#dateformat(Period.PayrollStart,client.dateSQL)#'
		</cfquery>	
			
		<cfif Check.recordcount gte "1">
			<input type="button" 
			       name="Final" 
				   value="Recalculate" 
				   class="button10g" 
				   onclick="calcperson('#Period.CalculationId#','#Contract.ContractId#','#period.mission#','1')">
			<input type="button" 
			       name="Final" 
				   value="Revoke" 
				   class="button10g" 
				   onclick="calcperson('#Period.CalculationId#','#Contract.ContractId#','#period.mission#','0')">	   
		<cfelse>
			<input type="button" 
			       name="Final" 
				   value="Calculate" 
				   class="button10g" 
				   onclick="calcperson('#Period.CalculationId#','#Contract.ContractId#','#period.mission#','1')">
		</cfif>
	
	</cfif>
	
	</td>
	</tr>
	
	<tr class="hide" id="d#currentrow#">
	     <td id="i#currentrow#" colspan="9"></td>
    </tr>

</cfoutput>

</table>	