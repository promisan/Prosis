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
<!--- JavaScript program form calls (in Tools tag directory)--->

<cf_dialogREMProgram>

<cfparam name="URL.Layout" default="Program">

<!--- headers and necessary Params for expand/contract --->
<cfparam name="URL.Verbose" default="#CLIENT.Verbose#">
<cfset #CLIENT.Verbose# = #URL.Verbose#>
<cfset Caller = "AuditViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Auditid=#URL.AuditId#">

<table width="100%" border="0" cellspacing="0" align="center" cellpadding="0" bordercolor="#C0C0C0" rules="rows">
  <tr>
  <td>
  SOME INFO HERE
 </td>
 </tr>
</table> 

<table><tr><td height="2"></td></tr></table>

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Parameter
</cfquery>
	
