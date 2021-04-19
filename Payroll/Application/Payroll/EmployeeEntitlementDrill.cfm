
<cfparam name="URL.Year" default="2006">

<cfif url.mode eq "EOD">

		<cfinvoke component = "Service.Process.Employee.PersonnelAction"
		    Method          = "getEOD"
		    PersonNo        = "#url.id#"
			Mission         = "#url.mission#"
		    ReturnVariable  = "EOD">	
				
</cfif>				

<table align="right">
	
	<cfquery name="Entitlement" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT EntitlementYear,
	       EntitlementMonth,
	       SalarySchedule,
		   Mission,			 
	       PaymentCurrency,		   
		   SUM(EntitlementAmount) AS EntitlementAmount,		   
		   MAX(Legs) as EntitlementLegs,		   
		   SUM(SalaryDays)    as SalaryDays,
		   SUM(SalarySLWOP)   as SalarySLWOP,
		   SUM(SalarySUSPEND) as SalarySUSPEND
		   
	FROM (	   
	
			SELECT   L.EntitlementYear,
			         L.EntitlementMonth,
			         L.SalarySchedule,					 
					 S.Mission,			 
			         L.PaymentCurrency,
					 COUNT(DISTINCT L.PayrollCalcNo) as Legs,
					 SUM(SalaryDays)      as SalaryDays,
					 SUM(SalarySLWOP)     as SalarySLWOP,
					 SUM(SalarySUSPEND)   as SalarySUSPEND,
					 SUM(SalarySickLeave) as SalarySickLeave,
					 SUM(PaymentAmount)   as EntitlementAmount
					 
			FROM     EmployeeSalaryLine L INNER JOIN EmployeeSalary S ON S.PersonNo = L.PersonNo
			AND      S.SalarySchedule = L.SalarySchedule
			AND      S.PayrollStart   = L.PayrollStart
			AND      S.Mission        = L.Mission
			AND      S.PayrollCalcNo  = L.PayrollCalcNo
						
			WHERE    S.PersonNo          = '#URL.ID#'	
			<cfif url.mode eq "Year">
			AND      S.Mission          = '#url.mission#'
			AND      L.EntitlementYear   = '#URL.Year#'
			<cfelse>
			AND      S.Mission          = '#url.mission#'
			-- AND      S.PayrollEnd      >= '#EOD#'		
			</cfif>			
			AND      L.PayrollItem       = '#URL.Item#'
			AND      L.PaymentCurrency   = '#URL.Curr#'
			
			GROUP BY L.EntitlementYear,
			         L.EntitlementMonth, 
					 L.SalarySchedule,					 
					 S.Mission,
			         L.PaymentCurrency	
					 
			UNION 
			
			SELECT   PaymentYear,
				     PaymentMonth,
					 SalarySchedule,
					 Mission,
				     Currency,		
					 1 as Legs,	 
					 0 as SalaryDays,
					 0 as SalarySLWOP,
					 0 as SalarySUSPEND,	
					 0 as SalarySickLeave,				    
					 0 AS EntitlementAmount
			FROM     EmployeeSettlementLine 
				
				WHERE    PersonNo          = '#URL.ID#'
				<cfif url.mode eq "Year">
				AND      Mission          = '#url.mission#'
				AND      PaymentYear       = '#URL.Year#'
				<cfelse>
				AND      Mission          = '#url.mission#'
				-- AND      PaymentDate     >= '#EOD#'		
			    </cfif>		
				
				AND      PayrollItem       = '#URL.Item#'
				AND      Currency          = '#URL.Curr#'
				
				GROUP BY PaymentYear,
				         PaymentMonth, 
				         SalarySchedule,
						 Mission, 
						 Currency
	
		) as D
	
	GROUP BY EntitlementYear,
	         EntitlementMonth,
	         SalarySchedule,
		     Mission,			 
	         PaymentCurrency		 		 
			 
	</cfquery>
	
	<cfquery name="Payment" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   PaymentYear,
		         PaymentMonth,
				 SalarySchedule,
				 Mission,
		       	 Currency,			 
				 SUM(PaymentAmount) AS Payment
		FROM     EmployeeSettlementLine 
		
		WHERE    PersonNo          = '#URL.ID#'
		<cfif url.mode eq "Year">
		AND      Mission           = '#url.mission#'
		AND      PaymentYear       = '#URL.Year#'
		<cfelse>
		AND      Mission           = '#url.mission#'
		-- AND      PaymentDate      >= '#EOD#'		
	    </cfif>		
		AND      PayrollItem       = '#URL.Item#'
		AND      Currency          = '#URL.Curr#'
		
		GROUP BY PaymentYear,
		         PaymentMonth, 
		         SalarySchedule,
				 Mission, 
				 Currency
			 
	</cfquery>
	
	<cfoutput query="Entitlement">
		
		<cfset c = "transparent">
				
		<tr bgcolor="#c#"  class="labelmedium line" style="height:21px">
			<td style="width:20px;">
				<cfif Entitlement.currentrow eq 1>
					<cf_tl id="Toggle detail" var="1">
					<img src="#session.root#/images/plus_green.png" 
						style="height:15px; cursor:pointer;" 
						onclick="$('.clsEntitlementDrillDetail_#URL.ID#_#URL.Year#_#URL.Item#_#URL.Curr#').toggle();" 
						title="#lt_text#">
				</cfif>
			</td>
			<td style="width:40%;padding-left:5px;padding-right:15px"><cfif url.mode neq "Year">#EntitlementYear#</cfif> #MonthAsString(EntitlementMonth)#</td>				
			<td align="right" style="max-width:45px;min-width:45px"></td>
			<td align="right" style="max-width:45px;min-width:45px"></td>
			<td align="right" style="max-width:45px;min-width:45px"></td>	
			<td align="right" style="max-width:45px;min-width:45px"></td>
			<td align="right" style="max-width:40px;min-width:40px"></td>												
			<td align="right" style="min-width:140px;padding-right:20px!important">
			<cfset am = round(EntitlementAmount*100)/100>					
			#numberFormat(am,",.__")#</td>
							
			<cfquery name="Pay"
		         dbtype="query">
					SELECT   *
					FROM     Payment 
					WHERE    PaymentYear    = #EntitlementYear#
					AND      PaymentMonth   = #EntitlementMonth#
					AND      SalarySchedule = '#SalarySchedule#'
					AND      Mission        = '#Mission#'
					AND      Currency       = '#PaymentCurrency#'
				</cfquery>
			
			<cfif pay.payment neq "">
				   <cfset p = pay.payment>
				<cfelse>
				   <cfset p = 0>
				</cfif>	
				
			<cfif abs(entitlementAmount-p) gte 0.01>
			<td align="right" style="min-width:140px;color:red;padding-right:8px!important">
			<cfelse>
			<td align="right" style="min-width:140px;padding-right:8px!important">
			</cfif>
			#Numberformat(pay.payment, ",.__" )#											
			</td>
		</tr>	
		
		<cfif EntitlementLegs gte "1">
		
			<cfquery name="Leg" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   L.EntitlementMonth,
				         L.SalarySchedule,
						 S.Mission,		
						 S.ServiceLocation,
						 S.ServiceLevel,
						 S.ServiceStep,	 
						 L.ComponentName,
				         L.PaymentCurrency,
						 L.PayrollCalcNo,	
						 MIN(EntitlementPercentage) as EntitlementPercentage,				
						 SUM(EntitlementPeriod)  as SalaryDays,
						 SUM(EntitlementSLWOP)   as SalarySLWOP,
						 SUM(EntitlementSUSPEND) as SalarySUSPEND,
						 SUM(EntitlementSickLeave) as SalarySickLeave,
						 SUM(PaymentAmount) as EntitlementAmount
							 
				FROM     EmployeeSalaryLine L INNER JOIN EmployeeSalary S ON S.PersonNo = L.PersonNo
				AND      S.SalarySchedule = L.SalarySchedule
				AND      S.PayrollStart   = L.PayrollStart
				AND      S.PayrollCalcNo  = L.PayrollCalcNo
				AND      S.Mission        = L.Mission
				
				WHERE    S.PersonNo          = '#URL.ID#'	
				AND      L.EntitlementYear   = '#EntitlementYear#'
				AND      L.EntitlementMonth  = '#EntitlementMonth#'
				AND      L.PayrollItem       = '#URL.Item#'
				AND      L.PaymentCurrency   = '#URL.Curr#'
				
				GROUP BY L.EntitlementMonth, 
						 L.SalarySchedule,
						 L.ComponentName,
						 S.Mission,
						 S.ServiceLocation,
						 S.ServiceLevel,
						 S.ServiceStep,	 
				         L.PaymentCurrency,
						 L.PayrollCalcNo	
						 
				ORDER BY PayrollCalcNo
						 
			 </cfquery>	
		 
			 <cfset c = "transparent">
			 
			 <cfloop query="Leg">			
					
			<tr bgcolor="ffffcf" class="labelmedium line clsEntitlementDrillDetail_#URL.ID#_#URL.Year#_#URL.Item#_#URL.Curr#" style="height:17px; display:none;">
				<td bgcolor="ffffff" style="width:20px;"></td>
				<td style="font-size:10px;border-left:1px solid silver;width:40%;padding-left:6px">#ServiceLocation# : #ServiceLevel#/#ServiceStep# : #ComponentName#</td>	
				<td align="right" style="font-size:10px;max-width:40px;min-width:40px"><cfif entitlementPercentage neq "">#entitlementPercentage#%</cfif></td>				
				<td align="right" style="font-size:10px;max-width:40px;min-width:40px">#SalaryDays#</td>
				<td align="right" style="font-size:10px;max-width:40px;min-width:40px">#SalarySLWOP#</td>
				<td align="right" style="font-size:10px;max-width:40px;min-width:40px">#SalarySUSPEND#</td>	
				<td align="right" style="font-size:10px;max-width:40px;min-width:40px">#SalarySickLeave#</td>							
				<td align="right" style="font-size:10px;padding-right:20px!important">
				<cfset am = round(EntitlementAmount*100)/100>					
				#numberFormat(am,",.__")#
				</td>
				<td style="width:20%"></td>
				
			</tr>	
			
			</cfloop>		 
			
		</cfif>
		
	</cfoutput>
		
</table>
