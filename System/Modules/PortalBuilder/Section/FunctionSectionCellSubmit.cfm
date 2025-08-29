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
<cfset isDirty = 0>
<cfset errorMessage = "">

<cfif len(form.CellValueQuery) gt 1000>
	<cfset isDirty = 1>
	<cfset errorMessage = errorMessage & "Query field must be 1000 characters or less.  Actual length: " & len(form.CellValueQuery) & ".\n">
</cfif>

<cfif len(form.CellValueConditionQuery) gt 1000>
	<cfset isDirty = 1>
	<cfset errorMessage = errorMessage & "Condition Query field must be 1000 characters or less.  Actual length: " & len(form.CellValueConditionQuery) & ".\n">
</cfif>

<cfif len(form.CellValueQuery) gt 0>
	<cfif findNoCase(form.CellValueField, form.CellValueQuery) eq 0>
		<cfset isDirty = 1>
		<cfset errorMessage = errorMessage & "The alias " & form.CellValueField & " must exist as a field inside the query field.\n">
	</cfif>
</cfif>

<cfif trim(form.CellValueQuery) neq "">
	<cfif FindNoCase("@user",FORM.CellValueQuery) eq 0>
		<cftry>
			<cfset vQuery = Replace(REReplaceNoCase(form.CellValueQuery,"@[[:word:]]+","''","ALL"), "''''", "'00000000-0000-0000-0000-000000000000'", "ALL")>
			<cfset vQuery = REReplaceNoCase(vQuery,"##[[:word:]]+.[[:word:]]+##","","ALL")>
			<cfset vQuery = REReplaceNoCase(vQuery,"##[[:word:]]+##","","ALL")>
			<cfquery name="validateQuery"
				datasource="#form.CellValueDatasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					<cfoutput>
					#PreserveSingleQuotes(vQuery)#
					</cfoutput>
			</cfquery>
		
			<cfcatch>
				<cfset isDirty = 1>
				<cfset errorMessage = errorMessage & "The query field could not be validated. Please, check the datasource and the query entered.\n">
			</cfcatch>
		</cftry>
	</cfif>	
</cfif>

<cfif trim(form.CellValueConditionQuery) neq "">
		<cfif FindNoCase("@user",FORM.CellValueQuery) eq 0>	
			<cftry>
				<cfset vQuery = Replace(REReplaceNoCase(FORM.CellValueQuery,"@[[:word:]]+","''","ALL"), "''''", "'00000000-0000-0000-0000-000000000000'", "ALL")>
				<cfset vQuery = REReplaceNoCase(vQuery,"##[[:word:]]+.[[:word:]]+##","","ALL")>
				<cfset vQuery = REReplaceNoCase(vQuery,"##[[:word:]]+##","","ALL")>
				<cfquery name="validateQuery"
					datasource="#form.CellValueDatasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						<cfoutput>
						#PreserveSingleQuotes(vQuery)#
						</cfoutput>
				</cfquery>
		
				<cfcatch>
					<cfset isDirty = 1>
					<cfset errorMessage = errorMessage & "The condition field could not be validated. Please, check the datasource and the query entered.\n">
				</cfcatch>
			</cftry>
		</cfif>				
</cfif>

