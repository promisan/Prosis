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
<cfparam name="url.box" default="3">
<cfset box = url.box>

<cfoutput>

    <tr id="dest#url.box#" name="dest#url.box#" class="#cla#">
		<td class="labelmedium" style="height:30px;padding-left:6px"><cf_tl id="Departure">:</td>
		<td colspan="3" style="height:36px">
			
			<cfif detail.DateArrival eq "">
				 <cfset def = "">
			<cfelse>
				 <cfset def = "#Dateformat(detail.DateArrival, CLIENT.DateFormatShow)#">
			</cfif>
		
		   	<cf_intelliCalendarDate9
				FieldName="DateArrival#box#" 
				Class="regularxl"	
				Default="#def#"			
				AllowBlank="True">	
										
		</td>
	</tr>
	
	<tr id="dest#url.box#" name="dest#url.box#" class="#cla#">
			<td class="labelmedium" style="padding-left:6px;padding-right:5px"><cf_tl id="Transport on departure">:</td>
			<td colspan="2">
			<table>
				<tr>
				<td><input class="radiol" type="checkbox" name="TransportDeparture#box#" id="TransportDeparture#box#" value="1" <cfif detail.TransportDeparture eq "1">checked</cfif>></td>	
				<td class="labelmedium" style="padding-left:6px"><cf_tl id="By">:</td>
					<td class="labelmedium" style="padding-left:6px">
					<cfoutput>
					<select class="regularxl" name="TransportMode#box#" id="TransportMode#box#">
					    <cfloop index="itm" list="Air,Train,Car">
					    <option value="#itm#" <cfif detail.TransportMode eq itm or itm eq "Air">selected</cfif>><cf_tl id="#itm#"></option>
						</cfloop>					
					</select>
					</cfoutput>
					
					</td>
					<td class="labelmedium" style="padding-left:6px"><cf_tl id="Class">:</td>
					<td class="labelmedium" style="padding-left:6px">
					<cfoutput>
					<select class="regularxl" name="TransportClass#box#" id="TransportClass#box#">
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
	
	
	<tr id="dest#box#" name="dest#box#" class="#cla#"><td height="4"></td></tr>
	
	<tr id="dest#box#"  name="dest#box#" class="#cla#">
		<td colspan="4" class="line"></td>
	</tr>
	
	<tr id="dest#box#"  name="dest#box#" class="#cla#"><td height="4"></td></tr>
	
	<tr id="dest#box#"  name="dest#box#" class="#cla#">
	<td width="100" class="labelmedium" style="padding-left:6px;"><cf_tl id="Continuation">: 
		   
		<img src = "#SESSION.root#/Images/delete5.gif" 
		 alt     = "remove leg" 
		 height="11" width="11"
		 style   = "cursor: pointer;"
		 onclick = "addleg('hide','#box#','#box+1#')" 
		 border  = "0">
	</td>
	<td colspan="3">
	
		<table cellspacing="0" cellpadding="0">
			<tr>
		    <cfset cit = "city#box#">			
			 					
			<td>
			 <cfdiv id="#cit#" 
			      bind="url:#SESSION.root#/Procurement/Application/Requisition/Travel/ItineraryEditCity.cfm?field=#cit#&cityid=#detail.countrycityid#"/>						 
			</td> 	
			
			<td style="padding-left:2px">					 
			 									  
			   <img src="#SESSION.root#/Images/contract.gif" 							    
				onClick="selectcity('#cit#','location#cit#')"
			    alt     = "Search" 
			    border  = "0" 		
				height  = "18"
				width   = "18"					  
			    align   = "absmiddle" 
			    style   = "cursor: pointer;">
								
			</td>	
			
			</tr>
			</table>
		</td>
	</tr>	
	
	<tr id="dest#box#"  name="dest#box#" class="#cla#">
		<td style="padding-left:6px" class="labelmedium"><cf_tl id="Transport on arrival">:</td>
		
		
		<td colspan="2" >
				<table>
				<tr style="height:35px">
					<td><input class="radiol" type="checkbox" name="TransportArrival#box#" id="TransportArrival#box#" value="1" <cfif detail.TransportArrival eq "1">checked</cfif>></td>	
									
				</tr>
				</table>
			</td>
		
	</tr>
			
	<tr id="dest#box#"  name="dest#box#" class="#cla#">
		<td style="padding-left:6px" class="labelit"><cf_tl id="Memo">:</td>
		<td colspan="3">		
		   <input type="text" name="Memo#box#" id="Memo#box#" size="60" maxlength="60" style="padding:3px;font-size:14px" class="regular" value="#detail.memo#">		   
		</td>
	</tr>
	
</cfoutput>	