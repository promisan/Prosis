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
<cfoutput>

<cfset pages   = Ceiling(counted/#CLIENT.PageRecords#)>
<cfif  pages lt "1">
	   <cfset pages = '1'>
</cfif>

<table width="100%" align="right">

<tr>
	<td>
	<!---  &nbsp;<b>#Counted#</b> results in #info.time# milliseconds--->

	</td>
	<td align="right">
	<cfif pages gt "1">
		 <cf_pagenavigation cpage="#url.page#" pages="#pages#">
	</cfif>	 
	</td>
</tr>
							
</table>	
</cfoutput>						