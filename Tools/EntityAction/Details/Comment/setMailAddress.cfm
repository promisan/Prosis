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
<cfparam name="form.MailAddress" default="">

<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    UserNames U 		
	<cfif form.MailAddress neq "">		
	WHERE 	U.Account IN (#preserveSingleQuotes(Form.MailAddress)#)
	<cfelse>
	WHERE    1=0
	</cfif>
	<cfif url.action eq "delete">
		AND Account != '#url.useraccount#'
	<cfelse>
		OR Account = '#url.useraccount#'	
	</cfif>
	
</cfquery>

<table style="width:100%">
													
		<cfoutput query="get">
		    <tr class="<cfif currentrow neq recordcount>line</cfif>">
		    <td class="labelit" style="padding-left:0px; color:black;">#LastName#</td>
			<td align="right" style="padding-top:2px;padding-left:2px;padding-right:4px">
			<cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/setMailAddress.cfm?objectid=#url.objectid#&action=delete&useraccount=#account#','mailselect','','','POST','entryform')">
			</td> 												
			</tr>
		</cfoutput>
		
	</table>
	
	<cfoutput>										
		<input type="hidden" id="mailaddress" name="mailaddress" 
		    value="#quotedvalueList(get.Account)#">
	</cfoutput>

		