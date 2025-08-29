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
<!--- to be shown as a detail in the main screen --->
<!--- ------------------------------------------ --->

<tr>
<td valign="top" style="padding: 5px;">
		
	<cfswitch expression="#url.topic#">
		
		<cfcase value="dep">
			<cfinclude template="ItemDetailDepreciation.cfm">
		</cfcase>
		
		<cfcase value="unit">
			<cfinclude template="ItemDetailOrganization.cfm">
		</cfcase>
		
		<cfcase value="loc">
			<cfinclude template="ItemDetailLocation.cfm">
		</cfcase>
	
	</cfswitch>

</td>
</tr>

