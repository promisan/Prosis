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

<cfquery name="Param" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Program.dbo.Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery> 

<cfquery name="getSchedule" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     S.SalarySchedule, S.Description, S.PaymentCurrency
		FROM       SalaryScheduleMission P INNER JOIN
		           SalarySchedule S ON P.SalarySchedule = S.SalarySchedule
		WHERE      P.Mission = '#url.mission#'  
		AND        S.Operational = 1		
		AND        S.SalarySchedule IN (SELECT DISTINCT SalarySchedule FROM EmployeeSettlement)	
		ORDER BY   S.ListingOrder																	
</cfquery>

<cfsavecontent variable="ProgramMaster">
    <cfoutput>
	SELECT Px.ProgramCode, Px.ProgramName, Pex.PeriodHierarchy, Pex.Period
	FROM   Program.dbo.Program Px INNER JOIN Program.dbo.ProgramPeriod Pex ON Px.ProgramCode = Pex.ProgramCode
	AND    Px.Mission = '#URL.Mission#'
	</cfoutput>
</cfsavecontent>

<!---
 
<cfloop query="GetSchedule">

	<cf_droptable dbname="AppsQuery" tblname="#SalarySchedule#_#Table1#"> 	

	<cfquery name= "PayrollSettlement"
		Datasource="AppsPayroll"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT 	newid()              as FactTableId,				
				-- S.Mission         as Mission_dim, 				
				Month(S.PaymentDate) as PaymentMonth_dim, 
				Month(S.PaymentDate) as PaymentMonth_ord,
				Year(S.PaymentDate)  as PaymentYear_dim,
				
				CASE Month(S.PaymentDate)
							WHEN 1 THEN 'January'
							WHEN 2 THEN 'February'
							WHEN 3 THEN 'March'
							WHEN 4 THEN 'April'
							WHEN 5 THEN 'May'
							WHEN 6 THEN 'June'
							WHEN 7 THEN 'July'
							WHEN 8 THEN 'August'
							WHEN 9 THEN 'September'
							WHEN 10 THEN 'October'
							WHEN 11 THEN 'November'
							WHEN 12 THEN 'December'
				END                  as PaymentMonth_nme,
								
				I.PayrollItem           as Item_dim,
				I.PrintDescription      as Item_nme, 
				L.GLAccount             as GLAccount_dim,
				-- L.GLAccountLiability    as GLAccountCredit_dim,
				I.Source                as ItemClass_dim,
				O.OrgUnitCode           as OrgUnit_dim, 
				LEFT(OrgUnitName,60)    as OrgUnit_nme,
				F.Fund                  as Fund_dim,
				
				PP.ProgramCode          as ProgramParent_dim,
				LEFT(PP.ProgramName,60) as ProgramParent_nme,			
				PP.PeriodHierarchy      as ProgramParent_ord,
				
				Pe.Reference            as ProgramUnit_dim,
				M.ProgramName           as ProgramUnit_nme,
				Pe.PeriodHierarchy      as ProgramUnit_ord,
				
				L.PaymentId,
				S.PaymentDate,
				P.IndexNo,
				P.PersonNo, 
				P.Gender as Gender_dim,
				
				(SELECT TOP 1 ISNULL(PG.PostGradeBudget,'NA')
						 FROM   Employee.dbo.PersonContract PC INNER JOIN Employee.dbo.Ref_PostGrade PG ON PC.ContractLevel = PG.PostGrade
						 WHERE  Mission          = '#url.mission#'
						 AND    PersonNo         = P.PersonNo
						 AND    Status IN ('0','1')						 
						 AND    DateEffective   <= S.PaymentDate
						 ORDER BY DateEffective DESC) as ContractLevel_dim,
					 
				(SELECT TOP 1 ISNULL(PG.PostOrderBudget,'99')
						 FROM   Employee.dbo.PersonContract PC INNER JOIN Employee.dbo.Ref_PostGrade PG ON PC.ContractLevel = PG.PostGrade
						 WHERE  Mission          = '#url.mission#'
						 AND    PersonNo         = P.PersonNo
						 AND    Status IN ('0','1')						 
						 AND    DateEffective   <= S.PaymentDate
						 ORDER BY DateEffective DESC) as ContractLevel_ord,
				 
				P.FirstName,                   
				P.LastName,
				L.PayrollStart, 
				L.PayrollEnd, 
				L.Currency,
				L.PaymentAmount * F.Percentage as AmountPay#PaymentCurrency#,
				<cfif PaymentCurrency neq Param.BudgetCurrency>
					L.DocumentAmount*F.Percentage as AmountPay#Param.BudgetCurrency#,
				</cfif>
				L.Amount * F.Percentage        as Amount	
				 											
				
		INTO    UserQuery.dbo.#SalarySchedule#_#Table1#
		
		FROM    EmployeeSettlement S
				INNER JOIN EmployeeSettlementLine L        ON S.PersonNo = L.PersonNo AND S.SalarySchedule = L.SalarySchedule AND S.Mission = L.Mission AND S.PaymentDate = L.PaymentDate
				INNER JOIN EmployeeSettlementLineFunding F ON L.PaymentId = F.PaymentId	 
				INNER JOIN Program.dbo.ProgramPeriod AS Pe INNER JOIN
                         Program.dbo.Ref_Period AS R ON Pe.Period = R.Period ON F.ProgramCode = Pe.ProgramCode AND YEAR(R.DateEffective) = L.PaymentYear	
						 
				<!--- find the root programcode for this one --->
			
				LEFT OUTER JOIN (#preservesinglequotes(ProgramMaster)#) as PP ON SUBSTRING(Pe.PeriodHierarchy,charindex('_',Pe.PeriodHierarchy)+1,
					       CASE charindex('.',Pe.PeriodHierarchy) WHEN 0 THEN len(Pe.PeriodHierarchy) ELSE (charindex('.',Pe.PeriodHierarchy)-1) END 
						   -(charindex('_',Pe.PeriodHierarchy))) = PP.ProgramCode 
						   AND Pe.Period = PP.Period			 
						 
				INNER JOIN Program.dbo.Program M           ON F.ProgramCode = M.ProgramCode		 
					
				INNER JOIN SalarySchedule SS               ON S.SalarySchedule = SS.SalarySchedule
				INNER JOIN SalaryScheduleMission SM        ON S.SalarySchedule = SM.SalarySchedule AND S.Mission = SM.Mission
				INNER JOIN Ref_PayrollItem I               ON L.PayrollItem = I.PayrollItem
				INNER JOIN Employee.dbo.Person P           ON S.PersonNo = P.PersonNo
				INNER JOIN Organization.dbo.Organization O ON L.Mission = O.Mission AND L.Orgunit = O.OrgUnit							
				
				
		WHERE   S.Mission        = '#URL.Mission#'				
		AND     S.SalarySchedule = '#SalarySchedule#'		
		AND     SM.DateEffectivePortal >= S.PaymentDate  
				
	</cfquery>		
	
	<cfset "SESSION.table#currentrow#_ds" = "#SalarySchedule#_#Table1#">	
		
