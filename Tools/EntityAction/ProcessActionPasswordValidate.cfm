<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	
	 ProsisUI.closeWindow('boxauth')
	 saveforms('#url.wfmode#')
	
	</script>
	
	</cfoutput>
	
</cfif>	