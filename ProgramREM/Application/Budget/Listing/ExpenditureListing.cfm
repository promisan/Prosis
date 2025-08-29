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
	<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   ProgramPeriod
		WHERE  ProgramCode = '#url.ProgramCode#'	
		AND    Period      = '#url.period#'
	</cfquery>

<cfoutput> 

	<!--- 24/8/2017 contribution base can be different from financial base like in
	STL budget is prepared in EUR, but the base financial currency is USD, so
	we need a different conversion for execution --->

		
	<cfsavecontent variable="myquery">  
	
	   SELECT *
	   FROM (
				
		SELECT   H.Journal, 
		         J.Description as journalDescription,
		         H.JournalSerialNo, 
				 L.JournalTransactionNo,
				 H.DocumentDate, 
				 H.TransactionDate,
				 H.TransactionPeriod,
				 H.TransactionId,		
				 H.Description,		 
				 H.Reference,
				 H.ReferenceName, 
				 H.ReferenceNo, 
				 L.ReferenceId, 
				 L.GLAccount+' '+O.Description as GLAccount, 				 
				 L.Fund, 
				 L.ProgramCode, 
				 L.ProgramPeriod, 			
				 Pe.Reference as ProgramReference,	 
				 L.ObjectCode,
				 (SELECT Code+' -'+left(Description,22)+'-'  <!--- we had very strange issue with matching it for Herve --->
				  FROM   Program.dbo.Ref_Object 
				  WHERE  Code = L.ObjectCode) as ObjectName,
				 L.Currency,
		         L.AmountDebit - L.AmountCredit as Amount 				
		
		FROM     TransactionHeader AS H INNER JOIN
		         TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
		         Journal AS J ON H.Journal = J.Journal INNER JOIN
				 Ref_Account O ON O.GLAccount = L.GLAccount INNER JOIN 
				 Program.dbo.ProgramPeriod Pe ON Pe.ProgramCode = L.ProgramCode and Pe.Period = L.ProgramPeriod 
		
		WHERE    H.Mission         = '#url.mission#' 
		AND      L.ProgramCode     = '#url.ProgramCode#'
		
		<!--- roll up --->			
		AND       L.ProgramCode IN (SELECT ProgramCode 
			                        FROM   Program.dbo.ProgramPeriod Pe
									WHERE  Pe.Period = '#url.period#' 
									AND    Pe.PeriodHierarchy LIKE '#get.PeriodHierarchy#%') 
		
		AND      L.ProgramPeriod   = '#url.Period#'
		
		AND      H.TransactionSource != 'PayrollSeries'
		
		AND      L.TransactionSerialNo <> 0			
				
				) as H
				
		WHERE 1=1
		-- condition		
		
		
	</cfsavecontent>	
		  
</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = "0">

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Journal",                     				
					field        = "JournalDescription",		
					alias        = "H",
					searchalias  = "H",	
					filtermode   = "3",  										
					search       = "text"}>		

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Transaction",                   
					field        = "JournalTransactionNo",			
					alias        = "H",
					searchalias  = "H",		
					width        = "40",
					search       = "text"}>
		
										
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Date Posted",                  			
					field        = "TransactionDate",		
					formatted    = "dateformat(TransactionDate,CLIENT.DateFormatShow)",			 
					width        = "27",
					search       = "date"}>							
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Date Source",                  			
					field        = "DocumentDate",	
					display      = "Yes",	
					width        = "27",
					formatted    = "dateformat(DocumentDate,CLIENT.DateFormatShow)"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Purchase", 
                    width        = "25", 					
					field        = "Reference",
					search       = "text"}>													
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Reference", 
                    width        = "20", 					
					field        = "ReferenceNo",
					search       = "text"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Name", 
                    width        = "50", 					
					field        = "ReferenceName",
					search       = "text"}>											

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Fund",                  			
					field        = "Fund",
					filtermode   = "2",  
					display      = "no",	
					search       = "text"}>							

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Period",                  			
					field        = "TransactionPeriod",	
					display      = "Yes",
					filtermode   = "3",  
					search       = "text"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Object",                    			
					field        = "ObjectCode"}>																		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Object",                    			
					field        = "ObjectName",
					display      = "No",
					filtermode   = "3",  
					searchalias  = "H",
					searchfield  = "ObjectName",
					search       = "text"}>							
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Account",                    			
					field        = "GLAccount",
					filtermode   = "2",  
					display      = "No",					
					search       = "text"}>	
			
<cfset itm = itm+1>														
<cfset fields[itm] = {label      = "Amount",    					
					field        = "Amount",
					align        = "right",
					aggregate    = "sum",					
					formatted    = "numberformat(Amount,',__.__')"}>	
			
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Description",                    			
					field        = "Description",		
					rowlevel      = "2",								
					Colspan       = "10",	
					search       = "text"}>							
					
	
<table width="100%" height="100%" align="center">
<tr>
<td valign="top" style="padding-left:10px;padding-right;10px;padding-bottom:10px">
									
<cf_listing
    header        = "lsLedger"
    box           = "lsLedger"
	link          = "#SESSION.root#/ProgramREM/Application/Budget/Listing/ExpenditureListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&programcode=#url.programcode#&period=#url.period#"	
    html          = "No"
	show          = "30"
	datasource    = "AppsLedger"
	listquery     = "#myquery#"	
	listkey       = "TransactionId"		
	listorder     = "DocumentDate"	
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	annotation    = "GLTransaction"
	drillmode     = "window"	
	drillargument = "930;1200;false;false"
	drilltemplate = "../GLedger/Application/Transaction/View/TransactionViewDetail.cfm?id="
	drillkey      = "TransactionId">

</td>
</tr>
</table>
