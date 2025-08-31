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
<cfquery name="validate" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	SELECT	*
		FROM	Ref_ModuleControlSection
		WHERE	SystemFunctionId = '#url.id#'
		AND		FunctionSection = '#form.functionSection#'
</cfquery>

<cfif url.section eq "">

	<cfif validate.recordCount eq 0>
	
		<cfquery name="insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 	INSERT INTO Ref_ModuleControlSection
					(
						SystemFunctionId,
						FunctionSection,
						SectionName,
						<cfif trim(form.sectionmemo) neq "">SectionMemo,</cfif>
						<cfif trim(form.sectionicon) neq "">SectionIcon,</cfif>
						SectionPresentation,
						ListingOrder,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.id#',
						'#form.functionSection#',
						'#evaluate("Form.SectionName_#client.languageId#")#',
						<cfif trim(form.sectionmemo) neq "">'#left(form.sectionMemo, 500)#',</cfif>
						<cfif trim(form.sectionicon) neq "">'#form.SectionIcon#',</cfif>
						'#form.sectionPresentation#',
						#form.listingOrder#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cf_LanguageInput
			TableCode       = "Ref_ModuleControlSection" 
			Key1Value       = "#url.id#"
			Key2Value       = "#form.functionSection#"
			Mode            = "Save"
			Name1           = "SectionName"	
			Operational     = "1">
	
		<cfoutput>
			<script>
				ColdFusion.navigate('#SESSION.root#/System/Modules/PortalBuilder/Section/FunctionSection.cfm?id=#url.id#', 'contentbox1');
				ColdFusion.Window.hide('mydialog');
			</script>
		</cfoutput>
	
	<cfelse>
	
		<script>
			alert('This code already exists!');
		</script>
	
	</cfif>
	
<cfelse>

	<cfif validate.recordCount gt 0 and form.functionSection neq url.section>
	
		<script>
			alert('This code already exists!');
		</script>
		
	<cfelse>
		<cfquery name="update" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 	UPDATE 	Ref_ModuleControlSection
				SET		FunctionSection 	= '#Form.FunctionSection#',
						SectionName 		= '#evaluate("Form.SectionName_#client.languageId#")#',
						SectionMemo			= <cfif trim(form.sectionMemo) neq "">'#left(form.sectionMemo, 500)#'<cfelse>null</cfif>,
						SectionIcon			= <cfif trim(form.sectionicon) neq "">'#form.SectionIcon#'<cfelse>null</cfif>,
						SectionPresentation = '#form.sectionPresentation#',
						ListingOrder		= #form.listingOrder#
				WHERE	SystemFunctionId 	= '#url.id#'
				AND		FunctionSection 	= '#url.section#'
		</cfquery>
		
		<cf_LanguageInput
			TableCode       = "Ref_ModuleControlSection" 
			Key1Value       = "#url.id#"
			Key2Value       = "#form.functionSection#"
			Mode            = "Save"
			Name1           = "SectionName"	
			Operational     = "1">

		<cfoutput>
			<script>
				ColdFusion.navigate('#SESSION.root#/System/Modules/PortalBuilder/Section/FunctionSection.cfm?id=#url.id#', 'contentbox1');
				ColdFusion.Window.hide('mydialog');
			</script>
		</cfoutput>
		
	</cfif>
	
</cfif>

