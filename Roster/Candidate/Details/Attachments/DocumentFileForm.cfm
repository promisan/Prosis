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
<cfparam name="url.memo" default="1">

<table width="100%">
	
	<cfif url.memo eq "1">
		
		<tr><td height="4"></td></tr>
		<tr class="line"><td><font size="3" color="gray"><cfoutput><cf_tl id="Memo"></cfoutput></font></td></tr>
				
		<tr>
		<td>		
		<cf_securediv bind="url:attachments/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#" id="imemo">		
		</td>
		</tr>
	
	</cfif>
	
	
<cfparam name="url.memo" default="1">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	
	<cfif url.memo eq "1">
				
		<tr><td height="1" class="linedotted"></td></tr>
				
		<tr>
		<td>		
		<cf_securediv bind="url:attachments/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#" id="imemo">		
		</td>
		</tr>
	
	</cfif>
	
	<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Parameter
		WHERE Identifier = 'A'
	</cfquery>
		
	<tr class="line"><td height="20" bgcolor="white" class="labelmedium"><cfoutput><cf_tl id="Profile documents"> for #url.owner#</cfoutput></td></tr>
				
	<tr>	
	<td>	
		
	<cf_filelibraryN
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#URL.ID#" 
		Filter="#url.owner#"
		Insert="yes"
		loadscript="No"
		Box="#url.owner#"
		Remove="yes"
		ShowSize="yes">	
	</td>
	</tr>
	
	

</table>
