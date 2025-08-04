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

<cfparam name="url.hostserver" default="All">

<cfinvoke component = "Service.Process.System.SystemError"  
	method			= "TagSystemError"
	ExecutionScope	= "Today">
		

<cfquery name="Error" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">   

	SELECT  UE.*, 
	        UN.FirstName+' '+UN.LastName+' ('+UN.Account+')' AS UserA, 
		    CONVERT(VARCHAR(10),UE.ErrorTimeStamp,103) as ErrorDate, UE.ErrorTimeStamp AS ErrorTime,
		    DateCount.TotalErrors
	FROM    UserError UE INNER JOIN UserNames UN ON UE.Account = UN.Account 
			INNER JOIN 
			(
					SELECT CONVERT(VARCHAR(10),UE.ErrorTimeStamp,103) AS ErrorDate, COUNT(CONVERT(VARCHAR(10),UE.ErrorTimeStamp,103)) TotalErrors
					FROM    UserError UE
					WHERE   ActionStatus IN ('0','1') AND (UE.Created > GETDATE() - 7) 	
					AND     EnableProcess = '1'
					<cfif url.hostserver neq "All">
					AND    HostServer = '#url.hostserver#'
					<cfelse>
					AND    HostServer != '' 
					</cfif>	
					GROUP BY CONVERT(VARCHAR(10),UE.ErrorTimeStamp,103)
			) DateCount ON DateCount.ErrorDate = CONVERT(VARCHAR(10),UE.ErrorTimeStamp,103)
	WHERE   ActionStatus IN ('0','1') AND (UE.Created > GETDATE() - 7) 	
	AND     EnableProcess = '1' 

	<cfif url.hostserver neq "All">
	AND    HostServer = '#url.hostserver#'
	<cfelse>
	AND    HostServer != ''
	</cfif>	
	
	<cfif SESSION.isAdministrator eq "No">
	AND    (HostServer IN (SELECT DISTINCT GroupParameter 
	                       FROM   Organization.dbo.OrganizationAuthorization
						   WHERE  Role        = 'ErrorManager'
						   AND    UserAccount = '#SESSION.acc#')
			OR
			
			UE.Account = '#SESSION.acc#'
			)		
	</cfif>			
	
	ORDER BY UE.ErrorTimeStamp DESC 

</cfquery>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">

<cfset col = "6">

<cfoutput>
	
	<tr> <td height="15" colspan="#col#"></td> </tr>
	
	<tr class="labelit linedotted">
		<td width="1%"></td>
		<td width="10%">No.</td>
		<td width="67%">Diagnostic</td>
		<td width="14%">User</td>
		<td width="8%">Time</td>
		<td width="8%">Server</td>		
	</tr>
		
</cfoutput>

<cfset day = 0>

<cfoutput query="Error" group="ErrorDate">

	<cfset day = day + 1>

	
	<tr onClick="toggledate('tableDay_#day#','imageDay_#day#')" class="line navigation_row" style="cursor: pointer;">
		<td colspan="#col-1#">
		
		    <table cellspacing="0" cellpadding="0" class="formpadding">
		    <tr><td class="labellarge">
			<img src="#SESSION.root#/Images/arrowright.gif" 
				 id="imageDay_#day#" 
				 alt="" border="0" 
			     class="show" 
				 style="cursor: pointer;" >
				 </td>
				 <td style="padding-left:7px" class="labelmedium">
				#ErrorDate#				
				</td></tr></table>
					
		</td>
		<td class="labellarge" align="right" style="padding-right:10px" class="labelit">#TotalErrors#</td>
	</tr>
			
	<cfoutput>
	
		<tr bgcolor="white" id="tableDay_#day#" name="tableDay_#day#" class="hide"><td height="5" colspan="#col#"></td></tr>
	
		<tr id="tableDay_#day#" name="tableDay_#day#" class="hide">
			<td valign="top"></td>
			<td valign="top" style="padding-right:5px" class="labelit">
				<a href="javascript:errorview('#errorid#')"><font color="6688aa"><u>#ErrorNo#</font></a>
			</td>
			<td class="labelit">#ErrorDiagnostics#</td>
			<td valign="top" style="padding-top:4px" class="labelit">
				<a href="javascript:ShowUser('#URLEncodedFormat(Account)#')"><font color="6688aa">#UserA#</a>
			</td>
			<td class="labelmedium" valign="top" style="padding-top:4px">#TimeFormat(ErrorTime, "hh:mm:ss tt")#</td>
			<td class="labelit" valign="top" style="padding-top:4px">#HostServer#</td>			
		</tr>
	
		<tr bgcolor="white" id="tableDay_#day#" name="tableDay_#day#" class="hide"><td height="5" colspan="#col#"></td></tr>
		
		<tr id="tableDay_#day#" name="tableDay_#day#" class="hide">
		
			<td></td>
						
			<td style="cursor:pointer"  class="regular" style="width:120">
			
				<cf_space spaces="60">
						
				<table cellspacing="0" cellpadding="0" id="process_#errorid#" name="process_#errorid#">	
							
					<tr>
						<td class="labelit">			
							<input type="radio" class="radiol" name="status_#ErrorNo#" id="status_#ErrorNo#" value="0" <cfif ActionStatus eq "0">checked</cfif>  onclick="ColdFusion.navigate('#client.root#/System/Portal/Exception/ExceptionMemo.cfm?mode=hide&errorid=#errorid#&actionstatus=0','tbox_#errorid#');">Keep as pending
						</td>
					</tr>
					<tr>
						<td class="labelit">			
							<input type="radio" class="radiol" name="status_#ErrorNo#" id="status_#ErrorNo#" value="2" <cfif ActionStatus eq "2">checked</cfif>  onclick="ColdFusion.navigate('#client.root#/System/Portal/Exception/ExceptionMemo.cfm?mode=show&errorid=#errorid#&actionstatus=2','tbox_#errorid#');">For review
						</td>
					</tr>
					<tr>
						<td class="labelit">			
							<input type="radio" class="radiol" name="status_#ErrorNo#" id="status_#ErrorNo#" value="3" <cfif ActionStatus eq "3">checked</cfif>  onclick="ColdFusion.navigate('#client.root#/System/Portal/Exception/ExceptionMemo.cfm?mode=show&errorid=#errorid#&actionstatus=3','tbox_#errorid#');">Dismiss error
						</td>
					</tr>					
				
				</table>
			
			</td>
			
			<td colspan="4" bgcolor="ffffcf" class="verdana" height="20" style="border:1px dotted silver; word-wrap: break-word; word-break: break-all;padding:3px">
			  <table cellspacing="0" cellpadding="0" class="formpadding">
			  	<tr><td class="labelit"><u>#ErrorTemplate#</u></td></tr>
				<tr><td class="labelit"><font size="1">#ErrorString#</font></td></tr>
			  </table>	
			</td>	
							
		</tr>
		
		<tr id="tableDay_#day#" name="tableDay_#day#" class="hide" bgcolor="white"><td height="5" colspan="#col#"></td></tr>
		
		<tr id="tableDay_#day#" name="tableDay_#day#" class="hide" bgcolor="white">
			<td></td>
			<td></td>
			<td colspan="4" id="tbox_#errorid#" name="tbox_#errorid#"></td>
			<td></td>
		</tr>
				
		<tr id="tableDay_#day#" name="tableDay_#day#" class="hide">
		    <td colspan="#col#" class="linedotted"></td>
		</tr>

	</cfoutput>
			
</cfoutput>

</table>
