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

<!--- set the values --->

<cfoutput>

<cfquery name="set" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *	
	FROM       PostalAddress A 			
	WHERE      Country = '#url.country#' 
	AND        PostalCode = '#url.keyvalue#'		
</cfquery>

<script>
    document.getElementById('field_#url.box#').value      = '#url.keyvalue#'
	document.getElementById('postalcode_#url.box#').value = "#set.PostalCode#"
	document.getElementById('city_#url.box#').value       = "#set.City#";
	document.getElementById('address_#url.box#').value    = "#set.Address#"	
</script>


</cfoutput>
