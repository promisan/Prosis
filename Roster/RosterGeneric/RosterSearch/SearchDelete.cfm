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
 <cfquery name="Delete" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE FROM RosterSearch
	 WHERE SearchId = '#URL.ID#'	  
 </cfquery>
 
<HTML><HEAD>
    <TITLE>Result listing</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD>
 
<table width="100%">
<tr>
	<td align="center" style="padding-top:80px" class="labellarge">Archived Search has been removed from the system</td>
</tr>
<tr><td align="center" class="labelmedium">
	<font color="6688aa">Please start  a new search</font></a>
</td></tr>
</table>

