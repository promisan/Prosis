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
<cf_screentop 
		height="100%" 
		scroll="Yes" 
		html="Yes" 
		label="Monthly Management Overview" 
		layout="webdialog" 
		banner="blue" 
		user="no">

<cfset bgColor = "D6EFFC">
<cfset iconTdWidth = "20%">
<cfset iconWidth = 100>
<cfset iconName = "contract.png">
<cfset elementName = "Contract">
<cfset link = "contracts.cfm">

<table width="95%" align="center" cellspacing="10">
	<tr>
		<td width="50%">
			<cfset iconName = "contract.png">
			<cfset elementName = "Contract">
			<cfset link = "contracts.cfm">
			<cfinclude template="dashboardElement.cfm">
		</td>
		<td>
			<cfset iconName = "personnel.png">
			<cfset elementName = "Personnel">
			<cfset link = "personnel.cfm">
			<cfinclude template="dashboardElement.cfm">			
		</td>
	</tr>
	<tr>
		<td>
			<cfset iconName = "cart.png">
			<cfset elementName = "Fuel Requirement">
			<cfset link = "requirements.cfm">
			<cfinclude template="dashboardElement.cfm">
		</td>
		<td>
			<cfset iconName = "safebox.png">
			<cfset elementName = "Reserves">
			<cfset link = "reserves.cfm">
			<cfinclude template="dashboardElement.cfm">
		</td>
	</tr>
	<tr>
		<td>
			<cfset iconName = "pricing.png">
			<cfset elementName = "Prices">
			<cfset link = "prices.cfm">
			<cfinclude template="dashboardElement.cfm">
		</td>
		<td>
			<cfset iconName = "truck.png">
			<cfset elementName = "Vehicles/Aircrafts/Generators">
			<cfset link = "vehicles.cfm">
			<cfinclude template="dashboardElement.cfm">			
		</td>
	</tr>
	<tr>
		<td>
			<cfset iconName = "fuel.png">
			<cfset elementName = "Road Tankers">
			<cfset link = "tankers.cfm">
			<cfinclude template="dashboardElement.cfm">
		</td>
		<td>
			<cfset iconName = "budget.png">
			<cfset elementName = "Budgets">
			<cfset link = "budgets.cfm">
			<cfinclude template="dashboardElement.cfm">
		</td>
	</tr>
</table>