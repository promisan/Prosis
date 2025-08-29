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
<cfparam name="url.mission"   default="">
<cfparam name="url.usergroup" default="">

<cfquery name="Function" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *, (SELECT count(*) 
	            FROM   MissionProfileGroup 
			    WHERE  ProfileId       = M.ProfileId 			   
			    AND    AccountGroup     = '#url.usergroup#') as Counted
    FROM     MissionProfile M
	WHERE    Mission = '#url.mission#'
	AND      Operational = 1
	ORDER BY ListingOrder	
</cfquery>

<cfif function.recordcount eq "0">

<cfoutput>
<table><tr class="labelmedium"><td>No functions set for #url.mission#</td></tr></table>
</cfoutput>

<cfelse>

<cfset cnt = 0>

<table style="width:100%;background-color:f1f1f1">

<tr><td style="height:3px"></td></tr>

<cfoutput query="Function">
	<cfset cnt = cnt + 1>
    
	<cfif cnt eq "1">
	  <tr class="labelmedium2" style="height:18px">
	</cfif>
	<td style="padding-left:6px;padding-right:2px">
	    <input type="checkbox" class="radiol" name="functionselect" <cfif counted gte "1">checked</cfif> value="#ProfileId#">
	</td>
	<td style="padding-right:2px;width:30%">#FunctionName#</td>	 
	<cfif cnt eq "3">
	    <cfset cnt = 0></tr>
	</cfif>
	
</cfoutput>

  </tr>
  <tr><td style="height:3px"></td></tr>

</table>

</cfif>

