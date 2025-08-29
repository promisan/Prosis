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
<cfparam name="url.mission"     default="">

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" scroll="no">
<cf_listingscript>
<cf_layoutscript>

<cfoutput>

<cfsavecontent variable="myquery">

	SELECT *
	FROM (
	
	SELECT	H.TransactionId,
            H.Journal,
            J.Description as JournalDescription,
            H.TransactionReference,
            H.Description as TransactionDescription,
            H.DocumentAmount,
            H.Currency,
            H.DocumentDate,
            C.TransactionCheckId,
            C.CheckNo,
            C.CheckDate,
            C.CheckPayee,
            C.CheckAmount,
            C.CheckMemo,
            C.CheckOfficer,
            C.Created
    FROM	TransactionIssuedCheck C
            INNER JOIN TransactionHeader H
                ON C.Journal          = H.Journal
                AND C.JournalSerialNo = H.JournalSerialNo
                AND	H.RecordStatus   != '9'
                AND	H.ActionStatus    = '1'
                AND H.Mission         = '#url.mission#'
                AND H.Currency        = '#url.currency#'
                AND H.AccountPeriod   = '#url.period#'
            INNER JOIN Journal J ON H.Journal = J.Journal
				) as B
	WHERE 1= 1
	-- condition			

</cfsavecontent>

<cfset itm = 1>
<cf_tl id="Journal" var="vJournal">
<cfset fields[itm] = {label = "#vJournal#",                  
					field   = "JournalDescription",
					search  = "text",
					filtermode = "2"}>

<cfset itm = itm+1>
<cf_tl id="Doc Date" var="vDocDate">
<cfset fields[itm] = {label      = "#vDocDate#", 					
					field      = "DocumentDate",
					formatted  = "dateformat(DocumentDate,CLIENT.DateFormatShow)",
					search     = "date"}>

<cfset itm = itm+1>
<cf_tl id="Check No" var="vCheckNo">
<cfset fields[itm] = {label      = "#vCheckNo#",
					field      = "CheckNo",
					search     = "text",
				    filtermode = "2"}>	

<cfset itm = itm+1>
<cf_tl id="Date" var="vCheckDate">
<cfset fields[itm] = {label      = "#vCheckDate#", 					
					field      = "CheckDate",
					formatted  = "dateformat(CheckDate,CLIENT.DateFormatShow)",
					search     = "date"}>

<cfset itm = itm+1>
<cf_tl id="Payee" var="vPayee">
<cfset fields[itm] = {label      = "#vPayee#",
					field      = "CheckPayee",
					search     = "text"}>

<cfset itm = itm+1>							
<cf_tl id="Amount" var="vAmount">		
<cfset fields[itm] = {label   = "#vAmount#", 					
					field   = "CheckAmount",
					align   = "right",
					formatted  = "numberformat(CheckAmount,',.__')",
					search  = "number"}>

<cfset itm = itm+1>							
<cf_tl id="Doc Amount" var="vDocAmount">		
<cfset fields[itm] = {label   = "#vDocAmount#", 					
					field   = "DocumentAmount",
					align   = "right",
					formatted  = "numberformat(DocumentAmount,',.__')"}>
					
<table height="100%" width="100%">

<tr><td valign="top">	
														
	<cf_listing
	    header           = "Issued checks #url.mission# #url.currency# #url.period#"
	    box              = "checks_#url.mission#_#url.currency#_#url.period#"
		link             = "#SESSION.root#/Gledger/Inquiry/Checks/CheckIssued.cfm?mission=#url.mission#&currency=#url.currency#&period=#url.period#&systemfunctionid=#url.systemfunctionid#"
		systemfunctionid = "#url.systemfunctionid#"
	    html             = "No"	
		datasource       = "AppsLedger"		
		tablewidth       = "100%"	
		excelshow        = "Yes"
        filterShow       = "Yes"	
		listquery        = "#myquery#"
		listkey          = "TransactionId"
		listorder        = "CheckDate"
		listorderdir     = "DESC"
		headercolor      = "ffffff"
		listlayout       = "#fields#"
		drillmode        = "tab"
		drillargument    = "920;1180;false;false"	
		drilltemplate    = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
		drillkey         = "TransactionId">
		
</td></tr>
</table>		
		
</cfoutput>	

<script>
	Prosis.busy('no')	
</script>

