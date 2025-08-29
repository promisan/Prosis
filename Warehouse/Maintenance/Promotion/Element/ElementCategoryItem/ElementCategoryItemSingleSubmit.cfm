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
<cftry>

	<cfif url.action eq "insert">
	
		<cfquery name="Insert" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				INSERT INTO PromotionElementItem
					(
						ElementSerialNo,
						PromotionId,
						Category,
						CategoryItem,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.serial#',
						'#url.promotionId#',
						'#url.category#',
						'#url.categoryItem#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
	
	<cfelseif url.action eq "delete">
	
		<cfquery name="delete" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				DELETE
				FROM 	PromotionElementItem
				WHERE	PromotionId = '#url.promotionId#'
				AND		ElementSerialNo = '#url.serial#'
				AND		Category = '#url.category#'
				AND		CategoryItem = '#url.categoryItem#'
		</cfquery>
	
	</cfif>
	
	<cfset vText = "Saved">
	<cfset vColor = "71A6F4">
	
	<cfoutput>
	<script>
		parent.elementrefresh('#url.promotionid#')
	</script>
	</cfoutput>
	
	<cfcatch>
		<cfset vText = "Error trying to save.">
		<cfset vColor = "FF0000">
	</cfcatch>

</cftry>

<cfoutput>
	<table width="100%" align="center">
		<tr>
			<td align="center" style="color:#vColor#;">#vText#</td>
		</tr>
	</table>
</cfoutput>