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
<cfquery name="get"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM  	Ref_AssetEvent	
		WHERE	Code = '#url.id1#'
</cfquery>

<cfquery name="validate"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	EventCode
	    FROM  	AssetItemEvent	
		WHERE	EventCode = '#url.id1#'
</cfquery>

<cfform action="RecordSubmit.cfm?id1=#url.id1#&idmenu=#url.idmenu#" method="POST" name="frmEvent">

	<cfoutput>
		<table width="100%" align="center" class="formpadding formspacing>
			<tr class="labelmedium">
				<td width="20%" class="labelmedium"><cf_tl id="Code">:</td>
				<td height="20" class="labelmedium">
					<cfif url.id1 eq "">
						<cfinput 
							type="Text" 
							name="code" 
							value="#get.code#" 
							required="Yes" 
							message="Please, enter a valid code." 
							maxlength="10" 
							class="regularxl"
							size="10">
					<cfelse>
						<b>#get.Code#</b>
						<input type="hidden" name="code" id="code" value="#get.Code#">
					</cfif>
				</td>
			</tr>
			<tr class="labelmedium">
				<td><cf_tl id="Description">:</td>
				<td>
					<cfinput 
						type="Text" 
						name="description" 
						value="#get.Description#" 
						required="Yes"
						class="regularxl"
						message="Please, enter a valid description." 
						maxlength="50" 
						size="20">
				</td>
			</tr>
			<tr class="labelmedium">
				<td><cf_tl id="Order">:</td>
				<td>
					<cfinput 
						type="Text" 
						name="listingOrder" 
						value="#get.listingOrder#" 
						required="Yes" 
						validate="integer" 
						message="Please, enter a valid numeric order." 
						maxlength="3" 
						class="regularxl"
						size="1" 
						style="text-align:center;">
				</td>
			</tr>
			<tr class="labelmedium">
				<td><cf_tl id="Operational">:</td>
				<td>
					<table>
						<tr class="labelmedium">
							<td valign="middle">
								<input type="radio" class="radiol" name="Operational" id="Operational" <cfif get.Operational eq "1" or url.id1 eq "">checked</cfif> value="1"> Yes
							</td>
							<td style="padding-left:8px;" valign="middle">
								<input type="radio" class="radiol" name="Operational" id="Operational" <cfif get.Operational eq "0">checked</cfif> value="0"> No
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td height="5"></td></tr>
			<tr><td class="line" colspan="2"></td></tr>
			<tr><td height="5"></td></tr>
			<tr>
				<td colspan="2" align="center">
					<table>
						<tr>
							<cfif url.id1 neq "" and validate.recordCount eq 0>
							<td>
								<cf_tl id="Delete" var="1">
								<cf_button 
									type		= "button"
									mode        = "silver"
									label       = "#lt_text#" 
									onclick		= "purgeEvent('#url.id1#');"
									id          = "delete"
									width       = "100px" 
									height      = "24"
									color       = "636334"
									fontsize    = "11px"> 
							</td>
							<td width="5"></td>
							</cfif>
							<td>
								<cf_tl id="Save" var="1">
								<cf_button 
									type		= "submit"
									mode        = "silver"
									label       = "#lt_text#" 
									id          = "save"
									width       = "100px" 
									height      = "24"
									color       = "636334"
									fontsize    = "11px"> 
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</cfoutput>

</cfform>