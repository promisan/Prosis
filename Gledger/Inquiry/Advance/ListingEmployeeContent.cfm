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
<cfoutput>

	<cfsavecontent variable="myquery">	
	
		SELECT *
		FROM (
			SELECT     P.PersonNo, 
				       P.IndexNo, 
					   P.LastName, 
					   P.FirstName, 
					   P.FullName,
					   P.Gender, 
					   P.Nationality, 
					   L.Currency, 
					   L.GLAccount,
					   G.Description,    
					   ROUND(SUM(L.AmountDebit), 2) AS Debit, 
			           ROUND(SUM(L.AmountCredit), 2) AS Credit, 
					   ROUND(SUM(L.AmountDebit) - SUM(L.AmountCredit), 2) AS Balance
			
			FROM       TransactionHeader AS H 
			           INNER JOIN TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
					   INNER JOIN Employee.dbo.Person AS P ON H.ReferencePersonNo = P.PersonNo
					   INNER JOIN Ref_Account G ON G.GLAccount = L.GLAccount 
					   			 
			WHERE      H.Mission = '#URL.Mission#' 
			
			AND        L.GLAccount IN (SELECT GLAccount
				                       FROM   Ref_AccountMission
                                  	   WHERE  Mission = H.Mission
                                       AND    SystemAccount = 'StaffAdvance') 			
						
			AND        H.RecordStatus <> '9' 
			AND        H.ActionStatus <> '9'
			
			<!---
			AND        H.ReferencePersonNo IN (SELECT     PersonNo
			                                   FROM       Employee.dbo.Person) 		
											   --->
		
			AND        L.Currency = '#url.currency#'
			
			AND        L.GLAccount IN (SELECT  GLAccount 
			                           FROM    Ref_Account 
									   WHERE   AccountClass = 'Balance')									   
												   
			GROUP BY   P.PersonNo, 
			           P.IndexNo, 
					   P.FullName,
					   P.LastName, 
					   P.FirstName, 			 
					   P.Gender, 
					   P.Nationality, 
					   L.Currency,
					   L.GLAccount,
					   G.Description
					   		
			) as D
			
		WHERE 1=1	
		
		--condition
		
	
	</cfsavecontent>	
	
</cfoutput>				  

<cfset itm = "0">
				
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>
				
<cfset fields[itm] = {label        = "Account",    	
				    width          = "34", 				
					field          = "GLAccount",									
					search         = "text",
					filtermode     = "3"}>	

<cfset itm = itm+1>
<cfset fields[itm] = {label        = "IndexNo",                    
					field          = "IndexNo",
					functionscript = "EditPerson",
					functionfield  = "personno",
					search         = "text"}>
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label        = "G", 					
                    labelfilter    = "Gender",
					field          = "Gender",	
					column         = "common",				
					filtermode     = "3",    
					search         = "text"}>		

<cfset itm = itm+1>					
<cfset fields[itm] = {label    	   = "Nat.",    					
					field          = "Nationality",
					width          = "14",
					align          = "center",
					column         = "common",		
					filtermode     = "2",					
					search         = "text"}>							

<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Name",                    
					field          = "FullName",
					width          = "200", 
					filtermode     = "2",
					search         = "text"}>	
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label        = "Issued",    
					width          = "40", 
					field          = "Debit",
					align          = "right",
					aggregate      = "sum",
					formatted      = "numberformat(Debit,',.__')"}>
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Offset",    
					width          = "40", 
					field          = "Credit",		
					align          = "right",		
					aggregate      = "sum",	
					formatted      = "numberformat(Credit,',.__')"}>						
		
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Balance",    
					width          = "40", 
					field          = "Balance",
					align          = "right",
					search         = "number",
					aggregate      = "sum",
					formatted      = "numberformat(Balance,',.__')"}>											

<cfset itm = itm+1>			
<cfset fields[itm] = {label        = "PersonNo",    
					width          = "1%", 
					Display        = "No",
					key            = "yes",
					field          = "PersonNo"}>				
									
<cf_listing
    header          = "Finance"
    box             = "transaction"
	link            = "#SESSION.root#/GLedger/Inquiry/Advance/ListingEmployeeContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&currency=#url.currency#&area=#url.area#"
    html            = "No"
	show            = "40"
	datasource      = "AppsLedger"
	listquery       = "#myquery#"
	listkey         = "PersonNo"
	listorder       = "LastName"
	listorderdir    = "ASC"
	listgroup       = "GLAccount"	
	listlayout      = "#fields#"
	filterShow      = "Yes"
	excelShow       = "Yes"
	drillmode       = "tab"
	drillargument   = "940;1000;false;false"	
	drilltemplate   = "Gledger/Application/lookup/AccountResult.cfm?mission=#url.mission#&currency=#url.currency#&account="
	drillkey        = "GLAccount">
	