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
<cfoutput>

<table width="96%" align="center">
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<cfset ts = now()>
	<cfset ts = dateAdd("n",-15,ts)>
	
	<cfquery name="System" 
		datasource="AppsSystem">
		SELECT  *	
		FROM    Parameter 
	</cfquery>	
	
	<cfquery name="get" 
		datasource="AppsSystem">
		SELECT   *
		FROM     UserNames
		WHERE    Account         = '#url.id#' 	
	</cfquery>	
	
	<cfquery name="getLogon" 
		datasource="AppsSystem">
		SELECT   count(*) as Fails
		FROM     UserActionLog
		WHERE    Account         = '#url.id#' 
		AND      ActionClass     IN ('Logon','LDAP') 
		AND      ActionMemo LIKE 'Denied%'
		AND      ActionTimeStamp > #ts#
	</cfquery>	
	
	<cfquery name="getLogonLast" 
		datasource="AppsSystem">
		SELECT   TOP 1 *
		FROM     UserActionLog
		WHERE    Account         = '#url.id#' 
		AND      ActionClass     IN ('Logon','LDAP') 	
		ORDER BY ActionTimeStamp DESC
	</cfquery>	
	
	
	<cfif getLogon.fails gte System.BruteForce and left(getLogonLast.ActionMemo,7) neq "Success">
		
		<tr><td style="height:60px" class="labelmedium" id="locked"><font color="red"><cf_tl id="Account is temporarily locked">: <font  size="5" color="0080C0"><u><a href="javascript:ColdFusion.navigate('#session.root#/System/UserPasswordUnlock.cfm?id=#url.id#','locked')"><font color="0080C0"><cf_tl id="Press to unlock account"></a></td></tr>	
		<tr><td colspan="2" class="line"></td></tr>
	
	</cfif>
	
	<cfif get.EnforceLDAP eq "1">
	
		<tr><td style="height:60px" class="labelmedium"><cf_tl id="Reset not available">:<b><font size="5"><cf_tl id="User enforced to use LDAP"></td></tr>
	
	<cfelse>
	
		<tr><td style="height:60px" class="labellarge"><a href="javascript:ColdFusion.navigate('#session.root#/System/UserpasswordReset.cfm?id=#url.id#','reset')"><cf_tl id="Reset password"></a></td></tr>
	
	</cfif>

	<tr><td colspan="2" class="line"></td></tr>
	<tr><td id="reset" style="padding:3px"></td></tr>

</table>

</cfoutput>

