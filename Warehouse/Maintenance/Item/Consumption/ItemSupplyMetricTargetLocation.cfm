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
<cfquery name="getLookup" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT Description FROM Ref_LocationClass WHERE Code = L.LocationClass) as ClassDescription
	FROM 	Location L
	WHERE 	Mission = '#url.mission#'
	AND		StockLocation = 1
	ORDER BY LocationName
</cfquery>

<cfif getLookup.recordcount gt 0>

	<table width="100%">
		<tr>
			<td width="25%"><cf_tl id="Geographical Location">:</td>
			<td>
			
			<cfif url.action eq "new">
			<!-- <cfform> -->
			
			<cfselect 	name="Location" 
						value="location" 
						display="LocationName" 
						group="ClassDescription" 
						query="getLookup" 
						selected="#url.location#" queryposition="below">
						<option value=""></option>
			</cfselect>
			
			<!-- </cfform> -->
			
			<cfoutput>
			<input type="Hidden" name="LocationOld" id="LocationOld" value="#url.location#">	
			</cfoutput>	
			
			<cfelse>
				<cfoutput>				
				<input type="Hidden" name="Location" id="Location" value="#url.location#">	
				<input type="Hidden" name="LocationOld" id="LocationOld" value="#url.location#">	
				</cfoutput>
			</cfif>
			
			</td>
		</tr>
	</table>

<cfelse>

	<table class="hide">
		<tr>
			<td>
				<input type="Hidden" name="Location" id="location" value="">
				<input type="Hidden" name="LocationOld" id="LocationOld" value="">
			</td>
		</tr>
	</table>

</cfif>