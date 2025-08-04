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

<!--- why is this ? --->

<cfquery name="Parameter" 
	datasource="appsInit" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT *
	FROM   Parameter
</cfquery>

<!---
<cfset selend = createdate (2011,6,30)>
<cfset mission = "OICT">
--->

<cfset selstr = createdate (url.year,url.month,1)>
<cfset selend = createdate (year(selstr),month(selstr),daysinMonth(selstr) )>
<cfset mission=url.mission >


<cfquery name="PayrollMiscellaneous" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT	 P.IndexNo,
				 15   as InfoType,
				 6050 as WageType,
				 ROUND(SUM(M.Amount),2) AS Amount,
				 M.Currency,
				 '' as Number,
				 '' as Unit,
				 '#dateformat(selstr,client.dateSQL)#' as DateEffective,
				 M.DocumentDate as DateExpiration,
				 'Call Charges for ' + DATENAME(month, M.DocumentDate) + ' '	+ convert(varchar,year(M.DocumentDate)) as Remarks,
				 '' as OCReason,
				 '' as OCType		

		FROM     Payroll.dbo.PersonMiscellaneous M INNER JOIN Employee.dbo.Person P ON M.PersonNo = P.PersonNo
		WHERE    M.Payrollitem IN (		
					SELECT DISTINCT PayrollItem
					FROM  ServiceItemUnit
					WHERE Operational=1
					AND   PayrollItem is not null
					)

		AND      M.DocumentDate = '#DateFormat(selend,CLIENT.dateSQL)#'
		AND      P.IndexNo IS NOT NULL
		AND      P.IndexNo <> ''		
		GROUP BY P.IndexNo, M.Currency,	M.DocumentDate,
				 'Call Charges for ' + DATENAME(month, M.DocumentDate) + ' '	+ convert(varchar,year(M.DocumentDate))
		HAVING   round(sum(M.Amount),2) <> 0
		ORDER BY round(sum(M.Amount),2) 
		
	
</cfquery>
	
<cfset DirName = DateFormat(selend,"YYYYMM")>	

<cfif not DirectoryExists("#Parameter.DocumentRootPath#\ServicePayrollCharges\#mission#\#DirName#")>			
	
	<cfdirectory action="CREATE" 
	   directory="#Parameter.DocumentRootPath#\ServicePayrollCharges\#mission#\#DirName#">
	   
</cfif>

<cfoutput>

<cfset vFileName = "#Parameter.DocumentRootPath#\ServicePayrollCharges\#mission#\#DirName#\#DirName#.xls">

<cfscript> 
    //Create empty ColdFusion spreadsheet object. ---> 
    theSheet = SpreadsheetNew("I0235"); 
	
    //Populate object with a query. ---> 
    SpreadsheetAddRows(theSheet,PayrollMiscellaneous); 

	//Add coding block header row	
    SpreadsheetAddRow(theSheet, 
    "Business Area,Cost Center,Internal Order,WBS Element,Fund,Budget Period,Funds Center,Functional Area,Grant", 
    1,1,true); 

	//Add coding block row	
    SpreadsheetAddRow(theSheet, "S100,15215,,,10RCR,B17,,29ACE002,GMNR",2,1,true); 

	//Add blank row	
    SpreadsheetAddRow(theSheet,"", 3,1,true); 	
		
	//Add header row	
    SpreadsheetAddRow(theSheet, 
    "Personnel Number,Info Type,Wage Type,Amount,Currency,Number,Unit,Effective Date,Expiration Date,Text/Remarks,OC Reason,OC Type", 
    4,1,true); 

</cfscript> 
 
<!--- Write the sheet to file ---> 
<cfspreadsheet action="write" filename="#vFileName#" name="theSheet"  
    sheetname="I0235" overwrite=true> 

		<cfif not DirectoryExists("\\NYVM1618\Files\ServicePayrollCharges\#mission#\#DirName#")>			
			
			<cfdirectory action="CREATE" 
			   directory="\\NYVM1618\Files\ServicePayrollCharges\#mission#\#DirName#">
			   
		</cfif>			
		
       <cffile action="copy"
	   		   destination="\\NYVM1618\Files\ServicePayrollCharges\#mission#\#DirName#\#DirName#.xls"
			   source="#Parameter.DocumentRootPath#\ServicePayrollCharges\#mission#\#DirName#\#DirName#.xls">		   
			   
</cfoutput>



