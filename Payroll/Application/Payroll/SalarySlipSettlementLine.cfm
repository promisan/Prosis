
<table width="100%" height="100%" align="center">
<tr>

<td height="100%" style="border:1px solid silver;padding:3px;background-color:f2f2f2">

<table width="99%" class="navigation_table" align="center">
	
	<tr>
		<td colspan="4" style="padding-top:3px;padding-left:3px">
		<table width="100%" align="center">
			<tr class="line">
				<td align="center" class="labelmedium" style="height:32px;font-size:15px;font-weight:normal">			
				<cf_tl id="Settlement details">
				</td>
			</tr>
		</table>
		</td>
	</tr>
	
	<cfquery name="get" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT      *
		FROM        EmployeeSettlement
		WHERE       SettlementId = '#url.id#'
	</cfquery>	
	
	<cfquery name="list" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT       *
		FROM         Ref_PayrollSource S2 INNER JOIN
	          		 Ref_PayrollItem S ON S2.Code = S.Source INNER JOIN
	           		 Ref_SlipGroup S1 ON S.PrintGroup = S1.PrintGroup LEFT OUTER JOIN
	           		 EmployeeSettlementLine E ON S.PayrollItem = E.PayrollItem
		WHERE        E.Mission        = '#get.Mission#'
		AND          E.SalarySchedule = '#get.SalarySchedule#'
		AND          E.PersonNo       = '#get.PersonNo#'
		AND          E.PaymentStatus  = '#get.PaymentStatus#'
		AND          E.PaymentDate    = '#get.PaymentDate#'
		AND          E.PayrollEnd     < '#get.PaymentDate#'
		AND          E.PayrollItem    = '#url.payrollitem#'
	</cfquery>
	
	<tr class="line labelmedium2 navigation_row">
		<td style="padding-left:4px"><cf_tl id="Period"></td>
		<td style="padding-left:4px"><cf_tl id="Currency"></td>
		<td align="right" style="padding-right:4px"><cf_tl id="Amount"></td>
		<td></td>
	</tr>
	
	<cfoutput query="list">
	
	<tr class="<cfif currentrow neq recordcount>line</cfif> labelmedium2 navigation_row" style="height:20px">
		<td style="padding-left:4px">#dateformat(PayrollEnd,client.dateformatshow)#</td>
		<td style="padding-left:4px">#Currency#</td>
		<td align="right" style="padding-right:5px" id="val#paymentid#"><cfif PrintGroup eq "Contributions">#NumberFormat(Amount,",.__")#<cfelse>#NumberFormat(PaymentAmount,",.__")#</cfif></td>
				
		<cfquery name="period" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			SELECT       *
			FROM         SalarySchedulePeriod
			WHERE        Mission        = '#get.Mission#'
			AND          SalarySchedule = '#get.SettlementSchedule#'			
			AND          PayrollEnd     = '#get.PaymentDate#'		
		</cfquery>		
		
		<cfif (get.PaymentStatus eq "0" and Period.calculationstatus neq "3") or
		      (get.PaymentStatus eq "1" and get.actionstatus neq "3")>
						
			<cfquery name="check" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT       *
				FROM         EmployeeSettlement
				WHERE        Mission        = '#get.Mission#'
				AND          SalarySchedule = '#get.SettlementSchedule#'
				AND          PersonNo       = '#get.PersonNo#'		
				AND          PaymentDate    = '#list.PayrollEnd#'		
			</cfquery>	
		
			<td id="#paymentid#" style="padding-left:5px;padding-top:2px">
			
				<table>
					<tr>					
						<td>|</td>
						<td>
						<cf_img icon="open" onclick="editsettlement('#url.id#','#paymentid#','#printgroup#','#url.box#')">
						</td>
						<td>|</td>								
						<td align="left" style="width:50px;padding-left:5px"><a href="javascript: if (confirm('Do you want to move this record ?')) { ptoken.navigate('setEmployeeSettlementLine.cfm?id=#url.id#&printgroup=#printgroup#&paymentid=#paymentid#&action=delete','#paymentid#')}"><cf_tl id="delete"></a></td>					
					</tr>
				</table>
				
			</td>
			
		<cfelse>
		
			<!---
		
			<td id="#paymentid#" style="padding-left:5px;padding-top:2px">
			
				<table>
					<tr>										
								
					<td align="left" style="width:50px;padding-right:4px"><a href="javascript:ptoken.navigate('setEmployeeSettlementLine.cfm?id=#url.id#&printgroup=#printgroup#&paymentid=#paymentid#&action=delete','#paymentid#')"><cf_tl id="delete"></a></td>
					
					</tr>
				</table>
				
			</td>	
			
			--->
		
		</cfif>
		
		
	</tr>
	
	</cfoutput>	

	<tr><td></td></tr>
	
</table>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>
