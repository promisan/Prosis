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

<cfparam name="url.box"               default=""> 
<cfparam name="url.currency"          default="">
<cfparam name="url.settlementphase"   default="">
<cfparam name="url.Documentcurrency"  default="0">

<cfparam name="attributes.settlementPhase" default="#url.settlementphase#">

<cfset vCurrencyField = "Currency">
<cfset vAmountField = "PaymentAmount">
<cfif url.documentCurrency eq 1>
	<cfset vCurrencyField = "DocumentCurrency">
	<cfset vAmountField = "DocumentAmount">
</cfif>

<cfquery name="Settlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     EmployeeSettlement E
	WHERE    E.SettlementId = '#URL.Settlementid#'		  
</cfquery>

<cfquery name="Period" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     SalarySchedulePeriod E
	WHERE    Mission        = '#Settlement.Mission#'		  
	AND      SalarySchedule = '#settlement.SalarySchedule#'
	AND      PayrollEnd     = '#settlement.PaymentDate#' 
</cfquery>

<cfif Settlement.recordCount lte 0>
	<cfoutput>
		No settlement found, please refresh the screen and check the payslip again.
		<cfabort>
	</cfoutput>
</cfif>
<cfset url.id = Settlement.PersonNo>

<cfquery name="Parameter" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Parameter
</cfquery>
	
<cfquery name="CurrencyList" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   DISTINCT Currency
	FROM     EmployeeSettlementLine E
	WHERE    E.PersonNo       = '#URL.ID#'
	   AND   E.SalarySchedule = '#Settlement.SalarySchedule#'
	   AND   E.Mission        = '#Settlement.Mission#'
	   AND   E.PaymentStatus  = '#Settlement.PaymentStatus#'
	   <cfif url.currency neq "">
	   AND   E.Currency       = '#url.Currency#'
	   </cfif>
	   AND   E.PaymentDate    <= '#Settlement.PaymentDate#'  
	   AND   E.PaymentYear >=  #year(Settlement.PaymentDate)#
	   <cfif attributes.settlementPhase neq "">
		 AND   SettlementPhase = '#attributes.settlementPhase#'
	   </cfif>
</cfquery>

