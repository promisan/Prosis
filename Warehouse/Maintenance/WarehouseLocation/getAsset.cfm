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

	<cftry>
	
		<cfquery name="GetAsset" 
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
				WHERE   ItemNo = '#getAsset.itemno#'		 				 
		</cfquery>			
				
		<input type="hidden" name="AssetId" id="AssetId" value="#url.AssetId#">&nbsp;
		
		<script language="JavaScript">
			
			document.getElementById('serialno').value      = "#getAsset.serialno#"
			document.getElementById('description').value   = "#getAsset.description#"
			document.getElementById('make').value          = "#getAsset.make#"
			document.getElementById('price').value         = "#numberformat(UoM.StandardCost,"__,__.__")#"
			document.getElementById('assetbarcode').value  = "#getAsset.assetBarCode#"
			document.getElementById('assetdecalno').value  = "#getAsset.assetDecalNo#"
			document.getElementById('consumption').disabled = false
			document.getElementById('resetasset').className = "regular"
				
		</script>
	
	<cfcatch></cfcatch>
	</cftry>
	
	
</cfif>	

</cfoutput>

