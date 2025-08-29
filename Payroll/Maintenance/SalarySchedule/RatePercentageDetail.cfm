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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="350" cellspacing="0" cellpadding="0">

<cfparam name="url.mode" default="Month">

<cfoutput>

<cfif url.mode eq "Month">
	
	<tr>
	<td>Month</td>
	<td>Percentage</td>
	</tr>
	<cfloop index="mth" from="1" to="12">
	
		<tr>
		<td>#Mth#</td>
		<td>
		<input type="text" name="#Mth#_Percentage" size="6" maxlength="6">		
		</td>
		
		</tr>
		
	</cfloop>

</cfif>

</cfoutput>

</table>
