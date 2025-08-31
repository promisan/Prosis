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
<cfparam name="url.currency" default="">

<cfparam name="attributes.settlementPhase" default="">

<cfquery name="Settlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     EmployeeSettlement E
	WHERE    E.SettlementId = '#URL.Settlementid#'		  
</cfquery>

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
		FROM     EmployeeSettlementLine E
		WHERE    E.PersonNo        = '#URL.ID#'
		AND      E.SalarySchedule  = '#Settlement.SalarySchedule#'
		AND      E.Mission         = '#Settlement.Mission#'
		<cfif url.currency neq "">
		AND      E.Currency        = '#URL.Currency#'
		</cfif>
		AND      E.PaymentDate     = '#Settlement.PaymentDate#'  				 
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
		
		SELECT E.Currency, 
		       S.PayrollItem, 
			   S.PayrollItemName as Component, 
			   S.ComponentOrder, 
			   S.Source, 
			   S1.PrintGroupOrder, 
			   S2.ListingOrder,
			   S2.Description as SourceDescription,
			   S.PrintGroup, 
			   S.PrintOrder, 
			   S.PrintDescriptionLong, 
		       SUM(E.PaymentAmount) as PaymentAmount, 
			   SUM(E.Amount) as Amount 
		
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
								  AND   PaymentYear   >= #year(Settlement.PaymentDate)#
								  AND   PayrollItem = S.PayrollItem
								 )	
		 							 
		GROUP BY S2.ListingOrder,
				 S2.Description,
		         S.Source, 
		         S.PayrollItemName, 
				 S1.PrintGroupOrder, 
				 S.ComponentOrder, 
				 S.PrintOrder, 
				 S.PrintGroup, 
				 S.PrintDescriptionLong, 
				 S.PayrollItem, 
				 E.Currency
				 
		ORDER BY S1.PrintGroupOrder,
		         S2.ListingOrder, 
				 S.Source, 
				 S.ComponentOrder, 
				 S.PrintOrder			
				 				 	 
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
	
	</cfloop>
	
	<cfquery name="NetPayment" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PrintGroup 
		FROM   Ref_SlipGroup 
		WHERE  PrintGroupOrder = '0'
	</cfquery>
	
	<cfset sal = NetPayment.PrintGroup>
	
	<cfquery name="NetPayment" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT SUM(E.PaymentAmount) as PaymentAmount
		FROM   EmployeeSettlementLine E,
		       Ref_PayrollItem P
		WHERE  E.PersonNo       = '#URL.ID#'
		  AND  E.PaymentDate    = '#Settlement.PaymentDate#' 
		  AND  E.SalarySchedule = '#Settlement.SalarySchedule#'
		  AND  E.Mission        = '#Settlement.Mission#'
		  		 
		  <cfif attributes.settlementPhase neq "">
		  AND   E.SettlementPhase = '#attributes.settlementPhase#'
		  </cfif>	
		  
		  AND  E.Currency       = '#Currency#'
		  AND  P.PayrollItem    = E.PayrollItem
		  AND  P.PrintGroup IN (SELECT PrintGroup 
		                        FROM   Ref_SlipGroup 
								WHERE  NetPayment = 1)
								
	</cfquery>
	
		<table width="98%" align="center" cellspacing="0" cellpadding="0">
		
		<cfoutput>		
				
		<tr>
		    
			<td colspan="1" style="height:40px" class="labelmedium" style="#label#">
			<cf_tl id="Net Payment for this period">:&nbsp;
			<font size="6" color="a0a0a0"><cfloop query="NetPayment">#NumberFormat(PaymentAmount,"_,.__")#</b></cfloop>
			</td>
			<td class="labelmedium" style="#label#" align="right"><cf_tl id="All amounts are in"> #Currency#</td>
			
		</tr>
			
		
		</cfoutput>
		
		<tr><td colspan="2">
		
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		
		 <cfoutput>	
		  
		  <tr>
		    <td width="100%" height="29">
		    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
		      <tr>
		        <td width="40%" align="left" style="#label#"><cf_tl id="Item"></td>
		        <td width="20%" align="right" style="#label#"><cf_tl id="Current"></td>
		        <td width="20%" align="right" style="#label#"><cf_tl id="Retroactive"></td>
		        <td width="20%" align="right" style="#label#"><cf_tl id="Cumulative">:<cfoutput>#year(Settlement.PaymentDate)#</cfoutput></b></td>
			  </tr>
		    </table>
		    </td>
		  </tr>
		  
		 <tr><td colspan="2" style="border-top:1px solid silver"></td></tr>
		  
		  </cfoutput>
		
		  <tr>
		    <td>
			
		    <table width="100%">
			
		      <td width="40%" align="left" valign="top">
		     	
				<cfoutput query="Current" group="PrintGroupOrder">
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
								
				<tr><td align="left" style="#label#;font-size:18;height:36px"><cf_tl id="#PrintGroup#"></td>
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
				        <td style="#label#;height:20px;padding-left:25px">
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
					<table width="99%">					
					<tr><td height="30"></td></tr>							
					<cfoutput group="Source">	
					<cfoutput>
			        <TR>
					<td align="right" style="#label#;height:20px">
					<cfif PrintGroup eq "Contributions">#NumberFormat(Amount,",.__")#<cfelse>#NumberFormat(PaymentAmount,",.__")#</cfif>
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
		  
		  <tr><td height="30" align="center">
				  <input type="button" name="Back" value="Back" class="button10g" onclick="history.back()">
			  </td>
		  </tr>
		  
		  </cfif>
					
		</table>		
		</td></tr>			
		      
	</table>
			
</cfloop>

