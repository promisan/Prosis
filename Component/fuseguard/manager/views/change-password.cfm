<cfparam name="thisTag.ExecutionMode" default="invalid">
<cfif thisTag.ExecutionMode IS "start">
	<h2>Change Password</h2>
	<cfparam name="attributes.user_id" default="0" type="integer">
	<cfoutput>
		<form action="#request.urlBuilder.createDynamicURL('change-password')#" method="post" class="labled">
			<input type="hidden" name="user_id" value="#Val(attributes.user_id)#" />
			<label for="old_password">Current Password:</label>
			<input type="password" name="old_password" id="old_password" value="" autocomplete="off" />
			<br />
			<label for="new_password">New Password:</label>
			<input type="password" name="new_password" id="new_password" value="" autocomplete="off" />
			<br />
			<label for="confirm_password">Confirm Password:</label>
			<input type="password" name="confirm_password" id="confirm_password" value="" autocomplete="off" />
			<br />
			<input type="submit" class="btn" value="Change Password">
		</form>
	</cfoutput>
</cfif>