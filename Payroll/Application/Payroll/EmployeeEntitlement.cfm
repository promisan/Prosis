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

<cfquery name="Years" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   DISTINCT ES.Mission, ESL.EntitlementYear
	FROM     EmployeeSalary AS ES INNER JOIN
	                         EmployeeSalaryLine AS ESL ON ES.SalarySchedule = ESL.SalarySchedule 
							 AND ES.PayrollStart  = ESL.PayrollStart 
							 AND ES.PersonNo      = ESL.PersonNo 
							 AND ES.PayrollCalcNo = ESL.PayrollCalcNo
							 AND ES.Mission       = ESL.Mission
	WHERE    ES.PersonNo = '#URL.ID#'
	ORDER BY ESL.EntitlementYear DESC
</cfquery>

<cfquery name="getPerson" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Person
	WHERE    PersonNo = '#URL.ID#'
</cfquery>

<table align="center" style="height:100%;width:99.5%">

	<tr>
	
	<td class="clsPrintContent">
	
	<cf_divscroll overflowy="scroll">
	
	<table style="width:98.5%" class="navigation_table">
	
	<cfif Years.recordcount eq "0">
	
		<tr><td height="80" align="center" class="labelmedium2">No entitlement records found for this employee</td></tr>
	
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
			FROM      EmployeeSalary AS ES 
			          INNER JOIN EmployeeSalaryLine AS ESL ON ES.SalarySchedule = ESL.SalarySchedule 
					                                      AND ES.PayrollStart   = ESL.PayrollStart 
														  AND ES.PersonNo       = ESL.PersonNo 
														  AND ES.PayrollCalcNo  = ESL.PayrollCalcNo 
														  AND ES.Mission        = ESL.Mission
		
			WHERE     ES.Mission = '#mission#'
			AND       ES.PersonNo = '#URL.ID#'
			AND       EntitlementYear = '#EntitlementYear#'
			ORDER BY  ES.PayRollStart DESC
		</cfquery>
	
		<tr class="line labelmedium fixrow fixlengthlist min-width:300px">
		<td title="#Mission# #EntitlementYear# - #dateformat(Last.PayrollStart,'MMMM')#" style="background-color:white;height:35px;font-size:22px;padding-left:2px" colspan="5" align="left">		
		<b>#Mission# #EntitlementYear# <font size="2">(<cf_tl id="until">#dateformat(Last.PayrollStart,"MMMM")# )</font></b>	
		</td>
		
			<td align="right" colspan="2" style="background-color:white;padding-top:8px;padding-right:2px;" class="clsNoPrint">
			
				<cfif currentrow eq "1">
				
				    <table width="100%">
					
					<tr>		
					<td class="labellarge" style="background-color:white;min-width:80px;font-size:18px;padding-right:10px">
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
		
		<tr class="line labelmedium2 fixrow2">
		 <td style="top:33px"></td>
		 <td style="width:80%;top:33px" colspan="2"><cf_tl id="Item"></td>
		 <td style="top:33px"></td>
		 <td style="top:33px" width="50"></td>
		 <td style="top:33px;min-width:140px" align="right"><cf_tl id="Entitlement"></td>
		 <td style="top:33px;min-width:140px;" align="right"><cf_tl id="Settled">#EntitlementYear#</td>
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
						 AND    Mission           = '#mission#'
						 
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
		             ES.PayrollCalcNo = ESL.PayrollCalcNo AND ES.Mission = ESL.Mission	
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
		             ES.PayrollCalcNo = ESL.PayrollCalcNo AND ES.Mission = ESL.Mission	
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
				<tr class="line labelmedium2"><td style="font-weight:bold;padding-left:5px;height:30px;font-size:16px" colspan="7">#Source#</td></tr>	
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
				
				<tr style="height:18px" class="line labelmedium2 navigation_row">
				
					<td align="center" style="padding-left:4px;width:40px;padding-right:10px">
				
						<img src="#SESSION.root#/Images/icon_expand.gif" alt="View History" 
							id="#mis#_#yr#_#row#_#currentrow#Exp" border="0" class="show" 
							align="absmiddle" style="cursor: pointer;" height="12"
							onClick="drill('year','#mis#','#mis#_#yr#_#row#_#currentrow#','#yr#','#itm#','#paymentCurrency#')">
							
							<img src="#SESSION.root#/Images/icon_collapse.gif" 
							id="#mis#_#yr#_#row#_#currentrow#Min" alt="Hide History" border="0" 
							align="absmiddle" class="hide" style="cursor: pointer;" height="12"
							onClick="drill('year','#mis#','#mis#_#yr#_#row#_#currentrow#','#yr#','#itm#','#paymentCurrency#')">				
					
					</td>
					
					<td style="width:50px">#itm#</td>
					<td>#nme#</td>
					<td></td>
					<td>#PaymentCurrency#</td>
					<td align="right"><a href="javascript:drill('year','#mis#','#yr#_#row#_#currentrow#','#yr#','#itm#','#paymentCurrency#')">
					    <font color="000000">#numberFormat(entitle,",.__")#</a>
					</td>				
					<td align="right" style="padding-right:4px!important">
					
					<a href="javascript:drill('year','#mis#','#yr#_#row#_#currentrow#','#yr#','#itm#','#paymentCurrency#')">
					<font color="000000">							
					<cfif abs(entitle-paym) gte 0.01><font color="FF0000"></cfif>
					#numberFormat(pay.payment,",.__")#
								
					</a>
					</td>
			</tr>	
			
			<tr class="hide" id="d#mis#_#yr#_#row#_#currentrow#">
			   <td colspan="3"></td>
			   <td id="i#mis#_#yr#_#row#_#currentrow#" style="padding-right:5px" colspan="4"></td>
		    </tr>		
			
			</cfif>
			
			</cfloop>
			
		</cfloop>
		
		<tr><td height="5"></td></tr>	
			
	</cfoutput>	
	
	</cfif>
	
	</table>
	
	</cf_divscroll>
	
	</td>
	</tr>

</table>

<cfset ajaxOnLoad("doHighlight")>
