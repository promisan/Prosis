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


<cfif #Form.Update# eq "No">

	<cfquery name="Check" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		Select * 
		from ClassFunctionAttribute
		where ClassFunctionId='#url.ID#' and
		Attribute='#Form.AttrName#'
	</cfquery>

	<cfif Check.recordcount eq "0">
		<cfif #Form.AttrName# neq "" >
			<cfquery name="InsertFile" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ClassFunctionAttribute(ClassFunctionId, Attribute, Format, Required,DefaultValue,Description)
				VALUES('#url.ID#','#Form.AttrName#','#Form.Format#','#Form.Required#','#Form.DefaultValue#','#trim(Form.Description)#')
			</cfquery>
		</cfif>
	<cfelse>
		<script>
			alert('Error, an attribute has already been defined under that name')
		</script>		
	</cfif>		
<cfelse>	
	<cfif #Form.AttrName# neq "" >
		<cfquery name="DeleteFile" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE from ClassFunctionAttribute
			where ClassFunctionId='#url.ID#'
			and Attribute='#Form.AttrOld#'
		</cfquery>
		
		<cfquery name="Check" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			Select * 
			from ClassFunctionAttribute
			where ClassFunctionId='#url.ID#' and
			Attribute='#Form.AttrName#'
		</cfquery>		
		<cfif Check.recordcount eq "0">
			<cfquery name="InsertFile" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ClassFunctionAttribute(ClassFunctionId, Attribute, Format, Required,DefaultValue,Description)
				VALUES('#url.ID#','#Form.AttrName#','#Form.Format#','#Form.Required#','#Form.DefaultValue#','#trim(Form.Description)#')
			</cfquery>
		<cfelse>
			<script>
				alert('Error, an attribute has already been defined under that name')
			</script>		
		</cfif>		
		
		<cfset URL.AttrName="">
	</cfif>



</cfif>



<cfoutput>
<script>
	ColdFusion.Window.hide('attributedialog')	
	ColdFusion.navigate('#SESSION.root#/system/parameter/functionClass/ViewDetail/UseCaseSelectAttr.cfm?id=#URL.ID#','Attributes')	
</script>	
</cfoutput>

