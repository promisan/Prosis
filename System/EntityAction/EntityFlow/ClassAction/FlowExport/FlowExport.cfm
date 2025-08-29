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
<cfparam name="url.entityCode" 			default="">
<cfparam name="url.sourceDatabase" 		default="Organization">
<cfparam name="url.destinationDatabase"	default="Organization">
<cfparam name="url.breakline"			default="<br>">

<cf_screentop height="100%" 
			  scroll="yes" 
			  layout="webapp" 
			  banner="blue" 
			  label="Workflow Export" 
			  JQuery="yes"
			  line="yes">

<cfoutput>
	<script>
		function generateScript() {
			var vEntity = $('##entity').val();
			var vUnderscored = $('input[name=underscored]:checked').val();
			var vLanguages = '';
			var cnt = 0;
			$('.clsLang').each(function(){
				var vComma = ',';
				if (cnt == 0) {
					vComma = '';
				}
				if ($(this).is(':checked')) {
					vLanguages = vLanguages + vComma + $(this).val();
					cnt = cnt + 1;
				}
			});

			ColdFusion.navigate('FlowExportDetail.cfm?sourceDatabase=#url.sourceDatabase#&destinationDatabase=#url.destinationDatabase#&breakline=#url.breakline#&entity='+vEntity+'&underscored='+vUnderscored+'&lang='+vLanguages, 'divExportDetail');
		}
	</script>
</cfoutput>

<cfquery name="getEntities" 
	datasource="AppsOrganization">
		SELECT 	*
		FROM 	Ref_Entity
		WHERE 	1=1
		<cfif url.entityCode neq "">
			AND EntityCode = '#url.entityCode#'
		</cfif>
		ORDER BY EntityDescription ASC
</cfquery>

<cfquery name="getLanguages" 
	datasource="AppsOrganization">
		SELECT  *
		FROM 	System.dbo.Ref_SystemLanguage
		ORDER BY SystemDefault DESC
</cfquery>

<table width="98%" height="100%" align="center" class="formpadding">
	<tr><td height="10"></td></tr>
	<tr>
		<td width="400px" class="labellarge"><cf_tl id="Entity">:</td>
		<td class="labellarge">
			<cfif url.entityCode neq "">
				<cfoutput>
					<b>#getEntities.EntityDescription# [#getEntities.EntityCode#]</b>
					<input type="hidden" name="entity" id="entity" value="#getEntities.EntityCode#">
				</cfoutput>
			<cfelse>
				<select name="entity" id="entity" class="regularxl">
					<cfoutput query="getEntities">
						<option value="#EntityCode#">#EntityDescription# [#EntityCode#]</option>
					</cfoutput>
				</select>
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="labellarge" valign="top" style="padding-top:3px;"><cf_tl id="Allowed Languages"> (<cf_tl id="If defined">) :</td>
		<td valign="top" style="padding-top:3px;">
			<table>
				<cfoutput query="getLanguages">
					<tr>
						<td class="labellarge">
							<input 
								type="checkbox" 
								name="langid_#Code#" 
								id="langid_#Code#" 
								class="clsLang" 
								value="#Code#" 
								<cfif operational neq '0'>checked="checked"</cfif>> 
							<label for="langid_#Code#">#Code# - #LanguageName#</label>
						</td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
	<tr>
		<td width="15%" class="labellarge"><cf_tl id="Include underscored (_) fields"> ? :</td>
		<td>
			<cfoutput>
				<table>
					<tr>
						<td class="labellarge">
							<cf_tl id="Yes" var="1">
							<input type="radio" name="underscored" id="underscored_1" value="1"> <label for="underscored_1">#lt_text#</label>
						</td>
						<td style="padding-left:10px;" class="labellarge">
							<cf_tl id="No" var="1">
							<input type="radio" name="underscored" id="underscored_0" value="0" checked="checked"> <label for="underscored_0">#lt_text#</label>
						</td>
					</tr>
				</table>
			</cfoutput>
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td class="line" colspan="2"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2" align="center">
			<cfoutput>
				<table align="center">
					<tr>
						<td>
							<cf_tl id="Generate Script" var="1">
							<input type="button" name="btnGenerate" id="btnGenerate" class="button10s" style="width:200px;" value="#lt_text#">	
						</td>
						<td style="padding-left:20px;">
							<cf_tl id="Copy to Clipboard" var="1">
							<input type="button" id="btnCopyToClipboard" class="button10s" style="width:200px;" value="#lt_text#">	
						</td>
					</tr>
				</table>
			</cfoutput>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="2" style="background-color:#E8E8E8; padding:10px;" height="100%">
			<cf_divScroll height="100%">
				<cfdiv style="height:100%;" id="divExportDetail">
			</cf_divScroll>
		</td>
	</tr>
</table>

<script>
	//set copy to clipboard button
	$('#btnCopyToClipboard').on('click', function(){
		//select text
		var text = document.getElementById('divExportDetail');
	    var selection = window.getSelection();
	    var range = document.createRange();
	    range.selectNodeContents(text);
	    selection.removeAllRanges();
	    selection.addRange(range);

	    //add to clipboard.
	    document.execCommand('copy');

	    //inform
		Prosis.alert("Script for exporting workflow has been moved into your clipboard.");
	});

	//set generate script button
	$('#btnGenerate').on('click', function(){
		generateScript();
	});

	//first script generation
	generateScript();
</script>