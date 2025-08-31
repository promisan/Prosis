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
<cfparam name="url.code" default="">

<cfquery name="GetApplication" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT A.*, U.FirstName, U.LastName
		 FROM   Ref_Application A
		 LEFT   JOIN UserNames U
		 	    ON A.OfficerManager = U.Account
		 ORDER  BY A.Usage, A.Created
		 
</cfquery>

<cfform method="POST" name="applicationform" onsubmit="return false;">

<table width="95%" align="center" class="navigation_table">

<tr class="labelmedium line">
	<td></td>
	<td>Code</td>
	<td>Description</td>
	<td>Host</td>
	<td>Owner</td>
	<td>Officer Manager</td>
	<td>Operational</td>
	<td>Officer</td>
	<td>Created</td>
</tr>

<cfif url.code eq "new">
	<cfinclude template="RecordAdd.cfm">
</cfif>

<cfoutput query="GetApplication" group="Usage">

	<tr class="linedotted"><td colspan="9" class="labellarge" style="height:30px;">#Usage#</b></td></tr>  

	<cfoutput>

		<cfif url.code eq Code>
			<cfinclude template="RecordEdit.cfm">
		<cfelse>
		
		  			
			<tr class="navigation_row labelmedium line">
				<td width="60px" style="height:17px;padding-top:1px; padding-left:20px;">
					<table cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<cf_img icon="select" navigation="Yes" onclick="recordedit('#code#')">
							</td>
							<cfif Usage neq "System">
								<td style="padding-left:4px;">
									<cf_img icon="delete" onclick="deleteApplication('#code#')">
								</td>
							</cfif>
							<td style="padding-left:4px;padding-right:4px;padding-top:8px">
								<cf_img icon="expand" toggle="Yes" onclick="showModules('#code#')">
							</td>
						</tr>
					</table>
				</td>
				<td> #Code# </td>
				<td> #Description# </td>
				<td> #HostName#</td>
				<td> #Owner# </td>
				<td> <cfif OfficerManager neq "">#OfficerManager#</cfif> </td>
				<td> <cfif Operational eq 1>Yes<cfelse>No</cfif></td>
				<td> #OfficerLastName#</td>
				<td> #DateFormat(Created,CLIENT.DateFormatShow)#</td>
			</tr>
									
			<tr>
				<td id="#code#_list" class="hide" colspan="9"></td>
			</tr>			
		
		</cfif>

	</cfoutput>

</cfoutput>

</table>

</cfform>


<cfset AjaxOnLoad("doHighlight")>	
