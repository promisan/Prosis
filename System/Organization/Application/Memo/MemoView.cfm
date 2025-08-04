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

<cfparam name="url.owner" default="">
<cfparam name="url.memo" default="1">

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<table width="100%" align="center">

	<tr><td>
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</td></tr>
	
</table>

<table width="97%" align="center">
	
	<cfif url.memo eq "1">
							
		<tr>
			<td style="padding-top:4px">		
				<cf_securediv bind="url:../memo/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#" id="imemo">		
			</td>
		</tr>
	
	</cfif>	
	
<cfparam name="url.memo" default="1">

<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfif url.memo eq "1">
				
		<tr>
			<td><cf_securediv bind="url:../memo/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#" id="imemo"></td>
		</tr>
	
	</cfif>
	
	<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Parameter
		WHERE  Identifier = 'A'
	</cfquery>
				
	<tr>	
	<td style="padding-left:20px; padding-right:20px">
	
	<cf_filelibraryN
		DocumentPath="Organization"
		SubDirectory="#URL.ID#" 
		Filter="#url.owner#"
		Insert="yes"
		Box="1"
		Remove="yes"
		ShowSize="yes">	

	</td>
	</tr>

</table>

