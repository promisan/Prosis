
<!--- ------------------------------------------ --->
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

