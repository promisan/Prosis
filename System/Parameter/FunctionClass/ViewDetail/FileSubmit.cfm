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
<cfparam name="Form.Update" default="No">

<cfif #Form.Update# eq "No">
	<cfif #Form.FileName# neq "" >
		<cfquery name="InsertFile" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ClassFunctionTemplate(ClassFunctionId, PathName, FileName, TemplateFunction)
			VALUES('#Form.ClassID#','#Form.PathName#','#Form.FileName#','#trim(Form.TemplateFunction)#')
		</cfquery>
	</cfif>
<cfelse>	

	<cfif #Form.FileName# neq "" >
		<cfquery name="DeleteFile" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE from ClassFunctionTemplate
			where TemplateFunctionId = '#Form.TemplateFunctionId#'			
		</cfquery>
	
		<cfquery name="InsertFile" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ClassFunctionTemplate(ClassFunctionId, PathName, FileName, TemplateFunction)
			VALUES('#Form.ClassID#','#Form.PathName#','#Form.FileName#','#trim(Form.TemplateFunction)#')
		</cfquery>
		
		<cfset URL.PathName="">
		<cfset URL.FileName="">
	</cfif>



</cfif>


<cfoutput>
<script>
	#ajaxlink('#SESSION.root#/system/parameter/functionClass/ViewDetail/FunctionTemplate.cfm?id=#URL.ID#')#
</script>

</cfoutput>
	