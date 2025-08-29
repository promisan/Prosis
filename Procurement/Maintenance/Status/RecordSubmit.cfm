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
<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Status
			SET 	StatusDescription  = '#Form.StatusDescription#',
					Description = <cfif trim(evaluate("Form.Description_#client.languageId#")) neq "">'#evaluate("Form.Description_#client.languageId#")#'<cfelse>null</cfif>
			WHERE 	StatusClass = '#url.id1#'
			AND		Status = '#url.id2#'
	</cfquery>
	
	<cf_LanguageInput
			TableCode       		= "StatusProcurement" 
			Key1Value       		= "#url.id1#"
			Key2Value       		= "#url.id2#"
			Mode            		= "Save"
			Name1           		= "Description"	
			Operational       		= "1">

</cfif>
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  