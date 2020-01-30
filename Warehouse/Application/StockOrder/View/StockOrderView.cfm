
<cfparam name="url.objectId" default="00000000-0000-0000-0000-000000000000">
<cfajaximport tags="cfform,cftree,cfdiv,cfinput-datefield">

<cf_menuScript>
<cf_StockOrderScript>
<cf_dialogmaterial>

<cfsavecontent variable="option">
	
	<table width="470" height="100%" align="right" cellspacing="0" cellpadding="0" border="0">
										
	  <tr>  		   
		  
		  	   <cfset ht = "15">
			   <cfset wd = "15">
			   
			   <cfset itm = 0>
			
			   <cfset itm = itm+1>
				
			   <cf_menutab item   = "1" 			       
					padding    = "0"
					type       = "Horizontal"
					name       = "Status and Requests"
					fontcolor     = "white"
					class      = "highlight1"
					iframe     = "detail"
					border     = "yes"
					source     = "iframe:StockOrderTabs.cfm?mission=#url.mission#">		
						
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
						WHERE    SystemFunctionId = '#url.systemfunctionid#'
				</cfquery>
					
				<cfif Module.recordcount eq "1">
									
						<cfquery name="Report" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_ReportControl
							WHERE    Operational        = 1
							AND      SystemModule       = '#module.SystemModule#'
							AND      SystemFunctionName = '#module.FunctionName#'
						</cfquery>
												
						<cfif report.recordcount gte "1">
						
							<cfloop query = "Report">
							
								<cfset item = item+1>
							
								<cf_menutab item  = "#item#" 					            
									iconwidth     = "#wd#" 
									iconheight    = "#ht#" 
									fontcolor     = "white"
									type          = "Horizontal"
									border        = "yes"
									name          = "#FunctionName#"
									source        = "report:#controlid#">			
					
							</cfloop>
						
						</cfif>					
					
				</cfif>
										  
				<cf_tl id="Advanced Inquiry" var="1">
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
						  reportPath     = "Warehouse\Inquiry\Request\"
						  SQLtemplate    = "RequestFactTable.cfm"
						  queryString    = "Mission=#URL.Mission#"
						  dataSource     = "appsQuery" 
						  module         = "Workorder"
						  reportName     = "Facttable: Stock Requests"
						  olap           = "1"
						  target         = "analysisbox"
						  Table1Name     = "Requests"
						  Table2Name     = "Distribution"				  					
						  Table3Name     = "Consumption"								  
						  returnvariable = "script"> 	
									  
			  	 		<cf_menutab item  = "#itm#" 	         		    
							 iconwidth  = "#wd#" 
							 iconheight = "#ht#" 
							 padding    = "0"
							 targetitem = "3"
							 fontcolor  = "white"
							 border     = "yes"
							 type       = "Horizontal"
							 name       = "#tInquiry#"
							 source     = "javascript:#script#">					  	
						
			</tr>
			
	</table>

</cfsavecontent>

<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.systemfunctionid#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">
		
<cf_screentop height="100%" 
	html="no" 	
	label="#lt_content#"		
	line="no"
	jQuery="Yes"
	menuaccess="Yes"	
	bannerheight="56"
	banner="gray">	
	
<cfoutput>

<cf_LayoutScript>
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop">	
				
		<cf_ViewTopMenu label="#lt_content#" option="#option#">
			 			  
	</cf_layoutarea>		
	 	
	<cf_layoutarea position="center" name="box">	
						
				<table width="100%" 
				   height="100%" 
				   border="0" 
				   cellspacing="0" 
				   cellpadding="0">					
				 		
					<cf_menucontainer iframe="detail" item="1" class="regular" template="StockOrderTabs.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#">						
					<cf_menucontainer item="2" class="hide">
					<cf_menucontainer iframe="analysisbox" item="3" class="hide">
					
				</table>
										
	</cf_layoutarea>			
		
</cf_layout>


</cfoutput>

