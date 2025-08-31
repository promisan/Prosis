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
<cfif trim(url.orgunit) neq "">

	<cfquery name="Org"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	* 
			FROM  	Organization 
			WHERE  	OrgUnit = '#url.orgunit#'
	</cfquery>           

	<cfoutput>
		<table>
			<tr>
				<td>
					<img src="#SESSION.root#/Images/search.png" alt="Select Implementer" name="img66" 
						onMouseOver="document.img66.src='#SESSION.root#/Images/search1.png'" 
						onMouseOut="document.img66.src='#SESSION.root#/Images/search.png'"
						style="cursor: pointer;border:1px solid black;border-radius:4px;" alt="" width="25" height="23" border="0" align="absmiddle" 
						onClick="selectorgN('#url.mission#','Administrative','orgunit1_#mission#','setOrgUnit','#url.mission#','1','modal')">
				</td>
				<td style="padding-left:5px;">
					<input 
						type="text"   
						name="orgunitname1_#mission#"  
						id="orgunitname1_#mission#" 
						class="regularxl orgunit" 
						value="#Org.OrgUnitName#" 
						style="width:300px;"
						data-value="#mission#" 
						readonly>
					<input type="hidden" name="orgunit1_#mission#" id="orgunit1_#mission#"  value="#Org.OrgUnit#">
				</td>
			</tr>
		</table>
	</cfoutput>

</cfif>