</cfloop>

--->

<cfoutput>
			
<cfsavecontent variable="myquery">

	 SELECT *, PaymentDate 
	 FROM (

		SELECT       L.PaymentId as FactTableId, 		
		             S.SalarySchedule,
		             I.PayrollItem AS Item_dim, I.PrintDescription AS Item_nme, 
					 L.GLAccount AS GLAccount_dim, 
					 I.Source AS Source, 
		             O.OrgUnitCode AS OrgUnit_dim, LEFT(O.OrgUnitName, 60) AS OrgUnit_nme, O.HierarchyCode AS OrgUnit_ord,
					 <!--- 
					 F.Fund AS Fund_dim, 
					 
					 PP.ProgramCode AS ProgramParent_dim, LEFT(PP.ProgramName, 60) AS ProgramParent_nme, PP.PeriodHierarchy AS ProgramParent_ord, 
					 Pe.Reference AS ProgramUnit_dim, M.ProgramName AS ProgramUnit_nme, Pe.PeriodHierarchy AS ProgramUnit_ord, 					 
					 --->
					 S.PaymentDate, 
					 P.IndexNo, P.PersonNo, 
					 P.Gender AS Gender_dim,
					 
                    (SELECT        TOP (1) ISNULL(PG.PostGradeBudget, 'NA') AS Expr1
                      FROM         Employee.dbo.PersonContract AS PC INNER JOIN
                                   Employee.dbo.Ref_PostGrade AS PG ON PC.ContractLevel = PG.PostGrade
                      WHERE        PC.Mission = '#url.mission#' 
					  AND          PC.PersonNo = P.PersonNo 
					  AND          PC.ActionStatus IN ('0','1') 
					  AND          PC.DateEffective <= S.PaymentDate
                      ORDER BY     PC.DateEffective DESC) AS ContractLevel_dim,					  
					  
                    (SELECT        TOP (1) ISNULL(PG.PostOrderBudget, '99') AS Expr1
                      FROM         Employee.dbo.PersonContract AS PC INNER JOIN
                                   Employee.dbo.Ref_PostGrade AS PG ON PC.ContractLevel = PG.PostGrade
                      WHERE        PC.Mission = '#url.mission#' 
					  AND          PC.PersonNo = P.PersonNo 
					  AND          PC.ActionStatus IN ('0','1') 
					  AND          PC.DateEffective <= S.PaymentDate
                      ORDER BY PC.DateEffective DESC) AS ContractLevel_ord, 
					  
					  P.FirstName+' '+P.LastName as Name, 
					  <!---	  -- L.PayrollStart, L.PayrollEnd, --->
					  
					  <!--- Hanno these amounts are not immediately populated : we have several values Payment to staff amount, cost to the organization
				    	  L.DocumentCurrency, 
					      <!--- L.PaymentAmount  * F.Percentage AS AmountPayUSD, --->
					      ROUND(L.DocumentAmount,2)  as DocumentAmount <!--- * F.Percentage AS DocumentAmount, --->
					  --->
					  
					  L.Currency as DocumentCurrency, 
					  ROUND(L.Amount,2)             as DocumentAmount         <!---  L.AmountBase * F.Percentage   as Amount --->
								 
		FROM          EmployeeSettlement AS S 
		              INNER JOIN EmployeeSettlementLine AS L ON S.PersonNo = L.PersonNo AND S.SalarySchedule = L.SalarySchedule AND S.Mission = L.Mission AND S.PaymentDate = L.PaymentDate AND S.PaymentStatus = L.PaymentStatus
					  
					  <!--- disabled more towards budget connection
					  INNER JOIN EmployeeSettlementLineFunding AS F ON L.PaymentId = F.PaymentId 
					  INNER JOIN Program.dbo.ProgramPeriod AS Pe 
					  INNER JOIN Program.dbo.Ref_Period AS R ON Pe.Period = R.Period ON F.ProgramCode = Pe.ProgramCode AND YEAR(R.DateEffective) = L.PaymentYear 
					  LEFT OUTER JOIN
		                             (SELECT   Px.ProgramCode, Px.ProgramName, Pex.PeriodHierarchy, Pex.Period
		                              FROM     Program.dbo.Program AS Px INNER JOIN
		                                       Program.dbo.ProgramPeriod AS Pex ON Px.ProgramCode = Pex.ProgramCode AND Px.Mission = 'STL') AS PP ON SUBSTRING(Pe.PeriodHierarchy, 
		                         CHARINDEX('_', Pe.PeriodHierarchy) + 1, CASE charindex('.', Pe.PeriodHierarchy) WHEN 0 THEN len(Pe.PeriodHierarchy) ELSE (charindex('.', Pe.PeriodHierarchy) - 1)
		                          END - CHARINDEX('_', Pe.PeriodHierarchy)) = PP.ProgramCode AND Pe.Period = PP.Period 
					  INNER JOIN  Program.dbo.Program AS M ON F.ProgramCode = M.ProgramCode 
					  --->
					  INNER JOIN  SalarySchedule AS SS               ON S.SalarySchedule = SS.SalarySchedule 
					  INNER JOIN  SalaryScheduleMission AS SM        ON S.SalarySchedule = SM.SalarySchedule AND S.Mission = SM.Mission AND S.PaymentDate >= SM.DateEffectivePortal 
					  INNER JOIN  Ref_PayrollItem AS I               ON L.PayrollItem = I.PayrollItem 
					  INNER JOIN  Employee.dbo.Person AS P           ON S.PersonNo = P.PersonNo 
					  INNER JOIN  Organization.dbo.Organization AS O ON L.OrgUnit = O.OrgUnit
		WHERE        S.Mission = '#url.mission#' 
		             -- AND L.DocumentAmount is not NULL
					 
					
		
		
		) as B
				
		WHERE 1=1 
				
			-- condition
			
			

