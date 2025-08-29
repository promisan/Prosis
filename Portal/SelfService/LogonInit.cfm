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
<cfparam name="url.returnValue"		default = "0">

<!--- account authentication --->

<cfquery name="UserExist" 
datasource="AppsSystem">
	SELECT *
	FROM   UserNames
	WHERE  Account = '#Account.Account#'		
</cfquery>

  <cf_verifyOperational module="Staffing" Warning="No">	   
   
  <cfif operational eq "1">
	  <cfquery name="EParameter" 
		datasource="AppsEmployee">
		 SELECT * 
    	 FROM Parameter
	   </cfquery>

	   <cfset CLIENT.IndexNoName  = "#EParameter.IndexNoName#">
   
   <cfelse>
   
       <cfset Client.IndexNoName = "IndexNo">
	   
   </cfif>


<cfset CLIENT.PageRecords    = UserExist.Pref_PageRecords>

<cfif UserExist.recordcount eq "0">

	<!--- create an account on the fly here --->

    <cfset acc = left(lcase(Check.FirstName),1)>
	<cfset row = 1>
	
	<cfloop index="nme" list="#Check.LastName#" delimiters=" ">
	     <cfif row eq "1">
	        <cfset acc = Replace("#acc##lcase(nme)#","-","","ALL")>
			<cfset row = "2">
		 </cfif>
	</cfloop>
	
	<cfset account = acc>
	
	<cfset account = Replace(account, " ", "", 'ALL')>
	<cfset account = Replace(account, "'", "", 'ALL')>
	<cfset account = Replace(account, "&", "", 'ALL')>
	<cfset account = Replace(account, "*", "", 'ALL')>
	<cfset account = Replace(account, "$", "", 'ALL')>
	<cfset account = Replace(account, "%", "", 'ALL')>
	<cfset account = Replace(account, "~", "", 'ALL')>
	<cfset account = Replace(account, "-", "", 'ALL')>
	<cfset account = Replace(account, "@", "", 'ALL')>
	<cfset account = Replace(account, "!", "", 'ALL')>
	<!---
	<cfset account = Replace(account, "_", "", 'ALL')>
	--->
	<cfset account = Replace(account, "(", "", 'ALL')>
	<cfset account = Replace(account, ")", "", 'ALL')>
	<cfset account = Replace(account, "+", "", 'ALL')>
	<cfset account = Replace(account, "=", "", 'ALL')>
	<cfset account = Replace(account, "|", "", 'ALL')>
	<cfset account = Replace(account, "{", "", 'ALL')>
	<cfset account = Replace(account, "}", "", 'ALL')>
	<cfset account = Replace(account, ";", "", 'ALL')>
	<cfset account = Replace(account, "?", "", 'ALL')>
	<cfset account = Replace(account, "<", "", 'ALL')>
	<cfset account = Replace(account, ">", "", 'ALL')>
	
	<cfset acc = account>
	
	<cfquery name="VerifyAccount" 
	datasource="AppsSystem">
		SELECT *
		FROM   UserNames
		WHERE  Account = '#acc#' 
	</cfquery>
	
	<cfif VerifyAccount.recordcount gte "1">
	
		<cfquery name="User" 
		datasource="AppsSystem">
			INSERT INTO UserNames
			(Account, 
			 LastName, 
			 FirstName, 
			 IndexNo, 
			 PersonNo, 
			 AccountType, 
			 Source,
			 OfficerUserId, 
			 OfficerLastName, 
			 officerFirstName)
			VALUES
			('SELF_#Check.PersonNo#', 
			'#Check.LastName#', 
			'#Check.FirstName#',
			'#Check.IndexNo#', 
			'#Check.PersonNo#', 
			'Individual', 
			'SService', 
			'SELF_#Check.PersonNo#',
			'#Check.LastName#', 
			'#Check.FirstName#')
		</cfquery>
		
		<cfset SESSION.acc    =  "SELF_#PersonNo#">
		<cfset CLIENT.eMail  =  "">
	
	<cfelse>
	
		<cfquery name="User" 
		datasource="AppsSystem">
			INSERT INTO UserNames
			(Account, 
			 LastName, 
			 FirstName, 
			 IndexNo, 
			 PersonNo, 
			 AccountType, 
			 Source,
			 OfficerUserId, 
			 OfficerLastName, 
			 officerFirstName)
			VALUES
			('#acc#', 
			'#Check.LastName#', 
			'#Check.FirstName#',
			'#Check.IndexNo#', 
			'#Check.PersonNo#', 
			'Individual', 
			'SService',
			'#acc#',
			'#Check.LastName#', 
			'#Check.FirstName#')
		</cfquery>
		
		<cfset SESSION.acc    =  acc>
		<cfset CLIENT.eMail  =  "">
		
	</cfif>
		
