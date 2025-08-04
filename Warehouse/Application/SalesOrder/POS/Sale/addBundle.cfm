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
<cfif trim(url.customerid) neq "">

	<cfquery name="qGetBundle" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT   *
			FROM     ItemBOM
			WHERE    ItemNo = '#url.BundleItemNo#'
			AND 	 DateEffective <= getdate()
			ORDER BY DateEffective DESC
	</cfquery>
				
	<cfquery name="qGetBundleDetails" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT    *
			FROM      ItemBOMDetail
			WHERE     BOMId = '#qGetBundle.BOMId#'
	</cfquery>	
	
	<cfloop query="qGetBundleDetails">
	
		<cfquery name="qGet" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			    SELECT   *
				FROM     Item I INNER JOIN ItemUoM U ON I.ItemNo = U.ItemNo
				WHERE    I.ItemNo = '#qGetBundleDetails.MaterialItemNo#'
				AND      U.UoM    = '#qGetBundleDetails.MaterialUoM#'
		</cfquery>		
		
		<cfset url.ItemUomId = qGet.ItemUoMid>
		<cfset url.Transactionlot = url.lot>
		<cfset url.refreshContent = 0>
		
		<cfif qgetBundleDetails.currentRow eq qGetBundleDetails.recordCount>
			<cfset url.refreshContent = 1>
		</cfif>
		
		<cfinclude template="addItem.cfm">				
		
	</cfloop>
	
	<cfif qGetBundleDetails.recordCount eq 0>
		<cfinclude template="SaleViewLines.cfm">
	</cfif>

</cfif>