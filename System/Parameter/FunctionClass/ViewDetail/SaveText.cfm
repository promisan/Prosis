<cfquery name="CHECK" 
     datasource="AppsControl" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 Select * from ClassFunctionElement
	 WHERE ClassFunctionId = '#Url.id#'
	 and ElementCode='#url.ElementCode#' 
</cfquery>

		<cfset txt = evaluate("Form.T_#ElementCode#")> 
		<cfif #Check.recordcount# eq "0">
			
			<cfquery name="INSERTCLASSFUNCTIONELEMENT" 
		     datasource="AppsControl" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				INSERT INTO ClassFunctionElement(ClassFunctionId, ElementCode, TextContent)
				VALUES('#url.Id#', '#url.ElementCode#','#txt#')
		 	</cfquery>	
		
		<cfelse>
		
			<cfquery name="UPDATECLASSFUNCTIONELEMENT" 
		     datasource="AppsControl" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 UPDATE ClassFunctionElement
			 SET TextContent='#txt#'
			 WHERE ClassFunctionId = '#url.Id#'
			 and ElementCode='#url.ElementCode#' 
			</cfquery>
		</cfif>
 	
	
<cfoutput>
<script>
	#ajaxlink('#SESSION.root#/system/parameter/functionClass/ViewDetail/UseCaseTextArea.cfm?id=#URL.ID#&ElementCode=#URL.elementcode#')#
</script>

</cfoutput>

	


