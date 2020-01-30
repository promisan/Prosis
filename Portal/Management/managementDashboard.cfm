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