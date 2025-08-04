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

<cfoutput>

<cfparam name="url.assetid" default="">

<cfif url.assetid neq "">
	
	<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM AssetItem
			WHERE AssetId = '#url.AssetId#'	
	</cfquery>
	&nbsp;
	
	<input type="hidden" name="AssetId" value="#url.AssetId#">
	
	<script language="JavaScript">
		
		document.getElementById('serialno').innerHTML = "#get.serialno#"
		document.getElementById('description').innerHTML = "#get.description#"
		document.getElementById('make').innerHTML  = "#get.make#"
		document.getElementById('model').innerHTML = "#get.model#"
		document.getElementById('year').innerHTML  = "#get.depreciationyearstart#"
			
	</script>
		
	
</cfif>	

</cfoutput>

