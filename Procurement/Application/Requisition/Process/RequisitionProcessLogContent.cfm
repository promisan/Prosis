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
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">
<cfparam name="URL.OrderClass" default="">

<cfquery name="Parameter" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Ref_ParameterMission 
   WHERE  Mission = '#url.mission#'
</cfquery>
 

<!--- pass the view --->

<cfoutput> 

	<cfsavecontent variable="myquery">  
		SELECT   *
		FROM  	userQuery.dbo.lsRequest_#SESSION.acc# P			 			
	</cfsavecontent>	
		  
</cfoutput>

<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cf_tl id="Action" var="1">
						
<cfset fields[itm] = {label       = "#lt_text#",                   
					field         = "Mode",		
					filtermode    = "2",						
					search        = "text"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Date" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
                    width      = "0", 			
					search     = "date",	
					formatted  = "dateformat(ActionDate,CLIENT.DateFormatShow)",	
					field      = "ActionDate"}>		
					
<cfset itm = itm+1>		
<cf_tl id="Period" var="1">
<cfset fields[itm] = {label      = "#lt_text#",                    
					field      = "Period",
					filtermode = "2",					
					search     = "text"}>											
					
<cfset itm = itm+1>		
<cf_tl id="Reference" var="1">
<cfset fields[itm] = {label      = "#lt_text#",                    
					field      = "Reference",					
					search     = "text"}>
					
									
<cfset itm = itm+1>		
<cf_tl id="Unit" var="1">
<cfset fields[itm] = {label      = "#lt_text#",                     
					field      = "OrgUnitName",
					filtermode = "2",
					search     = "text"}>
					
<cfset itm = itm+1>					
						
<cf_tl id="Description" var="1">
<cfset fields[itm] = {label      = "#lt_text#", 
					width      = "40", 
					field      = "Description",
					search     = "text"}>							

<!---					
<cfset itm = itm+1>					
					
<cf_tl id="Date" var="1">
<cfset fields[itm] = {label      = "#lt_text#",    
					width      = "0", 
					field      = "OrderDate",		
					labelfilter = "Order Date",			
					formatted  = "dateformat(OrderDate,CLIENT.DateFormatShow)",
					search     = "date"}>
--->						
					
<cfset itm = itm+1>					

<cf_tl id="Amount" var="1">
<cfset fields[itm] = {label      = "#lt_text#",
					width      = "0", 
					field      = "RequestAmountBase",
					align      = "right",
					aggregate  = "sum",
					search     = "number",
					formatted  = "numberformat(RequestAmountBase,'__,__.__')"}>	
	


<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">
<tr><td style="padding:6px">
										
	<cf_listing
    	header        = "lsPurchase"
    	box           = "lsPurchase"
		link          = "#SESSION.root#/Procurement/Application/Requisition/Process/RequisitionProcessLogContent.cfm?#cgi.query_string#"		
    	html          = "No"
		show	      = "30"
		datasource    = "AppsQuery"
		listquery     = "#myquery#"
		listkey       = "RequisitionNo"
		listgroup     = "Mode"	
		listorder     = "ActionDate"
		listorderalias = ""
		listorderdir  = "DESC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"		
		filterShow    = "Yes"
		Annotation    = "ProcReview"
		excelShow     = "Yes"
		drillmode     = "window"	
		drilltemplate = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?header=1&mode=dialog&id="
		drillkey      = "RequisitionNo">

</td></tr></table>
