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
<cfparam name="url.objectId" default="00000000-0000-0000-0000-000000000000">

<cf_menuScript>

<cf_CustomerScript>

<cfsavecontent variable="option">
	
	<table width="470" height="100%">
									
  	<tr>  	   
	  
	  	  <cfset ht = "15">
		  <cfset wd = "15">
		   
		  <cfset itm = 0>
		
		  <cfset itm = itm+1>
			
		  <cf_menutab item   = "1" 			       
			padding    = "0"
			type       = "Horizontal"
			name       = "Status and Requests"
			border     = "Yes"
			class      = "highlight1"
			iframe     = "detail">		
					
		  <!--- access --->	
		   		   
		  <cfinvoke component = "Service.Access"  
			   method           = "WorkOrderProcessor" 
			   mission          = "#url.mission#"  
			   returnvariable   = "access">
			   
		  <!--- only for workorder processors with access = 2 (ALL) --->	   		 
		  				
		  <!--- check for report --->
			 																		
		  <cfquery name="Module" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   * 
					FROM     Ref_ModuleControl
					WHERE    SystemFunctionId = '#url.idmenu#'
		  </cfquery>
				
		  <cfif Module.recordcount eq "1">
								
					<cfquery name="Report" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_ReportControl
						WHERE    Operational = 1
						AND      SystemModule = '#module.SystemModule#'
						AND      SystemFunctionName = '#module.FunctionName#'
					</cfquery>
											
					<cfif report.recordcount gte "1">
					
						<cfloop query = "Report">
						
							<cfset item = item+1>
						
							<cf_menutab item  = "#item#" 
					            iconsrc       = "Logos/Report.png" 
								iconwidth     = "#wd#" 
								iconheight    = "#ht#" 
								border        = "Yes"
								type          = "Horizontal"
								name          = "#FunctionName#"
								source        = "report:#controlid#">			
				
						</cfloop>
					
					</cfif>					
				
			</cfif>
			
			<cfinvoke component = "Service.Access"  
				   method           = "RoleAccess" 
				   mission          = "#url.mission#" 
				   role             = "'WorkRequestManager'" 
				   returnvariable   = "accessrole">
						
			<!--- show dataset only to processors or request managers --->
			
			<cfif access neq "NONE" or accessrole neq "DENIED">	
						  
				<cf_tl id="Extended Inquiry" var="1">
				<cfset tInquiry = "#Lt_text#">
				
				<cfset itm = itm+1>
	
				    <!--- just to create the needed scripts here, button is hidden --->
	
					<cfinvoke component="Service.Analysis.CrossTab"  
					  method         = "ShowInquiry"
					  buttonName     = "Analysis"				  
					  buttonClass    = "variable"		<!--- pass the loading script --->  
					  buttonIcon     = "#SESSION.root#/Images/dataset.png"
					  buttonText     = "#tInquiry#"
					  buttonStyle    = "height:29px;width:120px;"
					  reportPath     = "Workorder\Application\WorkOrder\ServiceDetails\Charges\"
					  SQLtemplate    = "ChargesFactTable.cfm"
					  queryString    = "Mission=#URL.Mission#"
					  dataSource     = "appsQuery" 
					  module         = "Workorder"
					  reportName     = "Facttable: Customer"
					  olap           = "1"
					  target         = "analysisbox"
					  Table1Name     = "Charges"
					  Table2Name     = "Usage"				  
					  Table3Name     = "Provisioning"
					  returnvariable = "script"> 	
								  								  
		  	 		 <cf_menutab item  = "#itm#" 
	         		   iconsrc    = "" 
					   iconwidth  = "#wd#" 
					   iconheight = "#ht#" 
					   padding    = "0"
					   targetitem = "3"
					   border     = "Yes"
					   type       = "Horizontal"
					   name       = "#tInquiry#"
					   source     = "javascript:#script#">	
					 
			  </cfif>	
			  
			  <cfif access eq "ALL">	   		
		 
				   <cfset itm = itm+1>
				   <cf_tl id="New Customer" var="vNewCustomer">
				   
				   <cf_menutab item   = "#itm#" 				      
							targetitem  = ""
							padding    = "0"
							type       = "Horizontal"
							border     = "Yes"
							iconheight = "#ht#" 
							name       = "#vNewCustomer#"
							source     = "javascript:add('#url.dsn#')">	
					
			</cfif>		 	
					
	</tr>
			
	</table>

</cfsavecontent>

<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.idmenu#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">

	<cfif lt_content eq "">
	    <cfset lt_content = "Prosis function">
	</cfif>
				
<cf_screentop height="100%" 
	html="No" 
	line="No" 
	label="#lt_content#"
	option="#option#" 
	Layout="Webapp" 		
	banner="gray"
	border="0"	
	jQuery="Yes"
	busy="busy10.gif"
	MenuAccess="Yes"		
	SystemFunctionId="#url.idmenu#">	
		
<cfoutput>

<cf_layoutScript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	 	 
<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	      type      = "Border"
          position  = "header"		
		  size      = "40" 
          name      = "controltop">		
		
		<cf_ViewTopMenu label="#lt_content# #URL.Mission#" background="gray">
				 
	</cf_layoutarea>		 

	<cf_layoutarea  type="Border" position="center" name="box" overflow="hidden" style="height:100%">
		
		<table width="100%" 
		   height="100%">		
		   		   		
			<cf_menucontainer iframe="detail" item="1" class="regular" 
					template="CustomerViewTabs.cfm?mission=#url.mission#&dsn=#url.dsn#&systemfunctionid=#url.idmenu#">		
											
			<cf_menucontainer item="2" class="hide">			
			<cf_menucontainer iframe="analysisbox" item="3" class="hide">
			
		</table>		
									
	</cf_layoutarea>		
	
	<cf_layoutarea 
	      type      = "Border"
          position  = "bottom"		 
          name      = "controlbottom">		
		
		<table width="100%" bgcolor="C0C0C0"><tr><td style="border-top:1px solid gray" height="10"></td></tr></table>
		
	</cf_layoutarea>			
	
</cf_layout>	

</cfoutput>