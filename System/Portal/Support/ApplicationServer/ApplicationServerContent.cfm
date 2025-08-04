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


<cfparam name="URL.Server" default="">

<cfquery name="Server" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT *
		FROM   Control.dbo.ParameterSite
		WHERE  ApplicationServer = '#URL.Server#'
</cfquery>


<cfset active = 24*60>
<cfset daterecent = DateAdd("n", "-#active#", "#now()#")>

<cfquery name="Users" 
datasource="AppsSystem">
	SELECT   U.ApplicationServer, U.Account, N.FirstName, U.NodeVersion, N.LastName, MAX(U.ActionTimeStamp) ActionTimeStamp, MAX(U.Created) Created
	FROM     [#Server.DatabaseServer#].System.dbo.UserStatus U, [#Server.DatabaseServer#].System.dbo.UserNames N 
	WHERE    U.Account = N.Account 
	AND      ActionTimeStamp > #daterecent#	
	GROUP    BY U.ApplicationServer, U.Account, N.FirstName, U.NodeVersion, N.LastName 
	ORDER    BY U.ApplicationServer, N.FirstName
</cfquery>	

<cfif Users.recordcount eq "0">

	<table width="100%"><tr><td class="labelmedium" style="padding-top:30px" align="center">No users</td></tr></table>

<cfelse>

	<table width="100%" class="formpadding" style="#vTextColor# padding-left:10px">
		<tr>
			<td style="padding-left:15px">
				<table width="100%" class="navigation_table">
					<tr class="line">
						<td></td>
						<td>Server</td>
						<td>Name</td>
						<td style="padding-left:7px;">Account</td>
						<td style="padding-left:5px;">Bwsr</td>
						<td>Last</td>
						<td>Active</td>
					</tr>
					<cfoutput query="Users">
						
						<tr class="navigation_row labelit" valign="top">
							<td width="10"> #currentRow#. </td>
							<td class="labelit">
								#ApplicationServer#
							</td>
							<td class="labelit">
								#FirstName# #LastName#
							</td>
							<td style="padding-left:7px;" width="10%" class="labelit">
								#Account#
							</td>
							<td style="padding-left:5px;">
							<cfinvoke component = "Service.Process.System.Client"  
							   method           = "getBrowser"
							   browserstring    = "#NodeVersion#"
							   minIE            = "8"
							   minFF            = "3"	  
							   returnvariable   = "userbrowser">	   
								
							<cfif userbrowser.pass eq "0" and userbrowser.name neq "android"><font color="FF0000"></cfif>#Left(UserBrowser.Name,1)# #userbrowser.release#&nbsp;&nbsp;
							</td>
							<td>
								<cfset diff = DateDiff("n", "#Users.ActionTimeStamp#", "#now()#")>
								<cfif diff lte "3">
									<b>now</b>
								<cfelse>
									<cfif diff gt 59>
										#int(diff/60)# hrs.
									<cfelse>
										#diff# min.
									</cfif>
								</cfif>
							</td>
							<td>
								<cfif DateFormat(now(),CLIENT.DateFormatShow) eq DateFormat(Created, CLIENT.DateFormatShow)>
									#TimeFormat(Created, "HH:MM")#
								<cfelse>
									#DateFormat(Created, "DD/MM")# #TimeFormat(ActionTimestamp, "HH:MM")#
								</cfif>
							</td>
						</tr>
						
						
					</cfoutput>							
				</table>	
			</td>
		</tr>
	</table>
	
</cfif>	