<cfelse>

	<cfset SESSION.acc        =  UserExist.Account>	
	<cfset CLIENT.eMail       =  UserExist.eMailAddress>
	<cfset CLIENT.eMailExt    =  UserExist.eMailAddressExternal>
	
	<!--- set the default account for the submission to open for the portal user --->
	<cfset CLIENT.ApplicantNo =  UserExist.ApplicantNo>	
	<cfset Session.ApplicantNo =  UserExist.ApplicantNo>	
		
	<cfif find("-","#UserExist.Account#")>	
	
		<cfset account = Replace(UserExist.Account, "-", "", 'ALL')>
		<cfset account = Replace(account, " ", "", 'ALL')>
		<cfset account = Replace(account, "'", "", 'ALL')>
		<cfset account = Replace(account, "&", "", 'ALL')>
		<cfset account = Replace(account, "*", "", 'ALL')>
		<cfset account = Replace(account, "$", "", 'ALL')>
		<cfset account = Replace(account, "%", "", 'ALL')>
		<cfset account = Replace(account, "~", "", 'ALL')>
		<cfset account = Replace(account, "-", "", 'ALL')>
		<cfset account = Replace(account, "@", "", 'ALL')>
		<cfset account = Replace(account, "!", "", 'ALL')>
		<!---
		<cfset account = Replace(account, "_", "", 'ALL')>
		--->
		<cfset account = Replace(account, "(", "", 'ALL')>
		<cfset account = Replace(account, ")", "", 'ALL')>
		<cfset account = Replace(account, "+", "", 'ALL')>
		<cfset account = Replace(account, "=", "", 'ALL')>
		<cfset account = Replace(account, "|", "", 'ALL')>
		<cfset account = Replace(account, "{", "", 'ALL')>
		<cfset account = Replace(account, "}", "", 'ALL')>
		<cfset account = Replace(account, ";", "", 'ALL')>
		<cfset account = Replace(account, "?", "", 'ALL')>
		<cfset account = Replace(account, "<", "", 'ALL')>
		<cfset account = Replace(account, ">", "", 'ALL')>
		
		<cfset SESSION.acc    =  account>	
	
			<cfquery name="User" 
			datasource="AppsSystem">
				UPDATE  UserNames
				SET     Account = '#SESSION.acc#'
				WHERE   Account = '#UserExist.Account#'			
			</cfquery>
		
	</cfif>

</cfif>

<cfquery name="UserExist" 
datasource="AppsSystem">
	SELECT *
	FROM   UserNames
	WHERE  Account = '#SESSION.acc#'	
</cfquery>

<cfset SESSION.first     =  "#UserExist.FirstName#">
<cfset SESSION.last      =  "#UserExist.LastName#">
<cfset CLIENT.IndexNo    =  "#UserExist.IndexNo#">
<cfset CLIENT.PersonNo   =  "#UserExist.PersonNo#">
<cfset CLIENT.SessionNo =  "0">

<!--- provision to assign an applicant --->


<cfif url.id eq "PHP">

	<cfif url.returnValue eq "1">
		<cfset prosisLoginResult = 203>
	<cfelse>
		<cfinclude template="basic/LogonPHP.cfm">
	</cfif>
</cfif>

<cfif len(CGI.HTTP_USER_AGENT) gt "200">
	<cfset bws = "#left(CGI.HTTP_USER_AGENT,200)#">
<cfelse>
	<cfset bws = "#CGI.HTTP_USER_AGENT#">
</cfif>

  <cfinvoke component = "Service.Process.System.Client"  
	   method           = "getBrowser"
	   browserstring    = "#bws#"			   
	   returnvariable   = "userbrowser">	  

<cf_getHost host="#cgi.http_host#">
   
<cftry>   
   		
	<cfquery name="Init" 
	datasource="AppsInit">
		SELECT * 
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'		
	</cfquery>
			  
	<cfquery name="insert" 
	datasource="AppsSystem">
	
		INSERT INTO UserStatus 
				(Account, 
				 HostName, 
				 HostSessionId,
				 NodeIP, 
				 ApplicationServer,			 
				 NodeVersion, 
				 NodeBrowser,
				 NodeBrowserVersion,
				 ActionTimeStamp, 
				 ActionTemplate)
		VALUES ('#SESSION.acc#',
			    '#host#',
			    '#Session.SessionId#', 
			    '#CGI.Remote_Addr#', 
			    '#init.applicationserver#',			 
			    '#bws#', 
			    '#userbrowser.name#',
				'#userbrowser.release#',
			    getDate(), 
			    '#CGI.SCRIPT_NAME#')
	</cfquery>
	
	<!--- check session --->
	
		<cfquery name="get" 
		datasource="AppsSystem">
			SELECT *
			FROM   UserNames
			WHERE  Account   = '#SESSION.acc#' 
		</cfquery>
				
		<cfif get.AllowMultipleLogon eq "0" and getAdministrator("*") eq "0">
				
			<cfquery name="update" 
			datasource="AppsSystem">
			
				UPDATE UserStatus 
				SET    ActionExpiration = 1
				WHERE  Account   = '#SESSION.acc#' 
				AND    HostName    = '#host#' 
				AND    HostSessionId  != '#SESSION.Sessionid#'
				
			</cfquery>
				
		</cfif>
		
	<cfcatch>
			
		<cfquery name="update" 
		datasource="AppsSystem">
			UPDATE UserStatus 
			SET    ActionTimeStamp  = getDate(),
			       ActionTemplate   =  '#CGI.SCRIPT_NAME#',
				   ActionExpiration = '0'
			WHERE  Account          = '#SESSION.acc#' 
			AND    HostName         = '#host#' 
			AND    HostSessionId    = '#SESSION.sessionid#'
		</cfquery>
		
	</cfcatch>	
		
</cftry>		
	
<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFRStage\user\#SESSION.acc#\")>

   <cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\CFRStage\user\#SESSION.acc#\">

</cfif>

<!--- returns a value --->

<cfif url.returnValue eq 1>
	<cfset caller.prosisLoginResult = prosisLoginResult>
</cfif>