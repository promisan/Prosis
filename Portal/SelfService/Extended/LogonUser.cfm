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
<cfoutput>

<cfparam name="session.logon" default="">
<cfparam name="client.logon"  default="">

<cfquery name="P" 
	datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  = 'SelfService'
	AND    FunctionName   = '#url.id#' 
	AND    (MenuClass      = 'Main' OR MenuClass = 'Mission')
	ORDER BY MenuOrder
</cfquery>

<cfquery name="Pref" 
	datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  = '#url.id#'
	AND    MenuClass      = 'function'
	AND    FunctionName   = 'preferences'
	AND    Operational    = 1
	ORDER BY FunctionName
</cfquery>

<cfquery name="User" 
datasource="AppsSystem">
	SELECT *
	FROM   Usernames
	WHERE  Account   = '#client.logon#'
</cfquery>			

<cfparam name="client.mission" default="">
<cfparam name="url.id"         default="">
<cfparam name="url.webapp"     default="#url.id#">
<cfparam name="url.scope"      default="Portal">

<cfif p.functionDirectory neq "">
	<cfparam name="url.link" default="#SESSION.root#/#P.FunctionDirectory#/#P.FunctionPath#|webapp=#url.id#-id=#url.id#-mission=#client.mission#-#P.functioncondition#">
<cfelse>
	<cfparam name="url.link" default="">
	<script>alert('Portal Log off undefined');</script>
</cfif>

<table width="100%" height="100%" border="0" align="right">
<tr><td align="right" style="font-family: Calibri; font-size: 13px; text-rendering: optimizeLegibility">
	
<cfif SESSION.authent  eq "1">
	<cfif user.recordcount eq "1">
	
		<cfif Pref.recordcount eq "1" and Pref.Operational eq "1">
			<a href="javascript:Preferences();" style="cursor:pointer">
				<font color="white"><cf_tl id="Preferences"></font>
			</a>
			&nbsp;<font color="silver">|</font>&nbsp;
		</cfif>
		
		<a href="javascript:ChangePassword('ajax','password','ChangePassword','#url.link#');" style="cursor:pointer">
			<font color="white"><cf_tl id="Change Password"></font>
		</a>
		&nbsp;<font color="silver">|</font>&nbsp;
	</cfif>	
	
	<a href="javascript:ColdFusion.navigate('#SESSION.root#/Portal/selfservice/Logoff.cfm?host=#CGI.HTTP_HOST#&scope=#url.scope#','user')">
	
	<font color="white"><cf_tl id="Logout"></font>
	
	</a>
	
	<!--- --------------------------------------------------------------- --->
	<!--- this button is used by the session framework to force a closing --->
	<!--- --------------------------------------------------------------- --->
	
	<input type="button" 
		    id="applicationclosebutton" 
			style="visibility:hidden" 
			onclick="javascript:ColdFusion.navigate('#SESSION.root#/Portal/selfservice/Logoff.cfm?host=#CGI.HTTP_HOST#&scope=#url.scope#','user')">
			
<cfelse>
    not logged on - 
	<a href="javascript:ColdFusion.navigate('LogonAjax.cfm?link=#url.link#','user');">Login</a>
</cfif>

</td></tr></table>
 		
</cfoutput>		