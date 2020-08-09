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