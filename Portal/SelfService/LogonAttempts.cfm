<!--
    Copyright © 2025 Promisan

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
<cfset ts = now()>
<cfset ts = dateAdd("n",-15,ts)>

<!--- This was the last chance --->
<cfquery name="getLogon" datasource="AppsSystem">
 SELECT   count(*) as Fails
 FROM     UserActionLog
 WHERE    Account         = '#SESSION.acc#' 
 AND      ActionClass     IN ('Logon','LDAP')
 AND      ActionMemo LIKE 'Denied%'
 AND      ActionTimeStamp > #ts#
</cfquery>
 
<cfset client.attempts = System.BruteForce-getLogon.fails>

<cfquery name="getLogonLast" datasource="AppsSystem">
 SELECT   TOP 1 *
 FROM     UserActionLog
 WHERE    Account         = '#SESSION.acc#' 
 AND      ActionClass     IN ('Logon','LDAP')
 ORDER BY ActionTimeStamp DESC
</cfquery>
  
<cfif left(getLogonLast.ActionMemo,7) neq "Success" 
           and getLogon.fails gte System.BruteForce <!--- changed to 4 --->
     and SESSION.Overwrite eq "0">  
     
   <!--- account has been brute forced no matter if logon succeeded or not --->       
  		<cfset caller.prosisLoginResult = 206>
    	<cfif url.printResult eq 1>

			<cfquery name="Parameter" 
				datasource="AppsInit">
				SELECT * 
				FROM   Parameter
				WHERE  HostName = '#CGI.HTTP_HOST#'
			</cfquery>
			<cfoutput>
				<cf_tl id="Your account"> [#SESSION.acc#] <cf_tl id="is"> <font color='FF0000'><b><cf_tl id="temporarily blocked"></b></font>
				<br>
				<cf_tl id="Reason">: <b>#system.BruteForce#</b> <cf_tl id="failed attempts"></b></font>. 
				<br>
				<cf_tl id="Please contact">: #Parameter.SystemContact# [#Parameter.SystemContactEMail#]
				<br>
			</cfoutput>
 		</cfif>
 		
 		<cfset SESSION.authent = "7">
 </cfif> 
 
 
 <cfif SESSION.authent neq 1>
	    <cf_tl id="Forgot your password">?
		<cf_tl id="Please use the forgot password link in the home page to reset your password">
		<br>
		<cfif client.attempts gte "2">
			<cf_tl id="You have #client.attempts# attempts left">. 
		<cfelseif client.attempts eq "1">							
			<cf_tl id="You have #client.attempts# attempt left">. 
		<cfelse>
			<cf_tl id="You have no attempts left">.
		</cfif>
		<br>							
 </cfif> 	
 	
 	
 	
 
