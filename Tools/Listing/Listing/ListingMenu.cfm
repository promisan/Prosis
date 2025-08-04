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

<cfsavecontent variable="selectme">       
		onMouseOver="this.className='highlight2 labelmedium'"
		onMouseOut="this.className='labelmedium'"
</cfsavecontent>

<cfoutput>

	<cfset show = 0>
	
	<cftry>
	
	<cfloop array="#attributes.listlayout#" index="current">
	
		<cfparam name="current.search" default="">
		<cfif current.search neq "">	
			<cfset show = 1>
		</cfif>		
	
	</cfloop>
	
	<cfcatch></cfcatch>
	
	</cftry>

	<!--- -------------- --->
	<!--- - menu box --- --->
	<!--- -------------- --->			
	
	<cfif show eq "1">	
	
	   <table width="100%">
	   
	   <tr>
	  
	   <td>
	   
	   <table class="formspacing">
	   <tr>
	   <td style="border-radius:3px;background-color:ffffaf;border:1px solid silver; font-size:15px;padding-left:20px;padding-right:20px;height:27px;white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
	   
	   
	   <cfquery name="Menu" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   xl#Client.LanguageId#_Ref_ModuleControl R
			WHERE SystemFunctionId = '#url.systemfunctionid#'	
		</cfquery>
	   
	   <cfoutput>#Menu.FunctionName#</cfoutput>
	   	   
	   </td>
	   </tr>
	   </table>
	   
	   </td>
	   <td style="padding-left:20px;padding-right:14px" align="right">
	  	      	
	   <table class="formspacing"><tr>
	   	   		
		<cfif url.systemfunctionid neq "">
		
			<cfquery name="system" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_ModuleControl R
					WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
			</cfquery>
						
			<cfif url.webapp eq "Backoffice" and system.functionTarget eq "Right">	
			
			   <td onclick="history.back()" #selectme# height="24" class="labelmedium" style="cursor:pointer;border: 1px transparent Solid;padding-left:4px;padding-right:4px">
		 		 &nbsp;<img src="#SESSION.root#/Images/back.gif" alt="Function configuration" height="14" width="16" 
			   	  style="cursor: pointer;" border="0" align="absmiddle">&nbsp;<cf_tl id="Back">			 
			 </td>
			 <td width="1">&nbsp;|&nbsp;</td>		
			
			</cfif>
		
		    <cfparam name="SESSION.isAdministrator" default="No">
				 
		     <cfif SESSION.isAdministrator eq "Yes">
		     <td onclick="recordedit('#systemFunctionId#')" #selectme# height="24" class="labelmedium" style="cursor:pointer;border: 1px transparent Solid;padding-left:4px;padding-right:4px">
		 		 &nbsp;<img src="#SESSION.root#/Images/configure.gif" alt="Function configuration" height="14" width="16" 
			   	  style="cursor: pointer;" border="0" align="absmiddle">&nbsp;<cf_tl id="Configure"></font>			 
			 </td>
			 <td width="1">&nbsp;|&nbsp;</td>			
			</cfif>
						 
			<cfif isArray(attributes.menu)>	
		
				<cfloop array="#attributes.menu#" index="option">
							
					<cfif option.label neq "">											
																						
						<td #selectme# height="22" onclick="addlistingentry('#option.script#','#attributes.DrillArgument#')" 
						   style="cursor:pointer;padding:2px;border: 1px transparent Solid;">
						   						   
							<table cellspacing="0" cellpadding="0">
							<tr>									
							<cfif option.icon neq "">
								<td><img src="#SESSION.root#/images/#option.icon#" height="15" width="15" alt="" border="0" align="absmiddle"></td>
							</cfif>						
							<td class="labelmedium" style="padding-left:4px">#option.label#</td>		
							</tr>
							</table>	
						
						</td>
							
						<td width="1" style="padding:2px">|</td>	
					 
					</cfif>
				
				</cfloop>			
			
			</cfif>
			
			<cfparam name="setting[5]" default="yes">
			
			<cfif setting[5] eq "Yes">
										 
			<td #selectme# height="25" class="labelmedium" style="cursor:pointer;padding-left:5px;padding:2px;border:1px transparent Solid;">
								 					  					  
					 <cfquery name="ModuleControl" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#"> 	
						SELECT * 
						FROM   Ref_ModuleControl
						WHERE  SystemFunctionId = '#url.systemfunctionid#'		
					 </cfquery>	
										 
					 <cfset name = replace(ModuleControl.FunctionName," ","","ALL")>
					 
					 <cfif len(name) gt "30">
					    <cfset name = left(name,30)>
					 </cfif>			
					 					 
					 <cfinvoke component="Service.Analysis.CrossTab"  
						  method      = "ShowInquiry"
						  buttonClass = "td"					  						 
						  buttonText  = "<font size='3' style='font-family: calibri;'>Excel</font>"						 
						  reportPath  = "Tools\Listing\Listing\"
						  SQLtemplate = "ListingExcel.cfm"
						  queryString = "box=#attributes.box#&systemfunctionid=#url.systemfunctionid#"
						  dataSource  = "#attributes.datasource#" 
						  module      = "SelfService"
						  outputid    = "#url.systemfunctionid#"
						  reportName  = "#ModuleControl.FunctionName#"
						  table1Name  = "#name#"
						  data        = "1"
						  filter      = "1"
						  olap        = "0" 
						  ajax        = "2" 
						  excel       = "1"> 							  
						 					 
			 </td>
			 
			 </cfif>
					 
			 <cfquery name="Mail" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 	
				SELECT * 
				FROM   Ref_ModuleControlDetailField
				WHERE  SystemFunctionId = '#url.systemfunctionid#'		
				AND    FunctionSerialNo = '#url.functionserialNo#'
				AND    (FieldOutputFormat = 'eMail' or FieldHeaderLabel = 'Name')
			 </cfquery>	
		 
			 <cfif Mail.recordcount eq "2">
			 
			   <td width="1" style="padding:2px">|</td>	
			   <td class="labelmedium" style="padding:2px" onclick="mail('#url.systemfunctionid#','#url.functionserialNo#')" #selectme#>	 
			   <img src="#SESSION.root#/Images//mail3.gif" alt="" border="0"> <cf_tl id="Broadcast">			   </td>			  	
			 						 
			 </cfif>
			 
			  <!--- *** LISTING PRINT FUNCTION **** --->
			 <td width="1" style="padding:2px">|</td>
			 <cfinclude template="ListingPrint.cfm">
					 
			</cfif>
						
			<td id="menuprocess" style="padding-left:10px"></td>
			
		</tr>
		
		</table>
	
	  </td>
	 </tr>
	
	</table>
			
	</cfif>
	
</cfoutput>	
	