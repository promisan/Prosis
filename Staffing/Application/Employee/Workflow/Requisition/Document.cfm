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
	