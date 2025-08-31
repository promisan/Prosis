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
    datasource="AppsLedger" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT      DISTINCT Mission,TransactionBatchNo
    FROM        Materials.dbo.ItemTransaction
    WHERE       WorkOrderId   = '#url.workorderid#' 
	AND         WorkOrderLine = '#url.workorderline#'	
</cfquery>

<!--- listing --->

<cfoutput> 

	<cfsavecontent variable="myquery">  
				
		SELECT   H.Journal, 
		         H.JournalSerialNo, 
				 H.DocumentDate, 
				 H.TransactionDate,
				 H.TransactionId,				 
				 L.ReferenceName, 
				 L.ReferenceNo, 
				 L.ReferenceId, 
				 L.GLAccount,
				 O.Description as GLAccountName, 	
				 I.TransactionType,		
				 I.TransactionBatchNo,	 
				 L.Fund, 
				 L.ProgramCode, 
				 L.ProgramPeriod, 							 
				 L.ObjectCode,			
				 R.Description,	 
		         L.AmountBaseDebit,
				 L.AmountBaseCredit 				
		
		FROM     TransactionHeader AS H INNER JOIN
		         TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
		         Journal AS J ON H.Journal = J.Journal INNER JOIN
				 Ref_Account O ON O.GLAccount = L.GLAccount INNER JOIN
				 Materials.dbo.ItemTransaction I ON I.TransactionId = H.ReferenceId INNER JOIN
				 Materials.dbo.Ref_TransactionType R ON R.TransactionType = I.TransactionType
		
		WHERE    H.Mission = '#get.mission#' 		
		<cfif get.TransactionBatchNo neq "">		
		AND      I.TransactionBatchNo IN (#quotedvalueList(get.TransactionBatchNo)#)		
		<cfelse>
		AND      1=0
		</cfif>
		
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
					Display      = "No",
					formatted    = "dateformat(DocumentDate,CLIENT.DateFormatShow)",			 
					search       = "date"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Type",                    			
					field        = "Description",
					filtermode   = "2",  
					searchalias  = "R",
					searchfield  = "Description",
					search       = "text"}>								
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Account",                    			
					field        = "GLAccount",
					filtermode   = "2",  
					searchalias  = "L",
					searchfield  = "GLAccount",
					search       = "text"}>			
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Name",                    			
					field        = "GLAccountName",
					filtermode   = "2",  
					searchalias  = "O",
					searchfield  = "Description",
					search       = "text"}>																	

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Reference", 
                    width        = "50", 					
					field        = "ReferenceName",
					search       = "text"}>	
					
<!---

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
--->					


				
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Batch",                    			
					field        = "TransactionBatchNo",					
					filtermode   = "2",  
					searchalias  = "I",
					searchfield  = "TransactionBatchNo",
					search       = "text"}>										
					
		
<cfset itm = itm+1>														
<cfset fields[itm] = {label      = "Debit",    					
					field        = "AmountBaseDebit",
					align        = "right",
					aggregate    = "sum",					
					formatted    = "numberformat(AmountBaseDebit,',.__')"}>		
					
<cfset itm = itm+1>														
<cfset fields[itm] = {label      = "Credit",    					
					field        = "AmountBaseCredit",
					align        = "right",
					aggregate    = "sum",					
					formatted    = "numberformat(AmountBaseCredit,',.__')"}>								
					
	
<table width="100%" height="100%" align="center"><tr><td valign="top" style="padding-left:10px;padding-right;10px;padding-bottom:10px">
									
<cf_listing
	    header        = "lsLedger"
	    box           = "lsLedger"
		link          = "#SESSION.root#/Workorder/Application/Assembly/Items/Halfproduct/Summary/PostingListing.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&workorderline=#url.workorderline#"	
	    html          = "No"
		show          = "30"
		datasource    = "AppsLedger"
		listquery     = "#myquery#"	
		listkey       = "TransactionId"		
		listorder     = "TransactionType"	
		listorderdir  = "ASC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"
		filterShow    = "Yes"
		excelShow     = "Yes"
		annotation    = "GLTransaction"
		drillmode     = "window"	
		drillargument = "1030;1100;false;false"
		drilltemplate = "../GLedger/Application/Transaction/View/TransactionViewDetail.cfm?id="
		drillkey      = "TransactionId">

</td></tr></table>
