<cfparam name="request.loginMessage" default="">
<cfif NOT Len(request.loginMessage) AND StructKeyExists(cgi, "https") AND LCase(cgi.https) IS NOT "on">
	<cfset request.loginMessage = "Warning you are not using a Secure HTTPS connection.">
</cfif>
<div id="loginContainer" align="center">
	<cfoutput>
	<form action="#request.urlBuilder.createDynamicURL('login')#" class="form" method="post">
		<cfif Len(request.loginMessage)>
			<div class="alert">#XmlFormat(request.loginMessage)#</div>
			<br />
		</cfif>
		<label for="username">username:</label>
		<input type="text" name="username" id="username" value="" /><br/>
		<label for="password">password:</label>
		<input type="password" name="password" id="password" value="" /><br />
		<input type="submit" class="btn" value="Login" /> &nbsp;&nbsp; <small><a href="forgot-password.cfm">Forgot Password</a></small>
	</form>
	</cfoutput>
</div>
