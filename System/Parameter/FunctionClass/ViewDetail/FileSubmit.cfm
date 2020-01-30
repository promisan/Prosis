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
	