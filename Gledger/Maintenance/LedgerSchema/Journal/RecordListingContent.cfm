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
<cfsavecontent variable="myquery">

	<cfoutput>	  
	
		SELECT *
		
		FROM (	
	
			 SELECT  J.*, 
	
			        (SELECT count(*) 
					 FROM  TransactionHeader 
					 WHERE Journal = J.Journal) as Lines,
					
					(SELECT TOP 1 GLAccount 
					  FROM  JournalAccount  
					  WHERE Journal = J.Journal
					  AND   Mode = 'Contra'
					  ORDER BY ListDefault DESC) as GLAccountJournal,
					 
			         T.TransactionCategory as Category, 
					 T.Description as DescriptionCategory,
					 T.OrderListing 
			 
			FROM     Journal J, Ref_transactionCategory T
			WHERE    J.transactionCategory = T.transactionCategory
			AND      J.Mission = '#URL.Mission#'
						
		) as D
		
		WHERE 1=1
		--condition	
		
	</cfoutput>	
	
</cfsavecontent>						

<cf_tl id = "Class"           var = "vClass">
<cf_tl id = "Category"        var = "vCategory">
<cf_tl id = "Journal"         var = "vJournal">
<cf_tl id = "Currency"        var = "vCurrency">
<cf_tl id = "System"          var = "vSystem">
<cf_tl id = "Name"            var = "vName">
<cf_tl id = "Contra account"  var = "vContra">
<cf_tl id = "Lines"           var = "vLines">
<cf_tl id = "Active"          var = "vOperational">

<cfset fields=ArrayNew(1)>

<cfset itm = 1>		
<cfset fields[itm] = {label           = "#vClass#",                    	                   
     				field             = "DescriptionCategory",	
					fieldsort         = "OrderListing",				
					column            = "common",												
					search            = "text",
					filtermode  	  = "3"}>	

				
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vJournal#",                    	                   
     				field             = "Journal",																				
					search            = "text"}>	
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vName#",                    	                   
     				field             = "Description",																				
					search            = "text"}>						

<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vCategory#",                    	                   
     				field             = "GLCategory",					
					column            = "common",												
					search            = "text",
					filtermode  	  = "3"}>	
										
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vCurrency#",                    	                   
     				field             = "Currency",					
					column            = "common",												
					search            = "text",
					filtermode  	  = "2"}>		
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vLines#",                    	                   
     				field             = "Lines",	
					align             = "right",																			
					search            = "amount"}>															   

				
<cfset itm = itm+1>		
<cfset fields[itm] = {label           = "#vOperational#",                    
     				field             = "Operational",						
					filtermode        = "2",
					formatted         = "Rating",
					ratinglist        = "0=red,1=green"}>				
											  		  						
<cfset itm = itm+1>						
<cf_tl id="Created" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    					
					field        = "Created",		
					fieldentry   = "1",			
					align        = "center",		
					labelfilter  = "#lt_text#",						
					formatted    = "dateformat(Created,CLIENT.DateFormatShow)"}>					

	
<cfset menu=ArrayNew(1)>	

<cfset newLabel = "Add journal">
<cf_tl id="#newLabel#" var="1">
<cfset menu[1] = {label = "#lt_text#", script = "recordadd('#url.mission#')"}>		
		   
<!--- embed|window|dialogajax|dialog|standard --->		

<cf_listing
    header              = "journallist"
    box                 = "journal_#url.mission#"
	link                = "#SESSION.root#/Gledger/Maintenance/LedgerSchema/Journal/RecordlistingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"		
	datasource          = "AppsLedger"
	height              = "100%"
	listquery           = "#myquery#"	
	listgroup           = "DescriptionCategory"			
	listorder           = "Journal"
	listorderalias      = ""
	listorderdir        = "ASC"				
	show                = "500"		
	menu                = "#menu#"	
	filtershow          = "Hide"
	excelshow           = "Yes" 		
	listlayout          = "#fields#"
	drillmode           = "tab" 
	drillargument       = "#client.height-90#;#client.width-90#;false;false"	
	drilltemplate       = "/Gledger/Maintenance/LedgerSchema/Journal/RecordEdit.cfm?id1="
	drillkey            = "Journal">	