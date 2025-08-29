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

	


