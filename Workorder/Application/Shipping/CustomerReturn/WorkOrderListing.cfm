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

<cf_screentop html="Label" jQuery="Yes" systemFunctionid="#url.systemfunctionid#">

<cf_listingscript>

<cfoutput>

	<table width="100%" cellspacing="0" cellpadding="0" height="100%">
				
		<tr class="labelmedium">
		   <td colspan="2" height="100%" valign="top" style="padding-top:5px;padding-left:7px;padding-right:7px" id="mymasterlist">
		      
		   The return process is
		   Search and Select a customer that has one or more shippings<br>
		   <br>
		   Open Dialog<br>
		   	Show all items shipped over time and their total (Item/UoM) and then expand on the workorder/shipping
				workorderline
				warehouse/location
				quantity					
			<br>
			Entry the quantity to be return and process.<br>
			WorkOrder will show for credit note under [Credit Note]<br>
			 
			<!--- <cfdiv style="height:100%" bind="url:WorkOrderListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&Status=#url.status#">
			--->
		   </td>
		</tr>
	
	</table>
	
</cfoutput>


