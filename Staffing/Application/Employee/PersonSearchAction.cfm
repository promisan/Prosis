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

<cfquery name="SearchResult" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT      OO.ObjectId,
	            OO.PersonNo, 
	            OO.EntityCode, 
				R.EntityDescription, 
				OO.ObjectURL, 
				OO.Mission, 
				OO.ObjectReference, 
				OO.ObjectReference2,
				OO.OfficerUserId,
				OO.OfficerLastName,
				OO.OfficerFirstName,
				OO.Created
				
	FROM        OrganizationObject AS OO INNER JOIN
	            Ref_Entity R ON OO.EntityCode = R.EntityCode
	WHERE       OO.PersonNo = '#url.personno#'
	<cfif url.mission neq "">
	AND         OO.Mission     = '#url.mission#'
	</cfif>
	AND         EXISTS (SELECT 'X'
	                    FROM  OrganizationObjectAction
						WHERE ObjectId = OO.ObjectId
						AND   ActionStatus = '0') <!--- has one or more unprocessed steps --->
	AND         OO.Operational = 1 	<!--- is an active workflow --->
	ORDER BY OO.Created

</cfquery>

<table style="width:100%" class="navigation_table">
	
	<cfoutput query="SearchResult">
		<tr class="navigation_row line labelmedium">
		    <td align="right" style="padding-top:2px;min-width:20;padding-right:3px">
			<cf_img icon="select" onclick="ptoken.open('#SESSION.root#/ActionView.cfm?id=#ObjectId#')">
			</td>
			<td style="min-width:200px;padding-left:15px">#EntityDescription#</td>			
			<td style="min-width:100px">#dateformat(Created,client.dateformatshow)#</td>
			<td style="width:90%">#OfficerLastName# : #ObjectReference#</td>	
		</tr>
	</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>
