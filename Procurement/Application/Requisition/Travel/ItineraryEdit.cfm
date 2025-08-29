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
<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLine
	WHERE RequisitionNo = '#URL.ID#'	
</cfquery>

<cfquery name="Check" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLineItinerary 
	WHERE RequisitionNo = '#URL.ID#'	
</cfquery>

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr>
<td valign="top" height="100%" style="padding-top:1px;padding-right:10px">

	<cf_divscroll style="height:100%">
	
		<cfform method="POST" style="width:100%" name="itinedit" onsubmit="return false">
		
		<table align="center" width="98%">
								
			<cfquery name="Detail" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  RequisitionLineItinerary 
				WHERE RequisitionNo = '#URL.ID#'	
				AND   ItineraryLineNo = '1' 	
			</cfquery>
			
			<td class="labelmedium" style="font-size:18px" width="130"><b><cf_tl id="Departure from">:</td>
			<td colspan="1">
			
			    <table  cellspacing="0" cellpadding="0">
				<tr>
					<cfset cit = "city1">	
													
					<td>
					   <cfdiv id="#cit#" bind="url:#SESSION.root#/Procurement/Application/Requisition/Travel/ItineraryEditCity.cfm?field=#cit#&cityid=#detail.countrycityid#"/>						 
					</td> 	
					
					<td width="20" style="padding-left:2px">						 
					 										  
						   <img src="#SESSION.root#/Images/contract.gif" 	
								onClick="selectcity('#cit#','location#cit#')"
								height  = "18"
								width   = "18"
							    alt     = "Search" 
							    border  = "0" 							  
							    align   = "absmiddle" 
							    style   = "cursor: pointer;">
										
					</td>
								
				</tr>
				</table> 	
				  
			</td>
			</tr>
			
			<td class="labelmedium" width="20" style="height:31px;padding-left:6px"><cf_tl id="on">:</td>
			<td colspan="3" width="100">	
				
				<cfif detail.DateDeparture eq "">
					 <cfset def = "#DateFormat(now(),CLIENT.DateFormatShow)#">
				<cfelse>
					 <cfset def = "#Dateformat(detail.DateDeparture, CLIENT.DateFormatShow)#">
				</cfif>
				
				<cf_intelliCalendarDate9
					FieldName="DateDeparture1" 
					Class="regularxl"	
					Default="#def#"			
					message="Please enter a departure date"	
					AllowBlank="False">	
													
			</td>		
			</tr>
			
			<tr style="height:35px">
			<td class="labelmedium" style="min-width:180px;padding-left:6px"><cf_tl id="Transport on departure">:</td>
			<td>
				<table>	
				<tr>
				<td><input class="radiol" type="checkbox" name="TransportDeparture1" id="TransportDeparture1" value="1" <cfif detail.TransportDeparture eq "1">checked</cfif>></td>				</td>
				<td class="labelmedium" style="padding-left:16px"><cf_tl id="By">:</td>
				<td class="labelmedium" style="padding-left:6px">
				<cfoutput>
				<select class="regularxl" name="TransportMode1" id="TransportMode1">
				    <cfloop index="itm" list="Air,Train,Car">
				    <option value="#itm#" <cfif detail.TransportMode eq itm or itm eq "Air">selected</cfif>><cf_tl id="#itm#"></option>
					</cfloop>					
				</select>
				</cfoutput>
				
				</td>
				<td class="labelmedium" style="padding-left:16px"><cf_tl id="Class">:</td>
				<td class="labelmedium" style="padding-left:6px">
				<cfoutput>
				<select class="regularxl" name="TransportClass1" id="TransportClass1">
				    <cfloop index="itm" list="Economy,Business,FirstClass">
				    <option value="#itm#" <cfif detail.TransportMode eq itm or itm eq "Economy">selected</cfif>><cf_tl id="#itm#"></option>
					</cfloop>					
				</select>
				</cfoutput>
				
				</td>
				</tr>
				</table>
			</td>
			
			</tr>
			
			<tr>
				<td class="labelmedium" style="padding-left:6px"><cf_tl id="Memo">:</td>
				<td colspan="3">		
				   <input type="text" style="height:25px;font-size:14px" name="Memo1" id="Memo1" size="60" maxlength="60" class="regularh" value="#detail.memo#">		   
				</td>
			</tr>
			
			<tr><td height="4"></td></tr>
			<tr><td colspan="4" class="line" height="1"></td></tr>
			<tr><td height="4"></td></tr>
				
			<cfquery name="Detail" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   RequisitionLineItinerary 
				WHERE  RequisitionNo   = '#URL.ID#'	
				AND    ItineraryLineNo = '2' 	
			</cfquery>
			
			<tr>
			<td class="labelmedium" width="100" style="font-size:18px"><b><cf_tl id="Destination">:</td>
			<td colspan="3">	
			
					<table cellspacing="0" cellpadding="0">
					<tr>
				    <cfset cit = "city2">			
					
					<td>
					 <cfdiv id="#cit#" 
					      bind="url:#SESSION.root#/Procurement/Application/Requisition/Travel/ItineraryEditCity.cfm?field=#cit#&cityid=#detail.countrycityid#"/>						 
					</td> 	
					
					<td width="20" style="padding-left:2px">						 
					 										  
						   <img src="#SESSION.root#/Images/contract.gif" 								
							    alt     = "Search" 
								height  = "18"
								width   = "18"
							    border  = "0" 	
								onClick ="selectcity('#cit#','location#cit#')"						  
							    align   = "absmiddle" 
							    style   = "cursor: pointer;">
										
					</td>
					
					</tr>
					</table>
			</td>
			</tr>
			
			<tr style="height:35px">
				<td class="labelmedium" style="padding-left:6px"><cf_tl id="Transport on arrival">:</td>
				
				<td colspan="2">
					<table>
					<tr>
						<td><input class="radiol" type="checkbox" name="TransportArrival2" id="TransportArrival2" value="1" <cfif detail.TransportArrival eq "1">checked</cfif>></td>					
							
					</tr>	
					</table>
				</td>
			</tr>
						
			<tr>
				<td class="labelmedium" style="padding-left:6px"><cf_tl id="Memo">:</td>
				<td colspan="3">		
				   <input type="text" style="height:25px;font-size:14px" name="Memo2" id="Memo2" size="60" maxlength="60" class="regularh" value="#detail.memo#">		   
				</td>
			</tr>
			
			<!--- ----- --->
			<!--- LEG 3 --->
			<!--- ----- --->
				
			<cfquery name="Detail" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  RequisitionLineItinerary 
				WHERE RequisitionNo = '#URL.ID#'	
				AND   ItineraryLineNo = '3' 	
			</cfquery>
			
			<cfif detail.recordcount eq "0">
				<cfset cl = "regular">
				<cfset cla = "hide"> 
			<cfelse>
				<cfset cla = "regular">
				<cfset cl = "hide"> 
			</cfif>	
			
			<tr id="destadd3" name="destadd3" class="#cl#"><td class="labelmedium">
				<img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle" onclick="addleg('show','3')">
				<a href="javascript:addleg('show','3','4')"><cf_tl id="Add Leg"></a>
			</td>
			</tr>
				
			<cfset url.box = "3">
			<cfinclude template="../../Requisition/Travel/ItineraryEditLeg.cfm">
			
			<!--- ----- --->
			<!--- LEG 4 --->
			<!--- ----- --->
			
			<cfquery name="Detail" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  RequisitionLineItinerary 
				WHERE RequisitionNo = '#URL.ID#'	
				AND   ItineraryLineNo = '4' 	
			</cfquery>
			
			<cfif cl eq "regular" and detail.recordcount eq "0">
				<cfset cl = "hide">
				<cfset cla = "hide"> 
			<cfelseif detail.recordcount eq "0">
				<cfset cl = "regular">
				<cfset cla = "hide"> 
			<cfelse>
				<cfset cla = "regular">
				<cfset cl = "hide"> 
			</cfif>	
			
			<tr id="destadd4" name="destadd4" class="#cl#"><td class="labelmedium">
				<img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle" onclick="addleg('show','4','')">
				<a href="javascript:addleg('show','4','')"><cf_tl id="Add Leg"></a>
			</td>
			</tr>
			
			<cfset url.box = "4">
			<cfinclude template="../../Requisition/Travel/ItineraryEditLeg.cfm">
					
			<!--- ------ --->
			<!--- LEG 99 --->
			<!--- ------ --->
				
			<cfquery name="Detail" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  RequisitionLineItinerary 
				WHERE RequisitionNo = '#URL.ID#'	
				AND   ItineraryLineNo = '99' 	
			</cfquery>
			
			<tr><td height="4"></td></tr>
			<tr><td colspan="4" class="line"></td></tr>
			<tr><td height="4"></td></tr>
			<tr>
			<td class="labelmedium" width="100" style="font-size:20px"><b><cf_tl id="Return to">:</td>
			<td colspan="3">
			
				<table cellspacing="0" cellpadding="0">
					<tr>
				    <cfset cit = "city99">			
								
					<td class="labelmedium">
					 <cfdiv id="#cit#" 
					      bind="url:#SESSION.root#/procurement/application/requisition/Travel/ItineraryEditCity.cfm?field=#cit#&cityid=#detail.countrycityid#"/>						 
					</td> 
					
					<td style="padding-left:2px">						 
					 										  
					   <img src="#SESSION.root#/Images/contract.gif" 							  
						onClick="selectcity('#cit#','location#cit#')"
					    alt     = "Search" 
						height  = "18"
						width   = "18"
					    border  = "0" 							  
					    align   = "absmiddle" 
					    style   = "cursor: pointer;">
										
					</td>
					
					
					</tr>
					</table>	  
				  
			</td>
			</tr>
					
			
			<tr style="height:35px">
			<td class="labelmedium" style="padding-left:6px;padding-right:5px"><cf_tl id="Transport on departure">:</td>
			<td colspan="2">
				<table>
				<tr>
						
						<td style="padding-right:10px"><input class="radiol" type="checkbox" name="TransportDeparture99" id="TransportDeparture99" value="1" <cfif detail.TransportDeparture eq "1">checked</cfif>></td>							
						<td class="labelmedium" style="padding-left:6px"><cf_tl id="By">:</td>
						<td class="labelmedium" style="padding-left:6px">
						<cfoutput>
						<select class="regularxl" name="TransportMode99" id="TransportMode99">
						    <cfloop index="itm" list="Air,Train,Car">
						    <option value="#itm#" <cfif detail.TransportMode eq itm or itm eq "Air">selected</cfif>><cf_tl id="#itm#"></option>
							</cfloop>					
						</select>
						</cfoutput>
						
						</td>
						<td class="labelmedium" style="padding-left:6px"><cf_tl id="Class">:</td>
						<td class="labelmedium" style="padding-left:6px">
						<cfoutput>
						<select class="regularxl" name="TransportClass99" id="TransportClass99">
						    <cfloop index="itm" list="Economy,Business,FirstClass">
						    <option value="#itm#" <cfif detail.TransportMode eq itm or itm eq "Economy">selected</cfif>><cf_tl id="#itm#"></option>
							</cfloop>					
						</select>
						</cfoutput>											
						</td>	
				</tr>
				</table>
			</td>
			</tr>	
			
			<tr>
			<td class="labelmedium" style="height:31px;padding-left:6px"><cf_tl id="On">:</td>
			<td colspan="3">
				
				 <cfif detail.DateArrival eq "">
					 <cfset def = "">
				 <cfelse>
					 <cfset def = "#Dateformat(detail.DateArrival, CLIENT.DateFormatShow)#">
				 </cfif>
					
				   	<cf_intelliCalendarDate9
					FieldName="DateArrival99" 
					Class="regularxl"	
					Default="#def#"		
					message="Please enter a return date"	
					AllowBlank="True">	
											
			</td>
			</tr>
											
			
			<tr>
				<td class="labelmedium" style="padding-left:6px"><cf_tl id="Transport on arrival">:</td>
				<td><input type="checkbox" class="radiol" name="TransportArrival99" id="TransportArrival99" value="1" <cfif detail.TransportArrival eq "1">checked</cfif>></td>	
			</tr>
			
			<tr>
				<td class="labelmedium" style="padding-left:6px"><cf_tl id="Memo">:</td>
				<td colspan="3">			
				   <input type="text" style="height:25px;font-size:14px;padding:3px" name="Memo99" id="Memo99" size="60" maxlength="60" class="regular" value="#detail.memo#">			   
				</td>
			</tr>		
							
			<tr style="height:40px"> 	 
				  			  								   
				<td colspan="4" align="center">
						
					<cfoutput>
					
						 <input type="button"
						  onclick="ProsisUI.closeWindow('dialogitin')"
						  value="Close" 				  
						  class="button10g">
						
						 <input type="button" onclick="itinvalidate('');" value="Save" class="button10g">
						  
					 </cfoutput> 
						  
				</td>
						    
			</TR>	
					
		</table>		
		
		</cfform>	
	
	</cf_divscroll>

</td></tr>

</table>

</cfoutput>			

<cfset ajaxonload("doCalendar")>