
<cfquery name="Years" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   DISTINCT Mission, EntitlementYear
	FROM     EmployeeSalary AS ES INNER JOIN
	                         EmployeeSalaryLine AS ESL ON ES.SalarySchedule = ESL.SalarySchedule AND ES.PayrollStart = ESL.PayrollStart AND ES.PersonNo = ESL.PersonNo AND 
	                         ES.PayrollCalcNo = ESL.PayrollCalcNo
	WHERE    ES.PersonNo = '#URL.ID#'
	ORDER BY EntitlementYear DESC
</cfquery>

<cfquery name="getPerson" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Person
	WHERE    PersonNo = '#URL.ID#'
</cfquery>

<table width="100%" style="height:100%" align="center"><tr><td class="clsPrintContent">

<cf_divscroll overflowy="scroll">

<table width="98%" align="center" border="0" class="navigation_table">

<cfif Years.recordcount eq "0">

<tr><td height="80" align="center" class="labelmedium">No entitlement records found for this employee</td></tr>

<cfelse>

<cfset prior = "">

<cfoutput query="Years">

	<cfinvoke component = "Service.Process.Employee.PersonnelAction"
		Method          = "getEOD"
		PersonNo        = "#url.id#"
		Mission         = "#mission#"
		ReturnVariable  = "EOD">	
		
	<cfquery name="Last" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      EmployeeSalary AS ES INNER JOIN
	              EmployeeSalaryLine AS ESL ON ES.SalarySchedule = ESL.SalarySchedule AND ES.PayrollStart = ESL.PayrollStart AND ES.PersonNo = ESL.PersonNo AND 
	              ES.PayrollCalcNo = ESL.PayrollCalcNo
	
		WHERE     ES.Mission = '#mission#'
		AND       ES.PersonNo = '#URL.ID#'
		AND       EntitlementYear = '#EntitlementYear#'
		ORDER BY  ES.PayRollStart DESC
	</cfquery>

	<tr class="line labelmedium fixrow">
	<td style="background-color:white;height:35px;font-size:25px;font-weight:200;padding-left:2px" colspan="5" align="left">		
	<b>#Mission# #EntitlementYear# <font size="2">(<cf_tl id="until">#dateformat(Last.PayrollStart,"MMMM")# )</font></b>	
	</td>
	
		<td align="right" colspan="2" style="background-color:white;padding-top:8px;padding-right:2px;" class="clsNoPrint">
		
			<cfif currentrow eq "1">
			
			    <table width="100%">
				
				<tr>		
				<td class="labellarge" style="background-color:white;min-width:80px;font-size:15px;padding-right:10px">
				<a href="javascript:ptoken.navigate('#session.root#/payroll/application/Payroll/EmployeeEntitlementEOD.cfm?id=#url.id#','contentbox1')"><cf_tl id="Show all years"> [#dateformat(EOD,client.dateformatshow)#]</a></td>		
				<td>|</td>
				<td align="right" style="background-color:white;padding-right:4px">
				
				<span id="printTitle" style="display:none;"><cf_tl id="Entitlements"> #EntitlementYear# : [#getPerson.indexNo#] #getPerson.fullName#</span>
				<cf_tl id="Print" var="1">
				<cf_button2 
					mode		= "icon"
					type		= "Print"
					title       = "#lt_text#" 
					id          = "Print"					
					height		= "20px"
					width		= "25px"
					imageHeight = "20px"
					printTitle	= "##printTitle"
					printContent = ".clsPrintContent">
					
				</td>
				</tr>
					
				</table>
			
			</cfif>
			
		</td>
		
	</tr>	
	
	<tr class="line labelmedium fixrow2">
	 <td style="top:33px"></td>
	 <td style="min-width:90%;top:33px" colspan="2"><cf_tl id="Item"></td>
	 <td style="top:33px" colspan="1"></td>
	 <td style="top:33px" colspan="1" width="50"></td>
	 <td style="top:33px" colspan="1" align="right" width="100"><cf_tl id="Entitlement"></td>
	 <td style="top:33px" colspan="1" align="right" width="140"><cf_tl id="Settled">#EntitlementYear#<cf_space spaces="40"></td>
	</tr>
	
	<cfquery name="Item" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   S.PayrollItem, 
				 S.PayrollItemName,
				 S.Source,
				 S.ComponentOrder
		FROM     Ref_PayrollItem S, Ref_PayrollSource R
		WHERE    S.Source = R.Code
		AND      PayrollItem IN (
		
								 SELECT PayrollItem 
		                         FROM   EmployeeSalaryLine E
								 WHERE  PersonNo          = '#URL.ID#'
								 AND    EntitlementYear   = '#EntitlementYear#'	
								 
								 UNION ALL
										
								 SELECT   PayrollItem 				
								 FROM     EmployeeSettlementLine  
								 WHERE    PersonNo    = '#URL.ID#'
								 AND      Mission     = '#mission#'
								 AND      PaymentYear = '#EntitlementYear#'
								 
								)  
				 				 
								 
		ORDER BY R.ListingOrder, ComponentOrder						  
	</cfquery>
	
	<cfquery name="Currency" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   DISTINCT ES.PaymentCurrency 
		FROM     EmployeeSalary AS ES INNER JOIN
	             EmployeeSalaryLine AS ESL ON ES.SalarySchedule = ESL.SalarySchedule AND ES.PayrollStart = ESL.PayrollStart AND ES.PersonNo = ESL.PersonNo AND 
	             ES.PayrollCalcNo = ESL.PayrollCalcNo	
		WHERE    ES.Mission       = '#mission#'
		AND      ES.PersonNo      = '#URL.ID#'
		AND      EntitlementYear  = '#EntitlementYear#'
	</cfquery>
	
	<cfquery name="Entitlement" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT *
		FROM (
		SELECT   ESL.PersonNo, 
		         ESL.PayrollItem, 
				 ESL.PaymentCurrency,
				 SUM(ESL.PaymentAmount) AS Entitlement
		FROM     EmployeeSalary AS ES INNER JOIN
	             EmployeeSalaryLine AS ESL ON ES.SalarySchedule = ESL.SalarySchedule AND ES.PayrollStart = ESL.PayrollStart AND ES.PersonNo = ESL.PersonNo AND 
	             ES.PayrollCalcNo = ESL.PayrollCalcNo	
		WHERE    ES.Mission        = '#mission#'
		AND      ES.PersonNo       = '#URL.ID#'
		AND      EntitlementYear   = '#EntitlementYear#'
		GROUP BY ESL.PersonNo, 
		         ESL.PayrollItem, 
				 ESL.PaymentCurrency		
		
				
		) as B
		
		ORDER BY PersonNo, 
		         PayrollItem, 
				 PaymentCurrency		
		
				
	</cfquery>
	
	<cfquery name="Payment" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   E.PersonNo, 
		         E.PayrollItem, 
				 E.Currency,
				 SUM(E.PaymentAmount) AS Payment
		FROM     EmployeeSettlementLine E 
		WHERE    PersonNo    = '#URL.ID#'
		AND      Mission     = '#mission#'
		AND      PaymentYear = '#EntitlementYear#'
		GROUP BY PersonNo, PayrollItem, Currency				
	</cfquery>		
		
	<cfset yr  = EntitlementYear>
	<cfset mis = Mission>
		
	<cfloop query="Item">
	
		<cfif Source neq prior>	
			<tr class="line"><td style="padding-top:0px;height:26px;font-size:16px;font-weight:200" colspan="7" class="labellarge">#Source#</td></tr>	
		</cfif>
	
		<cfset prior = source>
		
		<cfset itm = PayrollItem>
		<cfset nme = PayrollItemName>
		<cfset src = Source>
		<cfset row = currentrow>
	
		<cfloop query="Currency">
		
			<cfquery name="Ent"
	         dbtype="query">
				SELECT   Entitlement
				FROM     Entitlement 
				WHERE    PersonNo          = '#URL.ID#'
				AND      PaymentCurrency   = '#PaymentCurrency#'
				AND      PayrollItem       = '#itm#'
			</cfquery>
		
			<cfif ent.entitlement neq "">
				   <cfset entitle = ent.entitlement>
			<cfelse>
				   <cfset entitle = 0>
			</cfif>			
				
			<cfquery name="Pay"
		         dbtype="query">
					SELECT   Payment
					FROM     Payment 
					WHERE    PersonNo    = '#URL.ID#'
					AND      Currency    = '#PaymentCurrency#'
					AND      PayrollItem = '#itm#'
				</cfquery>
										
			<cfif pay.payment neq "">
			   <cfset paym = pay.payment>
			<cfelse>
			   <cfset paym = 0>
			</cfif>		
			
			<cfif entitle neq "0" or paym neq "0" or pay.recordcount gt "0">
			
			<tr style="height:18px" class="line labelmedium navigation_row">
				<td align="center" width="40">
			
					<img src="#SESSION.root#/Images/icon_expand.gif" alt="View History" 
						id="#yr#_#row#_#currentrow#Exp" border="0" class="show" 
						align="absmiddle" style="cursor: pointer;" height="12"
						onClick="drill('year','#mis#','#yr#_#row#_#currentrow#','#yr#','#itm#','#paymentCurrency#')">
						
						<img src="#SESSION.root#/Images/icon_collapse.gif" 
						id="#yr#_#row#_#currentrow#Min" alt="Hide History" border="0" 
						align="absmiddle" class="hide" style="cursor: pointer;" height="12"
						onClick="drill('year','#mis#','#yr#_#row#_#currentrow#','#yr#','#itm#','#paymentCurrency#')">				
				
				</td>
				<td style="width:50px">#itm#</td>
				<td>#nme#</td>
				<td></td>
				<td>#PaymentCurrency#</td>
				<td align="right"><a href="javascript:drill('year','#mis#','#yr#_#row#_#currentrow#','#yr#','#itm#','#paymentCurrency#')"><font color="000000">#numberFormat(entitle,",.__")#</a></td>				
				<td align="right" style="padding-right:4px!important">
				
				<a href="javascript:drill('year','#mis#','#yr#_#row#_#currentrow#','#yr#','#itm#','#paymentCurrency#')">
				<font color="000000">							
				<cfif abs(entitle-paym) gte 0.01><font color="FF0000"></cfif>
				#numberFormat(pay.payment,",.__")#
							
				</a>
				</td>
		</tr>	
		
		<tr class="hide" id="d#yr#_#row#_#currentrow#">
		   <td colspan="3"></td>
		   <td id="i#yr#_#row#_#currentrow#" style="padding-right:5px" colspan="4"></td>
	    </tr>		
		
		</cfif>
		
		</cfloop>
		
	</cfloop>
	
	<tr><td height="5"></td></tr>	
		
</cfoutput>	

</cfif>

</table>

</cf_divscroll>

</td></tr></table>

<cfset ajaxOnLoad("doHighlight")>
