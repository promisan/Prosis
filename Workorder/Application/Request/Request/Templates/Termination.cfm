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
<cfquery name="LinePersonal" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT RW.ValueTo 
     FROM   RequestWorkorderDetail RW
	 <cfif url.requestid neq ""> 
	 WHERE  RW.Requestid       = '#url.requestid#'
	 <cfelse>
	 WHERE 1=0
	 </cfif>
	 AND    Amendment          = 'Personal'			
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
	
	<td><cf_space spaces="40"><font color="808080">Personal Usage:</td>
	
	<td width="90%" style="padding-left:1px">
	<cfif url.Accessmode eq "Edit">
	<table cellspacing="0" cellpadding="0">
	<tr>
		<td><input type="radio" name="PersonalTo" id="PersonalTo" value="Y" <cfif LinePersonal.ValueTo eq "Y">checked</cfif>></td><td>YES</td>
		<td>&nbsp;</td>
		<td><input type="radio" name="PersonalTo" id="PersonalTo" value="N" <cfif LinePersonal.ValueTo neq "Y">checked</cfif>></td><td>NO</td>
	</tr>
	</table>
	<cfelse>
	<cfoutput>
	#LinePersonal.ValueTo#
	</cfoutput>
	</cfif>
	</td>

</tr>
</table>