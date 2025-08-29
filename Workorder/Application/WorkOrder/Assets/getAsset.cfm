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
<cfoutput>

<cf_compression>

<cfparam name="url.assetid" default="">

<cfif url.assetid neq "">

	<cftry>
	
		<cfquery name="Get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    AssetItem
				WHERE   AssetId = '#url.AssetId#'	
		</cfquery>
		
		<cfquery name="UoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  TOP 1 *
				FROM    ItemUoM
				WHERE   ItemNo = '#get.itemno#'		 				 
		</cfquery>	
				
		<input type="hidden" name="AssetId" id="AssetId" value="#url.AssetId#">
				
		<script language="JavaScript">			
			
			document.getElementById('description').innerHTML   = "#get.description#"
			document.getElementById('make').innerHTML          = "#get.make#"
			document.getElementById('price').innerHTML         = "#numberformat(get.DepreciationBase,"__,__.__")#"
			document.getElementById('assetserialno').innerHTML = "#get.serialno#"
				
		</script>
			
	<cfcatch></cfcatch>
	</cftry>
	
	
</cfif>	

</cfoutput>


