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
<cfswitch expression="#URL.ID#">
	
	<cfcase value="STA">
		<cfset condition = "WHERE PL.ActionStatus != '9' AND P.ActionStatus = '#URL.ID1#' AND P.Period = '#URL.Period#' AND P.Mission = '#URL.Mission#'">
				
		 <cfquery name="Display" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    *
			FROM      Status
			WHERE     StatusClass = 'Job' 
			AND       Status = '#URL.ID1#'
		  </cfquery>
	  	
		 <cfset text = "#Display.Description#">
		 
	</cfcase>
			
	<cfcase value="LOC">
	   <cfset text = "Inquiry">
	</cfcase>
	
</cfswitch>

<cfset condition = "AND J.Period = '#URL.Period#' AND J.Mission = '#URL.Mission#'">
   
<cfif URL.ID eq "STA">
	  
	  <cfoutput>
	  <cfsavecontent variable="myquery">
		SELECT    J.JobNo, 
		          J.CaseNo, 
				  J.CaseName, 
				  J.OrderClass, 
				  J.Description,
				  J.Created, 
				  J.DeadLine,
				  Sum(RequestAmountBase) as Total	
		FROM      RequisitionLine R INNER JOIN
	              Job J ON R.JobNo = J.JobNo
		WHERE     (R.RequisitionNo NOT IN
                          (SELECT     RequisitionNo
                            FROM          PurchaseLine))			
		AND      R.ActionStatus = '2k' 
		<cfif url.id1 neq "">
		AND      J.ActionStatus = '#URL.ID1#'		
		</cfif>
		 #preserveSingleQuotes(condition)# 			
		GROUP BY  J.Created, J.JobNo, J.CaseNo, J.CaseName, J.OrderClass, J.Deadline, J.Description									
				
	   </cfsavecontent>
	   </cfoutput>
	
<cfelse>

<!--- N/A --->
	
</cfif>	

<cf_listingScript>
	
<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset fields[1] = {label      = "Job",                  
					field      = "JobNo",
					alias      = "J",
					search     = "text"}>
								
<cfset fields[2] = {label      = "Case No",                    
					field      = "CaseNo",	
					alias      = "J",				
					search     = "text"}>					
					
<cfset fields[3] = {label      = "Name",                 
					field      = "CaseName",					
					search     = "text"}>
						
<cfset fields[4] = {label      = "Class", 					
					field      = "OrderClass",						
					filtermode = "2",    
					search     = "text"}>					
					
<cfset fields[5] = {label      = "Created",   					
					field      = "Created",		
					alias      = "J",			
					formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					search     = "date"}>
									
<cfset fields[6] = {label      = "Deadline",    					
					field      = "Deadline",		
					alias      = "J",			
					formatted  = "dateformat(Deadline,CLIENT.DateFormatShow)",
					search     = "date"}>					
															
<cfset fields[7] = {label      = "Amount",    					
					field      = "Total",
					align      = "right",
					formatted  = "numberformat(Total,'__,__.__')"}>	
					
<cfset fields[8] = {label      = "CaseName",    					
					field      = "Description",
					rowlevel    = "2",
					colspan     = "0"}>						
							
<cf_listing
    header        = "lsJob"
    box           = "lsJob"
	link          = "#SESSION.root#/Procurement/Application/PurchaseOrder/JobView/JobViewListing.cfm?#cgi.query_string#"
    html          = "No"
	show          = "20"
	tablewidth    = "99%"
	datasource    = "AppsPurchase"
	listquery     = "#myquery#"
	listkey       = "JobNo"
	listorder     = "Created"
	listorderalias = "J"
	listorderdir  = "ASC"	
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "window"
	drillargument = "#client.height-60#;#client.width-100#;false;false"	<!--- h then w --->
	drilltemplate = "Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?id1="
	drillkey      = "JobNo">

