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
<cfquery name="getElement" 
	datasource="AppsMaterials">	
		SELECT 	*
		FROM 	Item
		WHERE	ItemNo = '#url.reference#'
</cfquery>

<cfoutput>
	<div class="clearfix">
		<div class="pull-left" style="padding-right:20px;">
			<a href="javascript:enlargePicture('.elementPicture_#getElement.itemNo#');">
				<cfset vName = getElement.itemNo>
				<cfinclude template="getPicture.cfm">
		        <cf_tl id="Zoom in/out" var="1">
		        <div 
					title="#lt_text#" 
					class="img-circle clsRoundedPicture clsEnableTransition elementPicture_#getElement.itemNo#" 
					style="background-image:url('#vPhoto#'); height:75px; width:75px; border:3px solid ##808080;"></div>
		    </a>
		</div>
		<div class="clsElementHeader">
			[#getElement.ItemNo#] #getElement.ItemDescription#
			<div style="font-size:35%;"><b><cf_tl id="Classification">:</b> #getElement.Classification# | <b><cf_tl id="Color">:</b> #getElement.ItemColor# | <b><cf_tl id="Shipment">:</b> #getElement.ItemShipmentMode#</div>
		</div>
	</div>
</cfoutput>