</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>	
<cf_tl id="SalarySchedule" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "SalarySchedule",												
					display           = "1",	
					column            = "common",																																									
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>	
							
<cfset itm = itm+1>
<cf_tl id="IndexNo" var = "1">			
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "IndexNo",					
					alias             = "",																																			
					search            = "text"}>		
			
<cfset itm = itm+1>
<cf_tl id="Name" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Name",																							
					functionscript    = "EditPerson",
					functionfield     = "PersonNo",		
					functioncondition = "Miscellaneous",											
					width             = "40",																		
					search            = "text"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Gender" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Gender_dim",												
					display           = "1",	
					column            = "common",																																									
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>						
					
<cfset itm = itm+1>	
<cf_tl id="Level" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "ContractLevel_dim",		
					fieldsort         = "ContractLevel_ord",						
					display           = "1",																																										
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>						
					
<cfset itm = itm+1>	
<cf_tl id="Date" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "PaymentDate",								
					column            = "month",
					search            = "date",					
					display           = "1",																																														
					displayfilter     = "yes"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Source" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Source",											
					display           = "1",																																										
					column            = "common",
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>												
						
<cfset itm = itm+1>	
<cf_tl id="Item" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "Item_nme",		
					fieldsort         = "Item_dim",						
					display           = "1",																																										
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>	

