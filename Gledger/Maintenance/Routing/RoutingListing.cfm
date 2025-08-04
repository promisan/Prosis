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
	<cfsavecontent variable="stRouting" >
		Select 
			RoutingNo,
			Mission, 
			DutyStation, 
			Fund, 
			OrgCode,
			PrgCode, 
			ObjectClass, 
			ObjectCode, 
			ObjectName,
			ReconcileMode,
			NOVA_GlAccount,
			NOVA_Object,
			NOVA_Fund
		FROM stLedgerRouting
		Order by Mission, DutyStation, Fund, OrgCode,PrgCode, ObjectClass, ObjectCode
	</cfsavecontent>
	
	<cfset itm = 0>
	<cfset fields=ArrayNew(1)>
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label  = "RoutingNo",                                                  
	                     field   = "RoutingNo",                                                                             
	                     display = "No"}>          
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label  = "Mission",                                                  
	                     field   = "Mission",                                                                             
	                     display = "No"}>   
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "Duty Station",                                                  
	                     field   = "DutyStation",                                                                             
	                     filtermode = "2",
	                     search  = "text"}>          
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "Fund",                                            
	                     field   = "Fund",                                                                    
	                     search  = "text"}>          
	    
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "Org Code",                                           
	                     field   = "OrgCode",                                                                   
	                     search  = "text"}>         
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "Prg Code",                                      
	                     field   = "PrgCode",               
	                     search  = "text"}>                         
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "Object Class",                                    
	                     field   = "ObjectClass",                                                                         
	                     search  = "text"}>         
	   
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "Object Code",                                      
	                     field   = "ObjectCode"}>                                                                                               
	                                                                                                                     
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "Object Name",                                      
	                     field   = "ObjectName"}>
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "Reconcile Mode",                                      
	                     field   = "ReconcileMode"}>
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "NOVA GlAccount",                                      
	                     field   = "NOVA_GlAccount"}>
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "NOVA Object",                                      
	                     field   = "NOVA_Object"}>
	
	<cfset itm = itm+1>         
	<cfset fields[itm] = {label   = "NOVA Fund",                                      
	                     field   = "NOVA_Fund"}>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td valign="top">	

				<cf_listing
					header        = "TaskListing"
					box           = "routing"
					link          = "#client.root#/GLedger/Maintenance/Routing/RoutingListing.cfm?idmenu=#url.idmenu#"
					html          = "No"                           
					tableheight   = "100%"
					tablewidth    = "100%"
			 		listgroup     = "Mission"
			 		listgroupdir  = "ASC"			
					datasource    = "AppsPurchase"
					listquery     = "#stRouting#"
					listorderfield = "RoutingNo"
					listorder      = "RoutingNo"
					listorderdir   = "ASC"
					headercolor   = "ffffff"
					show          = "35"               
					filtershow    = "Hide"
					excelshow     = "No"                       
					listlayout    = "#fields#"
					allowgrouping = "Yes"
					drillmode      = "window" 
					drillargument  = "#client.height-400#;850;true;true"                                       
					drilltemplate  = "Gledger/Maintenance/Routing/RecordEdit.cfm?idmenu=#url.idmenu#&RoutingNo="
					drillkey       = "RoutingNo"
					drillbox       = "editRouting">
</td></tr></table>		