<cfloop query="CurrencyList">
	
	<!--- loop per currency --->
	
	<cfquery name="CurrentDate" 
	datasource="AppsPayroll" 
	maxrows="1"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   DISTINCT E.Currency, 
				          E.PayrollStart, 
				          E.PayrollEnd
		FROM    EmployeeSettlementLine E
		WHERE   E.PersonNo       = '#URL.ID#'
		 AND    E.SalarySchedule = '#Settlement.SalarySchedule#'
		 AND    E.Mission        = '#Settlement.Mission#'
		 <cfif url.currency neq "">
		 AND    E.Currency       = '#URL.Currency#'
		 </cfif>
		 AND    E.PaymentDate    = '#Settlement.PaymentDate#'  	
		 AND    E.PaymentStatus  = '#Settlement.PaymentStatus#'			 
		 <cfif attributes.settlementPhase neq "">
		 AND      SettlementPhase = '#attributes.settlementPhase#'
		 </cfif> 
		 ORDER BY PayrollStart DESC
	</cfquery>
	
	<cfloop index="qry" list="Current,Retro,Cumulative" delimiters=",">
	
		<cfquery name="#qry#" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT E.#vCurrencyField# as Currency, 
		       S.PayrollItem, 
			   S.PayrollItemName as Component, 
			   S.ComponentOrder, 
			   S.Source, 
			   S1.PrintGroupOrder, 
			   S2.ListingOrder,
			   S2.Description as SourceDescription,
			   S.PrintGroup, 
			   S.PrintOrder, 
			   S.PrintDescription as PrintDescriptionLong, 
		       SUM(E.PaymentAmount) as PaymentAmount, 
			   SUM(E.#vAmountField#) as Amount 
		
		FROM   Ref_PayrollSource S2 INNER JOIN
	           Ref_PayrollItem S ON S2.Code = S.Source INNER JOIN
	           Ref_SlipGroup S1 ON S.PrintGroup = S1.PrintGroup LEFT OUTER JOIN
	           EmployeeSettlementLine E ON S.PayrollItem = E.PayrollItem
			   
			   AND   E.PersonNo        =  '#URL.ID#'		
			   <!--- filter the settlement line --->
			    <cfswitch expression="#qry#">
				
					 <cfcase value="Current">
					 
						 AND   E.PaymentDate    =  E.PayrollEnd
						 AND   E.PaymentDate    =  '#Settlement.PaymentDate#'	
						 AND   E.PaymentStatus  =  '#Settlement.PaymentStatus#'							 	 
						 <cfif attributes.settlementPhase neq "">
						 AND     E.SettlementPhase = '#attributes.settlementPhase#'
						 </cfif>	
						 				 
					 </cfcase>
					 
					 <cfcase value="Retro">
					 
						 AND   E.PaymentDate    >  E.PayrollEnd
						 AND   E.PaymentDate    =  '#Settlement.PaymentDate#'
						 AND   E.PaymentStatus  =  '#Settlement.PaymentStatus#'
						 <cfif attributes.settlementPhase neq "">
						 AND     E.SettlementPhase = '#attributes.settlementPhase#'
						 </cfif>	
					 
					 </cfcase>
					 
					 <cfcase value="Cumulative">					
					 
					 	AND   E.PaymentYear >=  #year(Settlement.PaymentDate)#
						<!--- we show it all 
						AND   E.PaymentStatus  = '#Settlement.PaymentStatus#'  
						 --->
						AND   (
								
								E.PaymentDate < '#Settlement.PaymentDate#'
								
								OR
									( E.PaymentDate =  '#Settlement.PaymentDate#'		     							 		 
									  <cfif attributes.settlementPhase neq "">
									  AND E.SettlementPhase = '#attributes.settlementPhase#'
									 </cfif>	
									)
							   )	
						
						 
					 </cfcase>					 
					 
				 </cfswitch> 
				 AND   E.SalarySchedule = '#Settlement.SalarySchedule#'
				 AND   E.Mission        = '#Settlement.Mission#'
				 AND   E.Currency       =  '#Currency#'					 	
				 
		 WHERE S.PayrollItem IN (
		                         SELECT DISTINCT PayrollItem 
		                         FROM   EmployeeSettlementLine 
								 WHERE  PersonNo       = '#URL.ID#'
								  AND   SalarySchedule = '#Settlement.SalarySchedule#'
								  AND   Mission        = '#Settlement.Mission#'
								  AND   PaymentStatus  = '#Settlement.PaymentStatus#'
								  AND   PaymentYear   >= #year(Settlement.PaymentDate)#
								  AND   PayrollItem    = S.PayrollItem
								 )	
		 							 
		GROUP BY S2.ListingOrder,
				 S2.Description,
		         S.Source, 
		         S.PayrollItemName, 
				 S1.PrintGroupOrder, 
				 S.ComponentOrder, 
				 S.PrintOrder, 
				 S.PrintGroup, 
				 S.PrintDescription, 
				 S.PayrollItem, 
				 E.#vCurrencyField#
				 
		ORDER BY S1.PrintGroupOrder,
		         S2.ListingOrder, 
				 S.PrintOrder,	
				 S.Source, 
				 S.ComponentOrder 
				 		
				 				 	 
		</cfquery>		
		
		<cfquery name="FirstMonth" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT MIN(PaymentMonth) as Month		
			FROM   EmployeeSettlementLine
			WHERE  PersonNo     =  '#URL.ID#'		
			AND    PaymentYear  >=  #year(Settlement.PaymentDate)#						 
		</cfquery>

		<cfif qry eq "Current">
			<cfquery name="NetPayment" dbtype="query">
				SELECT SUM(Amount) as PaymentAmount
				FROM   [Current]
				WHERE 	PrintGroup != 'Contributions'
			</cfquery>
			<cfset vTotalNetPayment = NetPayment.PaymentAmount>
		</cfif>
		
		<cfif qry eq "Retro">
		
			<cfquery name="NetPayment" dbtype="query">
				SELECT  SUM(Amount) as PaymentAmount
				FROM    [Retro]
				WHERE 	PrintGroup != 'Contributions'
			</cfquery>
						
			<cfif NetPayment.PaymentAmount neq "">
			
				<cfif vTotalNetPayment neq "">			
					<cfset vTotalNetPayment = vTotalNetPayment + NetPayment.PaymentAmount>				
				<cfelse>				
					<cfset vTotalNetPayment = NetPayment.PaymentAmount>				
				</cfif>
			
			</cfif>
			
		</cfif>
		
		
	</cfloop>
	
	<cfquery name="GetGroup" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PrintGroup 
		FROM   Ref_SlipGroup 
		WHERE  PrintGroupOrder = '0'
	</cfquery>
	
	<cfset sal = GetGroup.PrintGroup>
	
	<table width="100%" align="center" cellspacing="0" cellpadding="0">
		
		<cfoutput>		
				
		<tr class="line">
		    
			<td colspan="1" style="padding-left:0px;height:43px;#label#" class="labelmedium">
			<table>
			<tr>
			<td>
			<cf_tl id="Net Payment for this period">:&nbsp;
			<font size="5" color="800080">
			<cfloop query="NetPayment">#NumberFormat(vTotalNetPayment,"_,.__")#</cfloop>
			</font>
			</td>
														
			<cfif Period.calculationstatus lte "2" 
			    and vTotalNetPayment lt 0 
				and settlement.paymentstatus eq "0">
								
							
				<!--- check if there is a schedule for the same period --->
				
				<cfquery name="getOther" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				
					SELECT ES.SalarySchedule, 
					       (SELECT Description FROM SalarySchedule WHERE SalarySchedule = ES.SalarySchedule) as SalaryScheduleName
						   
					FROM   EmployeeSettlement AS ES INNER JOIN
                           SalarySchedulePeriod AS SSP ON ES.Mission = SSP.Mission AND ES.SalarySchedule = SSP.SalarySchedule AND ES.PaymentDate = SSP.PayrollEnd

					WHERE  ES.PersonNo        = '#Settlement.PersonNo#'		
					AND    ES.Mission         = '#Settlement.Mission#'
					AND    ES.SalarySchedule != '#Settlement.SalarySchedule#'
					AND    ES.PaymentDate     = '#Settlement.PaymentDate#'
					AND    ES.PaymentStatus   = '0' <!--- in cycle --->
					AND    SSP.CalculationStatus < = '2'							 
					
				</cfquery>
				
				<cfif getOther.recordcount gte "1">				
				
					<td style="padding-top:8px;padding-left:10px;padding-right:10px">
						<cf_tl id="Associate Settlement to">
					</td>
					<td id="process"></td>
					<td>
					<select name="associate" onchange="ptoken.navigate('setEmployeeSettlement.cfm?id=#settlement.settlementid#&action=associate&value='+this.value,'process')">
					     <option <cfif settlement.settlementschedule eq settlement.salaryschedule>selected</cfif> value="#Settlement.SalarySchedule#">No</option>
						 <cfloop query="getOther">
						 <option <cfif settlement.settlementschedule eq salaryschedule>selected</cfif> value="#SalarySchedule#">#SalaryScheduleName#</option>
						 </cfloop>
					</select>
					</td>
					
				<cfelse>
				
					<cfif settlement.salaryschedule neq settlement.settlementschedule>
					
					<td style="padding-top:8px;padding-left:10px">
						<cf_tl id="Associated">:&nbsp;#settlement.settlementschedule#
					</td>
					
					</cfif>	
					
				</cfif>
				
			</cfif>	
			
			</tr>
			</table>
			</td>
			<cfset vTotalCurrency = evaluate("#qry#.Currency")>
			<td class="labelmedium" style="#label#;padding-right:5px" align="right"><cf_tl id="All amounts are in">&nbsp;<font size="4" color="800080">#vTotalCurrency#</b></font></td>
				
			<cf_assignId>	
			<td valign="top" id="drilldown_#rowguid#" rowspan="2" style="padding:3px;max-width:250px;;"></td>			
		</tr>			
		
		</cfoutput>
				
		<tr>
		<td colspan="2" valign="top" style="padding-right:5px">
		
		<table width="100%">
		
		 <cfoutput>	
		  
		  <tr class="line">
		    <td width="100%" height="29">
		    <table width="100%" class="formpadding">
		      <tr>
		        <td width="40%" align="left" style="#label#"><cf_tl id="Item"></td>
		        <td width="20%" align="right" style="#label#"><cf_tl id="Current"></td>
		        <td width="20%" align="right" style="#label#"><cf_tl id="Retroactive"></td>
		        <td width="20%" align="right" style="#label#"><cf_tl id="Cumulative">:<cfoutput>#year(Settlement.PaymentDate)#</cfoutput></b></td>
			  </tr>
		    </table>
		    </td>
		  </tr>
		  
		  </cfoutput>
		
		  <tr>
		    <td>
			
		    <table width="100%">
			
		      <td width="40%" align="left" valign="top">
		     	
				<cfoutput query="Current" group="PrintGroupOrder">
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
								
				<tr><td align="left" style="#field#;height:36px"><b><cf_tl id="#PrintGroup#"></b></td>
				<td style="height:30px"></td>
				<td style="height:30px"></td>
				<td style="height:30px"></td>
				</tr>
				
				<cfoutput group="Source">
				
					<cfif PrintGroup eq sal>
					    <!---
						<tr><td height="6"></td></tr>
						<tr><td height="30" style="#label#"><b>&nbsp;#SourceDescription#</font></b></td></tr>
						<tr><td style="border-bottom:1px solid d2d2d2"></td></tr>
						--->
					</cfif>
					
					<cfoutput>
				        <TR>
				        <td class="#label#" style="font-size:13px;height:20px;padding-left:25px">
						<cfif len(PrintDescriptionLong) gt 40>
						#left(PrintDescriptionLong,40)#..
						<cfelse>
						#PrintDescriptionLong#
						</cfif>
						</td>
						</TR>
					</cfoutput>
					
			    </cfoutput>

				</table>	
					
				</cfoutput>
			 
			  </td>
			  
			  <cfloop index="qry" list="Current,Retro,Cumulative" delimiters=",">
			  	 
			      <td width="20%" align="center">
				 
				  	<cfoutput query="#qry#" group="PrintGroupOrder">
					<table width="99%" border="0" cellspacing="0" cellpadding="0">					
					<tr><td height="30"></td></tr>							
					<cfoutput group="Source">	
					<cfoutput>
			        <TR>
					<td align="right" style="#label#;height:20px">
										
					<cfif qry eq "Retro" and ((amount neq "" and abs(amount) gte "0.01") or (paymentAmount neq "" and abs(paymentamount) gte "0.01"))>					
					<a href="javascript:drilldown('#settlementid#','#settlementphase#','retro','#PayrollItem#','drilldown_#rowguid#','#url.box#')">
					<cfif PrintGroup eq "Contributions">#NumberFormat(Amount,",.__")#<cfelse>#NumberFormat(PaymentAmount,",.__")#</cfif>
					</a>
					<cfelse>
					<cfif PrintGroup eq "Contributions">#NumberFormat(Amount,",.__")#<cfelse>#NumberFormat(PaymentAmount,",.__")#</cfif>
					</cfif>
					</td>
					</TR>
					</cfoutput>
				    </cfoutput>
					</table>		
					</cfoutput>		  
				  </td>
			  
			  </cfloop>
		      
		      </tr>
		    </table>
		    </td>
						
		  </tr>
		    
		  <cfif url.mode eq "Full">
		  
		  <tr><td colspan="1" 
		          height="30" 
				  align="center">
				  <input type="button" name="Back" value="Back" class="button10g" onclick="history.back()">
			  </td>
		  </tr>
		  
		  </cfif>
					
		</table>		
		</td>
				
		</tr>			
		      
	</table>
			
</cfloop>

