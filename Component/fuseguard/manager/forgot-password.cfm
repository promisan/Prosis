<cfinclude template="common.cfm">
<cfset request.title = "Forgot Password">
<cfinclude template="views/header.cfm">
<div id="loginContainer" align="center">
<cfset auth = request.firewall.getAuthenticator()>

<cfif IsDefined("url.h")>
	<cfoutput>
		<form action="#request.urlBuilder.createDynamicURL('forgot-password')#" method="post">
			<input type="hidden" name="h" value="#XmlFormat(ReReplaceNoCase(url.h, "[^a-z0-9]", "", "ALL"))#" />
			
			<label for="email">email:</label>
			<input type="text" name="email" id="email" value="" /><br />
			
			<label for="password">new password:</label>
			<input type="password" name="password" id="password" value="" /><br />
			
			<label for="confirm_password">confirm password:</label>
			<input type="password" name="confirm_password" id="confirm_password" value="" /><br />
			
			<input type="submit" class="btn" value="Send Password" />
		</form>
	</cfoutput>
<cfelseif IsDefined("form.password") AND IsDefined("form.confirm_password") AND IsDefined("form.h") AND IsDefined("form.email")>
	<cftry>
		<cfset success = auth.changeForgotPassword(form.email, form.password, form.confirm_password, form.h)>
		<cfif success>
			<div class="message">Password reset.</div>
		</cfif>
		<cfcatch>
			<div class="message"><cfoutput>#XmlFormat(cfcatch.message)#</cfoutput></div>
		</cfcatch>
	</cftry>
<cfelseif IsDefined("form.email")>
	<!--- filled out send password form --->
	<cfset auth.sendForgotPasswordEmail(form.email)>
	If the email address you entered corresponds to an active user, an email was sent containing a password reset link.
<cfelse>
	<cfoutput>
		<form action="#request.urlBuilder.createDynamicURL('forgot-password')#" method="post">
			<div class="alert">Enter your email address to send a password reset request.</div>
			<br />
			<label for="email">Email:</label>
			<input type="email" name="email" id="email" placeholder="you@example.com" value="" /><br />
			<input type="submit" class="btn" value="Reset Password" />
		</form>
	</cfoutput>	
	
</cfif>

</div>
<cfinclude template="views/footer.cfm">
