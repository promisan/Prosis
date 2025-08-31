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
<cf_screentop height="100%" scroll="no" layout="webapp" banner="gray" label="Stock History" user="yes" close="ColdFusion.Window.hide('dialoghistory')">

	<cf_divscroll>
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white">
	
		<tr><td style="padding:9px" valign="top">				
		<cfinclude template="../../Maintenance/WarehouseLocation/LocationItemUoM/ItemUoMHistory.cfm">				
		</td></tr>
	
	</table>
	</cf_divscroll>

<cf_screenbottom layout="webdialog">