

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

