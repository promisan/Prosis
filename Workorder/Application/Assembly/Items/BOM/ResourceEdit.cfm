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
<cfparam name="url.scope" default="Service">

<cfoutput>
	
	<table width="100%" height="100%">
	
	<tr><td style="height:100%;width:100%" valign="top">
	
	<cf_getMID>
	
	<cfif url.scope eq "service">
	
		<iframe src="#session.root#/workorder/application/Assembly/Items/BOM/ResourceEditService.cfm?WorkOrderId=#url.workorderid#&WorkOrderLine=#url.workorderline#&ResourceId=#url.resourceid#&mid=#mid#" 
		   width="100%" height="99%" frameborder="0"></iframe>
		   
	<cfelse>
		
	    <iframe src="#session.root#/workorder/application/Assembly/Items/BOM/ResourceEditSupply.cfm?WorkOrderItemId=#url.WorkOrderItemId#&workorderitemidresource=#url.workorderitemidresource#&itemNo=#url.itemno#&uom=#url.uom#&mid=#mid#" 
		  width="100%" height="99%" frameborder="0"></iframe>
	
	</cfif>
		
	</td></tr>
	
	</table>
	
</cfoutput>
