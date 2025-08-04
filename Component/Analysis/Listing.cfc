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
  
  <cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Listing Init">
	
	<cffunction access="public" name="InitInquiry" 
	         output="true" 
			 returntype="string" 
			 displayname="Show a button to the user">		
				 			 			 
		<cfargument name="ButtonName"     		type="string"  required="yes"   default="Inquiry">		 
		<cfargument name="ButtonClass"    		type="string"  required="yes"   default="ButtonFlat">			 
		<cfargument name="ButtonIcon"     		type="string"  required="yes"   default="excel.png">			 
		<cfargument name="ButtonText"     		type="string"  required="yes"   default="">			 
		<cfargument name="ButtonStyle"    		type="string"  required="yes"   default="">			 
		<cfargument name="ButtonWidth"    		type="string"  required="yes"   default="180px">
		<cfargument name="ButtonHeight"   		type="string"  required="yes"   default="30px">
		<cfargument name="ButtonBGColor"  		type="string"  required="yes"   default="f4f4f4">
		<cfargument name="ButtonTextSize" 		type="string"  required="yes"   default="13px">
		<cfargument name="ButtonTextColor" 		type="string"  required="yes"   default="black">
		<cfargument name="ButtonBorderColor" 	type="string"  required="yes"   default="##6B6B6B">
		<cfargument name="ButtonBorderColorInit" type="string"  required="yes"   default="silver">
		<cfargument name="ButtonBorderRadius" 	type="string"  required="yes"   default="6px">
		<cfargument name="ButtonOnmouseover" 	type="string"  required="yes"   default="this.style.border='1px solid #ButtonBorderColor#';">
		<cfargument name="ButtonOnmouseout" 	type="string"  required="yes"   default="this.style.border='1px solid #ButtonBorderColorInit#';">
		
		<cfargument name="Module"               type="string"  required="yes"   default="Reporting">
		<cfargument name="FunctionName"         type="string"  required="yes"   default="My listing">
		<cfargument name="FunctionClass"        type="string"  required="yes"   default="Listing">
		<cfargument name="MenuClass"            type="string"  required="yes"   default="Embed">
			
		<!--- pass the datasets NEW 
		<cfargument name="datasets"       type="array"   required="no"    default="#ArrayNew(1)#">
		--->
				
		<cfargument name="Target"               type="string"  required="yes"   default="_blank">
		<cfargument name="ListingPath"          type="string"  required="yes"   default="">
		<cfargument name="Data"                 type="string"  required="yes"   default="1">
		<cfargument name="scriptfunction"       type="string"  required="yes"   default="facttablexls">
		<cfargument name="ListingTemplate"      type="string"  required="yes"   default="">
		<cfargument name="QueryString"          type="string"  required="yes"   default="">
		<cfargument name="SelectedId"           type="string"  required="yes"   default="">
		<cfargument name="Filter"               type="string"  required="yes"   default="1">
		<cfargument name="Ajax"                 type="string"  required="yes"   default="0">
		<cfargument name="Excel"                type="string"  required="yes"   default="0">
		<cfargument name="OLAP"                 type="string"  required="yes"   default="0">
		<cfargument name="Report"               type="string"  required="yes"   default="0">	
		<cfargument name="Invoke"               type="string"  required="yes"   default="No">
		<cfargument name="returnvariable"       type="string"  required="yes"   default="">
		
									
		<!--- register this listing to obtain a system function id --->
		
		<cfquery name="System" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
			FROM      Parameter	 
		</cfquery>
				
		<cfset dbserver = system.databaseserver>
		
		<cfquery name="ModuleControl" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
			FROM      Ref_ModuleControl R
		    WHERE     SystemModule   = '#Module#' 
			AND       FunctionName   = '#FunctionName#' 
			AND       FunctionClass  = '#FunctionClass#'	
			AND       MenuClass      = '#MenuClass#'	
		</cfquery>		
				
		<cfif ModuleControl.recordcount gte "1">
		
			<cfset systemfunctionid = ModuleControl.systemfunctionid>
		
			<cfquery name="Update" 
			datasource="AppsSystem"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_ModuleControl
				SET    FunctionDirectory   = '#ListingPath#',
				       FunctionPath        = '#ListingTemplate#',
					   FunctionName        = '#FunctionName#'					   
				WHERE  SystemFunctionId    = '#SystemFunctionId#' 
			</cfquery>	
			
		<cfelse>
				
			<cf_AssignId>
			
			<cfset systemfunctionid = rowguid>
							
			 <cf_ModuleInsertSubmit
			   SystemModule      = "#Module#" 
			   FunctionClass     = "#FunctionClass#"
			   FunctionName      = "#FunctionName#" 
			   MenuClass         = "#MenuClass#"
			   MenuOrder         = "1"
			   MainMenuItem      = "0"
			   FunctionMemo      = "Extended Inquiry"			   
	           FunctionPath      = "#ListingPath#"
			   FunctionDirectory = "#ListingTemplate#"> 
							
			<cfset systemfunctionid = rowguid>
			
		</cfif>	
		
		<!---
		
		<cftransaction>
				
		<cfif arrayLen(datasets) gte "1">		
			
			<cfset len = arrayLen(datasets)>
			
		<cfelse>
		
			<cfset len = "8">	
			
		</cfif>
												
		<cfloop index="itm" from="1" to="#len#">	
				
			<cfparam name="Table#itm#Name" default="">
			
			<cfif arrayLen(datasets) gte "1">	
														
					<cfset tble     = "#datasets[itm].table#">
					<cfset clss     = "#datasets[itm].tableClass#">
					<cfset name     = "#datasets[itm].tableName#">
					<cfset drill    = "#datasets[itm].tableDrill#">
					<cfset field    = "#datasets[itm].TableField#">
							
			<cfelse>
			
					<cfset tble  = evaluate("Table#itm#")>		
					<cfset clss  = evaluate("Table#itm#Class")>		
					<cfset name  = evaluate("Table#itm#Name")>		
					<cfset drill = evaluate("Table#itm#Drill")>
					<cfset field = evaluate("Table#itm#DrillField")>
			
			</cfif>
					
			<cfif field eq "">
			   <cfset field = "facttableid">		
			</cfif>
												
			<cfif name neq "" and outputid eq "">
															
					<cfquery name="Layout" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT    ControlId
						FROM      Ref_ReportControlOutput R
					    WHERE     ControlId    = '#ControlId#'				
						AND       VariableName = '#tble#' 				
					</cfquery>
				
					<cfif layout.recordcount eq "0">
							
						<cfquery name="Insert" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO Ref_ReportControlOutput
								(ControlId, 
								 DataSource, 
								 OutputClass,
								 VariableName, 
								 OutputName, 
								 DetailTemplate,
								 DetailKey,
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName) 
						 VALUES
							    ('#controlId#',
								 '#DataSource#', 
								 '#clss#',
								 '#tble#', 
								 '#name#',
								 '#drill#',
								 '#field#',
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#')
						</cfquery>
						
						<cfquery name="Clean" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    DELETE FROM Ref_ReportControlOutput 
						    WHERE     ControlId    = '#ControlId#'				
							AND       OutputClass  = 'variable' 	
							AND       Created < getdate()-1			
						</cfquery>
						
					<cfelse>
									
						<cfquery name="Layout" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    UPDATE    Ref_ReportControlOutput
							SET       Created      = getDate(), 
							          Datasource   = '#datasource#'
						    WHERE     ControlId    = '#ControlId#'				
							AND       VariableName = '#tble#' 									
						</cfquery>				
					
					</cfif>					
					
			<cfelseif name neq "" and outputid neq "">			 
				
				 <cfquery name="Clean" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    DELETE FROM Ref_ReportControlOutput
					    WHERE     OutputId     = '#OutputId#' 			
						AND       ControlId != '#controlid#'
				</cfquery>
								
				<cfquery name="Output" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT    ControlId
						FROM      Ref_ReportControlOutput R
					    WHERE     OutputId     = '#OutputId#' 			
					</cfquery>
				
					<cfif output.recordcount eq "0">
							
						<cfquery name="Insert" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO Ref_ReportControlOutput
								(ControlId, 
								 OutputId, 
								 DataSource, 
								 OutputClass,
								 VariableName, 
								 OutputName, 
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName) 
							 VALUES ('#controlId#',
								  '#OutputId#',
								  '#DataSource#',
								   'variable',
								   'table#itm#', 
								   '#name#',
								   '#SESSION.acc#',
								   '#SESSION.last#',
								   '#SESSION.first#')
						</cfquery>
						
					<cfelse>
					
						<cfquery name="Output" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE    Ref_ReportControlOutput
						SET       DataSource     = '#datasource#',
						          DetailTemplate = '#drill#'
					    WHERE     ControlId    = '#ControlId#'				
						AND       OutputId     = '#OutputId#'					 				
					</cfquery>
					
					</cfif>	
					
			</cfif>
							
			</cfloop>	
							
			</cftransaction>
			
			--->
		
		<cfoutput>		
		
		<cfif invoke eq "Yes">
		
			<!--- determine values on the fly in querystring { } --->
			
			<cfset start = "1">
			<cfset new   = "#querystring#">
			
			<cfloop condition="#start# lte #len(new)#">
				
				<cfif find("{","#new#",start)>
						
					<cfset str = find("{","#new#",start)>
					<cfset str = str+1>
					<cfset end = find("}","#new#",start)>
					<cfset end = end>
					
					<cfset fld = Mid(new, str, end-str)>
					<cfset qry = "'+document.getElementById('#fld#').value+'">			
					<cfset new = replace(new,"{#fld#}","#qry#")>  
					
					<cfset start = end>
					
				<cfelse>
				
					<cfset start = len(new)+1>	
		
				</cfif> 
			
			</cfloop>		
			
			<cfset querystring = new>
		
		</cfif>
						
		<cfif buttonclass eq "variable">			
				
			<cfset scriptvalue = "#ListingTemplate#?#querystring#&systemfunctionid=#systemfunctionid#">
		
		<cfelse>
		
			<!--- this section is to trigger a direct opening or something else that we define --->
		
			<cfset scriptvalue = "">
			
		</cfif>	
		
		<cfreturn scriptvalue>
		
				
		</cfoutput>
		
		<!--- buttons opens a new forms on the full width in which the variables are passed --->
				 			 
	</cffunction>		
			
	<!--- HEADER --->
	
	
	<!--- FOOTER --->	
				
	
	<!--- DIMENSION --->
		  
	
	<!--- DIMENSION registration --->					
			
			
</cfcomponent>