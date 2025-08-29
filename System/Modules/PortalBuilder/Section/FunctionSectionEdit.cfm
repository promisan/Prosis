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
<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">

<cfquery name="get"
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM
	<cfif client.lanPrefix neq "">
		#CLIENT.LanPrefix#Ref_ModuleControlSection
	<cfelse>
		xl#client.languageId#_Ref_ModuleControlSection
	</cfif>
	WHERE	SystemFunctionId = '#url.id#'
	AND		FunctionSection = '#url.section#'
</cfquery>

<cfif url.section neq "">
	<cfset vFunctionId = get.SystemFunctionId>
</cfif>


<cfif url.section eq "">

	<cf_screentop 
		 height="100%"
	     scroll="Yes" 
		 html="Yes" 
		 label="Function Section"
		 option="Add Section"	 
		 layout="webapp" 
		 banner="blue"
		 jquery="yes"
		 user="no">

<cfelse>

	<cf_screentop 
		 height="100%"
	     scroll="Yes" 
		 html="Yes" 
		 label="Function Section"
		 option="Maintain Section"	 
		 layout="webapp" 
		 banner="yellow"
		 jquery="yes"
		 user="no">
		 
</cfif>

<table>
	<tr class="hide"><td><iframe name="processSection" id="processSection" frameborder="0"></iframe></td></tr>
</table>

<cfform name="frmSection" action="Section/FunctionSectionSubmit.cfm?id=#url.id#&section=#url.section#" method="POST" target="processSection">	
	
<table width="90%" align="center" class="formpadding">
	<tr><td height="15"></td></tr>
	<tr class="labelmedium">
		<td width="15%">Code:</td>
		<td colspan="2">
			<cfinput type="Text" 
				name="FunctionSection" 
				required="Yes" 
				message="Please, enter a valid code."
			   	class="regularxl"
			   	size="10"
				value="#get.FunctionSection#"
			   	maxlength="10">
		</td>
	</tr>
	<tr class="labelmedium">
		<td valign="top">Name:</td>
		<td colspan="2">
			<table width="100%" align="center">						
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControlSection" 
				Mode            = "Edit"
				Name            = "SectionName"
				Key1Value       = "#vFunctionId#"
				Key2Value       = "#get.functionSection#"
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please, enter a valid name."
				MaxLength       = "50"
				Size            = "50"
				Class           = "regularxl"
				Operational     = "1"
				Label           = "Yes">
			</table>
		</td>
	</tr>
	<tr class="labelmedium">
		<td valign="top" style="padding-top:2px;">Memo:</td>
		<td valign="top" style="padding-top:2px;">
			<textarea type="Text" 
				name="SectionMemo" 
			   	class="regularxl" 
				cols="75" 
				rows="5" 
				style="border:1px solid #C0C0C0;"
			   	maxlength="500"><cfoutput>#get.sectionMemo#</cfoutput></textarea>
		</td>
	</tr>
	<tr class="labelmedium">
		<td>Icon Class:</td>
		<td>
			<cfinput type="Text" 
				name="SectionIcon" 
				required="no"
				message="Please, enter a valid icon class." 
			   	class="regularxl"
			   	size="35"
				value="#get.sectionicon#"
			   	maxlength="50">
		</td>
	</tr>
	<tr class="labelmedium" style="display:none;">
		<td>Presentation:</td>
		<td colspan="2">
			<select name="SectionPresentation" id="SectionPresentation" class="regularxl">			
				<option value="Line" <cfif get.SectionPresentation eq "Line">selected</cfif>>Line</option>
			</select>
		</td>
	</tr>
	<tr class="labelmedium">
		<td>Order:</td>
		<td colspan="2">
			<cfinput type="Text" 
				name="ListingOrder" 
				required="Yes"
				message="Please, enter a valid numeric order." 
			   	class="regularxl"
			   	size="1" 
				maxlength="3" 
				validate="integer"
				value="#get.listingOrder#" 
				style="text-align:center;">
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td class="linedotted" colspan="3"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="3" align="center">
			<cfoutput>
			<input type="Submit" class="button10g" name="save" id="save" value="  Save  ">			
			</cfoutput>
		</td>
	</tr>
	
	
	<cfif url.section neq "">
	<tr><td height="15"></td></tr>
	<tr><td class="linedotted" colspan="3"></td></tr>
	<tr>
		<td colspan="3" height="30" valign="middle" class="labellarge">Meta Info Cells</td>
	</tr>
	<tr><td class="linedotted" colspan="3"></td></tr>
	<tr>
		<td colspan="3">
			<cfdiv id="divCellListing" bind="url:Section/FunctionSectionCell.cfm?id=#url.id#&section=#url.section#"> 
		</td>
	</tr>
	</cfif>
	
</table>

</cfform>