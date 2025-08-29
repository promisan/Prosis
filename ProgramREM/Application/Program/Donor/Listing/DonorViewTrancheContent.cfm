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
<!--- listing --->

<cfoutput>
	
	<cfsavecontent variable="myquery">
	
	      SELECT * 
		  FROM #SESSION.acc#TrancheStatus D		      				 
							
	</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>
				
<cfset itm = 0>
		
<cfset itm = itm+1>
<cf_tl id="Donor" var="vDonor">
<cfset fields[itm] = {label      = "#vDonor#", 
					width      = "45", 
					field      = "OrgUnitName",		
					search     = "text",
					filtermode = "2",					
					alias      = "D"}>		
					
	
<cfset itm = itm+1>
<cf_tl id="Class" var="vClass">
<cfset fields[itm] = {label      = "#vClass#", 
					width        = "0", 
					field        = "ContributionClassName",	
					search       = "text",
					filtermode   = "2",	
					display      = "No",
					filterfield  = "Description",							
					alias        = "D"}>		
					
<cfset itm = itm+1>
<cf_tl id="Earmark" var="vEarmark">
<cfset fields[itm] = {label      = "#vEarmark#", 
					width        = "0", 
					field        = "EarmarkName",
					search       = "text",	
					filterfield  = "Description",
					filtermode   = "2",	
					display      = "No",						
					alias        = "D"}>																
					
			
			
<cfset itm = itm+1>
<cf_tl id="Reference" var="vReference">
<cfset fields[itm] = {label      = "#vReference#", 
					width      = "0", 
					search     = "text",	
					field      = "LineReference",							
					alias      = "D"}>		
					
<!--- different dates to be shown Kristhian 									
		
<cfset itm = itm+1>
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label      = "#vDate#", 
					width      = "0", 
					field      = "DateSubmitted",	
					align      = "center",	
					formatted  = "dateformat(DateSubmitted,CLIENT.DateFormatShow)",		
					search     = "date",		
					alias      = "D"}>		
					
--->					
					
<cfset itm = itm+1>
<cf_tl id="Received" var="vDateR">
<cfset fields[itm] = {label      = "#vDateR#", 
					width      = "0", 
					field      = "LineDateReceived",	
					align      = "center",	
					formatted  = "dateformat(LineDateReceived,CLIENT.DateFormatShow)",		
					search     = "date",		
					alias      = "D"}>	
					
<cfset itm = itm+1>
<cf_tl id="Effective" var="vDateE">
<cfset fields[itm] = {label      = "#vDateE#", 
					width      = "0", 
					field      = "LineDateEffective",	
					align      = "center",	
					formatted  = "dateformat(LineDateEffective,CLIENT.DateFormatShow)",		
					search     = "date",		
					alias      = "D"}>	
					
<cfset itm = itm+1>
<cf_tl id="Expiration" var="vDateX">
<cfset fields[itm] = {label      = "#vDateX#", 
					width      = "0", 
					field      = "LineDateExpiration",	
					align      = "center",	
					formatted  = "dateformat(LineDateExpiration,CLIENT.DateFormatShow)",		
					search     = "date",		
					alias      = "D"}>								

				
<cfset itm = itm+1>				
<cf_tl id="Status" var="vStatus">
<cfset fields[itm] = {label      = "#vStatus#",
					width      = "0", 
					field      = "StatusDescription",
					alias      = "D",
					search     = "text",
					filtermode = "2"}>	
										
				
<cfset itm = itm+1>
<cf_tl id="Fund" var="vFund">
<cfset fields[itm] = {label      = "#vFund#",
					width      = "0", 
					field      = "Fund",	
					align      = "center",				
					alias      = "D",
					search     = "text",
					filtermode = "2"}>	
					
						
<cfset itm = itm+1>					
<cf_tl id="Amount" var="vAmount">
<cfset fields[itm] = {label      = "#vAmount#",
					field      = "Tranche",
					align      = "right",
					width      = "24",
					aggregate  = "SUM",
					formatted  = "numberformat(Tranche,',__')"}>
					
					
<cfset itm = itm+1>					
<cf_tl id="Correction" var="vCorrection">
<cfset fields[itm] = {label      = "#vCorrection#",                     			
					field      = "Correction",
					align      = "right",	
					width      = "24",				
					formatted  = "numberformat(Correction,',__')"}>					
				
<cfset itm = itm+1>				
<cf_tl id="Allotted" var="vAllotted">
<cfset fields[itm] = {label      = "#vAllotted#",    					
					field      = "Alloted",	
					align      = "right",
					width      = "24",
					formatted  = "numberformat(Alloted,',__')",														
					filtermode = "0"}>		
					
<cfset itm = itm+1>				
<cf_tl id="Balance" var="vBalance">
<cfset fields[itm] = {label      = "#vBalance#",    					
					field      = "Balance",	
					align      = "right",
					width      = "24",
					formatted  = "numberformat(Balance,',__')",														
					filtermode = "0"}>																						

<!---
						
<!--- second line fields --->

<cfset itm = itm+1>					
<cf_tl id="Name" var="vName">
<cfset fields[itm] = {label    = "#vName#",                     			
					field      = "Description",
					search     = "text",
					rowlevel   = "2",
					colspan    = "12",	
					row        = "2"}>
					
					--->
						
<!--- hidden fields --->					
	
<cfset itm = itm+1>
<cf_tl id="Id" var="vId">
<cfset fields[itm] = {label      = "#vId#", 
                    width      = "1%", 					
					display    = "No",
					alias      = "D",
					field      = "ContributionId"}>	
			
<!--- embed|window|dialogajax|dialog|standard --->

<cfsavecontent variable="myaddscript">

<cfparam name="url.id1" default="">

	<cfoutput>
		h = #client.height-90#;
		w = #client.width-60#;
		ptoken.open('#SESSION.root#/ProgramREM/Application/Program/Donor/Contribution/ContributionViewGeneral.cfm?mission=#url.mission#&id1=#url.id1#&action=new','_blank','left=30, top=30, width=' + w + ', height= ' + h + ', toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes');		
	</cfoutput>

</cfsavecontent>

<cfset menu=ArrayNew(1)>
<cf_tl id="New Contribution" var="vNewContribution">
<cfset menu[1] = {label = "#vNewContribution#", icon = "add.png", script = "#myaddscript#"}>				 		
					
<cf_listing header          = "listing1"
		    box             = "donordetail"
			link            = "#SESSION.root#/ProgramREM/Application/Program/Donor/Listing/DonorViewTrancheContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&id1=#url.id1#"
		    html            = "No"		
			datasource      = "AppsQuery"
			listquery       = "#myquery#"
			listgroup       = "StatusDescription"
			listorder       = "OrgUnitName"		
			listorderdir    = "ASC"
			headercolor     = "transparent"		
			height          = "100%"
			menu            = "#menu#"			
			filtershow      = "Hide"
			excelshow       = "Yes"
			listlayout      = "#fields#"			
			show            = "40"
			drillmode       = "window"	
			annotation      = "entDonor"
		    drillargument   = "#client.height-90#;#client.width-60#;true;true"				
			drilltemplate   = "ProgramREM/Application/Program/Donor/Contribution/ContributionView.cfm?systemfunctionid=#url.systemfunctionid#&drillid="
			drillkey        = "ContributionId"			
			drillbox        = "editdonor">