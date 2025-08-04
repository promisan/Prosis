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

<cfparam name="URL.Mission"  default="">
<cfparam name="URL.Type"     default="Class">
<cfparam name="URL.STA"      default="Class">
<cfparam name="url.tasktype" default="purchase">
<cfparam name="URL.Code"     default="">

<cfinclude template = "TaskDeliveryStatus.cfm">

<cfinvoke component = "Service.Process.Materials.Taskorder"  
	   method           = "CountStatus" 
	   mode             = "listing"
	   mission          = "#url.mission#"
	   warehouse        = "#url.warehouse#"
	   tasktype         = "#url.tasktype#"
	   STA              = "#url.STA#"							  
	   ShipToMode       = "#url.code#"
	   returnvariable   = "myquery">			

	<cfset itm = 0>

	<cfset fields=ArrayNew(1)>	
	
	<cfif url.tasktype eq "purchase">
	
		<cfset itm = itm+1>	
		<cfset fields[itm] = {label   = "Vendor",                   		
							  field   = "OrgUnitName",					
							  filtermode = "2",
							  search  = "text"}>	
	
	<cfelse>
	
		<cfset itm = itm+1>	
		<cfset fields[itm] = {label   = "Locaton",                   		
							  field   = "Description",					
							  filtermode = "2",
							  search  = "text"}>		
	
	</cfif>

	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "Taskorder No",                   		
						  field   = "Reference",					
						  search  = "text"}>	
						  
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "Order Date",                   		
						  field   = "OrderDate",					
					      formatted  = "DateFormat(OrderDate,CLIENT.DateFormatShow)",
						  search  = "date"}>	
						  
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "Officer",                   		
						  field   = "Officerlastname",					
						  alias       = "T",
					      searchalias = "T",						     
						  search  = "text"}>							  
						  
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "Issued",                   		
						  field   = "Created",					
						  alias       = "T",
					      searchalias = "T",	
					      formatted  = "DateFormat(Created,CLIENT.DateFormatShow)",
						  search  = "date"}>						  

	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "Delivery Date",                   		
						  field   = "DeliveryDate",	
						  display = "No",				
					      formatted  = "DateFormat(DeliveryDate,CLIENT.DateFormatShow)",
						  search  = "date"}>	
						  
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "Destination", 	                      				             		
						  field   = "Destination"}>							  	
	
	<!---					  
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "Lines", 
	                      align   = "center",  
						  width    = "20",                 		
						  field   = "TotalLines"}>		
						  
						  --->
						  
	<cfif url.sta eq "0">	
	
	<!--- show the flow status --->
	
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label      = "Stage", 					
					field      = "ActionDescriptionDue",
					formatted  = "left(ActionDescriptionDue,35)",				
					filtermode = "2",    
					search     = "text"}>					  						  
	
	<cfelse>
	
	<!--- show number of completed lines --->
						  						
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "Fulfilled",  
	                      align   = "right",   
						  width    = "20",               		
						  field   = "TotalReceived"}>		
						  
	</cfif>					  
						  
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label   = "StockOrderId",                   		
						  field   = "StockOrderId",					
						  display = "No"}>						  						  
		  						  
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label       = "",  
	                      labelfiter  = "Status",
						  align       = "center",                		
						  field       = "Sta",					
						  formatted   = "Rating",
				          ratinglist  = "9=Red,0=white,1=Gray,2=yellow,3=Green"
						  }>									  
	
						  			  
<cf_listing
    header         = "TaskListing"
    box            = "linedetail#URL.Type#"
	link           = "#SESSION.root#/Warehouse/Application/StockOrder/Task/Shipment/TaskListingContent.cfm?Mission=#URL.Mission#&tasktype=#url.tasktype#&warehouse=#url.warehouse#&Type=#URL.Type#&STA=#URL.STA#&Code=#URL.Code#"
    html           = "No"		
	tableheight    = "100%"
	tablewidth     = "100%"
	datasource     = "AppsMaterials"
	listquery      = "#myquery#"
	listorderfield = "OrderDate"
	listorder      = "OrderDate"
	listorderdir   = "ASC"
	headercolor    = "ffffff"
	show           = "35"	
	showrows       = "1"	
	filtershow     = "Yes"
	excelshow      = "Yes" 		
	listlayout     = "#fields#"
	allowgrouping  = "No"
	drillmode      = "window" 
	annotation     = "WhsTaskOrder"
	drillargument  = "#client.height-150#;980;true;true"			
	drilltemplate  = "Warehouse/Application/StockOrder/Task/Shipment/TaskView.cfm?scope=regular&stockorderid="
	drillkey       = "StockOrderId"
	drillbox       = "addcasefile">			

	
		