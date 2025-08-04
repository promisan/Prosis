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
<cf_screentop html="no" jquery="yes">

<cf_listingscript>

<table width="100%" height="100%">
	<tr>
		<td valign="top">
			<cfquery name="Get" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_ReportControlCriteria 
				WHERE ControlId  = '#URL.ID#'
				AND CriteriaName = '#URL.ID1#'
			</cfquery>
			
			<cfif URL.Sel eq "">
			 <cf_message message = "You have not specified a query field value">
			 <cfabort>
			</cfif> 
			
			<cfif URL.Display eq "">
			 <cf_message message = "You have not specified a query display value">
			 <cfabort>
			</cfif> 
			
			<cfif URL.Table eq "">
			 <cf_message message = "You have not specified a lookup table">
			 <cfabort>
			</cfif> 
		
			<cfset Crit = replaceNoCase("#Get.CriteriaValues#", "@userid", "#SESSION.acc#" , "ALL")>
			<cfset Crit = replaceNoCase("#Crit#", "@parent", "'selected value runtime'" , "ALL")>
					
			<cfif FindNoCase("ORDER BY #URL.Sel#", "#preserveSingleQuotes(Crit)#")>				
			   <cfset dis = "DISTINCT">
			<cfelseif FindNoCase("ORDER BY #URL.Display#", "#preserveSingleQuotes(Crit)#")>	
			   <cfset dis = "DISTINCT">
			<cfelseif FindNoCase("ORDER BY", "#preserveSingleQuotes(Crit)#")>
				<cfset dis = "">
			<cfelse>
				<cfset dis = "DISTINCT">
			</cfif>  
			
		<cfoutput>
						
			<cftry>
							
			<cfquery name="Check" 
		    datasource="#url.ds#">
			 SELECT #dis# 
			      #URL.Sel# as Value
				  <cfif url.sorting neq "">, #URL.Sorting# as Sorting</cfif>, 
				  #URL.Display# as Display
			 <cfif not Find("FROM ", "#Get.CriteriaValues#")>
				 FROM #URL.Table#
		 	 </cfif>	 
			  #preserveSingleQuotes(Crit)#	 
			</cfquery>	
			
			<cfcatch>
						
				<table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
				<tr><td colspan="2">
					<font size="2" color="FF0000">The below SQL query can not be validated. Please correct your configuration settings.</font>
					</td>
				</tr>
				<tr><td height="4"></td></tr>
				<tr><td width="100">DataSource:</td><td width="80%"><font size="2">#url.ds#</td></tr>
				<tr><td colspan="2" class="line"></td></tr>
				<tr><td width="20">Script:</td><td><font size="2">
				 <cfoutput>
				 				 
				 SELECT #dis# <br>
				      #URL.Sel# as Value, <br>
					  #URL.Display# as Display 
					  <cfif url.sorting neq "">, <br> #URL.Sorting# as Sorting</cfif> 
					   <br>
				 <cfif not Find("FROM ", "#Get.CriteriaValues#")>
					 FROM #URL.Table# <br>
			 	 </cfif>	 
				  #preserveSingleQuotes(Crit)#	<br>
				  </cfoutput>
				</td></tr>
				<tr><td colspan="2" class="line"></td></tr>
				<tr><td height="30" colspan="2" align="center">
					<input type="button" class="button10g" value="Close" name="Close" id="Close" onClick="window.close()">
				</td></tr>	
				
				</table>
			
			<cfabort>
			
			</cfcatch>
			
			</cftry>
							
			<cfsavecontent variable="myquery"> 
			     SELECT
				      #URL.Sel# as LookupValue
				  <cfif url.sorting neq ""> 
				  ,#URL.Sorting# as LookupSorting
				  </cfif>
				  ,#URL.Display# as Display
			 <cfif not Find("FROM ", "#Get.CriteriaValues#")>
				 FROM #URL.Table#
		 	 </cfif>	 
			  <cfif check.recordcount gt "0">
			  #preserveSingleQuotes(Crit)#	 
			  </cfif>
			</cfsavecontent>
						
			<cfif URL.sorting neq "">	
				<cfset sort = URL.Sorting>
			<cfelse>
				<cfset sort = "Display">
			</cfif>
			
			<cfsavecontent variable="banner"> 
			<table width="100%" cellspacing="0" cellpadding="0">
			<tr><td align="center" style="height:35px">
				<input type="button" class="button10g" value="Close" name="Close" id="Close" onClick="window.close()">
			</td></tr>	
			
			</table>
			</cfsavecontent>
			
			<table width="100%" height="100%" cellspacing="0" cellpadding="0">
				
			<tr><td id="mydetails" valign="top">
			
			<cfset fields=ArrayNew(1)>
			
			<cfif url.sorting neq "">
			
				<cfset fields[1] = {label      = "Key",    
									width      = "20%", 
									field      = "LookupValue",
									search     = "text"}>
									
				<cfset fields[2] = {label      = "Sorting",    
									width      = "20%", 
									field      = "LookupSorting",
									search     = "text"}>			
				
				<cfset fields[3] = {label   = "Display", 
				                    width   = "60%", 
									field   = "Display",
									search  = "text"}>			
								
			<cfelse>		
				
				<cfset fields[1] = {label    = "Key",    
									width    = "20%", 
									field    = "LookupValue",
									search   = "text"}>
					
				<cfset fields[2] = {label   = "Display", 
				                    width   = "80%", 
									field   = "Display",
									search  = "text"}>			
			
			</cfif>					
								
			<cfset str = "?Id=#URL.ID#&ID1=#URL.ID1#&ds=#URL.DS#&name=#URL.Name#&table=#URL.table#&sel=#URL.sel#&display=#URL.display#&sorting=#URL.sorting#">					
												
			<cf_listing
			    banner        = "#banner#"
			    header        = "<b>Test Lookup table</b>"
				filtershow    = "No"
			    box           = "mydetails"
				link          = "#SESSION.root#/System/Modules/Reports/SQLCheck.cfm#str#"
			    html          = "No"	
				show          = "20"
				scroll        = "Yes"
				datasource    = "#url.ds#"
				tablewidth    = "98%"
				listquery     = "#myquery#"
				listkey       = "#URL.sel#"
				listorder     = "#sort#"
				listorderdir  = "ASC"
				headercolor   = "ffffff"
				listlayout    = "#fields#">
				
			</cfoutput>	
				
			</td></tr>
			</table>

	
		</td>
	</tr>
</table>