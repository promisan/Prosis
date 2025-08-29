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
<!--- 1. check format in NY/CICIG of the date
      2. send eMail will details using the dialog we have 	  
	  3. test behavior on windows dialog screen 
 --->
 
<cfoutput>

<cftry>

<cfquery name="Log" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	   SELECT * 
	   FROM   UserError
	   WHERE  ErrorId = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> 
</cfquery>			
	
    <!--- get the recorded error in the log file of cf 	
	
	Note:  April 10, 2015. by dev.
	As discussed with Hanno, I'm taking this out because: (a) We are already storing error diagnostics and error content in the database so no 
	need for exception.log file to be populated
	
	<cffile action="READ" 
	    file="#Server.ColdFusion.RootDir#\logs\exception.log" 
		variable="flog">	
		
	<cfset base = right(flog, 7000)>
	<cfset base = replace(base,'"',"-",'ALL')> 			
					
	<cfset loc = Find("#url.ts#", base)>		
	
	<cfif loc eq "0">
	    <cfset err = mid(base, 1, 8000)>
	<cfelse>
		<cfset err = mid(base, loc, 8000)>		
	</cfif>			

	<cfset vErrorContent = "#Log.ErrorContent# Stack:  #HTMLCodeFormat(err)#">		
									
	<!--- update error details, at the begining it comes the information on the file location --->
	<cfquery name="Update" 
	datasource="AppsSystem">
		UPDATE UserError
		SET    ErrorContent = '#vErrorContent#'
		WHERE  ErrorId      = '#url.id#'
	</cfquery> 
	
	--->
	
	<!--- We send email only once per user and per error. EnableProcess is updated in Service.Process.System.SystemError--->
	<cfif Log.EnableProcess eq 1> 
	
		<!--- sending a mail --->
		<cf_ErrorInsertMail errorid="#url.id#">	
								
		<cfquery name="Parameter" 
			datasource="AppsInit">
			SELECT * 
			FROM   Parameter
			WHERE  HostName = '#CGI.HTTP_HOST#'
		</cfquery>
		
		<!--- dev, on 21/05/2015: removed as per discussion with Hanno.
		<cfif Parameter.ErrorMailToOwner eq "9">
			
			<script>
				alert("Thank you, an eMail notification was sent.")
			</script>	
		
		</cfif> --->
		
	</cfif>		
	
<cfcatch>

	<!---
		
	<script>
		alert("Sorry, an automatic Email notification could NOT be sent to the administrator.")
	</script>	
	
	--->
			
</cfcatch>

</cftry>

</cfoutput>


