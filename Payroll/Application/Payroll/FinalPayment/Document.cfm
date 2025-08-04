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

<cfparam name="components" default="'FirstLangAllow','SecLangAllow'">
<cfparam name="correction" default="PostAd">
<cfparam name="actionlogging" default="0">

<cfparam name="url.WParam" default="Final">

<cfoutput>
<script>
	function applyfinalpayment() {
	    _cf_loadingtexthtml='';		    
		ptoken.navigate('#session.root#/Payroll/Application/Payroll/FinalPayment/DocumentSubmit.cfm?action=embed','result','','','POST','formembed')
	}
</script>
</cfoutput>

<cfquery name="get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   EmployeeSettlement	
    WHERE  SettlementId = '#Object.ObjectKeyValue4#'	
</cfquery>	

<cfquery name="clean" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM PersonMiscellaneous	
    WHERE  PersonNo = '#get.PersonNo#'
	AND    Source = 'Final'
	AND    (SourceId != '#Object.ObjectKeyValue4#' AND SourceId is not NULL)	   	
	AND    DocumentDate = '#get.PaymentDate#'
</cfquery>	

<cfquery name="Schedule" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   SalarySchedule	
    WHERE  SalarySchedule = '#get.SalarySchedule#'	
</cfquery>	

<cfquery name="Document" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   PersonMiscellaneous	
    WHERE  SourceId = '#Object.ObjectKeyValue4#'	
</cfquery>	

<cfset cell = "padding:0px;border-right:1px solid silver">
<cfset cont = "padding:0px;border-right:1px solid silver;text-align:center;font-size:15px">
<cfset con2 = "padding:0px;border-right:1px solid silver;text-align:center;font-size:12px">
<cfset head = "height:24px;color:gray;padding-left:10px;font-size:14px;font-weight:200;background-color:eaeaea">
<cfset lbl  = "padding-left:10px;background-color:fafafa">

<cfoutput>

<table width="100%" align="center">

<cfif actionLogging eq "0">
	
	<tr><td>
		<cfset url.id = get.Personno>
		<cfset openmode   = "close">
		<cfset url.header = "0">	
		<cfinclude template="../../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">	
	</td></tr>

</cfif>

<!--- period --->

<cfquery name="get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   EmployeeSettlement	
    WHERE  SettlementId = '#Object.ObjectKeyValue4#'	
</cfquery>	

<!--- EOD date --->

<cfquery name="SeparationDate" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT   TOP 1 *
		FROM     PersonContract
		WHERE    PersonNo        = '#get.PersonNo#' 
		AND      Mission         = '#get.Mission#' 
		AND      ActionStatus    = '1' 		
		AND      DateExpiration <=  '#get.PaymentDate#'
		ORDER BY DateEffective DESC	
</cfquery>

<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	    Method          = "getEOD"
	    PersonNo        = "#get.PersonNo#"
		Mission         = "#get.Mission#"
		SelDate         = "#dateformat(get.PaymentDate,client.dateformatshow)#"
	    ReturnVariable  = "EOD">   <!--- this obtains the current EOD of this action --->	
		
<cfset min = EOD>		

<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	    Method          = "getEOD"
	    PersonNo        = "#get.PersonNo#"
		Mission         = "#get.Mission#"		
	    ReturnVariable  = "EODNext">	<!--- this obtains the last EOD --->
 
<!--- date expiration ---> 

<cfif EODNext lte EOD>
	
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
		
	<cfset balancestatus = "0">
	
<cfelse>

	<cfquery name="getPeriod" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      Employee.dbo.PersonContract
		WHERE     PersonNo          = '#get.PersonNo#' 
		AND       SalarySchedule    = '#get.SalarySchedule#' 
		AND       Mission           = '#get.Mission#' 
		AND       ActionStatus      = '1' 
		AND       HistoricContract != '1'	
		AND       DateEffective < '#EODNext#'		        
		ORDER BY  DateEffective DESC		
	</cfquery>	
	
	<cfif getPeriod.recordcount neq "0">
		<cfset max = getPeriod.DateExpiration>
	<cfelse>
		<cfset max = get.PaymentDate>
	</cfif>
	
	<cfset balancestatus = "1">

</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(min,CLIENT.DateFormatShow)#">
<cfset min = dateValue>

<CF_DateConvert Value="#DateFormat(max,CLIENT.DateFormatShow)#">
<cfset max = dateValue>		

<cfquery name="get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   EmployeeSettlement	
    WHERE  SettlementId = '#Object.ObjectKeyValue4#'	
</cfquery>	

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
			
<cfelse>
		
		<table align="center"><tr><td class="labellarge" style="font-size:21px;padding-top:50px" align="center">No scales found for #getContract.ContractLevel# / #getContract.ContractStep# </td></tr></table>
		<cfabort>
	
</cfif>

