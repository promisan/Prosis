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
<cfquery name="GetUoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemUoMMission
		WHERE   ItemNo  = '#url.itemno#'
		AND     UoM     = '#url.uom#'
		AND     Mission = '#url.mission#'	
</cfquery>

<cfif getUoM.recordcount eq "0">

	<cfquery name="GetUoM" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    ItemUoM
			WHERE   ItemNo = '#url.itemno#'
			AND     UoM    = '#url.uom#'		
	</cfquery>

</cfif>

<cfset vCost = GetUom.StandardCost>	

<cfif URL.MaterialId neq "">

	<cfquery name="GetBOM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemBOMDetail
		WHERE   MaterialId = '#URL.MaterialId#'
	</cfquery>		
	
	<cfif GetBom.MaterialItemNo eq url.itemNo 
			and getBom.MaterialUoM eq url.uom>
	
		<cfset vCost=GetBOM.MaterialCost>
		
	</cfif>
	
</cfif>
	

<cfoutput>

	<script language="JavaScript">
		 document.getElementById('itemcost#URL.boxnumber#').value = "#numberformat(VCost,',.__')#"
	</script>
	
</cfoutput>