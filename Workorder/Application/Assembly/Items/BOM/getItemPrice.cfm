

<cfparam name="url.UoM"    default="">

<cfquery name="GetItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Item I INNER JOIN Ref_Category R ON I.Category = R.Category
	WHERE	I.ItemNo = '#url.itemno#'			
</cfquery>

<cfquery name="GetItemUoMMission" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    ItemUoMMission I 
	WHERE	I.ItemNo  = '#url.itemno#'				
	AND     I.Mission = '#url.mission#'
	AND     I.UoM     = '#url.Uom#'
</cfquery>

<cfif getItemUoMMission.standardCost gt "0">

	<cfset cost = getItemUoMMission.standardCost>
	
<cfelse>

	<cfquery name="GetItemUoM" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemUoM I
		WHERE	I.ItemNo  = '#url.itemno#'					
	</cfquery>

	<cfset cost = getItemUoM.standardCost>	

</cfif>

<cfoutput>
<script>	
	document.getElementById('price').value  = "#numberformat(cost,',.__')#"	
	document.getElementById('dTotal').innerHTML = "#numberformat(cost*url.quantity,',.__')#"
</script>
</cfoutput>