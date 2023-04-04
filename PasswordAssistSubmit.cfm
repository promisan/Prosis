
<cfquery name="Check" 
	datasource="AppsSystem">
		SELECT 	* 
		FROM 	UserNames 
		WHERE 	Account = '#form.account#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Check" 
	datasource="AppsSystem">
		SELECT 	* 
		FROM 	UserNames 
		WHERE 	MailServerAccount = '#form.account#'
	</cfquery>

</cfif>

<cfif form.account eq "Administrator">

	<font color="FF0000"><cf_tl id="Invalid account"></font>
 
<cfelseif Check.recordcount eq "0">

	<font color="FF0000"><cf_tl id="Invalid account"></font>
	 
<cfelseif Check.enforceLDAP eq "1">

	<font color="FF0000"><cf_tl id="This account requires LDAP authentication. Option is not available"></font>	
	
<cfelseif Check.eMailAddress eq "">

	<font color="FF0000"><cf_tl id="No email address associated to this account"></font>

<cfelse>
		
	<cfset SESSION.acc = form.account>	
	
	<!--- now we generate the eMail message --->
		
	<cf_mailPasswordInfo source="#form.source#">
				
	<script>
	 document.getElementById('action').className = "hide"
	</script>
	
	<cfif url.mode eq "regular">
		<cfoutput>
			<font face="Verdana" size="2" color="008000"><cf_tl id="An email was sent to your account."> <br><a href="http://#CGI.HTTP_HOST#"><font color="0080C0"><u><cf_tl id="Press here to return to the logon screen"></a></font>
		</cfoutput>
	<cfelse>
	
	<font face="Verdana" size="2" color="008000"><cf_tl id="An email was sent to your account."></font>
		
	</cfif>
	
</cfif>