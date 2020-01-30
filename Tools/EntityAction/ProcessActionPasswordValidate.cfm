
<!--- validate password --->

<cfquery name="Parameter" 
	datasource="AppsSystem">
		SELECT  *		
		FROM    Parameter 
</cfquery>	

<cfquery name="Account" 
	datasource="AppsSystem">
		SELECT  *		
		FROM    UserNames 
		WHERE   Account = '#Session.Acc#'
</cfquery>	

<cfset domain = "">
<cfif Account.recordcount eq 1>
	<cfset domain = Account.MailServerDomain>
</cfif>

<cfif parameter.LogonMode eq "Prosis">
	
	<cfinvoke component = "Service.Authorization.Password"  
	   method           = "Prosis" 
	    pwd              = "#form.ProcessPassword#" 	 
	   returnvariable   = "searchresult">		
	
<cfelseif parameter.LogonMode eq "LDAP">

	<cfinvoke component = "Service.Authorization.Password"  
	   method           = "LDAP" 
	   domain			= "#domain#"
	   pwd              = "#form.ProcessPassword#" 
	   returnvariable   = "searchresult">		
	
<cfelse>

	<cfinvoke component = "Service.Authorization.Password"  
	   method           = "Prosis" 	  
	   pwd              = "#form.ProcessPassword#" 	 
	   returnvariable   = "searchresult">		   
			
	<cfif searchresult.recordcount eq "0">
	
			<cfinvoke component = "Service.Authorization.Password"  
			   method           = "LDAP" 
			   domain			= "#domain#"
			   pwd              = "#form.ProcessPassword#" 
			   returnvariable   = "searchresult">	
			   			   
	</cfif>
	
	
</cfif>

<cfif searchresult.recordcount eq "0">

	<table align="center">
		 <tr><td height="24" align="center"><font color="FF0000">Incorrect password</font></td></tr>
	</table>

<cfelse>
	
	<!--- process action --->
	
	<cfoutput>
	
	<script>
	
	 ColdFusion.Window.hide('boxauth')
	 saveforms('#url.wfmode#')
	
	</script>
	
	</cfoutput>
	
</cfif>	