<tr><td align="center" style="padding-left:14px;padding-right:14px;padding-bottom:10px;padding-top:3px">
	
	<table width="100%" style="border:0px solid silver">
	
		<!--- -------------------- --->
		<!--- ---Salary reference- --->
		<!--- -------------------- --->
		
		<tr class="line" style="padding-left:10px">
		   <td style="padding-left:1px;font-size:18px;height:25px" class="labelmedium">Final Payment Assistant</td>
		</tr>	
		
			
		<tr class="line" class="labelmedium">
		
			<td style="padding:0px">
										
				<table width="100%" class="formpadding">
				
					<tr class="labelit line" style="background-color:eaeaea;border-top:0px solid silver;border-left:0px solid silver">
						<td style="#con2#;width:15%"><cf_tl id="Element"></td>
						<td style="#con2#;width:12%"><cf_tl id="Year"></td>
						<td style="#con2#;width:12%"><cf_tl id="Month"></td>
						<td style="#con2#;width:12%"><cf_tl id="Week"></td>
						<td style="#con2#;width:12%"><cf_tl id="Day"></td>
						<td style="#con2#;width:10%"><cf_tl id="Hour"></td>
						<td style="#con2#;width:10%"><cf_tl id="Overtime"><font size="1">1.5</td>
						<td style="#con2#;width:10%"><cf_tl id="Overtime"><font size="1">2.0</td>
					</tr>
					<cfif amt eq "">
					   <cfset amt = 0>
					</cfif>
					<cfset amtY        = amt>
					<cfset amtM        = amt/12>
					<cfset amtW        = amt/52.2>
					<cfset amtD        = amt/(12*21.75)> 					
					<cfset amtH        = amt/(12*21.75*8)> 
					
					<cfset rateM = amtM>
					<cfset rateW = amtW>
					<cfset rateD = amtD>
					
					<tr class="labelmedium" style="background-color:C0F1C1;border-left:0px solid silver">
					    <td style="#cont#"><cf_tl id="Net Salary">in #cur#</td>
						<td style="#cont#">#numberformat(amtY,',.__')#</td>
						<td style="#cont#">#numberformat(amtM,',.__')#</td>
						<td style="#cont#">#numberformat(amtW,',.__')#</td>
						<td style="#cont#">#numberformat(amtD,',.__')#</td>
						<td style="#cont#">#numberformat(amtH,',.__')#</td>
						<td style="#cont#">#numberformat((amtH*1.5),',.__')#</td>
						<td style="#cont#">#numberformat((amtH*2.0),',.__')#</td>						
					</tr>		
					
					<cfif adjust neq "0">
					
					<tr class="labelit" style="border-top:1px solid silver;background-color:ffffcf;border-left:0px solid silver">
					    <td style="#con2#">+ #adjust#%</td>
						<td style="#con2#">#numberformat(amtY*adjust/100,',.__')#</td>
						<td style="#con2#">#numberformat(amtM*adjust/100,',.__')#</td>
						<td style="#con2#">#numberformat(amtW*adjust/100,',.__')#</td>
						<td style="#con2#">#numberformat(amtD*adjust/100,',.__')#</td>
						<td style="#con2#">#numberformat(amtH*adjust/100,',.__')#</td>
						<td style="#con2#"></td>
						<td style="#con2#"></td>						
					</tr>							
					
					</cfif>
					
					<cfset dayrate = amtD + (amtD*adjust/100)>
																			
					<!--- check if this person has language entitlement until the expiration date --->
					
					<cfquery name="getAllowance" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   DISTINCT R.Code, R.Description
						FROM     PersonEntitlement PE 
						         INNER JOIN Ref_PayrollComponent R ON PE.SalaryTrigger = R.SalaryTrigger 
								 INNER JOIN SalaryScheduleComponent S ON PE.SalarySchedule = S.SalarySchedule 
									AND      PE.EntitlementGroup = S.EntitlementGroup
									AND      R.Code = S.ComponentName 
						WHERE    PersonNo              = '#get.PersonNo#' 
						AND      PE.SalarySchedule     = '#get.SalarySchedule#' 
						AND      PE.SalaryTrigger     IN (#preservesinglequotes(components)#)      
						AND      PE.DateEffective     <= #max# 
						AND      (PE.DateExpiration IS NULL OR PE.DateExpiration >= #max#)
						AND      Status != '9'						
					</cfquery>
					
					<cfloop query="getAllowance">
					
						<cfquery name="getRate" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      SalaryScaleLine SL 
						    WHERE     SL.ScaleNo = #getScale.ScaleNo# 
							AND       SL.ServiceLevel = '#getContract.ContractLevel#' 
							AND       SL.ServiceStep  = '#getContract.ContractStep#' 
							AND       SL.ComponentName = '#Code#'
						</cfquery>		
				
						<cfset cur = getRate.currency>
						<cfset amt = getRate.Amount>
						
						<cfset amtY = amt>
						<cfset amtM = amt/12>
						<cfset amtW = amt/52.1>
						<cfset amtD = amt/(12*21.75)> 
												
						<cfset dayrate = dayrate + amtD>
																		
						<cfset amtH = amt/(12*21.75*8)> 
						
						<cfset rateM = rateM + amtM>
						<cfset rateW = rateW + amtW>
						<cfset rateD = rateD + amtD>
										
						<!--- ------------------- --->					
						<!--- show language rates --->
						<!--- ------------------- --->
						
						<tr class="labelmedium" style="background-color:C0F1C1;border-top:1px solid silver">
						    <td style="#cont#"><cf_tl id="Language"></td>
							<td style="#cont#"><font size="1">#cur#</font> #numberformat(amtY,',.__')#</td>
							<td style="#cont#"><font size="1">#cur#</font> #numberformat(amtM,',.__')#</td>
							<td style="#cont#"><font size="1">#cur#</font> #numberformat(amtW,',.__')#</td>
							<td style="#cont#"><font size="1">#cur#</font> #numberformat(amtD,',.__')#</td>
							<td style="#cont#"><font size="1">#cur#</font> #numberformat(amtH,',.__')#</td>
							<td style="#cont#"><font size="1">#cur#</font> #numberformat((amtH*1.5),',.__')#</td>
							<td style="#cont#"><font size="1">#cur#</font> #numberformat((amtH*2.0),',.__')#</td>						
						</tr>							
						
					</cfloop>											
				
				</table>	
			</td>
			
		</tr>
								
		<cfif url.wparam eq "Retention">		
					
			<tr  bgcolor="FFDFFF" class="line" class="labelmedium">
			
				<td style="padding-left:10px">
				
				<cfquery name="getEntitlement" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   SL.Currency, S.SalarySchedule, SUM(SL.PaymentAmount) AS Entitlement 
						FROM     EmployeeSalary AS S 
						         INNER JOIN EmployeeSalaryLine AS SL 
								           ON  S.SalarySchedule = SL.SalarySchedule 
										   AND S.PayrollStart   = SL.PayrollStart 
										   AND S.PersonNo       = SL.PersonNo 
										   AND S.Mission        = SL.Mission 
										   AND S.PayrollCalcNo  = SL.PayrollCalcNo 
								 INNER JOIN Ref_PayrollItem ON SL.PayrollItem = Ref_PayrollItem.PayrollItem AND Ref_PayrollItem.Settlement = 1								 
						WHERE    S.PersonNo   = '#get.PersonNo#' 
						AND      S.PayrollEnd = '#get.PaymentDate#'
						AND      S.Mission    = '#get.Mission#'
						AND      SL.PayrollItem NOT IN (SELECT   PayrollItem
													    FROM     Ref_PayrollGroupItem
													    WHERE    Code IN ('Final', 'Recovery', 'Retention')) AND SL.PayrollItem != 'A55'
						AND      Ref_PayrollItem.Source != 'Contribution' 		
						AND      SL.Currency = '#cur#'
															
						GROUP BY SL.Currency,  S.SalarySchedule
				</cfquery>			
				
				<table>
				
				<cfloop query="getEntitlement">
				
					<cfquery name="getDays" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   SUM(SalaryDays) AS Days 
							FROM     EmployeeSalary 
							WHERE    PersonNo       = '#get.PersonNo#' 
							AND      PayrollEnd     = '#get.PaymentDate#'	
							AND      Mission        = '#get.Mission#'					
							AND      SalarySchedule = '#salaryschedule#'
					</cfquery>
					
					<cfquery name="Schedule" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     SalarySchedule  
							WHERE    SalarySchedule = '#SalarySchedule#'						
					</cfquery>
					
					<!---
					<cfset amt = Entitlement * (Schedule.SalaryBasePeriodDays/getDays.Days)>
					--->
					
					<cfset amt = Entitlement>
					
					<tr style="height:35px" class="labellarge">
					    <td style="padding-left:0px;font-size:15px">Entitlement for this month:</td>
						<td style="padding-left:10px;font-size:15px">#Currency#</td>
						<td style="padding-left:5px;font-size:15px" align="right">#numberformat(amt,',.__')#</td>
						<td style="padding-left:15px;font-size:15px" align="right">Proposed retention 20% -> </td>
						<td style="padding-left:20px;font-size:18px" align="right"><font color="0B8EDD">#Currency#&nbsp;<b>#numberformat(amt*0.20,',.__')#</td>					
					</tr>
				
				</cfloop>
				
				</table>
				
				</td>
			
			</tr>
			
			<input type="hidden" name="Expiration" value="#dateformat(max,client.dateformatshow)#">
			
		
		<cfelse>
	
			<!---
			<tr class="line" style="#lbl#">
			   <td class="labellarge" style="#head#">Service</td>
		    </tr>
			--->	
			
			<cfquery name="getLWOP" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     PersonLeave
				WHERE    LeaveType IN (SELECT    LeaveType
		                               FROM      Ref_LeaveType
		                               WHERE     Leaveparent = 'LWOP') 
				AND      PersonNo       = '#get.PersonNo#' 
				AND      DateEffective  <= #max# 
				AND      DateExpiration >= #min#
				AND      Status NOT IN ('8','9')
			</cfquery>
		
			<tr class="line" class="labelmedium">
			
				<cfset slwop = "FED7CF">
					
				<td style="padding:0px">
				
					<table width="100%" class="formpadding">
					<tr class="labelit line" style="height:20px;border-top:0px solid silver;border-left:0px solid silver">
						<td style="width:20%;padding:3px;#cell#" align="center"><cf_tl id="Employment Period"></td>						
						<td style="width:15%;padding:3px;#cell#" align="center"><cf_tl id="Duration"></td>
						<td style="width:30%;padding:3px;#cell#;background-color:#slwop#" align="center"><cf_tl id="SLWOP"></b></td>
						<td style="width:15%;padding:3px;#cell#" align="center"><cf_tl id="Correction"></td>		
						<td style="width:15%;padding:3px;#cell#" align="center"><cf_tl id="Leave Balance"></td>	
					</tr>
					<!--- content --->
					<tr class="labelmedium" style="border-left:0px solid silver">
						<td style="padding:0px">
						
						<table width="100%" height="100%">					
								<tr class="labelmedium line" style="height:50%;">
									<td style="width:23%;#cell#;padding-left:9px"><cf_tl id="EOD"></td>
									<td style="#cont#;font-size:18px" align="center">#dateformat(min,client.dateformatshow)#</td>
																	
								</tr>
								<tr class="labelmedium" style="height:50%">
									<td style="width:23%;#cell#;padding-left:9px"><cf_tl id="COB"></td>
									<td style="#cont#;font-size:18px" align="center">#dateformat(max,client.dateformatshow)#
									<input type="hidden" name="Expiration" value="#dateformat(max,client.dateformatshow)#">
									</td>
								</tr>
						</table>		
						
						</td>
						
						<!--- duration --->
											
						<cfset mt  = datediff("m", min,max)>
						
						<cfset yr = int(mt/12)>
						<cfset mt = mt - (yr*12)>
						
						<cfif day(min) lte day(max)>
							<cfset dte1=createdate(year(min),month(min),1)>
							<cfset dte = createdate(year(min),month(min),day(DaysInMonth(dte1)))>
						<cfelse>
						    <cfif month(min) eq "12">
								<cfset dte1 = createdate(year(min)+1,1,1)>
							    <cfset dte  = createdate(year(min)+1,1,day(DaysInMonth(dte1)))>
							<cfelse>
								<cfset dte1 = createdate(year(min),month(min)+1,1)>
							    <cfset dte  = createdate(year(min),month(min)+1,day(DaysInMonth(dte1)))>
							</cfif>
						</cfif> 
							
						<cfset dy = datediff("d",min,dte)+1>
											
						<td style="padding:0px">
						
							<table width="100%" height="100%">					
								<tr class="labelmedium line" style="">
									<td style="width:53%;#cell#;padding-left:6px"><cf_tl id="Year"></td>
									<td style="width:33%;#cont#;background-color:e4f4f4">#yr#</td>
								</tr>	
								<tr class="labelmedium line" style="background-color:ffffff">
									<td style="#cell#;padding-left:6px"><cf_tl id="Month"></td>
									<td style="#cont#;background-color:e4f4f4">#mt#</td>
								</tr>	
								<tr class="labelmedium line" style="background-color:ffffff">
									<td style="#cell#;padding-left:6px"><cf_tl id="Day"></td>
									<td style="#cont#;background-color:e4f4f4">#dy#</td>
								</tr>	
								<cfset day  = datediff("d", min,max)+1>
								<tr class="labelmedium" style="background-color:ffffff">
									<td style="#cell#;padding-left:6px"><cf_tl id="Total days"></td>
									<td style="#cont#;background-color:ffffaf">#day#</td>
								</tr>	
															
							</table>								
						
						</td>
						
						<!--- SLWOP --->
						
						<td style="padding:0px">					
											
							<table width="100%" height="100%">					
								<tr class="labelmedium line" style="height:20px;background-color:#slwop#">
									<td style="width:33%;padding:3px;#cont#"><cf_tl id="Start"></td>
									<td style="width:33%;padding:3px;#cont#"><cf_tl id="End"></td>
									<td style="width:33%;padding:3px;#cont#"><cf_tl id="Days"></td>					
								</tr>
								<cfset daycor = 0>
								<cfloop query="getLWOP">
								    <cfset daycor = daycor + DaysLeave>
									<tr class="<cfif currentrow neq recordcount>line</cfif> labelmedium" style="height:80%">
									<td style="#cont#;font-size:16px" align="center">#dateformat(dateEffective,client.dateformatshow)#</td>
									<td style="#cont#;font-size:16px" align="center">#dateformat(dateExpiration,client.dateformatshow)#</td>
									<td	style="#cont#;font-size:16px;padding-right:5px">#DaysLeave#</td>
									</tr>
								</cfloop>
							</table>					
						
						</td>
						
						<!--- correction --->
						
						<td style="padding:0px">
											
							<table width="100%" height="100%">					
								<tr class="labelmedium line" style="">
									<td style="width:53%;#cell#;padding-left:6px"><cf_tl id="Year"></td>
									<td style="width:33%;#cont#;background-color:e4f4f4">-<!---#yr#---></td>
								</tr>	
								<tr class="labelmedium line" style="background-color:ffffff">
									<td style="#cell#;padding-left:6px"><cf_tl id="Month"></td>
									<td style="#cont#;background-color:e4f4f4">-<!---#mt#---></td>
								</tr>	
								<tr class="labelmedium line" style="background-color:ffffff">
									<td style="#cell#;padding-left:6px"><cf_tl id="Day"></td>
									<td style="#cont#;background-color:e4f4f4">-<!---#dy#---></td>
								</tr>	
								<cfset day  = datediff("d", min,max)+1>
								<cfset day = day - daycor>
								<tr class="labelmedium" style="background-color:ffffff">
									<td style="#cell#;padding-left:6px"><cf_tl id="Total days"></td>
									<td style="#cont#;background-color:ffffaf">#day#</td>
								</tr>	
															
							</table>								
											
						</td>					
						
						<td style="padding:0px;min-width:190px">
						
							<!--- calculate the leave again --->
							
							<cfinclude template="setLeaveBalance.cfm">
																										
							<cfquery name="getLeave" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  ISNULL(SUM(ISNULL(Balance,0)),0) as Balance
								FROM    PersonLeaveBalance
								WHERE   PersonNo      = '#get.PersonNo#' 
								AND     Mission       = '#get.Mission#'
								AND     BalanceStatus = '#balancestatus#'
								AND     DateExpiration = #max# 
								AND     LeaveType IN (SELECT LeaveType
		                				              FROM   Ref_LeaveType
						                              WHERE  EnablePayroll = 1)  
													  
							</cfquery>
							
							<cfquery name="exist" 
									datasource="AppsPayroll" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">		
									    SELECT * 
										FROM   PersonMiscellaneous
										WHERE  PersonNo    = '#get.PersonNo#' 
										AND    Sourceid    = '#get.SettlementId#'		
										AND    PayrollItem = 'A55'		<!--- hardcoded for annual leave compensation --->
									</cfquery>
																				
							<table width="100%" height="100%">	
											
								<tr class="labelmedium line">
									<td style="width:40%;#cell#;padding-left:6px"><cf_tl id="Days"></td>
									<td colspan="2" style="width:60%;#cont#;background-color:e4f4f4">
									<cfif exist.quantity eq "">
									<input type="text" name="Quantity_A55" class="regularxl" value="#getLeave.Balance#" onchange="applyfinalpayment()" style="text-align:right;padding-right:7px;border:1px solid silver">
									<cfelse>
									<input type="text" name="Quantity_A55" class="regularxl" value="#exist.quantity#" onchange="applyfinalpayment()" style="text-align:right;padding-right:7px;border:1px solid silver">
									</cfif>
									</td>
								</tr>	
								<tr class="labelmedium" style="background-color:ffffff">
									<td style="#cell#;padding-left:6px;min-width:80px;"><cf_tl id="Rate"></td>	
									<td style="#cell#;text-align:center;min-width:60px;padding-left:6px"><font size="1">#cur#</font></td>							
									<td style="#cont#;background-color:ffffaf;font-size:20px">
									
									<input type="hidden" name="PayrollItem"  value="'A55'">
									<input type="hidden" name="Memo_A55"     value="">
									<input type="hidden" name="Currency_A55" value="#cur#">									
									<input type="hidden" name="Rate_A55"     value="#round(dayrate*100)/100#">		
									
									#round(dayrate*100)/100#
									
									<!---							
									
									<cfif exist.amount eq "">
									
										<input name="Amount_A55" type="text" style="padding-right:7px;font-size:26px;height:60px;border:1px solid silver" class="regularxl amount enterastab" 
										value="#numberformat(getLeave.Balance*dayrate,',.__')#" onchange="applyfinalpayment()">
										
									<cfelse>
									
										<input name="Amount_A55" type="text"  style="padding-right:7px;font-size:26px;height:60px;border:1px solid silver" class="regularxl amount enterastab" 
										value="#numberformat(exist.amount,',.__')#" onchange="applyfinalpayment()">
										
									</cfif>
									
									--->	
									
									</td>
								</tr>	
																							
							</table>	
						
						</td>
					</tr>
					
					</table>
				</td>
			
			</tr>
			
		</cfif>	
		
		<!--- -------------------- --->
		<!--- ----Retention------- --->
		<!--- -------------------- --->									
		
		<tr class="line" class="labelmedium">
			
			<td style="padding:1px">
			
				<cfquery name="Currency" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT    DISTINCT PaymentCurrency as Currency
					FROM      SalarySchedule					
				</cfquery>
		
				<cfquery name="Entitlement" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT    *
					FROM      Ref_PayrollItem
					WHERE     1=1
					--Source = 'Miscellaneous' 
					AND       PayrollItem IN (SELECT PayrollItem FROM Ref_PayrollGroupItem WHERE Code = 'Retention')					
				</cfquery>
				
				<table width="100%" class="formpadding">
				
					<tr class="line" style="background-color:f1f1f1;height:14px;border-top:1px solid silver;border-left:1px solid silver">
						<td style="#cell#;min-width:400px;padding-left:10px"><cf_tl id="Description"></td>
						<td style="#cell#;width:60%"><cf_tl id="Memo"></td>
						<td style="#cell#;min-width:70"></td>						
						<td style="#cell#;min-width:180px"><cf_tl id="Amount"></td>
					</tr>
					
					<cfloop query="Entitlement">
										
						<cfquery name="exist" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						    SELECT * 
							FROM   PersonMiscellaneous
							WHERE  PersonNo = '#get.PersonNo#' 
							AND    Sourceid = '#get.SettlementId#'		
							AND    PayrollItem = '#payrollitem#'					
						</cfquery>
						
						<tr class="labelmedium line" style="border-left:1px solid silver">
							<td style="#cell#;min-width:260;padding-left:10px">#PayrollItemName#
							<input type="hidden" name="PayrollItem" value="'#PayrollItem#'">
							</td>	
												
							<td style="#cell#;background-color:DAF9FC;">
							<input name="Memo_#PayrollItem#"   type="text" class="regularxl enterastab" value="#exist.remarks#"  style="width:98%;background-color:transparent;border:0px;padding-left:5px">
							</td>		
							<td style="#cell#;background-color:DAF9FC;min-width:50px">
							<select name="Currency_#PayrollItem#" class="regularxl enterastab" style="width:94%;background-color:transparent;border:0px;;font-size:14px">
							<cfloop query="Currency">
							    <cfif exist.recordcount eq "0">
								    <option value="#Currency#" <cfif schedule.paymentcurrency eq currency>selected</cfif>>#Currency#</option>
								<cfelse>
									<option value="#Currency#" <cfif exist.currency eq currency>selected</cfif>>#Currency#</option>
								</cfif>
							</cfloop>
							</select>
							</td>				
							<td style="#cell#;background-color:DAF9FC;min-width:392px">
							<cfif exist.amount eq "">
							<input name="Amount_#PayrollItem#" type="text" class="regularxl amount enterastab" 
								value="#numberformat(0,',.__')#" onchange="applyfinalpayment()"
								style="border:0px;background-color:transparent;padding-right:3px;width:100%">
							<cfelse>
							<input name="Amount_#PayrollItem#" type="text" class="regularxl amount enterastab" 
								value="#numberformat(exist.amount,',.__')#" onchange="applyfinalpayment()"
								style="border:0px;background-color:transparent;padding-right:3pxwidth:100px">
							</cfif>	
							</td>
						</tr>		
						
					</cfloop>
				
				</table>
		
			</td>
				
		</tr>
					
		
		<!--- -------------------- --->
		<!--- ----Cost recovery--- --->
		<!--- -------------------- --->
		
		<cfif url.wparam eq "Final" or url.wparam eq "recovery">
						
			<tr class="line" style="#lbl#">
			   <td style="#head#" class="labellarge"><cf_tl id="Cost recovery"></td>
			</tr>
					
			<tr class="line" class="labelmedium">
			
				<td style="padding:1px">
				
					<cfquery name="Currency" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT    DISTINCT PaymentCurrency as Currency
						FROM      SalarySchedule					
					</cfquery>
			
					<cfquery name="Entitlement" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT    *
						FROM      Ref_PayrollItem
						WHERE     PayrollItem IN (SELECT PayrollItem FROM Ref_PayrollGroupItem WHERE Code = 'Recovery')					
					</cfquery>
					
					<table width="100%" class="formpadding">
					
						<tr class="labelit line" style="background-color:f1f1f1;height:14px;border-top:1px solid silver;border-left:1px solid silver">
							<td style="#cell#;width:1%;min-width:400px;padding-left:10px"><cf_tl id="Description"></td>
							<td style="#cell#;width:60%"><cf_tl id="Memo"></td>
							<td style="#cell#;min-width:70"></td>						
							<td style="#cell#;min-width:180px"><cf_tl id="Amount"></td>
						</tr>
						
						<cfloop query="Entitlement">
											
							<cfquery name="exist" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
							    SELECT * 
								FROM   PersonMiscellaneous
								WHERE  PersonNo = '#get.PersonNo#' 
								AND    Sourceid = '#get.SettlementId#'		
								AND    PayrollItem = '#payrollitem#'					
							</cfquery>
							
							<tr class="labelmedium line" style="border-left:1px solid silver">
								<td style="#cell#;min-width:260;padding-left:10px">#PayrollItemName#
								<input type="hidden" name="PayrollItem" value="'#PayrollItem#'">
								</td>	
													
								<td style="#cell#;background-color:DAF9FC;">
								<input name="Memo_#PayrollItem#"   type="text" class="regularxl enterastab" value="#exist.remarks#"  style="width:98%;background-color:transparent;border:0px;padding-left:5px">
								</td>		
								<td style="#cell#;background-color:DAF9FC;min-width:50px">
								<select name="Currency_#PayrollItem#" class="regularxl enterastab" style="width:94%;background-color:transparent;border:0px;;font-size:14px">
								<cfloop query="Currency">
								    <cfif exist.recordcount eq "0">
									    <option value="#Currency#" <cfif schedule.paymentcurrency eq currency>selected</cfif>>#Currency#</option>
									<cfelse>
										<option value="#Currency#" <cfif exist.currency eq currency>selected</cfif>>#Currency#</option>
									</cfif>
								</cfloop>
								</select>
								</td>				
								<td style="#cell#;background-color:DAF9FC;min-width:392px">
								<cfif exist.amount eq "">
								<input name="Amount_#PayrollItem#" type="text" class="regularxl amount enterastab" 
									value="#numberformat(0,',.__')#" onchange="applyfinalpayment()"
									style="border:0px;background-color:transparent;padding-right:3px;width:100%">
									
								<cfelse>
								
								<input name="Amount_#PayrollItem#" type="text" class="regularxl amount enterastab" 
									value="#numberformat(exist.amount,',.__')#" onchange="applyfinalpayment()"
									style="border:0px;background-color:transparent;padding-right:3px;width:100%">
									
								</cfif>	
								</td>
							</tr>		
							
						</cfloop>
					
					</table>
			
				</td>
				
			</tr>
			
		</cfif>	
						
		<!--- --------------------- --->
		<!--- --- Repatriation ---- --->
		<!--- --------------------- --->
		
		<cfquery name="getDependent" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      PersonDependentEntitlement
					WHERE     PersonNo = '#get.PersonNo#'
					AND       DateExpiration >= #max#
					AND       Status IN ('1','2')       
					AND       SalaryTrigger IN (SELECT SalaryTrigger 
					                            FROM   Ref_PayrollTrigger 
												WHERE  TriggerGroup IN ('Allowance','Entitlement')
												)
		</cfquery>
				
		<cfquery name="getCategory" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  P.Description
				FROM    Ref_PostGrade R INNER JOIN
                        Ref_PostGradeParent P ON R.PostGradeParent = P.Code
				WHERE   R.PostGrade = '#getContract.ContractLevel#'
		</cfquery>		
			
		
		<cfif url.WParam eq "Final">		 
		
			<tr class="line" style="#lbl#">
			   <td style="#head#" class="labellarge"><cf_tl id="Separation entitlements">
			   
			   <font color="808080">
			   | #getCategory.Description#
				 	   
			   | <cfif getDependent.recordcount gte "1">
			         <cf_tl id="Dependent">
				 <cfelse>
				     <cf_tl id="Single">
				 </cfif>
				 
				 <cfif getAllowance.recordcount gte "1">
				 | <cf_tl id="Language Allowance">
				 </cfif>
			   
			   </td>
		    </tr>
		
			<tr class="line" class="labelmedium">
			
				<td style="padding:1px">
			
					<cfquery name="Entitlement" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT    *
						FROM      Ref_PayrollItem R 
						          INNER JOIN Ref_PayrollGroupItem I ON I.PayrollItem = R.PayrollItem
						WHERE     I.Code = 'Final'					
					</cfquery>
					
					<table width="100%" class="formpadding">
					
						<tr class="labelit line" style="background-color:f1f1f1;height:14px;border-top:1px solid silver;border-left:1px solid silver">
							<td style="#cell#;width:1%;min-width:400px;padding-left:10px"><cf_tl id="Description"></td>
							<td style="#cell#;width:80%"><cf_tl id="Memo"></td>						
							<td style="#cell#;min-width:60"></td>
							<td style="#cell#;width:1%;min-width:100"><cf_tl id="Rate"></td>
							<td style="#cell#;width:1%;min-width:50"><cf_tl id="Qty"></td>
							<td style="#cell#;width:1%;min-width:180"><cf_tl id="Amount"></td>
						</tr>
						
						<cfloop query="Entitlement">
						
							<cfif pointer eq "Day">
							
								<cfset rate = rateD>
								
							<cfelseif pointer eq "Month">
							
								<cfset rate = rateM>	
								
							<cfelse>
							
								<cfset rate = rateW>
							
							</cfif>
						
							<cfquery name="exist" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
							    SELECT * 
								FROM   PersonMiscellaneous
								WHERE  PersonNo    = '#get.PersonNo#' 
								AND    Sourceid    = '#get.SettlementId#'		
								AND    PayrollItem = '#payrollitem#'			
							</cfquery>
													
							<tr class="labelmedium line" style="height:20px;border-left:1px solid silver">
								<td style="#cell#;padding-left:10px">#PayrollItemMemo# (#pointer#)
								<input type="hidden" name="PayrollItem" value="'#PayrollItem#'">
								</td>
								<td style="#cell#;background-color:DAF9FC;">
								<input name="Memo_#PayrollItem#" type="text" value="#exist.remarks#" class="regularxl enterastab" style="width:98%;background-color:transparent;border:0px;padding-left:5px">
								</td>													
								
								<td style="#cell#;background-color:DAF9FC;min-width:50px">
									<select name="Currency_#PayrollItem#" onchange="applyfinalpayment()" class="regularxl enterastab" style="width:100%;background-color:transparent;border:0px;;font-size:14px">
									<cfloop query="Currency">
									   <cfif exist.recordcount eq "0">
									    <option value="#Currency#" <cfif schedule.paymentcurrency eq currency>selected</cfif>>#Currency#</option>
									   <cfelse>
										<option value="#Currency#" <cfif exist.currency eq currency>selected</cfif>>#Currency#</option>
									   </cfif>
									</cfloop>
									</select>
								</td>	
								
								<td style="#cell#;background-color:DAF9FC;">															
								
								    <cfif exist.recordcount eq "0">
									
										<cfif PayrollItem eq "M11">
									
										 <cfif getDependent.recordcount gte "1">
										 	 <cfset rt = "18000">
										 <cfelse>
										     <cfset rt = "13000">								 
										 </cfif>	
										
										 <input name="Rate_#PayrollItem#" id="rate_#PayrollItem#" type="text" value="#numberformat(rt,',.__')#" 
											onchange="_cf_loadingtexthtml='';applyfinalpayment();ptoken.navigate('#session.root#/payroll/application/payroll/finalpayment/setamount.cfm?payrollitem=#payrollitem#&qty='+document.getElementById('quantity_#PayrollItem#').value+'&rate='+this.value,'total_#payrollitem#')"
											class="regularxl amount enterastab" style="border:0px;background-color:transparent;padding-right:3px">
										
										<cfelse>
										
											<cfif pointer eq "day">
											 	 <cfset rt = dayrate>											
											 <cfelse>
											     <cfset rt = rate>								 
											 </cfif>	
										
										    <input name="Rate_#PayrollItem#" id="rate_#PayrollItem#" type="text" value="#numberformat(rt,',.__')#" 
												onchange="_cf_loadingtexthtml='';applyfinalpayment();ptoken.navigate('#session.root#/payroll/application/payroll/finalpayment/setamount.cfm?payrollitem=#payrollitem#&qty='+document.getElementById('quantity_#PayrollItem#').value+'&rate='+this.value,'total_#payrollitem#')"
												class="regularxl amount enterastab" style="border:0px;background-color:transparent;padding-right:3px">
											
										</cfif>
									
									<cfelse>
									
									    <input name="Rate_#PayrollItem#" id="rate_#PayrollItem#" type="text" value="#numberformat(exist.rate,',.__')#" 
											onchange="_cf_loadingtexthtml='';applyfinalpayment();ptoken.navigate('#session.root#/payroll/application/payroll/finalpayment/setamount.cfm?payrollitem=#payrollitem#&qty='+document.getElementById('quantity_#PayrollItem#').value+'&rate='+this.value,'total_#payrollitem#')"
											class="regularxl amount enterastab" style="border:0px;background-color:transparent;padding-right:3px">
															
									</cfif>		
										
																	
								</td>
																	
								<td style="#cell#;background-color:DAF9FC;">
								
								    <cfif PayrollItem eq "M11">
									
									    <table>
										<tr class="labelmedium">
										<td>
										<select name="Quantity_#PayrollItem#" id="quantity_#PayrollItem#" class="regularxl enterastab"
										onchange="_cf_loadingtexthtml='';applyfinalpayment();ptoken.navigate('#session.root#/payroll/application/payroll/finalpayment/setamount.cfm?payrollitem=#payrollitem#&qty='+this.value+'&rate='+document.getElementById('rate_#PayrollItem#').value,'total_#payrollitem#')"								
										style="width:60;background-color:transparent;border:0px;text-align:center;font-size:14px">
											<option value="0">No</option>
											<option value="1">Yes</option>
										</select>
										
										</td>
																												
										</tr>
										</table>
									
									<cfelse>
									
									<input name="Quantity_#PayrollItem#" id="quantity_#PayrollItem#" class="regularxl enterastab" 
										onchange="_cf_loadingtexthtml='';applyfinalpayment();ptoken.navigate('#session.root#/payroll/application/payroll/finalpayment/setamount.cfm?payrollitem=#payrollitem#&qty='+this.value+'&rate='+document.getElementById('rate_#PayrollItem#').value,'total_#payrollitem#')"								
										style="width:94%;background-color:transparent;border:0px;text-align:center;font-size:14px" value="<cfif exist.quantity neq "">#exist.quantity#<cfelse>0</cfif>">										
									
									</cfif>
													    
								</td>		
																							
								<td style="#cont#;background-color:e3e3e3;text-align:right;padding-right:6px;font-size:14px" id="total_#payrollitem#">#numberformat(exist.amount,',.__')#</td>
								
							</tr>		
						</cfloop>
					
					</table>
			
				</td>
				
			</tr>
		
		</cfif>
		
		<tr class="line">
		   <td style="padding:0px" id="result">
		   
		   <table width="100%"><tr>
		          <td style="padding-right:19px;width:100%;border-right:1px solid silver;font-size:15px;padding-bottom:4px" valign="bottom" align="right" class="labellarge">Final payment corrections:</td>
				  <td style="padding:1px;height:100%">
					  <table height="100%">
					  <tr>
			               <td height="100%" style="height:30;min-width:240px">
						   
						   <cfquery name="myresult" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
  							  SELECT   Currency, R.PayrollItem, PrintDescriptionShort, SUM(Amount) AS Amount
							  FROM     PersonMiscellaneous P INNER JOIN Ref_PayrollItem R ON P.PayrollItem = R.PayrollItem
							  WHERE    PersonNo    = '#get.PersonNo#' 
							  AND      Sourceid    = '#get.SettlementId#'		
							  GROUP BY Currency, R.PayrollItem,PrintDescriptionShort 
  						   </cfquery>
						  
						   <table width="100%">
						   <cfloop query="myresult">
						     <tr class="labelmedium <cfif currentrow neq recordcount>line</cfif>">
							 <td style="padding-left:4px">#PrintDescriptionShort#</td>
							 <td>#Currency#</td>							 
							 <td align="right" style="font-size:15px;padding-right:5px">#numberformat(amount,',.__')#</td>
							 </tr>					  
						   </cfloop>		
						   </table>		
						   
						   </td>
					  </tr>
					  </table>
				  </td>
				  </tr>
		   </table>
		   </td>
	    </tr>
		
	</table>

</td></tr>

</table>

<input name="savecustom" type="hidden"  value="Payroll/Application/Payroll/FinalPayment/DocumentSubmit.cfm">
<input name="Key4"       type="hidden"  value="#Object.ObjectKeyValue4#">

</cfoutput>

<script>applyfinalpayment()</script>
 
 