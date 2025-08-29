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
<cfquery name="getC"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	E.*,
				(SELECT Description FROM Ref_Category WHERE Category = E.Category) as CategoryDescription
	    FROM  	Ref_AssetEventCategory E
		WHERE	E.EventCode = '#url.id1#'
		AND		E.Category = '#url.category#'
</cfquery>


<cfif url.category eq "">
	<cf_screentop height="100%" 
	  scroll="Yes" 
	  html="Yes" 
	  label="Add Category" 
	  layout="webapp" 
	  banner="blue" 
	  menuAccess="Yes" 
	  user="no"
	  systemfunctionid="#url.idmenu#">
<cfelse>
	<cf_screentop height="100%" 
	  scroll="Yes" 
	  html="Yes" 
	  label="Edit Category" 
	  layout="webapp" 
	  banner="yellow"
	  menuAccess="Yes" 
	  user="no"
	  systemfunctionid="#url.idmenu#">
</cfif>

<cfform 
	action="RecordSubmitCat.cfm?id1=#url.id1#&category=#url.category#&idmenu=#url.idmenu#" 
	method="POST" 
	name="frmEventCat" 
	target="processEventCat">

	<table width="95%" align="center" class="formpadding formspacing">
		<tr><td height="10"></td></tr>
		<tr class="labelmedium">
			<td class="labelmedium" width="20%"><cf_tl id="Category">:</td>
			<td class="labelmedium">
				<cfif url.category eq "">
					
					<cfquery name="categories"
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT 	*
						    FROM  	Ref_Category
							WHERE 	Category NOT IN (SELECT Category FROM Ref_AssetEventCategory WHERE EventCode = '#url.id1#')
							ORDER BY Description
					</cfquery>
					
					<cfselect 
						name="category" 
						id="category" 
						query="categories" 
						value="category" 
						display="description" 
						class="regularxl"
						required="Yes" 
						message="Please, select a valid category.">
					</cfselect>
				<cfelse>
					<cfoutput>
						<b>#getC.CategoryDescription#</b>
						<input type="Hidden" id="category" name="category" value="#getC.Category#">
					</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr class="labelmedium">
			<td class="labelmedium"><cf_tl id="Issuance">:</td>
			<td class="labelmedium">
			    <table><tr>
				<td style="padding-left:0px"><input type="radio" class="radiol" name="ModeIssuance" id="ModeIssuance" <cfif getC.ModeIssuance eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:4px" class="labelmedium">Yes</td>
				<td style="padding-left:5px"><input type="radio" class="radiol" name="ModeIssuance" id="ModeIssuance" <cfif getC.ModeIssuance eq "0" or url.category eq "">checked</cfif> value="0"></td>
				<td style="padding-left:4px" class="labelmedium">No</td>
				</tr></table>
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td class="line" colspan="2"></td></tr>
		<tr><td height="5"></td></tr>
		<tr class="labelmedium">
			<td colspan="2" align="center">
				<table>
					<tr>
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

</cfform>

<table>
	<tr class="hide"><td colspan="2"><iframe name="processEventCat" id="processEventCat" frameborder="0"></iframe></td></tr>
</table>