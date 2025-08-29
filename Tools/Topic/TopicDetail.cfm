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
<cfloop index="lk" from="1" to="5">

		<cfset link = "#link#&topictable#lk#=#evaluate('url.topictable#lk#')#&topictable#lk#name=#evaluate('url.topictable#lk#name')#">
		<cfset link = "#link#&topicscope#lk#=#evaluate('url.topicscope#lk#')#&topicfield#lk#=#evaluate('url.topicfield#lk#')#&topicscope#lk#table=#evaluate('url.topicscope#lk#table')#&topicscope#lk#field=#evaluate('url.topicscope#lk#field')#">

</cfloop>

<cfquery name="Topic" 
datasource="#alias#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM      Ref_Topic	
	WHERE 
	<cfif url.systemmodule eq "Roster">
	    Topic = '#url.code#'
	<cfelse>
		Code = '#url.code#'
	</cfif>
</cfquery>

<cfif Topic.ValueClass eq "List">
	<cfset cl = "regular">
<cfelse>
	<cfset cl = "hide">
</cfif>      

<table width="90%" align="center">
	
	<!--- class --->
	<tr>
	<td  width="100%" align="center"> 			
		<cfinclude template="TopicListingClass.cfm">
	</td>
	</tr>							
	
	
</table>