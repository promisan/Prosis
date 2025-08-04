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

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_WarehouseBatchClass
		SET   	Description    	= '#Form.Description#',
				ListingOrder	= '#Form.ListingOrder#',
				ReportTemplate	= <cfif trim(Form.ReportTemplate) neq "">'#Form.ReportTemplate#'<cfelse>null</cfif>
		WHERE 	Code           	= '#Form.CodeOld#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
	
</cfif>	

<script language="JavaScript">
   
     parent.window.close()
	 opener.location.reload()
        
</script>  
