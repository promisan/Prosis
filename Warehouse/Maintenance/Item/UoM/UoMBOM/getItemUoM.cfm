
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