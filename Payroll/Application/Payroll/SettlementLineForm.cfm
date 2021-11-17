
<!--- allow granual corrections --->

<cfquery name="Settlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     EmployeeSettlement E
	WHERE    E.SettlementId = '#URL.id#'		  
</cfquery>

<cfquery name="Payment" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     EmployeeSettlementLine E
	WHERE    E.PaymentId = '#URL.PaymentId#'		  
</cfquery>

<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	Method          = "getEOD"
	PersonNo        = "#settlement.personNo#"
	Mission         = "#settlement.mission#"
	ReturnVariable  = "EOD">	

<cfquery name="Period" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	SELECT    PayrollEnd
	FROM      SalarySchedulePeriod
	WHERE     Mission         = '#settlement.mission#' 
	AND       SalarySchedule  = '#settlement.salaryschedule#'
	AND       CalculationStatus = '3' 
	and       PayrollEnd >= '#eod#'
	AND       Payrollend <> '#settlement.paymentdate#'
</cfquery>

<form method="post" name="paymentamend">
	
	<table width="100%" class="formpadding formspacing">
	
		<tr class="labelmedium2"><td colspan="2">This function will not financially repost a prior payroll period if it was already closed and set as IN cycle.<br><br> Its SOLE purpose is to apply corrections in the payroll in order to correct current and/or future payment settlement calculations.<br></td></tr>
		<tr class="line"><td colspan="2"></td></tr>
		<tr class="labelmedium2">
		<td style="font-size:14px"><cf_tl id="Set as"></td>
		<td>
			<table><tr class="labelmedium"><td><input class="radiol" type="radio" name="PaymentStatus" value="0" <cfif settlement.paymentstatus eq "0">checked</cfif>></td>
		           <td><cf_tl id="IN Cycle"></td>
				   <td style="padding-left:4px"><input type="radio" class="radiol" name="PaymentStatus" value="1" <cfif settlement.paymentstatus eq "1">checked</cfif>></td>
				   <td><cf_tl id="OFF Cycle"></td>	
			</table>
		</td>		   	
		</tr>
		
		<tr class="labelmedium2">
		<td style="font-size:14px"><cf_tl id="Payment date"></td>
		<td>
		<select name="PaymentDate" class="regularxl" style="width:110px">
		<cfoutput query="Period">
		<option value="#PayrollEnd#" <cfif payment.payrollend eq payrollend>selected</cfif>>#dateformat(PayrollEnd,client.dateformatshow)#</option>
		</cfoutput>
		</select>
		
		</td>
		</tr>
		
		<cfif url.PrintGroup eq "Contributions">
			<cfset amt = Payment.Amount>
		<cfelse>
			<cfset amt = Payment.PaymentAmount>
		</cfif>
		
		<cfoutput>
		<tr class="labelmedium2">
			<td style="font-size:14px"><cf_tl id="Amount"></td>
			<td><input type="text" name="amount" class="regularxl" style="text-align:right;width:110px;padding-right:4px" value="#numberformat(amt,'.__')#"></td>
		</tr>
		
		<tr class="labelmedium2">
			<td style="font-size:14px"><cf_tl id="Memo"></td>
			<td><input type="text" name="memo" maxlength="20" class="regularxl" style="width:220px;padding-right:4px"></td>
		</tr>
		
		<tr class="line"><td style="height:7px" colspan="2"></td></tr>
		<tr><td colspan="2" style="padding-top:4px" align="center">
			<input type="button" value="Apply" style="width:120px" class="button10g"
			 onclick="ptoken.navigate('#session.root#/Payroll/Application/Payroll/setEmployeeSettlementLine.cfm?printgroup=#url.printgroup#&id=#url.id#&paymentid=#url.paymentid#&action=edit&box=#url.box#','#paymentid#','','','POST','paymentamend')">
			</td>
		</tr>
		</cfoutput>
	
	</table>

</form>