<!---					
<cfset itm = itm+1>	
<cf_tl id="Parent" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "ProgramParent_nme",		
					fieldsort         = "ProgramParent_ord",						
					display           = "1",	
					column            = "common",																																									
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>		
					
--->					
					
<cfset itm = itm+1>	
<cf_tl id="Unit" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "OrgUnit_nme",		
					fieldsort         = "OrgUnit_ord",						
					display           = "1",																																										
					displayfilter     = "yes",																																									
					search            = "text",
					filtermode        = "3"}>		
					
<cfset itm = itm+1>	
<cf_tl id="Currency" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "DocumentCurrency",													
					display           = "1",																																										
					displayfilter     = "yes",																																									
					search            = "date",
					filtermode        = "3"}>
					
<cfset itm = itm+1>	
<cf_tl id="Amount" var = "1">		
<cfset fields[itm] = {label           = "#lt_text#",                    
     				field             = "DocumentAmount",								
					Aggregate         = "SUM",					
					display           = "1",	
					align             = "right",																																									
					displayfilter     = "yes",																																									
					search            = "number"}>																				
					
																
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "payroll settlement"
	    box                 = "payrollsettlementlisting_#url.mission#"
		link                = "#SESSION.root#/Payroll/Inquiry/Settlement/SettlementViewListing.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "98%"
		calendar            = "9" 
		font                = "Calibri"
		datasource          = "AppsPayroll"
		listquery           = "#myquery#"		
		listorderfield      = "LastName"
		listorder           = "LastName"
		listorderdir        = "ASC"		
		headercolor         = "ffffff"		
		menu                = "#menu#"
		showrows            = "1"
		filtershow          = "Yes"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"		
		drillkey            = "facttableid"
		drillbox            = "costbox">
		
		<!---
		
		drillmode           = "workflow" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "workflow"
		
		--->
		