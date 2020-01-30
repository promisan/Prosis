<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start">
	<cfparam name="attributes.users" type="query">
	
	<table border="0" class="table table-bordered table-striped" cellspacing="0">
		<tr>
			<th>Username</th>
			<th>Roles</th>
			<th>Enabled</th>
			<th>Edit</th>
		</tr>
		<cfoutput query="attributes.users">
			<tr>
				<td>#request.firewall.stringCleaner(attributes.users.username)#</td>
				<td>#request.firewall.stringCleaner(attributes.users.roles)#</td>
				<td>#YesNoFormat(attributes.users.enabled)#</td>
				<td><a href="#request.urlBuilder.createDynamicURL('user', 'user_id=#URLEncodedFormat(attributes.users.id)#&mode=edit')#" class="btn">Edit</a></td>
			</tr>
		</cfoutput>
	</table>
	
</cfif>