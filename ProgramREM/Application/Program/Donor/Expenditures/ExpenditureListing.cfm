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

<!--- listing associations --->

<cfquery name="get"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT  C.*, R.Description as Classdescription
	FROM    Contribution C, Ref_ContributionClass R
	WHERE   C.ContributionClass = R.Code
	AND     ContributionId = '#URL.ContributionId#'
</cfquery>


<!--- listing --->

<cfoutput> 

	<!--- 24/8/2017 contribution base can be different from financial base like in
	STL budget is prepared in EUR, but the base financial currency is USD, so
	we need a different conversion for execution --->

	<cfsavecontent variable="myquery">  
				
		SELECT   H.Journal, 
		         H.JournalSerialNo, 
				 H.DocumentDate, 
				 H.TransactionDate,
				 H.TransactionId,				 
				 L.ReferenceName, 
				 L.ReferenceNo, 
				 L.ReferenceId, 
				 L.GLAccount+' '+O.Description as GLAccount, 				 
				 L.Fund, 
				 L.ProgramCode, 
				 L.ProgramPeriod, 			
				 Pe.Reference as ProgramReference,	 
				 L.ObjectCode,
				 C.Reference,
		         L.AmountBaseDebit - L.AmountBaseCredit as Amount 				
		
		FROM     TransactionHeader AS H INNER JOIN
		         TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
		         Journal AS J ON H.Journal = J.Journal INNER JOIN
				 Ref_Account O ON O.GLAccount = L.GLAccount INNER JOIN 
				 Program.dbo.ProgramPeriod Pe ON Pe.ProgramCode = L.ProgramCode and Pe.Period = L.ProgramPeriod INNER JOIN 
				 Program.dbo.ContributionLine C ON C.ContributionLineId = L.ContributionLineId
		
		WHERE    H.Mission = '#GET.mission#' 
		
		AND      L.TransactionSerialNo <> 0
		
		AND      C.ContributionId = '#url.ContributionId#'		
		
	</cfsavecontent>	
		  
</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = "0">

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Journal",                     				
					field        = "Journal",		
					alias        = "H",
					searchalias  = "H",	
					filtermode   = "2",  										
					search       = "text"}>		

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "SerialNo",                   
					field        = "JournalSerialNo",			
					alias        = "H",
					searchalias  = "H",		
					search       = "number"}>
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Date",                  			
					field        = "DocumentDate",		
					formatted    = "dateformat(DocumentDate,CLIENT.DateFormatShow)",			 
					search       = "date"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Account",                    			
					field        = "GLAccount",
					filtermode   = "2",  
					searchalias  = "L",
					searchfield  = "GLAccount",
					search       = "text"}>												

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Reference", 
                    width        = "50", 					
					field        = "ReferenceName",
					search       = "text"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Fund",                  			
					field        = "Fund",
					filtermode   = "2",  
					search       = "text"}>							
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Program",                    			
					field        = "ProgramReference",
					alias        = "Pe",		
					searchfield  = "Reference",			
					searchalias  = "Pe",
					search       = "text"}>						

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Object",                    			
					field        = "ObjectCode",
					filtermode   = "2",  
					searchalias  = "L",
					searchfield  = "ObjectCode",
					search       = "text"}>			
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Tranche",                    			
					field        = "Reference",					
					filtermode   = "2",  
					searchalias  = "C",
					searchfield  = "Reference",
					search       = "text"}>										
			
<cfset itm = itm+1>														
<cfset fields[itm] = {label      = "Amount",    					
					field        = "Amount",
					align        = "right",
					aggregate    = "sum",					
					formatted    = "numberformat(Amount,'__,__')"}>			
					
	
<table width="100%" height="100%" align="center">
<tr>
<td valign="top" style="padding-left:10px;padding-right;10px;padding-bottom:10px">
									
<cf_listing
    header        = "lsLedger"
    box           = "lsLedger"
	link          = "#SESSION.root#/ProgramREM/Application/Program/Donor/Expenditures/ExpenditureListing.cfm?systemfunctionid=#url.systemfunctionid#&contributionid=#url.contributionid#"	
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
	drillargument = "930;1000;false;false"
	drilltemplate = "../../GLedger/Application/Transaction/View/TransactionViewDetail.cfm?id="
	drillkey      = "TransactionId">

</td>
</tr>
</table>
