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
<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">

<cfquery name="get"
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM
	<cfif client.lanPrefix neq "">
		#CLIENT.LanPrefix#Ref_ModuleControlSectionCell
	<cfelse>
		xl#client.languageId#_Ref_ModuleControlSectionCell
	</cfif>
	WHERE	SystemFunctionId = '#url.id#'
	AND		FunctionSection = '#url.section#'
	AND		CellCode = '#url.code#'
</cfquery>

<cfif url.code neq "">
	<cfset vFunctionId = get.SystemFunctionId>
</cfif>

<cfif url.code eq "">

	<cf_screentop 
		 height="100%"
	     scroll="Yes" 
		 html="Yes" 
		 label="Function Section Cells"
		 option="Add Section Cell"	 
		 layout="webapp" 
		 banner="blue"
		 jquery="yes"
		 user="no">

<cfelse>

	<cf_screentop 
		 height="100%"
	     scroll="Yes" 
		 html="Yes" 
		 label="Function Section Cells"
		 option="Maintain Section Cell"	 
		 layout="webapp" 
		 banner="yellow"
		 jquery="yes"
		 user="no">
		 
</cfif>

<script>
	function validateCellFileFields() {	
		var controlToValidate = document.getElementById('DetailTemplate');	 
					
		controlToValidate.focus(); 
		controlToValidate.blur(); 
		
		if (controlToValidate.value != "")
		{
			if (document.getElementById('validateCellPath').value == 0) 
			{ 
				alert('[' + controlToValidate.value + '] not validated!');
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return true;
		}		
	}
	
	function toggleArray(value){
		document.getElementById('trCodeField').className = 'regular';
		document.getElementById('trDescriptionField').className = 'regular';
		document.getElementById('trOrderField').className = 'regular';
			
		if (value == 0) {
			document.getElementById('trCodeField').className = 'hide';
			document.getElementById('trDescriptionField').className = 'hide';
			document.getElementById('trOrderField').className = 'hide';
		}
	}
</script>

<table>
	<tr class="hide"><td><iframe name="processSectionCell" id="processSectionCell" frameborder="0"></iframe></td></tr>
</table>

<cfform name="frmSectionCell" action="FunctionSectionCellSubmit.cfm?id=#url.id#&section=#url.section#&code=#url.code#" method="POST" target="processSectionCell">	
	
<table width="90%" align="center" cellspacing="0" class="formpadding">
	<tr><td height="5"></td></tr>
	<tr>
		<td width="20%" class="labelmedium">Code:</td>
		<td colspan="2">
			<cfinput type="Text" 
				name="CellCode" 
				required="Yes" 
				message="Please, enter a valid code."
			   	class="regularxxl"
			   	size="10"
				value="#get.CellCode#"
			   	maxlength="10">
		</td>
	</tr>
	<tr>
		<td valign="top" class="labelmedium">Label:</td>
		<td colspan="2">
			<table width="100%" align="center">						
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControlSectionCell" 
				Mode            = "Edit"
				Name            = "CellLabel"
				Key1Value       = "#vFunctionId#"
				Key2Value       = "#get.functionSection#"
				Key3Value       = "#get.cellCode#"
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please, enter a valid label."
				MaxLength       = "150"
				Size            = "50"
				Class           = "regularxxl"
				Operational     = "1"
				Label           = "Yes">
			</table>
		</td>
	</tr>
	<tr style="display:none;">
		<td class="labelmedium">Tooltip:</td>
		<td colspan="2">
			<cfinput type="Text" 
				name="CellTooltip" 
				required="no"
				message="Please, enter a valid tooltip." 
			   	class="regularxxl"
			   	size="68"
				value="#get.CellTooltip#"
			   	maxlength="200">
		</td>
	</tr>
	<tr>
		<td class="labelmedium">Datasource:</td>
		<td colspan="2">						
			<cfobject action="create"
				type="java"
				class="coldfusion.server.ServiceFactory"
				name="factory">
			<!--- Get datasource service --->
			<cfset dsService=factory.getDataSourceService()>		
			<cfset dsNames = dsService.getNames()>
			<cfset ArraySort(dsnames, "textnocase")> 
						
			<select name="CellValueDatasource" id="CellValueDatasource" class="regularxxl">						
				<cfloop index="i" from="1" to="#ArrayLen(dsNames)#">
					<cfoutput>
						<option value="#dsNames[i]#" <cfif get.CellValueDatasource eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
					</cfoutput>
				</cfloop>						
			</select>
		</td>
	</tr>
	<tr>
		<td class="labelmedium">Field:</td>
		<td colspan="2">
			<cfset vDefaultField = "CellResult">
			<cfif trim(get.CellValueField) neq "">
				<cfset vDefaultField = trim(get.CellValueField)>
			</cfif>
			<cfinput type="Text" 
				name="CellValueField" 
				required="yes"
				message="Please, enter a valid field." 
			   	class="regularxxl"
			   	size="20"
				value="#vDefaultField#"
			   	maxlength="30">
		</td>
	</tr>
	<tr>
		<td class="labelmedium">Format:</td>
		<td colspan="2">
			<select name="CellValueFormat" id="CellValueFormat" class="regularxxl">			
				<option value="Number" <cfif get.CellValueFormat eq "Number">selected</cfif>>Number</option>
				<option value="Currency" <cfif get.CellValueFormat eq "Currency">selected</cfif>>Currency</option>
				<option value="Text" <cfif get.CellValueFormat eq "Text">selected</cfif>>Text</option>
			</select>
		</td>
	</tr>
	<tr style="display:none;">
		<td class="labelmedium">Array:</td>
		<td colspan="2" class="labelmedium">
			<input type="radio" name="CellArray" id="CellArray" class="radiol" value="0" onclick="javascript: toggleArray(0);" <cfif get.CellArray eq "0" or url.code eq "">checked</cfif>>No
			<input type="radio" name="CellArray" id="CellArray" class="radiol" value="1" onclick="javascript: toggleArray(1);" <cfif get.CellArray eq "1">checked</cfif>>Yes				
		</td>
	</tr>
	<cfset vArrayClass = "regular">
	<cfif get.CellArray eq 0 or url.code eq "">
		<cfset vArrayClass = "hide">
	</cfif>
	<tr id="trCodeField" class="<cfoutput>#vArrayClass#</cfoutput>">
		<td class="labelmedium"><font color="002350">Code Field:</font></td>
		<td colspan="2">
			<cfinput type="Text" 
				name="CellCodeField" 
				required="no"
				message="Please, enter a valid code field." 
			   	class="regularxxl"
			   	size="20"
				value="#get.CellCodeField#"
			   	maxlength="30">
		</td>
	</tr>
	<tr id="trDescriptionField" class="<cfoutput>#vArrayClass#</cfoutput>">
		<td class="labelmedium"><font color="002350">Description Field:</font></td>
		<td colspan="2">
			<cfinput type="Text" 
				name="CellDescriptionField" 
				required="no"
				message="Please, enter a valid description field." 
			   	class="regularxxl"
			   	size="20"
				value="#get.CellDescriptionField#"
			   	maxlength="30">
		</td>
	</tr>
	<tr id="trOrderField" class="<cfoutput>#vArrayClass#</cfoutput>">
		<td class="labelmedium"><font color="002350">Order Field:</font></td>
		<td colspan="2">
			<cfinput type="Text" 
				name="CellOrderField" 
				required="no"
				message="Please, enter a valid order field." 
			   	class="regularxxl"
			   	size="20"
				value="#get.CellOrderField#"
			   	maxlength="30">
		</td>
	</tr>
	<tr>
		<td valign="top" class="labelmedium">
			<cf_UIToolTip tooltip="This query must contain the same field entered above as an alias.<br>Example: SELECT COUNT(*) AS CellResult FROM ExampleTable">
				Query:
			</cf_UIToolTip>
		</td>
		<td colspan="2" class="labelmedium">
			<cfoutput>
				<textarea name="CellValueQuery" cols="70" rows="6" class="regularxxl" style="border:1px solid ##C0C0C0;">#get.CellValueQuery#</textarea>
			</cfoutput>
			<br>
			@id, @mission, @user, @today : are valid operators
		</td>
	</tr>
	<tr style="display:none;">
		<td valign="top" class="labelmedium">Condition:</td>
		<td colspan="2" class="labelmedium">
			<cfoutput>
				<textarea name="CellValueConditionQuery" cols="70" rows="6" class="regularxxl" style="border:1px solid ##C0C0C0;">#get.CellValueConditionQuery#</textarea>
			</cfoutput>
		</td>
	</tr>
	<tr style="display:none;">
		<td class="labelmedium">Detail Template:</td>
		<td class="labelmedium">
			<cfoutput>#SESSION.root#/</cfoutput>
			<cfinput type="Text" 
				name="DetailTemplate" 
				required="no"
				message="Please, enter a valid detail template." 
			   	class="regularxl"
			   	size="35"
				value="#get.DetailTemplate#"
				onblur= "ptoken.navigate('FileValidation.cfm?template='+this.value+'&container=pathCellValidationDiv&resultField=validateCellPath','pathCellValidationDiv')"
			   	maxlength="100">
		</td>
		<td valign="middle" align="left" width="25%">
		 	<cf_securediv id="pathCellValidationDiv"
			   bind="url:FileValidation.cfm?template=#get.DetailTemplate#&container=pathCellValidationDiv&resultField=validateCellPath">				
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td colspan="3" class="linedotted"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="3" align="center">
			<!--- onclick="return validateCellFileFields();" --->
			<cfoutput>
			<input type="Submit" class="button10g" name="save" id="save" value="Save">			
			</cfoutput>
		</td>
	</tr>
	
</table>

</cfform>