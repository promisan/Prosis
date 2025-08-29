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
<cfparam name="url.documentCurrency" 	default="0">

<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'  
    </cfquery>

<cfoutput>

	<table width="100%" height="100%">
		
		<tr><td height="60">
		
			<table width="100%" height="100%" style="border:0px silver solid">
				<tr>
				<td>					
				<img src="#Session.root#/#parameter.applogopath#/#parameter.logofilename#" style="width:120px;height:80px;">
				<!---
				<cf_reportlogo size="100">	
				--->
				</td>
				<td align="right" style="font-size:29px"><cf_tl id="Statement of Earnings and Deductions"></td>		
				</tr>
			</table>
		
			</td>
		</tr>
				
		<tr><td height="100">
		
			<table width="100%" height="99%" style="border-bottom:0px silver solid">
			
			<tr>
			<td width="33%" height"20" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Name">:</td></tr>
			   <tr><td style="#field#">#Settle.FirstName# #Settle.MiddleName# #Settle.LastName# #Settle.MaidenName#</td></tr>
			   </table>   
			</td>
			<td width="33%" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="IndexNo">:</td></tr>
			   <tr><td style="#field#">#Settle.PersonNo#</td></tr>
			   </table>   
			</td>
			<td width="34%" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Contract Type">:</td></tr>
			   <tr><td style="#field#"><cfif Contract.ContractDescription eq "">--<cfelse>#Contract.ContractDescription#</cfif></td></tr>
			   </table>   
			</td>
			</tr>
				
			<cfquery name="Dependents" 
			datasource="AppsPayroll">
				 SELECT  count(DISTINCT Cast(DependentId as varchar(50))) as total
			     FROM    PersonDependentEntitlement 
				 WHERE   PersonNo = '#Settle.PersonNo#'
				 AND     Status != '9'	 
				 AND     DateEffective <= '#settle.PaymentDate#'
				 AND     (DateExpiration >= '#settle.PaymentDate#' or DateExpiration is NULL)	
			</cfquery>
			
			
			<tr>
			<td width="33%" height"20" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="eMail">:</td></tr>
			   <tr><td style="#field#">#Settle.eMailAddress#</td></tr>
			   </table>   
			</td>
			<td width="33%" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Dependents">:</td></tr>
			   <tr><td style="#field#">#Dependents.total#</td></tr>
			   </table>   
			</td>
			<td width="33%" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Nationality">:</td></tr>
			   <tr><td style="#field#">#settle.Nationality#</td></tr>
			   </table>   
			</td>
			</tr>
				
			<cfquery name="Grade" 
			datasource="AppsPayroll">
				 SELECT   DISTINCT ServiceLevel, ServiceStep, PositionNo, OrgUnit
			     FROM     EmployeeSalary
				 WHERE    PersonNo       = '#Settle.PersonNo#'
				 AND      SalarySchedule = '#Settle.SalarySchedule#'
				 AND      PayrollEnd     = '#Settle.PaymentDate#'
				 AND      Mission        = '#Settle.Mission#'	
			</cfquery>	
			
			<tr>
			<td width="33%" height"20" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Grade - Step">:</td></tr>
			   <tr><td>
			   <table cellspacing="0" cellpadding="0">
			   <cfloop query="Grade">
			   <tr><td style="#field#">#ServiceLevel#</td><td style="#field#">/#ServiceStep#</td></tr>
			   </cfloop>
			   </table>
			   </td></tr>
			   </table>   
			</td>
			
			<cfquery name="Org" 
				datasource="AppsOrganization">
				 SELECT   *
		    	 FROM     Organization
				 WHERE    OrgUnit = '#Grade.OrgUnit#'	
			</cfquery>
		
			<td width="33%" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Unit">:</td></tr>
			   <tr><td style="#field#">#Org.OrgUnitName#</td></tr>
			   </table>   
			</td>
			
			<td width="33%" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Location">:</td></tr>
			   <tr><td style="#field#">#Contract.ServiceLocation#</td></tr>
			   </table>   
			</td>
			</tr>	
						
			<tr>
			<td width="33%" height"20" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Schedule">:</td></tr>
			   <tr><td style="#field#">#Settle.SalarySchedule#</td></tr>
			   </table>   
			</td>
			<td width="33%" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Period">:</td></tr>
			   <tr><td style="#field#">
			   	   
				<cfquery name="SettleDetail" 
				datasource="AppsPayroll">
				 SELECT   DISTINCT PayrollEnd, PayrollStart
			     FROM     EmployeeSettlementLine
				 WHERE    PersonNo        = '#Settle.PersonNo#'
				 AND      SalarySchedule  = '#Settle.SalarySchedule#'
				 AND      PaymentDate     = '#Settle.PaymentDate#'
				 AND      Mission         = '#Settle.Mission#'	
				 
				 <cfif url.settlementPhase neq "">
				 AND      SettlementPhase = '#url.settlementPhase#'			 
				 </cfif>
				 ORDER BY PayrollStart DESC
				</cfquery>
							
			   <table cellspacing="0" cellpadding="0">
			   <cfloop query="SettleDetail">
			  	<tr>
			       <td style="#field#">#dateformat(SettleDetail.PayrollEnd,"mm/yyyy")# <cfif url.settlementPhase neq "Final">#url.settlementPhase#</cfif></td>
				   </tr>
				   
			   </cfloop>
			   </table>
		       </td></tr>
			   </table>   
			</td>
						
			<cfquery name="Position" 
				datasource="AppsEmployee">
				 SELECT   *
		    	 FROM     Position
				 WHERE    PositionNo = '#Grade.PositionNo#'	
			</cfquery>
				
			<td width="33%" valign="top">
			   <table>
			   <tr><td style="#label#"><cf_tl id="Post type">:</td></tr>
			   <tr><td style="#field#">#Position.PostType#</td></tr>
			   </table>   
			</td>
			</tr>
			
			
			<cfif Settle.PayslipMode eq "2">
			
					<!--- check with Dev on getdate() replacement on the query below --->
					
					<cfquery name="qPayslipEntitlementRates" 
					datasource="AppsPayroll">
					
					SELECT     S.ScaleNo,
					           S.ServiceLevel, 
							   S.ServiceStep, 
							   S.SalarySchedule, 
							   S.ComponentName, 
							   S.Currency, 
							   S.Amount,
		                       
							      (SELECT     TOP (1) ROUND(ExchangeRate, 3) AS Expr1
		                            FROM      Accounting.dbo.CurrencyExchange AS CE
		                            WHERE     Currency       = S.Currency 
									AND       EffectiveDate <= '#settle.PaymentDate#'
		                            ORDER BY  EffectiveDate DESC) AS Exchange, 
									
							    T_1.Description
									
					FROM       SalaryScaleLine AS S INNER JOIN
		                        
								     (SELECT   DISTINCT MAX(SSL.ScaleNo) AS ScaleNo, 
									           SSL.ServiceLevel, 
											   SSL.ServiceStep, 
											   SSL.ComponentName, 
											   SSL.Currency, 
											   R.Description
											   
		                              FROM     SalaryScaleLine AS SSL 
									           INNER JOIN SalaryScale AS SS ON SSL.ScaleNo = SS.ScaleNo 
											   INNER JOIN Ref_PayrollComponent AS R ON SSL.ComponentName = R.Code 
											   INNER JOIN Ref_PayrollTrigger AS T ON R.SalaryTrigger = T.SalaryTrigger
											   
		                              WHERE    SS.SalaryFirstApplied <= '#SettleDetail.PayrollStart#' 
									  AND      T.TriggerGroup         = 'Entitlement' 
									  AND      SSL.SalarySchedule     = '#Settle.SalarySchedule#' 
									  AND      SSL.ServiceLevel IN (#quotedvalueList(grade.ServiceLevel)#)
									  AND      SS.Mission             = '#Settle.Mission#'
									  AND      SS.ServiceLocation     = '#Contract.ServiceLocation#'								 
									  
		                              GROUP BY SSL.ComponentName, 
									           SSL.Currency, 
											   SSL.ServiceLevel, 
											   SSL.ServiceStep,
											   R.Description) AS T_1 
									
									ON    S.ScaleNo       = T_1.ScaleNo 
									AND   S.ServiceLevel  = T_1.ServiceLevel 
									AND   S.ServiceStep   = T_1.ServiceStep 
									AND   S.ComponentName = T_1.ComponentName
											
					</cfquery>		
					
					<tr><td colspan="3" align="center" style="padding-top:3px">
					
						<table width="96%" cellspacing="0" cellpadding="0" align="center" style="padding:1px;">
						
						<tr style="border-bottom:1px solid gray">
							<td style="#label#"><cf_tl id="Entitlement"></td>
							<td style="#label#"><cf_tl id="Amount"></td>				
							<td style="#label#"><cf_tl id="Exchange"></td>
							<td style="#label#">#APPLICATION.BaseCurrency#</td>
								
						</tr>
						
						<cfloop query="qPayslipEntitlementRates">
						
							<tr style="border-bottom:1px solid gray">
								<td width="33%">
									<table width="100%">
									<tr>
									<td style="#label#"><cf_tl id="#qPayslipEntitlementRates.Description#">:</td>
									</tr>
									</table>
								</td>
								
								<td width="33%" style="#field#" align="right">
									<cfif qPayslipEntitlementRates.Currency neq APPLICATION.BaseCurrency>
									<table width="100%">
									<tr>
										<td style="#field#">#qPayslipEntitlementRates.Currency#</td>
										<td width="40%" align="right" style="#field#">
											#NumberFormat(qPayslipEntitlementRates.Amount,",.__")#
										</td>
										<td width="60%"></td>
									</tr>
									</table>
									</cfif>
								</td>
								
								<td width="33%" style="#field#" align="left"  valign="center">
									<cfif qPayslipEntitlementRates.Currency neq APPLICATION.BaseCurrency>					
									<table>
									<tr>
										<td style="#field#" align="right">
											#qPayslipEntitlementRates.Exchange#
										</td>
									</tr>
									</table>
									</cfif>						
								</td>
								
								<td width="33%" style="#field#" align="right">
									<table width="100%">
									<tr>							
										<td width="40%" align="right" style="#field#">
											<cfif qPayslipEntitlementRates.Currency neq APPLICATION.BaseCurrency>
												#NumberFormat(qPayslipEntitlementRates.Amount/qPayslipEntitlementRates.Exchange,",.__")#
											<cfelse>
												#NumberFormat(qPayslipEntitlementRates.Amount,",.__")#
											</cfif>
										</td>
										<td width="60%"></td>
									</tr>
									</table>
								</td>
								
							</tr>
							
						</cfloop>
						
						</table>
						
					</td></tr>			
					
				</cfif>	
			
			</table>
		
		</td></tr>	
						
		<tr>
			
			<td colspan="4" height="590" valign="top" style="border-bottom:1px silver solid">
				
				<table width="98%" height="98%">
				<tr>
				<td valign="top">							
					<cfset url.mode = "Print">			
					<cfinclude template="SalarySlipDetail.cfm">
				</td>
				</tr>
				</table>
			
			</td>
		
		</tr>
				
		<tr><td height="10" align="center" style="#label#">#Session.welcome# <cf_tl id="Payroll"> #dateformat(now(),CLIENT.DateFormatShow)#</td></tr>
		
	</table>
	
	</cfoutput>
	