<cfif isDirty eq 0>

	<cfquery name="validate" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 	SELECT	*
			FROM	Ref_ModuleControlSectionCell
			WHERE	SystemFunctionId = '#url.id#'
			AND		FunctionSection = '#url.section#'
			AND		CellCode = '#form.cellCode#'
	</cfquery>

	<cfif url.code eq "">
	
		<cfif validate.recordcount eq 0>
		
			<cfquery name="insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	INSERT INTO Ref_ModuleControlSectionCell
						(
							SystemFunctionId,
							FunctionSection,
							CellCode,
							CellLabel,
							<cfif trim(form.CellTooltip) neq "">CellTooltip,</cfif>
							CellValueDatasource,
							<cfif trim(form.CellValueQuery) neq "">CellValueQuery,</cfif>
							<cfif trim(form.CellValueConditionQuery) neq "">CellValueConditionQuery,</cfif>
							CellValueField,
							CellValueFormat,
							CellArray,
							<cfif trim(form.CellCodeField) neq "">CellCodeField,</cfif>
							<cfif trim(form.CellDescriptionField) neq "">CellDescriptionField,</cfif>
							<cfif trim(form.CellOrderField) neq "">CellOrderField,</cfif>
							<cfif trim(form.DetailTemplate) neq "">DetailTemplate,</cfif>
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#url.id#',
							'#url.section#',
							'#form.cellCode#',
							'#evaluate("Form.CellLabel_#client.languageId#")#',
							<cfif trim(form.CellTooltip) neq "">'#form.CellTooltip#',</cfif>
							'#form.CellValueDatasource#',
							<cfif trim(form.CellValueQuery) neq "">'#form.CellValueQuery#',</cfif>
							<cfif trim(form.CellValueConditionQuery) neq "">'#form.CellValueConditionQuery#',</cfif>
							'#form.CellValueField#',
							'#form.CellValueFormat#',
							'#form.CellArray#',
							<cfif trim(form.CellCodeField) neq "">'#form.CellCodeField#',</cfif>
							<cfif trim(form.CellDescriptionField) neq "">'#form.CellDescriptionField#',</cfif>
							<cfif trim(form.CellOrderField) neq "">'#form.CellOrderField#',</cfif>
							<cfif trim(form.DetailTemplate) neq "">'#form.DetailTemplate#',</cfif>
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
			
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControlSectionCell" 
				Key1Value       = "#url.id#"
				Key2Value       = "#url.section#"
				Key3Value       = "#form.cellCode#"
				Mode            = "Save"
				Name1           = "CellLabel"	
				Operational     = "1">
		
			<cfoutput>
				<script>
					parent.window.close();
					parent.opener.ColdFusion.navigate('Section/FunctionSectionCell.cfm?id=#url.id#&section=#url.section#', 'divCellListing');
				</script>
			</cfoutput>
		
		<cfelse>
		
			<script>
				alert('This code already exists!');
			</script>
		
		</cfif>
	
	<cfelse>
	
		<cfif validate.recordCount gt 0 and form.cellCode neq url.code>
	
			<script>
				alert('This code already exists!');
			</script>
			
		<cfelse>
		
			<cfquery name="validate" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 	UPDATE	Ref_ModuleControlSectionCell
					SET		CellCode 					= '#form.cellCode#',
							CellLabel 					= '#evaluate("Form.CellLabel_#client.languageId#")#',
							CellTooltip					= <cfif trim(form.CellTooltip) neq "">'#form.CellTooltip#'<cfelse>null</cfif>,
							CellValueDatasource 		= '#form.CellValueDatasource#',
							CellValueQuery  			= <cfif trim(form.CellValueQuery) neq "">'#form.CellValueQuery#'<cfelse>null</cfif>,
							CellValueConditionQuery 	= <cfif trim(form.CellValueConditionQuery) neq "">'#form.CellValueConditionQuery#'<cfelse>null</cfif>,
							DetailTemplate				= <cfif trim(form.DetailTemplate) neq "">'#form.DetailTemplate#'<cfelse>null</cfif>,
							CellCodeField				= <cfif trim(form.CellCodeField) neq "">'#form.CellCodeField#'<cfelse>null</cfif>,
							CellDescriptionField		= <cfif trim(form.CellDescriptionField) neq "">'#form.CellDescriptionField#'<cfelse>null</cfif>,
							CellOrderField				= <cfif trim(form.CellOrderField) neq "">'#form.CellOrderField#'<cfelse>null</cfif>,
							CellValueField				= '#form.CellValueField#',
							CellValueFormat				= '#form.CellValueFormat#',
							CellArray				    = '#form.CellArray#'
					WHERE	SystemFunctionId 			= '#url.id#'
					AND		FunctionSection 			= '#url.section#'
					AND		CellCode 					= '#url.code#'
			</cfquery>
			
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControlSectionCell" 
				Key1Value       = "#url.id#"
				Key2Value       = "#url.section#"
				Key3Value       = "#form.cellCode#"
				Mode            = "Save"
				Name1           = "CellLabel"	
				Operational     = "1">
		
			<cfoutput>
				<script>
					parent.window.close();
					parent.opener.ColdFusion.navigate('Section/FunctionSectionCell.cfm?id=#url.id#&section=#url.section#', 'divCellListing');
				</script>
			</cfoutput>
			
		</cfif>
	
	</cfif>
	
<cfelse>
	
	<cfoutput>
		<script>
			alert('#errorMessage#');
		</script>
	</cfoutput>

</cfif>