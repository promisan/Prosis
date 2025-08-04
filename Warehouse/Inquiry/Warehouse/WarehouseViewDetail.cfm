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

<cfif url.mode eq "MAP">

	<cfinclude template="WarehouseViewDetailMAP.cfm">
	
<cfelseif url.mode eq "ROLAP">	

	<table width="100%" height="100%"><tr><td style="padding:1px">
	
	<iframe name="invokedetail"
	        id="invokedetail"
	        width="100%"
	        height="100%"
	        scrolling="no"
	        frameborder="0"></iframe>
			
<cfdiv bind="url:WarehouseViewDetailDataset.cfm?mission=#url.mission#&itemno=#url.itemno#&uom=#url.uom#">		
	
	</td></tr></table>
	
<cfelse>

	<table width="100%" height="100%"><tr><td style="padding:8px">

	<cfinclude template="WarehouseViewDetailListing.cfm">
	
	</td></tr></table>

</cfif>