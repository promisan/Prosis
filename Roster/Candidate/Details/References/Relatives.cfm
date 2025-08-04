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

<cfquery name="Relatives" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*
    FROM ApplicantRelative A
    WHERE PersonNo = '#URL.ID#'
	ORDER BY Relationship
</cfquery>

<table border="0" 
      bordercolor="silver" 
	  cellpadding="0" 
	  cellspacing="0" 
	  width="100%" 
	  align="center">

<cfif Relatives.recordcount eq "0">

    <!---
	<tr>
	<td colspan="8" align="left">&nbsp;&nbsp;<cf_tl id="No relative information recorded"></b></td>
	</TR>
	--->

</cfif>

<cfoutput query="Relatives">

<tr>
	<td valign="top">&nbsp;#RelativeFirstName# #RelativeLastName#</td>
	<td colspan="2" valign="top" >#Organization#</td>
	<td valign="top">#Relationship#</td>
</tr>

<tr><td colspan="4" class="linedotted"></td></tr>

</cfoutput>
</table>

