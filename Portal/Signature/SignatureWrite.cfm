
<cfparam name="FORM.SignatureContent" default="">

<cfif FORM.SignatureContent neq "">

		<cfquery datasource="AppsSystem" name="qUpdate">
			UPDATE UserNames
			SET    Signature = '#FORM.SignatureContent#',
				   SignatureModified = getDate()
			WHERE  Account = '#account#'
		</cfquery>
		
<cfelse>

		<cfquery datasource="AppsSystem" name="qUpdate">
			UPDATE UserNames
			SET    Signature = NULL,
				   SignatureModified = getDate()
			WHERE  Account = '#account#'
		</cfquery>
		
</cfif>

<cfoutput>
		
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>  
	
	<script>
	parent.pref('UserSignature.cfm')
	</script>
	
	
</cfoutput>