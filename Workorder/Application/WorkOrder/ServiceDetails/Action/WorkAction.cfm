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
<cfparam name="url.header" default="Yes">
<cfparam name="url.embed"  default="No">

<cfoutput>

<table width="100%" height="100%">
	
	<cfif url.header eq "Yes">
	
		<tr class="line"><td height="20" style="padding-bottom:5px;padding-top:4px;padding-left:10px">
			
			<table cellspacing="0" cellpadding="0">
			
				<tr>
				
					<td><input type="radio" name="actionselect" value="Manual" checked 
					    onclick="ColdFusion.navigate('#session.root#/WorkOrder/Application/Workorder/ServiceDetails/Action/WorkActionListing.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','actioncontent')"></td>
					<td style="padding-left:4px" class="labelmedium"><cf_tl id="Manually recorded"></td>
					
					<td style="padding-left:10px">
					   <input type="radio" name="actionselect" value="All"
						onclick="ColdFusion.navigate('#session.root#/WorkOrder/Application/Workorder/ServiceDetails/Action/WorkActionContent.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','actioncontent')"></td>
					<td style="padding-left:4px" class="labelmedium"><cf_tl id="Scheduled and manually recorded"></td>
					
				</tr>
			
			</table>	
			
			</td>
			
		</tr>	
					
	</cfif>
	
	<tr>	
	
	    <cfif url.embed eq "no">
		<td width="100%" height="100%" valign="top">
	    <cf_divscroll id="actioncontent">			
			<cfinclude template="WorkActionListing.cfm">
		</cf_divscroll>
		</td>
		<cfelse>
		<td width="100%" height="100%" valign="top" id="actioncontent">				
		    <cfinclude template="WorkActionListing.cfm">
		</td>	
		</cfif>
		
	</tr>

</table>

</cfoutput>