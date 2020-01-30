
<!--- Parameters for portal enabled password change---->
<cfparam name="URL.actionid" default="">

<cfquery name="action" 
		datasource="AppsSystem">
			SELECT * 
			FROM   UserPasswordAction
			 WHERE ActionId = <cfqueryparam
						value="#URL.Actionid#"
						cfsqltype="CF_SQL_IDSTAMP"> 
</cfquery>

<cfif action.recordcount eq "0" or action.ActionExpiration lt now()>

	<table height="100%">
	   <tr>
	   	<td align="center" style="padding-top:10px" class="labellarge"><font color="FF0000"><cf_tl id="This expiration period of this link has expired"></font></td>
	   </tr>
   </table>
	<cfabort>

</cfif>

<cfif action.account neq form.account>

	<table height="100%">
	   <tr>
	   	<td align="center" style="padding-top:10px" class="labellarge"><font color="FF0000"><cf_tl id="This link is not intended for this account"></font></td>
	   </tr>
   </table>
	<cfabort>

</cfif>

	
<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
	javascript:window.history.forward(1);
</script> 


<cfquery name="get" 
	datasource="AppsSystem">
		SELECT * 
		FROM   UserNames 
		WHERE  Account = '#form.account#'
</cfquery>		

<cfif get.recordcount eq "0">
		
	<cfquery name="get" 
		datasource="AppsSystem">
			SELECT * 
			FROM   UserNames 
			WHERE  MailServerAccount = '#form.account#'
			AND    Disabled = 0
	</cfquery>		

</cfif>

<cftransaction>
	
	<cfquery name="setaction" 
		datasource="AppsSystem">
			UPDATE UserPasswordAction
			SET    SubmitTime      = getDate(),
			       SubmitPassword1 = '#Form.Password1#',
				   SubmitPassword2 = '#form.Password2#',
				   ActionStatus = '3'
			WHERE  ActionId = '#action.ActionId#'			 
	</cfquery>
	
	<cfquery name="logpassword" 
		datasource="AppsSystem">
			INSERT INTO UserPasswordLog
					(Account,PasswordExpiration,Password)
			VALUES	('#Form.account#',
			         getdate(),
					 '#get.Password#')		
	</cfquery>
	
	<cf_encrypt text = "#Form.Password1#">	
	
	<cfquery name="setaccount" 
		datasource="AppsSystem">
			UPDATE UserNames
			SET    PasswordResetForce = 0,
				   Password           = '#EncryptedText#',
				   PasswordModified   = getDate()			 
			WHERE  Account            = '#get.Account#'			 
	</cfquery>

</cftransaction>

<cfif action.ActionRedirect eq "Backoffice">
	
	<cfquery name="get" 
		datasource="AppsInit">
			SELECT * 
			FROM   Parameter
			WHERE  hostName = '#CGI.HTTP_HOST#'		
	</cfquery>
	
	<cfoutput>
	<script>
		window.open('#get.applicationroot#','_top')
	</script>
	</cfoutput>
	
<cfelse>	

	<!--- portal --->

</cfif>

