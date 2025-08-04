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
<cfset actionform = "Requisition">

<!--- show the contract edit screen by creating a contract with the objectid of the Id code --->
	
<cfset URL.Mission = Object.Mission>
<cfset URL.Period  = "FY19">
<cfset URL.menu    = "1">

<cfif Object.PersonNo neq "">
	
	<table width="100%" height="100%">
			
		<tr>
		<td>
				
		<cfoutput>
			<iframe src="#session.root#/Procurement/Application/Requisition/Portal/RequisitionView.cfm?menu=1&mission=#url.mission#&context=workflow&requirementid=#Object.ObjectKeyValue4#&personNo=#Object.PersonNo#&itemMaster=#url.wparam#" width="100%" height="100%" frameborder="0"></iframe>
		</cfoutput>
		</td>
		</tr>
		
	</table>	

</cfif>
	