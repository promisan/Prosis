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


<cfquery name="Class" 
	datasource="#alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT O.*, 
		       (SELECT ServiceItem 
			    FROM   Ref_ActionServiceItem 
				WHERE  Code = '#url.code#' 
				AND    ServiceItem = O.Code) as Selected
	    FROM  ServiceItem O
		WHERE Code IN (SELECT ServiceItem 
		               FROM ServiceItemMission 
					   WHERE (Mission = '#url.mission#') 
					   AND    Operational = 1)
		AND  Operational = 1			   
		ORDER By O.ListingOrder
</cfquery>

<cfset col = 1>

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td bgcolor="e4e4e4" colspan="12"></td></tr>

	<cfoutput query="Class">
		<cfif col eq "1"><tr></cfif>
			<cfset col = col+1>
			<td>&nbsp;</td>
			<td><input type="checkbox" name="TopicClassValues" id="TopicClassValues" value="#Code#" <cfif selected neq "">checked</cfif>></td>
			<td width="65">#Code#</td>			
			<td>#Description#</td>
			<cfif col eq "4">
			<cfset col = 1>
			</tr>
			<tr><td bgcolor="e4e4e4" colspan="12"></td></tr>
		</cfif>
	</cfoutput>

</table>
