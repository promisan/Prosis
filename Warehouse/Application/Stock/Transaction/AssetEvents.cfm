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
<cfparam name="URL.table" default="">

<cfoutput>

		<cfquery name="qEvents" 
		    datasource="AppsMaterials"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  EC.EventCode, AE.Description 
			FROM    Ref_AssetEventCategory EC INNER JOIN Ref_AssetEvent AE ON EC.EventCode = AE.Code
			WHERE   
			<cfif Get.Category neq "">
				EC.ModeIssuance = '1' 
				AND     EC.Category = '#Get.Category#'
			<cfelse>
				 EC.ModeIssuance = '0' 
				AND  EC.Category = '#URL.Category#'
			</cfif>		
		</cfquery>

	<cfif qEvents.recordcount neq 0>

		<cfset i= 1>
		<cfloop query="qEvents">	

			<cfif URL.table neq "">
				<cfquery name="getTemp"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
					SELECT   Event1, EventDate1, EventDetails1, 
							 Event2, EventDate2, EventDetails2, 
							 Event3, EventDate3, EventDetails3, 
							 Event4, EventDate4, EventDetails4, 
							 Event5, EventDate5, EventDetails5 
					FROM     #PreserveSingleQuotes(URL.table)#
					WHERE    TransactionId      = '#url.transactionid#'								
				</cfquery>		
			
				<cfif getTemp.recordcount neq 0>
					<cfset TempEditing = 1>
				<cfelse>
					<cfset TempEditing = 0>	
				</cfif>	
			<cfelse>
				<cfset TempEditing = 0>	
			</cfif>
			
			<cfif TempEditing eq 0>
													
					<cfquery name="getPrior"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">							
							SELECT   TOP 1 *
							FROM     AssetItemEvent			
							<cfif url.transactionid eq "">
							WHERE 1=0
							<cfelse>							                 		  
							WHERE    TransactionId      = '#url.transactionid#'								
							AND      EventCode          = '#EventCode#'
							AND      AssetId            = '#url.assetid#' 
							</cfif>
					</cfquery>				
					
					<tr>
						<td valign="top" style="padding-top:3px;padding-left:1px" class="labelit"><font color="808080">#Description#:</font></td>
						
						<td colspan="3" bgcolor="f4f4f4" style="height:34;border:1px dotted silver;padding-left:2px">
						
							<table width="100%" cellspacing="0" cellpadding="0">
							
							<tr>
							<td align="right" style="Padding-left:5px">
							
							<cfif Get.Category neq "">
							
							    <cf_getWarehouseTime warehouse="#url.whs#">					  		   
						        <cfset hr = "#timeformat(localtime,'HH')#">			
							    <cfset mn = "#timeformat(localtime,'MM')#">										
								
								<cf_getWarehouseTime warehouse="#url.whs#">
								
								<div id="dTransactionDate">
								
								<CFIF getPrior.DateTimePlanning neq "">
																													
									 <cf_setCalendarDate
									      name     = "#EventCode#"        							        
									      mode     = "datetime"
										  value    = "#getPrior.DateTimePlanning#"
										  valuecontent = "datetime"
										  font     = "14"
										  class    = "detailvalue"> 
									  
								<cfelse>
								
										 <cf_setCalendarDate
									      name     = "#EventCode#"        
									      timeZone = "#tzcorrection#"     
									      mode     = "datetime"
										  value    = ""
										  font     = "14"
										  class    = "detailvalue"> 								
								
								</cfif>	  
								  
								</div>	
								
							<cfelse>
							
								<cfset HR = URL.hour>
								<cfset MN = URL.minute>	
								
							</cfif>		
						
							</td>							
							
							<cfif Get.Category eq "">
						
								    <cfset vDate = DateAdd("h", hour, tDate)>		
								    <cfset vDate = DateAdd("n", minute, vDate)>
									
									<cfquery name="GetDetails" 
									    datasource="AppsMaterials"  
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT  *
										FROM  AssetItemEvent
										WHERE   AssetId   		  = '#URL.AssetId#'
										AND     EventCode 		  = '#EventCode#'
										AND     DateTimePlanning  = #vDate# 
									</cfquery>
																
									<cfset vDetails = getDetails.EventDetails>
									
							<cfelse>
							
								<cfset vDetails = "#getPrior.eventdetails#">
								
							</cfif>
							
							<td align="left" width="100%" style="padding-left:4px;padding-right:4px">
								
						  		<input type = "Text"
								   style    = "width:100%;height:24;padding-top:3px"
							       name     = "#EventCode#_details"
								   id       = "#EventCode#_details"
								   class    = "regularxl detailvalue enterastab" 
								   value    = "#vDetails#">
								   
							</td>																		
							</tr>
							</table>
						</td>
					</tr>		
			<cfelse>
			
					<tr>
						<td valign="top" style="padding-top:3px;padding-left:4px" class="labelsmall"><font color="808080">#Description#:</font></td>
						<td colspan = "3" onkeydown="if (event.keyCode==13) {event.keyCode=9; return event.keyCode}">
							<table width="100%" cellspacing="0" cellpadding="0">
							
							<tr>
							<td align="right">
							
								<div id="dTransactionDate">
								
								 <cfset vTimePlanning = Evaluate("getTemp.EventDate#i#")>
								 
								 <cf_setCalendarDate
									      name     = "#EventCode#"        							        
									      mode     = "datetime"
										  value    = "#vTimePlanning#"
										  valuecontent = "datetime"
										  font     = "14"
										  class    = "detailvalue"> 
										  
								</div>	
								
							</td>
							
							
							<cfset vDetails = #Evaluate("getTemp.EventDetails#i#")#>
							
							<td align="left" width="100%" style="padding-left:4px;padding-right:4px">
						  		<input type = "Text"
								   style    = "width:97%;height:19"
							       name     = "#EventCode#_details"
								   id       = "#EventCode#_details"
								   class    = "regular detailvalue enterastab" 
								   value    = "#vDetails#">
							</td>																		
							</tr>
							</table>
						</td>
					</tr>	
						
					
			</cfif>		
			<cfset i= i+1>
		</cfloop>								
	</cfif>	
</cfoutput>


