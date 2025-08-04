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

<!--- location box --->

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td>
	
	<cfparam name="url.access"           default="READ">
	<cfparam name="url.systemfunctionid" default="">
	
	<cfoutput>
		<iframe src="#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/LocationView.cfm?systemfunctionid=#url.systemfunctionid#&access=#url.access#&warehouse=#url.warehouse#&location=#url.location#" width="100%" height="100%" marginwidth="0" marginheight="0" align="middle" scrolling="no" frameborder="0" style="overflow:hidden"></iframe>
	</cfoutput>	

</td></tr>

</table>