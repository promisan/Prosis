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

<cfparam name="URL.Mission"    default="">

<cfquery name="Parameter" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_ParameterMission 
   WHERE  Mission = '#url.mission#'
</cfquery>

<cfoutput> 

<!--- body --->

	<cfsavecontent variable="sqlbody">
	     
		     SELECT *
			 FROM (
	  
		
				SELECT      D.Mission, 
				            D.PersonNo, 
							D.PayrollItemName, 
							D.PayrollItem, 
							D.PayrollStart,
							P.IndexNo,
							P.LastName, 
							P.FirstName, 
							P.FullName as Name,
							P.Gender, 
							P.Nationality, 
							D.Currency, 
							D.Entitlement, 
							D.Settled, 
							ROUND(D.Entitlement - D.Settled, 2) AS Balance
							
				FROM        (SELECT      L.Mission, 
				                         L.PersonNo, 
										 R.PayrollItemName, 
										 L.PayrollItem, 
										 L.Currency, 
										 MAX(L.PayrollStart) as PayrollStart,
										 ISNULL(ROUND(SUM(L.PaymentAmount), 2), 0) AS Entitlement,
		                                   (SELECT     ISNULL(ROUND(SUM(PaymentAmount), 2), 0) AS Expr1
		                                    FROM       EmployeeSettlementLine
		                                    WHERE      Mission = L.Mission 
											AND        PersonNo = L.PersonNo 
											AND        PayrollItem = L.PayrollItem) AS Settled
											
	                          FROM       EmployeeSalaryLine AS L INNER JOIN
				                         Ref_PayrollItem AS R ON L.PayrollItem = R.PayrollItem
	                          WHERE      R.SettlementMonth <> '0'
							  AND        L.Mission = '#url.mission#'
							  <cfif url.id1 neq "">
							  AND        L.PayrollItem = '#url.id1#'
							  </cfif> 
	                          GROUP BY   L.Mission, L.PersonNo, L.Currency, L.PayrollItem, R.PayrollItem, R.PayrollItemName
							  
					          ) AS D 
					  
					  INNER JOIN Employee.dbo.Person AS P ON P.PersonNo = D.PersonNo
					  
				) as E
				WHERE 1= 1
				--condition	  
			
		
	   
	</cfsavecontent>
	
	<!--- pass the view --->

	<cfsavecontent variable="myquery">  
		#preserveSingleQuotes(sqlbody)#					
	</cfsavecontent>	
		  
</cfoutput>

<!--- show person, status processing color and filter on raise by me --->

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "IndexNo",                  
					field         = "IndexNo",					
					search        = "text"}>	
					
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Name",                  
					field         = "Name",
					filtermode    = "0",
					search        = "text"}>			

<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "S", 					
                    labelfilter   = "Gender",
					field         = "Gender",					
					filtermode    = "3",    
					align         = "center",
					search        = "text"}>	
	
<!---					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Source",  					
                    labelfilter   = "Source",
					field         = "Source",	
					filtermode    = "2",								
					search        = "text"}>		
					
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Status",				
					field         = "Status",					
					filtermode    = "2",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=White,1=Yellow,3=green,5=purple,9=red"}>		
					
--->											
																			
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Month",  					
					field         = "PayrollStart",
					align         = "center",										
					formatted     = "dateformat(PayrollStart,'YYYY-MM')"}>						
		
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Curr",  
                    labelfilter   = "Currency", 					
					field         = "Currency",
					align         = "center",     
					filtermode    = "2",					
					search        = "text"}>
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Entitlement",                  
					field         = "Entitlement",
					formatted     = "numberformat(Entitlement,',.__')",
					width         = "20",
					aggregate  = "sum",
					align         = "right",
					search        = "amount"}>						
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Due",                  
					field         = "Balance",
					formatted     = "numberformat(Balance,',.__')",
					width         = "20",
					aggregate  = "sum",
					align         = "right",
					search        = "amount"}>								
						
<cf_listing
	    header         = "#url.mission#_payrollbalance"
	    box            = "#url.mission#_payrollbalance"
		link           = "#SESSION.root#/Payroll/Application/Entitlements/EntitlementBalanceListing.cfm?mission=#url.mission#&id1=#url.id1#&systemfunctionid=#url.systemfunctionid#"
	    html           = "No"
		show           = "200"
		datasource     = "appsPayroll"
		listquery      = "#myquery#"			
		listorder      = "Name"
		listorderdir   = "ASC"
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Yes"
		excelShow      = "Yes"
		drillmode      = "tab"
		drillargument  = "940;1190;false;false"	
		drilltemplate  = "Staffing/Application/Employee/PersonView.cfm?id="
		drillkey       = "PersonNo">
	
